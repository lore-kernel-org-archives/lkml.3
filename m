Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358AbaEMQvW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 12:51:22 -0400
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:65447 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753192AbaEMQvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 12:51:04 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmhHAFlMclNbtADP/2dsb2JhbABZgwaBYasWBAEBAQEBAQUBmhkCAoEiF3SCUxMcIxiBAiQTiEUBxy2FVIh6hEcBA48piiYBkxCDODs
Date: Tue, 13 May 2014 18:50:59 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Jan Harkes <jaharkes@cs.cmu.edu>, akpm <akpm@linux-foundation.org>
Subject: [PATCH 2/3] FS/CODA: Logging prefix uniformization
Message-Id: <20140513185059.830857dd681b468a4b747754@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-Adding pr_fmt based on module name.
-Remove Coda: coda: from pr_foo()

Cc: Jan Harkes <jaharkes@cs.cmu.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/coda/coda_linux.h | 6 ++++++
 fs/coda/dir.c        | 2 +-
 fs/coda/inode.c      | 2 +-
 fs/coda/psdev.c      | 6 +++---
 fs/coda/upcall.c     | 6 +++---
 5 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/fs/coda/coda_linux.h b/fs/coda/coda_linux.h
index a3bf7a8..d42b725 100644
--- a/fs/coda/coda_linux.h
+++ b/fs/coda/coda_linux.h
@@ -12,6 +12,12 @@
 #ifndef _LINUX_CODA_FS
 #define _LINUX_CODA_FS
 
+#ifdef pr_fmt
+#undef pr_fmt
+#endif
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/param.h>
 #include <linux/mm.h>
diff --git a/fs/coda/dir.c b/fs/coda/dir.c
index bdd34df..cf2735c 100644
--- a/fs/coda/dir.c
+++ b/fs/coda/dir.c
@@ -589,7 +589,7 @@ int coda_revalidate_inode(struct inode *inode)
 		coda_vattr_to_iattr(inode, &attr);
 
 		if ((old_mode & S_IFMT) != (inode->i_mode & S_IFMT)) {
-			pr_warn("Coda: inode %ld, fid %s changed type!\n",
+			pr_warn("inode %ld, fid %s changed type!\n",
 				inode->i_ino, coda_f2s(&(cii->c_fid)));
 		}
 
diff --git a/fs/coda/inode.c b/fs/coda/inode.c
index b87d49f..b5ee590 100644
--- a/fs/coda/inode.c
+++ b/fs/coda/inode.c
@@ -247,7 +247,7 @@ static void coda_put_super(struct super_block *sb)
 	sb->s_fs_info = NULL;
 	mutex_unlock(&vcp->vc_mutex);
 
-	pr_info("Coda: Bye bye.\n");
+	pr_info("Bye bye.\n");
 }
 
 static void coda_evict_inode(struct inode *inode)
diff --git a/fs/coda/psdev.c b/fs/coda/psdev.c
index accddf6..39ebb14 100644
--- a/fs/coda/psdev.c
+++ b/fs/coda/psdev.c
@@ -120,7 +120,7 @@ static ssize_t coda_psdev_write(struct file *file, const char __user *buf,
 			goto out;
 		}
 		if ( nbytes > size ) {
-			pr_warn("Coda: downcall opc %d, uniq %d, too much!",
+			pr_warn("downcall opc %d, uniq %d, too much!",
 				hdr.opcode, hdr.unique);
 		        nbytes = size;
 		}
@@ -400,7 +400,7 @@ static int __init init_coda(void)
 	
 	status = register_filesystem(&coda_fs_type);
 	if (status) {
-		pr_warn("coda: failed to register filesystem!\n");
+		pr_warn("failed to register filesystem!\n");
 		goto out;
 	}
 	return 0;
@@ -422,7 +422,7 @@ static void __exit exit_coda(void)
 
 	err = unregister_filesystem(&coda_fs_type);
 	if (err != 0)
-		pr_warn("coda: failed to unregister filesystem\n");
+		pr_warn("failed to unregister filesystem\n");
 	for (i = 0; i < MAX_CODADEVS; i++)
 		device_destroy(coda_psdev_class, MKDEV(CODA_PSDEV_MAJOR, i));
 	class_destroy(coda_psdev_class);
diff --git a/fs/coda/upcall.c b/fs/coda/upcall.c
index 5f3b217..0780de5 100644
--- a/fs/coda/upcall.c
+++ b/fs/coda/upcall.c
@@ -675,7 +675,7 @@ static int coda_upcall(struct venus_comm *vcp,
 	mutex_lock(&vcp->vc_mutex);
 
 	if (!vcp->vc_inuse) {
-		pr_notice("coda: Venus dead, not sending upcall\n");
+		pr_notice("Venus dead, not sending upcall\n");
 		error = -ENXIO;
 		goto exit;
 	}
@@ -725,7 +725,7 @@ static int coda_upcall(struct venus_comm *vcp,
 
 	error = -EINTR;
 	if ((req->uc_flags & CODA_REQ_ABORT) || !signal_pending(current)) {
-		pr_warn("coda: Unexpected interruption.\n");
+		pr_warn("Unexpected interruption.\n");
 		goto exit;
 	}
 
@@ -735,7 +735,7 @@ static int coda_upcall(struct venus_comm *vcp,
 
 	/* Venus saw the upcall, make sure we can send interrupt signal */
 	if (!vcp->vc_inuse) {
-		pr_info("coda: Venus dead, not sending signal.\n");
+		pr_info("Venus dead, not sending signal.\n");
 		goto exit;
 	}
 
-- 
1.8.4.5

