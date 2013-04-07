Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935024Ab3DGXfw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 19:35:52 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46857 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934939Ab3DGXdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 19:33:36 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Sasha Levin" <levinsasha928@gmail.com>,
        "Dave Jones" <davej@redhat.com>, "Ming Lei" <ming.lei@canonical.com>
Date: Sun, 07 Apr 2013 23:45:42 +0100
Message-ID: <lsq.1365374742.954887030@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [21/74] sysfs: fix race between readdir and lseek
In-Reply-To: <lsq.1365374742.214522651@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:b4b3:7e2a:e2d0:3478
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.43-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Lei <ming.lei@canonical.com>

commit 991f76f837bf22c5bb07261cfd86525a0a96650c upstream.

While readdir() is running, lseek() may set filp->f_pos as zero,
then may leave filp->private_data pointing to one sysfs_dirent
object without holding its reference counter, so the sysfs_dirent
object may be used after free in next readdir().

This patch holds inode->i_mutex to avoid the problem since
the lock is always held in readdir path.

Reported-by: Dave Jones <davej@redhat.com>
Tested-by: Sasha Levin <levinsasha928@gmail.com>
Signed-off-by: Ming Lei <ming.lei@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 3.2: open-code file_inode() which we don't have]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/sysfs/dir.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -1023,10 +1023,21 @@ static int sysfs_readdir(struct file * f
 	return 0;
 }
 
+static loff_t sysfs_dir_llseek(struct file *file, loff_t offset, int whence)
+{
+	struct inode *inode = file->f_path.dentry->d_inode;
+	loff_t ret;
+
+	mutex_lock(&inode->i_mutex);
+	ret = generic_file_llseek(file, offset, whence);
+	mutex_unlock(&inode->i_mutex);
+
+	return ret;
+}
 
 const struct file_operations sysfs_dir_operations = {
 	.read		= generic_read_dir,
 	.readdir	= sysfs_readdir,
 	.release	= sysfs_dir_release,
-	.llseek		= generic_file_llseek,
+	.llseek		= sysfs_dir_llseek,
 };

