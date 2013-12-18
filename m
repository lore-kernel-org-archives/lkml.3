Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305Ab3LRV1o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 16:27:44 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36504 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754327Ab3LRVNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:13:54 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David Sterba <dsterba@suse.cz>, Chris Mason <clm@fb.com>
Subject: [PATCH 3.12 079/118] btrfs: call mnt_drop_write after interrupted subvol deletion
Date: Wed, 18 Dec 2013 13:11:56 -0800
Message-Id: <20131218211221.683666023@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20131218211219.461663463@linuxfoundation.org>
References: <20131218211219.461663463@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Sterba <dsterba@suse.cz>

commit e43f998e47bae27e37e159915625e8d4b130153b upstream.

If btrfs_ioctl_snap_destroy blocks on the mutex and the process is
killed, mnt_write count is unbalanced and leads to unmountable
filesystem.

Signed-off-by: David Sterba <dsterba@suse.cz>
Signed-off-by: Chris Mason <clm@fb.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/ioctl.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2130,7 +2130,7 @@ static noinline int btrfs_ioctl_snap_des
 
 	err = mutex_lock_killable_nested(&dir->i_mutex, I_MUTEX_PARENT);
 	if (err == -EINTR)
-		goto out;
+		goto out_drop_write;
 	dentry = lookup_one_len(vol_args->name, parent, namelen);
 	if (IS_ERR(dentry)) {
 		err = PTR_ERR(dentry);
@@ -2293,6 +2293,7 @@ out_dput:
 	dput(dentry);
 out_unlock_dir:
 	mutex_unlock(&dir->i_mutex);
+out_drop_write:
 	mnt_drop_write_file(file);
 out:
 	kfree(vol_args);


