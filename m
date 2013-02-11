Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760167Ab3BKXPX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 18:15:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10456 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757154Ab3BKXPV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 18:15:21 -0500
Date: Mon, 11 Feb 2013 18:15:00 -0500
From: Josh Boyer <jwboyer@redhat.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>, Colin Cross <ccross@android.com>,
        Kees Cook <keescook@chromium.org>, Tony Luck <tony.luck@intel.com>
Cc: kay@redhat.com, lpoetter@redhat.com, mjg59@srcf.ucam.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] pstore: Create a convenient mount point for pstore
Message-ID: <20130211231500.GD21501@hansolo.jdub.homelinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using /dev/pstore as a mount point for the pstore filesystem is slightly
awkward.  We don't normally mount filesystems in /dev/ and the /dev/pstore
file isn't created automatically by anything.  While this method will
still work, we can create a persistent mount point in sysfs.  This will
put pstore on par with things like cgroups and efivarfs.

Signed-off-by: Josh Boyer <jwboyer@redhat.com>
---
 Documentation/ABI/testing/pstore | 10 +++++-----
 fs/pstore/inode.c                | 18 +++++++++++++++++-
 2 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/Documentation/ABI/testing/pstore b/Documentation/ABI/testing/pstore
index ff1df4e..5fca9f5 100644
--- a/Documentation/ABI/testing/pstore
+++ b/Documentation/ABI/testing/pstore
@@ -1,4 +1,4 @@
-Where:		/dev/pstore/...
+Where:		/sys/fs/pstore/... (or /dev/pstore/...)
 Date:		March 2011
 Kernel Version: 2.6.39
 Contact:	tony.luck@intel.com
@@ -11,9 +11,9 @@ Description:	Generic interface to platform dependent persistent storage.
 		of the console log is captured, but other interesting
 		data can also be saved.
 
-		# mount -t pstore -o kmsg_bytes=8000 - /dev/pstore
+		# mount -t pstore -o kmsg_bytes=8000 - /sys/fs/pstore
 
-		$ ls -l /dev/pstore
+		$ ls -l /sys/fs/pstore/
 		total 0
 		-r--r--r-- 1 root root 7896 Nov 30 15:38 dmesg-erst-1
 
@@ -27,9 +27,9 @@ Description:	Generic interface to platform dependent persistent storage.
 		the file will signal to the underlying persistent storage
 		device that it can reclaim the space for later re-use.
 
-		$ rm /dev/pstore/dmesg-erst-1
+		$ rm /sys/fs/pstore/dmesg-erst-1
 
-		The expectation is that all files in /dev/pstore
+		The expectation is that all files in /sys/fs/pstore/
 		will be saved elsewhere and erased from persistent store
 		soon after boot to free up space ready for the next
 		catastrophe.
diff --git a/fs/pstore/inode.c b/fs/pstore/inode.c
index 67de74c..e4bcb2c 100644
--- a/fs/pstore/inode.c
+++ b/fs/pstore/inode.c
@@ -418,9 +418,25 @@ static struct file_system_type pstore_fs_type = {
 	.kill_sb	= pstore_kill_sb,
 };
 
+static struct kobject *pstore_kobj;
+
 static int __init init_pstore_fs(void)
 {
-	return register_filesystem(&pstore_fs_type);
+	int err = 0;
+
+	/* Create a convenient mount point for people to access pstore */
+	pstore_kobj = kobject_create_and_add("pstore", fs_kobj);
+	if (!pstore_kobj) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	err = register_filesystem(&pstore_fs_type);
+	if (err < 0)
+		kobject_put(pstore_kobj);
+
+out:
+	return err;
 }
 module_init(init_pstore_fs)
 
-- 
1.8.1.2

