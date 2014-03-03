Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958AbaCCSU4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 13:20:56 -0500
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:54436 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751743AbaCCSUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 13:20:55 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApcRAGXHFFNbslH8/2dsb2JhbABaKIJeg0O+HgICgSMXdIJmHCMYgQIkE4d9AcxbjgJXhD8EiUmOcgGKVIdXgzovgS0
Date: Mon, 3 Mar 2014 18:22:18 +0800
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 1/1] affs: AFFS_NO_TRUNCATE added to Kconfig
Message-Id: <20140303182218.bc1de22e2c404dd1e07553b4@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Filename truncate process is defined in affs.h.

This patch exports current define to Kconfig and removes
AFFS_MAX_PREALLOC which is never used.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/affs/Kconfig    | 12 ++++++++++++
 fs/affs/affs.h     |  9 ---------
 fs/affs/amigaffs.c |  2 +-
 3 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/fs/affs/Kconfig b/fs/affs/Kconfig
index a04d9e8..4db24d9 100644
--- a/fs/affs/Kconfig
+++ b/fs/affs/Kconfig
@@ -19,3 +19,15 @@ config AFFS_FS
 
 	  To compile this file system support as a module, choose M here: the
 	  module will be called affs.  If unsure, say N.
+
+config AFFS_NO_TRUNCATE
+	bool "Amiga FFS no filename truncate"
+	depends on AFFS_FS
+	default n
+	help
+	  If you say Y here, creating filesystem objects with longer names than
+	  30 characters (standard limit) will result in an error (ENAMETOOLONG).
+
+	  By default this option is disabled and filenames are automatically
+	  truncated.
+
diff --git a/fs/affs/affs.h b/fs/affs/affs.h
index 3952121..128ae5d 100644
--- a/fs/affs/affs.h
+++ b/fs/affs/affs.h
@@ -5,14 +5,6 @@
 #include <linux/mutex.h>
 #include <linux/workqueue.h>
 
-/* AmigaOS allows file names with up to 30 characters length.
- * Names longer than that will be silently truncated. If you
- * want to disallow this, comment out the following #define.
- * Creating filesystem objects with longer names will then
- * result in an error (ENAMETOOLONG).
- */
-/*#define AFFS_NO_TRUNCATE */
-
 /* Ugly macros make the code more pretty. */
 
 #define GET_END_PTR(st,p,sz)		 ((st *)((char *)(p)+((sz)-sizeof(st))))
@@ -28,7 +20,6 @@
 
 #define AFFS_CACHE_SIZE		PAGE_SIZE
 
-#define AFFS_MAX_PREALLOC	32
 #define AFFS_LC_SIZE		(AFFS_CACHE_SIZE/sizeof(u32)/2)
 #define AFFS_AC_SIZE		(AFFS_CACHE_SIZE/sizeof(struct affs_ext_key)/2)
 #define AFFS_AC_MASK		(AFFS_AC_SIZE-1)
diff --git a/fs/affs/amigaffs.c b/fs/affs/amigaffs.c
index d9a4367..6e7b4cd 100644
--- a/fs/affs/amigaffs.c
+++ b/fs/affs/amigaffs.c
@@ -479,7 +479,7 @@ affs_check_name(const unsigned char *name, int len)
 	int	 i;
 
 	if (len > 30)
-#ifdef AFFS_NO_TRUNCATE
+#ifdef CONFIG_AFFS_NO_TRUNCATE
 		return -ENAMETOOLONG;
 #else
 		len = 30;
-- 
1.8.1.4

