Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541AbaJTFTE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 01:19:04 -0400
Received: from mail.kernel.org ([198.145.19.201]:59746 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752442AbaJTFSj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 01:18:39 -0400
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 04/09] f2fs: fix race conditon on truncation with inline_data
Date: Sun, 19 Oct 2014 22:18:27 -0700
Message-Id: <1413782312-11631-4-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413782312-11631-1-git-send-email-jaegeuk@kernel.org>
References: <1413782312-11631-1-git-send-email-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let's consider the following scenario.

blkaddr[0] inline_data i_size  i_blocks writepage           truncate
  NEW        X        4096        2    dirty page #0
  NEW        X         0                                    change i_size
  NEW        X         0          2    f2fs_write_inline_data
  NEW        X         0          2    get_dnode_of_data
  NEW        X         0          2    truncate_data_blocks_range
  NULL       O         0          1    memcpy(inline_data)
  NULL       O         0          1    f2fs_put_dnode
  NULL       O         0          1                         f2fs_truncate
  NULL       O         0          1                         get_dnode_of_data
  NULL       O         0          1                       *invalid block addr*

This patch adds checking inline_data flag during f2fs_truncate not to refer
corrupted block indices.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/file.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 8e68bb6..543d8c6 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -473,6 +473,12 @@ int truncate_blocks(struct inode *inode, u64 from, bool lock)
 		return err;
 	}
 
+	/* writepage can convert inline_data under get_donde_of_data */
+	if (f2fs_has_inline_data(inode)) {
+		f2fs_put_dnode(&dn);
+		goto done;
+	}
+
 	count = ADDRS_PER_PAGE(dn.node_page, F2FS_I(inode));
 
 	count -= dn.ofs_in_node;
-- 
2.1.1

