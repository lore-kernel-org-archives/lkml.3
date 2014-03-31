Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708AbaCaPeJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 11:34:09 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:33371 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887AbaCaPeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 11:34:06 -0400
Date: Mon, 31 Mar 2014 17:34:02 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/kaslr changes for v3.15
Message-ID: <20140331153402.GA12849@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-kaslr-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-kaslr-for-linus

   # HEAD: 9dd721c6dbfc310f94306902611f86dda87a45fa x86, kaslr: fix module lock ordering problem

This adds kernel module load address randomization.

 Thanks,

	Ingo

------------------>
Kees Cook (2):
      x86, kaslr: randomize module base load address
      x86, kaslr: fix module lock ordering problem


 Documentation/kernel-parameters.txt |  4 ++--
 arch/x86/kernel/module.c            | 46 ++++++++++++++++++++++++++++++++++---
 2 files changed, 45 insertions(+), 5 deletions(-)

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
index 18be189..e69f988 100644
--- a/arch/x86/kernel/module.c
+++ b/arch/x86/kernel/module.c
@@ -28,6 +28,7 @@
 #include <linux/mm.h>
 #include <linux/gfp.h>
 #include <linux/jump_label.h>
+#include <linux/random.h>
 
 #include <asm/page.h>
 #include <asm/pgtable.h>
@@ -43,13 +44,52 @@ do {							\
 } while (0)
 #endif
 
+#ifdef CONFIG_RANDOMIZE_BASE
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
