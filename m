Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567AbaIWCf4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 22:35:56 -0400
Received: from mail.kernel.org ([198.145.19.201]:37663 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753489AbaIWCfx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 22:35:53 -0400
From: Zefan Li <lizf@kernel.org>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Pavel Shilovsky <pshilovsky@samba.org>,
        Steve French <smfrench@gmail.com>, Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 12/45] CIFS: Fix wrong directory attributes after rename
Date: Tue, 23 Sep 2014 10:31:14 +0800
Message-Id: <1411439507-30391-12-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1411439259-30224-1-git-send-email-lizf@kernel.org>
References: <1411439259-30224-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavel Shilovsky <pshilovsky@samba.org>

3.4.104-rc1 review patch.  If anyone has any objections, please let me know.

------------------

commit b46799a8f28c43c5264ac8d8ffa28b311b557e03 upstream.

When we requests rename we also need to update attributes
of both source and target parent directories. Not doing it
causes generic/309 xfstest to fail on SMB2 mounts. Fix this
by marking these directories for force revalidating.

Signed-off-by: Pavel Shilovsky <pshilovsky@samba.org>
Signed-off-by: Steve French <smfrench@gmail.com>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 fs/cifs/inode.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 43944c6..8d6ac6b 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -1653,6 +1653,12 @@ unlink_target:
 				    target_dentry, toName);
 	}
 
+	/* force revalidate to go get info when needed */
+	CIFS_I(source_dir)->time = CIFS_I(target_dir)->time = 0;
+
+	source_dir->i_ctime = source_dir->i_mtime = target_dir->i_ctime =
+		target_dir->i_mtime = current_fs_time(source_dir->i_sb);
+
 cifs_rename_exit:
 	kfree(info_buf_source);
 	kfree(fromName);
-- 
1.7.9.5

