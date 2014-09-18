Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757277AbaIRUPl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 16:15:41 -0400
Received: from smtp.outflux.net ([198.145.64.163]:57304 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756232AbaIRUPk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 16:15:40 -0400
Date: Thu, 18 Sep 2014 13:14:52 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Russell King <linux@arm.linux.org.uk>,
        Andrey Ryabinin <a.ryabinin@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Jianguo Wu <wujianguo@huawei.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH] arm, kaslr: randomize module base address
Message-ID: <20140918201452.GA1653@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While we don't yet have text base address randomization in ARM, we can
do module base address randomization. This bumps the module base by up
to 4MiB.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/arm/Kconfig         |  8 ++++++++
 arch/arm/kernel/module.c | 45 ++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 50 insertions(+), 3 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 32cbbd565902..47b03360aa51 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1769,6 +1769,14 @@ config XEN
 	help
 	  Say Y if you want to run Linux in a Virtual Machine on Xen on ARM.
 
+config RANDOMIZE_BASE
+	bool "Randomize the base address of loaded modules"
+	depends on MMU
+	default n
+	---help---
+	   Randomizes the base address at which kernel modules are loaded,
+	   with 10 bits of entropy. At most, this will create a 4MiB gap
+	   at the start of the kernel modules virtual address range.
 endmenu
 
 menu "Boot options"
diff --git a/arch/arm/kernel/module.c b/arch/arm/kernel/module.c
index 6a4dffefd357..f7cf7e84905e 100644
--- a/arch/arm/kernel/module.c
+++ b/arch/arm/kernel/module.c
@@ -19,6 +19,7 @@
 #include <linux/fs.h>
 #include <linux/string.h>
 #include <linux/gfp.h>
+#include <linux/random.h>
 
 #include <asm/pgtable.h>
 #include <asm/sections.h>
@@ -38,11 +39,49 @@
 #endif
 
 #ifdef CONFIG_MMU
+# ifdef CONFIG_RANDOMIZE_BASE
+static unsigned long module_load_offset;
+static int randomize_modules = 1;
+
+/* Mutex protects the module_load_offset. */
+static DEFINE_MUTEX(module_kaslr_mutex);
+
+static int __init parse_nokaslr(char *p)
+{
+	randomize_modules = 0;
+	return 0;
+}
+early_param("nokaslr", parse_nokaslr);
+
+static unsigned long int get_module_load_offset(void)
+{
+	if (randomize_modules) {
+		mutex_lock(&module_kaslr_mutex);
+		/*
+		 * Calculate the module_load_offset the first time this
+		 * code is called. Once calculated it stays the same until
+		 * reboot.
+		 */
+		if (module_load_offset == 0)
+			module_load_offset =
+				(get_random_int() % 1024 + 1) * PAGE_SIZE;
+		mutex_unlock(&module_kaslr_mutex);
+	}
+	return module_load_offset;
+}
+# else
+static unsigned long int get_module_load_offset(void)
+{
+	return 0;
+}
+# endif
+
 void *module_alloc(unsigned long size)
 {
-	return __vmalloc_node_range(size, 1, MODULES_VADDR, MODULES_END,
-				GFP_KERNEL, PAGE_KERNEL_EXEC, NUMA_NO_NODE,
-				__builtin_return_address(0));
+	return __vmalloc_node_range(size, 1,
+				MODULES_VADDR + get_module_load_offset(),
+				MODULES_END, GFP_KERNEL, PAGE_KERNEL_EXEC,
+				NUMA_NO_NODE, __builtin_return_address(0));
 }
 #endif
 
-- 
1.9.1


-- 
Kees Cook
Chrome OS Security
