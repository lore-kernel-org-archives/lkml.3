Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751219AbaBZA7h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 19:59:37 -0500
Received: from smtp.outflux.net ([198.145.64.163]:37303 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750755AbaBZA7g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 19:59:36 -0500
Date: Tue, 25 Feb 2014 16:59:17 -0800
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rob Landley <rob@landley.net>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Jianguo Wu <wujianguo@huawei.com>, Andy Honig <ahonig@google.com>,
        David Rientjes <rientjes@google.com>, linux-doc@vger.kernel.org
Subject: [PATCH v3] x86, kaslr: randomize module base load address
Message-ID: <20140226005916.GA27083@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randomize the load address of modules in the kernel to make kASLR
effective for modules.  Modules can only be loaded within a particular
range of virtual address space.  This patch adds 10 bits of entropy to
the load address by adding 1-1024 * PAGE_SIZE to the beginning range
where modules are loaded.

The single base offset was chosen because randomizing each module
load ends up wasting/fragmenting memory too much. Prior approaches to
minimizing fragmentation while doing randomization tend to result in
worse entropy than just doing a single base address offset.

Example kASLR boot without this change, with a single module loaded:
---[ Modules ]---
0xffffffffc0000000-0xffffffffc0001000           4K     ro     GLB x  pte
0xffffffffc0001000-0xffffffffc0002000           4K     ro     GLB NX pte
0xffffffffc0002000-0xffffffffc0004000           8K     RW     GLB NX pte
0xffffffffc0004000-0xffffffffc0200000        2032K                   pte
0xffffffffc0200000-0xffffffffff000000        1006M                   pmd
---[ End Modules ]---

Example kASLR boot after this change, same module loaded:
---[ Modules ]---
0xffffffffc0000000-0xffffffffc0200000           2M                   pmd
0xffffffffc0200000-0xffffffffc03bf000        1788K                   pte
0xffffffffc03bf000-0xffffffffc03c0000           4K     ro     GLB x  pte
0xffffffffc03c0000-0xffffffffc03c1000           4K     ro     GLB NX pte
0xffffffffc03c1000-0xffffffffc03c3000           8K     RW     GLB NX pte
0xffffffffc03c3000-0xffffffffc0400000         244K                   pte
0xffffffffc0400000-0xffffffffff000000        1004M                   pmd
---[ End Modules ]---

Signed-off-by: Andy Honig <ahonig@google.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
v3:
 - describe base address choice in commit message; hpa.
v2:
 - update Documentation/kernel-parameters.txt; akpm.
---
 Documentation/kernel-parameters.txt |    4 ++--
 arch/x86/kernel/module.c            |   43 ++++++++++++++++++++++++++++++++---
 2 files changed, 42 insertions(+), 5 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 7116fda7077f..580a60cabd9b 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2053,8 +2053,8 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			IOAPICs that may be present in the system.
 
 	nokaslr		[X86]
-			Disable kernel base offset ASLR (Address Space
-			Layout Randomization) if built into the kernel.
+			Disable kernel and module base offset ASLR (Address
+			Space Layout Randomization) if built into the kernel.
 
 	noautogroup	Disable scheduler automatic task group creation.
 
diff --git a/arch/x86/kernel/module.c b/arch/x86/kernel/module.c
index 18be189368bb..49483137371f 100644
--- a/arch/x86/kernel/module.c
+++ b/arch/x86/kernel/module.c
@@ -28,6 +28,7 @@
 #include <linux/mm.h>
 #include <linux/gfp.h>
 #include <linux/jump_label.h>
+#include <linux/random.h>
 
 #include <asm/page.h>
 #include <asm/pgtable.h>
@@ -43,13 +44,49 @@ do {							\
 } while (0)
 #endif
 
+#ifdef CONFIG_RANDOMIZE_BASE
+static unsigned long module_load_offset;
+static int randomize_modules = 1;
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
+		mutex_lock(&module_mutex);
+		/*
+		 * Calculate the module_load_offset the first time this
+		 * code is called. Once calculated it stays the same until
+		 * reboot.
+		 */
+		if (module_load_offset == 0)
+			module_load_offset =
+				(get_random_int() % 1024 + 1) * PAGE_SIZE;
+		mutex_unlock(&module_mutex);
+	}
+	return module_load_offset;
+}
+#else
+static unsigned long int get_module_load_offset(void)
+{
+	return 0;
+}
+#endif
+
 void *module_alloc(unsigned long size)
 {
 	if (PAGE_ALIGN(size) > MODULES_LEN)
 		return NULL;
-	return __vmalloc_node_range(size, 1, MODULES_VADDR, MODULES_END,
-				GFP_KERNEL | __GFP_HIGHMEM, PAGE_KERNEL_EXEC,
-				NUMA_NO_NODE, __builtin_return_address(0));
+	return __vmalloc_node_range(size, 1,
+				    MODULES_VADDR + get_module_load_offset(),
+				    MODULES_END, GFP_KERNEL | __GFP_HIGHMEM,
+				    PAGE_KERNEL_EXEC, NUMA_NO_NODE,
+				    __builtin_return_address(0));
 }
 
 #ifdef CONFIG_X86_32
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
