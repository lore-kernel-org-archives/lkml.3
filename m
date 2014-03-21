Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761028AbaCUQtY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 12:49:24 -0400
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:22893 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753512AbaCUQtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 12:49:16 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AksWAMBsLFNbtAWg/2dsb2JhbABZgwY7gwynGJkOAgKBFBd0glMTHCMYgQIkE4d9Ac91jmqEPwSOUol2AZIxgT+Bbzw
Date: Fri, 21 Mar 2014 17:50:53 +0100
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, anton <anton@tuxera.com>,
        Joe Perches <joe@perches.com>
Subject: [PATCH V3 RESEND] NTFS: Logging clean-up
Message-Id: <20140321175053.f0d26c0070ed429a3d8d0747@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-Convert spinlock/static array to va_format (inspired by Joe Perches help
on previous logging patches).
-Convert printk(KERN_ERR to pr_warn in __ntfs_warning.
-Convert printk(KERN_ERR to pr_err in __ntfs_error.
-Convert printk(KERN_DEBUG to pr_debug in __ntfs_debug.
(Note that __ntfs_debug is still guarded by #if DEBUG)
-Improve !DEBUG to parse all arguments (Joe Perches).
-Sparse pr_foo() conversions in super.c

NTFS, NTFS-fs prefixes as well as 'warning' and 'error'
were removed : pr_foo() automatically adds module name
and error level is already specified.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
v3: fix pr_info("driver " NTFS_VERSION " 
v2: Improve !DEBUG, changelog, fix va_end 

 fs/ntfs/debug.c | 58 ++++++++++++++++++++++++---------------------------------
 fs/ntfs/debug.h |  7 ++++++-
 fs/ntfs/super.c | 28 ++++++++++++----------------
 3 files changed, 42 insertions(+), 51 deletions(-)

diff --git a/fs/ntfs/debug.c b/fs/ntfs/debug.c
index 807150e..dd6103c 100644
--- a/fs/ntfs/debug.c
+++ b/fs/ntfs/debug.c
@@ -18,16 +18,9 @@
  * distribution in the file COPYING); if not, write to the Free Software
  * Foundation,Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
-
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 #include "debug.h"
 
-/*
- * A static buffer to hold the error string being displayed and a spinlock
- * to protect concurrent accesses to it.
- */
-static char err_buf[1024];
-static DEFINE_SPINLOCK(err_buf_lock);
-
 /**
  * __ntfs_warning - output a warning to the syslog
  * @function:	name of function outputting the warning
@@ -50,6 +43,7 @@ static DEFINE_SPINLOCK(err_buf_lock);
 void __ntfs_warning(const char *function, const struct super_block *sb,
 		const char *fmt, ...)
 {
+	struct va_format vaf;
 	va_list args;
 	int flen = 0;
 
@@ -59,17 +53,15 @@ void __ntfs_warning(const char *function, const struct super_block *sb,
 #endif
 	if (function)
 		flen = strlen(function);
-	spin_lock(&err_buf_lock);
 	va_start(args, fmt);
-	vsnprintf(err_buf, sizeof(err_buf), fmt, args);
-	va_end(args);
+	vaf.fmt = fmt;
+	vaf.va = &args;
 	if (sb)
-		printk(KERN_ERR "NTFS-fs warning (device %s): %s(): %s\n",
-				sb->s_id, flen ? function : "", err_buf);
+		pr_warn("(device %s): %s(): %pV\n",
+			sb->s_id, flen ? function : "", &vaf);
 	else
-		printk(KERN_ERR "NTFS-fs warning: %s(): %s\n",
-				flen ? function : "", err_buf);
-	spin_unlock(&err_buf_lock);
+		pr_warn("%s(): %pV\n", flen ? function : "", &vaf);
+	va_end(args);
 }
 
 /**
@@ -94,6 +86,7 @@ void __ntfs_warning(const char *function, const struct super_block *sb,
 void __ntfs_error(const char *function, const struct super_block *sb,
 		const char *fmt, ...)
 {
+	struct va_format vaf;
 	va_list args;
 	int flen = 0;
 
@@ -103,17 +96,15 @@ void __ntfs_error(const char *function, const struct super_block *sb,
 #endif
 	if (function)
 		flen = strlen(function);
-	spin_lock(&err_buf_lock);
 	va_start(args, fmt);
-	vsnprintf(err_buf, sizeof(err_buf), fmt, args);
-	va_end(args);
+	vaf.fmt = fmt;
+	vaf.va = &args;
 	if (sb)
-		printk(KERN_ERR "NTFS-fs error (device %s): %s(): %s\n",
-				sb->s_id, flen ? function : "", err_buf);
+		pr_err("(device %s): %s(): %pV\n",
+		       sb->s_id, flen ? function : "", &vaf);
 	else
-		printk(KERN_ERR "NTFS-fs error: %s(): %s\n",
-				flen ? function : "", err_buf);
-	spin_unlock(&err_buf_lock);
+		pr_err("%s(): %pV\n", flen ? function : "", &vaf);
+	va_end(args);
 }
 
 #ifdef DEBUG
@@ -124,6 +115,7 @@ int debug_msgs = 0;
 void __ntfs_debug (const char *file, int line, const char *function,
 		const char *fmt, ...)
 {
+	struct va_format vaf;
 	va_list args;
 	int flen = 0;
 
@@ -131,13 +123,11 @@ void __ntfs_debug (const char *file, int line, const char *function,
 		return;
 	if (function)
 		flen = strlen(function);
-	spin_lock(&err_buf_lock);
 	va_start(args, fmt);
-	vsnprintf(err_buf, sizeof(err_buf), fmt, args);
+	vaf.fmt = fmt;
+	vaf.va = &args;
+	pr_debug("(%s, %d): %s(): %pV", file, line, flen ? function : "", &vaf);
 	va_end(args);
-	printk(KERN_DEBUG "NTFS-fs DEBUG (%s, %d): %s(): %s\n", file, line,
-			flen ? function : "", err_buf);
-	spin_unlock(&err_buf_lock);
 }
 
 /* Dump a runlist. Caller has to provide synchronisation for @rl. */
@@ -149,12 +139,12 @@ void ntfs_debug_dump_runlist(const runlist_element *rl)
 
 	if (!debug_msgs)
 		return;
-	printk(KERN_DEBUG "NTFS-fs DEBUG: Dumping runlist (values in hex):\n");
+	pr_debug("Dumping runlist (values in hex):\n");
 	if (!rl) {
-		printk(KERN_DEBUG "Run list not present.\n");
+		pr_debug("Run list not present.\n");
 		return;
 	}
-	printk(KERN_DEBUG "VCN              LCN               Run length\n");
+	pr_debug("VCN              LCN               Run length\n");
 	for (i = 0; ; i++) {
 		LCN lcn = (rl + i)->lcn;
 
@@ -163,13 +153,13 @@ void ntfs_debug_dump_runlist(const runlist_element *rl)
 
 			if (index > -LCN_ENOENT - 1)
 				index = 3;
-			printk(KERN_DEBUG "%-16Lx %s %-16Lx%s\n",
+			pr_debug("%-16Lx %s %-16Lx%s\n",
 					(long long)(rl + i)->vcn, lcn_str[index],
 					(long long)(rl + i)->length,
 					(rl + i)->length ? "" :
 						" (runlist end)");
 		} else
-			printk(KERN_DEBUG "%-16Lx %-16Lx  %-16Lx%s\n",
+			pr_debug("%-16Lx %-16Lx  %-16Lx%s\n",
 					(long long)(rl + i)->vcn,
 					(long long)(rl + i)->lcn,
 					(long long)(rl + i)->length,
diff --git a/fs/ntfs/debug.h b/fs/ntfs/debug.h
index 53c27ea..61bf091 100644
--- a/fs/ntfs/debug.h
+++ b/fs/ntfs/debug.h
@@ -48,7 +48,12 @@ extern void ntfs_debug_dump_runlist(const runlist_element *rl);
 
 #else	/* !DEBUG */
 
-#define ntfs_debug(f, a...)		do {} while (0)
+#define ntfs_debug(fmt, ...)						\
+do {									\
+	if (0)								\
+		no_printk(fmt, ##__VA_ARGS__);				\
+} while (0)
+
 #define ntfs_debug_dump_runlist(rl)	do {} while (0)
 
 #endif	/* !DEBUG */
diff --git a/fs/ntfs/super.c b/fs/ntfs/super.c
index 82650d5..e23fb9d 100644
--- a/fs/ntfs/super.c
+++ b/fs/ntfs/super.c
@@ -19,6 +19,7 @@
  * distribution in the file COPYING); if not, write to the Free Software
  * Foundation,Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/stddef.h>
 #include <linux/init.h>
@@ -1894,7 +1895,7 @@ get_ctx_vol_failed:
 	vol->minor_ver = vi->minor_ver;
 	ntfs_attr_put_search_ctx(ctx);
 	unmap_mft_record(NTFS_I(vol->vol_ino));
-	printk(KERN_INFO "NTFS volume version %i.%i.\n", vol->major_ver,
+	pr_info("volume version %i.%i.\n", vol->major_ver,
 			vol->minor_ver);
 	if (vol->major_ver < 3 && NVolSparseEnabled(vol)) {
 		ntfs_warning(vol->sb, "Disabling sparse support due to NTFS "
@@ -3093,7 +3094,7 @@ static int __init init_ntfs_fs(void)
 	int err = 0;
 
 	/* This may be ugly but it results in pretty output so who cares. (-8 */
-	printk(KERN_INFO "NTFS driver " NTFS_VERSION " [Flags: R/"
+	pr_info("driver " NTFS_VERSION " [Flags: R/"
 #ifdef NTFS_RW
 			"W"
 #else
@@ -3113,16 +3114,15 @@ static int __init init_ntfs_fs(void)
 			sizeof(ntfs_index_context), 0 /* offset */,
 			SLAB_HWCACHE_ALIGN, NULL /* ctor */);
 	if (!ntfs_index_ctx_cache) {
-		printk(KERN_CRIT "NTFS: Failed to create %s!\n",
-				ntfs_index_ctx_cache_name);
+		pr_crit("Failed to create %s!\n", ntfs_index_ctx_cache_name);
 		goto ictx_err_out;
 	}
 	ntfs_attr_ctx_cache = kmem_cache_create(ntfs_attr_ctx_cache_name,
 			sizeof(ntfs_attr_search_ctx), 0 /* offset */,
 			SLAB_HWCACHE_ALIGN, NULL /* ctor */);
 	if (!ntfs_attr_ctx_cache) {
-		printk(KERN_CRIT "NTFS: Failed to create %s!\n",
-				ntfs_attr_ctx_cache_name);
+		pr_crit("NTFS: Failed to create %s!\n",
+			ntfs_attr_ctx_cache_name);
 		goto actx_err_out;
 	}
 
@@ -3130,8 +3130,7 @@ static int __init init_ntfs_fs(void)
 			(NTFS_MAX_NAME_LEN+1) * sizeof(ntfschar), 0,
 			SLAB_HWCACHE_ALIGN, NULL);
 	if (!ntfs_name_cache) {
-		printk(KERN_CRIT "NTFS: Failed to create %s!\n",
-				ntfs_name_cache_name);
+		pr_crit("Failed to create %s!\n", ntfs_name_cache_name);
 		goto name_err_out;
 	}
 
@@ -3139,8 +3138,7 @@ static int __init init_ntfs_fs(void)
 			sizeof(ntfs_inode), 0,
 			SLAB_RECLAIM_ACCOUNT|SLAB_MEM_SPREAD, NULL);
 	if (!ntfs_inode_cache) {
-		printk(KERN_CRIT "NTFS: Failed to create %s!\n",
-				ntfs_inode_cache_name);
+		pr_crit("Failed to create %s!\n", ntfs_inode_cache_name);
 		goto inode_err_out;
 	}
 
@@ -3149,15 +3147,14 @@ static int __init init_ntfs_fs(void)
 			SLAB_HWCACHE_ALIGN|SLAB_RECLAIM_ACCOUNT|SLAB_MEM_SPREAD,
 			ntfs_big_inode_init_once);
 	if (!ntfs_big_inode_cache) {
-		printk(KERN_CRIT "NTFS: Failed to create %s!\n",
-				ntfs_big_inode_cache_name);
+		pr_crit("Failed to create %s!\n", ntfs_big_inode_cache_name);
 		goto big_inode_err_out;
 	}
 
 	/* Register the ntfs sysctls. */
 	err = ntfs_sysctl(1);
 	if (err) {
-		printk(KERN_CRIT "NTFS: Failed to register NTFS sysctls!\n");
+		pr_crit("Failed to register NTFS sysctls!\n");
 		goto sysctl_err_out;
 	}
 
@@ -3166,7 +3163,7 @@ static int __init init_ntfs_fs(void)
 		ntfs_debug("NTFS driver registered successfully.");
 		return 0; /* Success! */
 	}
-	printk(KERN_CRIT "NTFS: Failed to register NTFS filesystem driver!\n");
+	pr_crit("Failed to register NTFS filesystem driver!\n");
 
 	/* Unregister the ntfs sysctls. */
 	ntfs_sysctl(0);
@@ -3182,8 +3179,7 @@ actx_err_out:
 	kmem_cache_destroy(ntfs_index_ctx_cache);
 ictx_err_out:
 	if (!err) {
-		printk(KERN_CRIT "NTFS: Aborting NTFS filesystem driver "
-				"registration...\n");
+		pr_crit("Aborting NTFS filesystem driver registration...\n");
 		err = -ENOMEM;
 	}
 	return err;
-- 
1.8.4.5

