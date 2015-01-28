Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933320AbbA1Bib (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 20:38:31 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41426 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759979AbbA1BiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 20:38:19 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 3.14 20/77] fix deadlock in cifs_ioctl_clone()
Date: Tue, 27 Jan 2015 17:26:58 -0800
Message-Id: <20150128012746.569220580@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150128012745.971137091@linuxfoundation.org>
References: <20150128012745.971137091@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

commit 378ff1a53b5724f3ac97b0aba3c9ecac072f6fcd upstream.

It really needs to check that src is non-directory *and* use
{un,}lock_two_nodirectories().  As it is, it's trivial to cause
double-lock (ioctl(fd, CIFS_IOC_COPYCHUNK_FILE, fd)) and if the
last argument is an fd of directory, we are asking for trouble
by violating the locking order - all directories go before all
non-directories.  If the last argument is an fd of parent
directory, it has 50% odds of locking child before parent,
which will cause AB-BA deadlock if we race with unlink().

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/ioctl.c |   21 +++++----------------
 1 file changed, 5 insertions(+), 16 deletions(-)

--- a/fs/cifs/ioctl.c
+++ b/fs/cifs/ioctl.c
@@ -86,21 +86,16 @@ static long cifs_ioctl_clone(unsigned in
 	}
 
 	src_inode = src_file.file->f_dentry->d_inode;
+	rc = -EINVAL;
+	if (S_ISDIR(src_inode->i_mode))
+		goto out_fput;
 
 	/*
 	 * Note: cifs case is easier than btrfs since server responsible for
 	 * checks for proper open modes and file type and if it wants
 	 * server could even support copy of range where source = target
 	 */
-
-	/* so we do not deadlock racing two ioctls on same files */
-	if (target_inode < src_inode) {
-		mutex_lock_nested(&target_inode->i_mutex, I_MUTEX_PARENT);
-		mutex_lock_nested(&src_inode->i_mutex, I_MUTEX_CHILD);
-	} else {
-		mutex_lock_nested(&src_inode->i_mutex, I_MUTEX_PARENT);
-		mutex_lock_nested(&target_inode->i_mutex, I_MUTEX_CHILD);
-	}
+	lock_two_nondirectories(target_inode, src_inode);
 
 	/* determine range to clone */
 	rc = -EINVAL;
@@ -124,13 +119,7 @@ static long cifs_ioctl_clone(unsigned in
 out_unlock:
 	/* although unlocking in the reverse order from locking is not
 	   strictly necessary here it is a little cleaner to be consistent */
-	if (target_inode < src_inode) {
-		mutex_unlock(&src_inode->i_mutex);
-		mutex_unlock(&target_inode->i_mutex);
-	} else {
-		mutex_unlock(&target_inode->i_mutex);
-		mutex_unlock(&src_inode->i_mutex);
-	}
+	unlock_two_nondirectories(src_inode, target_inode);
 out_fput:
 	fdput(src_file);
 out_drop_write:


