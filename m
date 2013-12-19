Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756526Ab3LSMGx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 07:06:53 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45354 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753628Ab3LSL75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:59:57 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: David Sterba <dsterba@suse.cz>, Chris Mason <clm@fb.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 191/208] btrfs: call mnt_drop_write after interrupted subvol deletion
Date: Thu, 19 Dec 2013 11:54:49 +0000
Message-Id: <1387454106-19326-192-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
References: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Sterba <dsterba@suse.cz>

commit e43f998e47bae27e37e159915625e8d4b130153b upstream.

If btrfs_ioctl_snap_destroy blocks on the mutex and the process is
killed, mnt_write count is unbalanced and leads to unmountable
filesystem.

Signed-off-by: David Sterba <dsterba@suse.cz>
Signed-off-by: Chris Mason <clm@fb.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/btrfs/ioctl.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 9877a2a..6074a8e 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2099,7 +2099,7 @@ static noinline int btrfs_ioctl_snap_destroy(struct file *file,
 
 	err = mutex_lock_killable_nested(&dir->i_mutex, I_MUTEX_PARENT);
 	if (err == -EINTR)
-		goto out;
+		goto out_drop_write;
 	dentry = lookup_one_len(vol_args->name, parent, namelen);
 	if (IS_ERR(dentry)) {
 		err = PTR_ERR(dentry);
@@ -2241,6 +2241,7 @@ out_dput:
 	dput(dentry);
 out_unlock_dir:
 	mutex_unlock(&dir->i_mutex);
+out_drop_write:
 	mnt_drop_write_file(file);
 out:
 	kfree(vol_args);
-- 
1.8.3.2

