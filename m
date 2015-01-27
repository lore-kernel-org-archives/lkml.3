Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758236AbbA0MRJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:17:09 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34846 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758205AbbA0MRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:17:04 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Chris Mason <clm@fb.com>, Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 011/126] Btrfs: don't delay inode ref updates during log replay
Date: Tue, 27 Jan 2015 12:15:16 +0000
Message-Id: <1422361031-19364-12-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
References: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Mason <clm@fb.com>

commit 6f8960541b1eb6054a642da48daae2320fddba93 upstream.

Commit 1d52c78afbb (Btrfs: try not to ENOSPC on log replay) added a
check to skip delayed inode updates during log replay because it
confuses the enospc code.  But the delayed processing will end up
ignoring delayed refs from log replay because the inode itself wasn't
put through the delayed code.

This can end up triggering a warning at commit time:

WARNING: CPU: 2 PID: 778 at fs/btrfs/delayed-inode.c:1410 btrfs_assert_delayed_root_empty+0x32/0x34()

Which is repeated for each commit because we never process the delayed
inode ref update.

The fix used here is to change btrfs_delayed_delete_inode_ref to return
an error if we're currently in log replay.  The caller will do the ref
deletion immediately and everything will work properly.

Signed-off-by: Chris Mason <clm@fb.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/btrfs/delayed-inode.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index a2e90f855d7d..e5856d792f8b 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1857,6 +1857,14 @@ int btrfs_delayed_delete_inode_ref(struct inode *inode)
 {
 	struct btrfs_delayed_node *delayed_node;
 
+	/*
+	 * we don't do delayed inode updates during log recovery because it
+	 * leads to enospc problems.  This means we also can't do
+	 * delayed inode refs
+	 */
+	if (BTRFS_I(inode)->root->fs_info->log_root_recovering)
+		return -EAGAIN;
+
 	delayed_node = btrfs_get_or_create_delayed_node(inode);
 	if (IS_ERR(delayed_node))
 		return PTR_ERR(delayed_node);
-- 
2.1.4

