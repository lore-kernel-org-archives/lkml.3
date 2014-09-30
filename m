Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741AbaI3VeR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 17:34:17 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60800 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922AbaI3VcC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:32:02 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Pavel Shilovsky <pshilovsky@samba.org>, Steve French <smfrench@gmail.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 019/103] CIFS: Fix wrong directory attributes after rename
Date: Tue, 30 Sep 2014 14:30:24 -0700
Message-Id: <1412112708-27356-20-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412112708-27356-1-git-send-email-kamal@canonical.com>
References: <1412112708-27356-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Shilovsky <pshilovsky@samba.org>

commit b46799a8f28c43c5264ac8d8ffa28b311b557e03 upstream.

When we requests rename we also need to update attributes
of both source and target parent directories. Not doing it
causes generic/309 xfstest to fail on SMB2 mounts. Fix this
by marking these directories for force revalidating.

Signed-off-by: Pavel Shilovsky <pshilovsky@samba.org>
Signed-off-by: Steve French <smfrench@gmail.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/cifs/inode.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 5f8bdff..36d2b1d 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -1689,6 +1689,12 @@ unlink_target:
 				    target_dentry, to_name);
 	}
 
+	/* force revalidate to go get info when needed */
+	CIFS_I(source_dir)->time = CIFS_I(target_dir)->time = 0;
+
+	source_dir->i_ctime = source_dir->i_mtime = target_dir->i_ctime =
+		target_dir->i_mtime = current_fs_time(source_dir->i_sb);
+
 cifs_rename_exit:
 	kfree(info_buf_source);
 	kfree(from_name);
-- 
1.9.1

