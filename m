Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752142AbaBZBJr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 20:09:47 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34207 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910AbaBZBJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 20:09:44 -0500
Date: Tue, 25 Feb 2014 17:09:26 -0800
From: tip-bot for Kees Cook <tipbot@zytor.com>
Message-ID: <tip-e2b32e6785138d92d2a40e0d0473575c8c7310a2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, ahonig@google.com, hpa@zytor.com,
        mingo@kernel.org, keescook@chromium.org, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, ahonig@google.com,
        linux-kernel@vger.kernel.org, keescook@chromium.org,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <20140226005916.GA27083@www.outflux.net>
References: <20140226005916.GA27083@www.outflux.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/kaslr] x86, kaslr: randomize module base load address
Git-Commit-ID: e2b32e6785138d92d2a40e0d0473575c8c7310a2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e2b32e6785138d92d2a40e0d0473575c8c7310a2
Gitweb:     http://git.kernel.org/tip/e2b32e6785138d92d2a40e0d0473575c8c7310a2
Author:     Kees Cook <keescook@chromium.org>
AuthorDate: Tue, 25 Feb 2014 16:59:17 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 25 Feb 2014 17:07:26 -0800

x86, kaslr: randomize module base load address

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
Link: http://lkml.kernel.org/r/20140226005916.GA27083@www.outflux.net
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 Documentation/kernel-parameters.txt |  4 ++--
 arch/x86/kernel/module.c            | 43 ++++++++++++++++++++++++++++++++++---
 2 files changed, 42 insertions(+), 5 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 7116fda..580a60c 100644
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
index 18be189..4948313 100644
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
