Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751121Ab3F3EH2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jun 2013 00:07:28 -0400
Received: from smtp.outflux.net ([198.145.64.163]:44520 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750737Ab3F3EH0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jun 2013 00:07:26 -0400
Date: Sat, 29 Jun 2013 21:05:15 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: [PATCH] x86, kernel: make dump_pagetables a tristate
Message-ID: <20130630040514.GA20587@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Being able to examine page tables is handy, so make this a module that
can be loaded as needed.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/Kconfig.debug        |    2 +-
 arch/x86/kernel/head.c        |    6 ++++++
 arch/x86/mm/dump_pagetables.c |   13 ++++++++++---
 3 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index c198b7e..a43b7ca 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -70,7 +70,7 @@ config DEBUG_STACKOVERFLOW
 	  If in doubt, say "N".
 
 config X86_PTDUMP
-	bool "Export kernel pagetable layout to userspace via debugfs"
+	tristate "Export kernel pagetable layout to userspace via debugfs"
 	depends on DEBUG_KERNEL
 	select DEBUG_FS
 	---help---
diff --git a/arch/x86/kernel/head.c b/arch/x86/kernel/head.c
index 992f442..871c0ca 100644
--- a/arch/x86/kernel/head.c
+++ b/arch/x86/kernel/head.c
@@ -69,3 +69,9 @@ void __init reserve_ebda_region(void)
 	/* reserve all memory between lowmem and the 1MB mark */
 	memblock_reserve(lowmem, 0x100000 - lowmem);
 }
+
+#ifdef CONFIG_X86_64
+EXPORT_SYMBOL_GPL(init_level4_pgt);
+#else
+EXPORT_SYMBOL_GPL(swapper_pg_dir);
+#endif
diff --git a/arch/x86/mm/dump_pagetables.c b/arch/x86/mm/dump_pagetables.c
index 0002a3a..7a54145 100644
--- a/arch/x86/mm/dump_pagetables.c
+++ b/arch/x86/mm/dump_pagetables.c
@@ -340,6 +340,8 @@ static int ptdump_open(struct inode *inode, struct file *filp)
 	return single_open(filp, ptdump_show, NULL);
 }
 
+static struct dentry *pe;
+
 static const struct file_operations ptdump_fops = {
 	.open		= ptdump_open,
 	.read		= seq_read,
@@ -347,9 +349,8 @@ static const struct file_operations ptdump_fops = {
 	.release	= single_release,
 };
 
-static int pt_dump_init(void)
+static int __init pt_dump_init(void)
 {
-	struct dentry *pe;
 
 #ifdef CONFIG_X86_32
 	/* Not a compile-time constant on x86-32 */
@@ -369,7 +370,13 @@ static int pt_dump_init(void)
 	return 0;
 }
 
-__initcall(pt_dump_init);
+static void __exit pt_dump_exit(void)
+{
+	debugfs_remove_recursive(pe);
+}
+
+module_init(pt_dump_init);
+module_exit(pt_dump_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Arjan van de Ven <arjan@linux.intel.com>");
 MODULE_DESCRIPTION("Kernel debugging helper that dumps pagetables");
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
