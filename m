Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176AbaI3HKf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 03:10:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14143 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751365AbaI3HKd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 03:10:33 -0400
From: Baoquan He <bhe@redhat.com>
To: hpa@zytor.com
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        x86@kernel.org, vgoyal@redhat.com, keescook@chromium.org,
        ak@linux.intel.com, ebiederm@xmission.com, kexec@lists.infradead.org,
        whissi@whissi.de, kumagai-atsushi@mxc.nes.nec.co.jp,
        Baoquan He <bhe@redhat.com>, stable@vger.kernel.org
Subject: [resend Patch v3 1/2] kaslr: check if kernel location is changed
Date: Tue, 30 Sep 2014 15:08:15 +0800
Message-Id: <1412060896-1902-1-git-send-email-bhe@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function handle_relocations() is used to do the relocations handling
for i686 and kaslr of x86_64. For 32 bit the relocation handling is
mandotary to perform. For x86_64 only when kaslr is enabled and a
random kernel location is chosen successfully the relocation handling
shound be done. However previous implementation only compared the
kernel loading address and LOAD_PHYSICAL_ADDR where kernel were
compiled to run at. This would casue system to be exceptional in
few conditions like when delta between load address and compiled
address is bigger than what 32bit signed relocations can handle.
Also there will be limitations that delta can't be too big otherwise
kernel text virtual addresses will overflow in module address space.

So in this patch check if kernel location is changed after
choose_kernel_location() when x86_64. If and only if in x86_64
and kernel location is changed, we say a kaslr random kernel
location is chosen, then the relocation handling is needed.

Signed-off-by: Baoquan He <bhe@redhat.com>
Acked-by: Vivek Goyal <vgoyal@redhat.com>
Acked-by: Kees Cook <keescook@chromium.org>
Tested-by: Thomas D. <whissi@whissi.de>
Cc: stable@vger.kernel.org
---
 arch/x86/boot/compressed/misc.c | 26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index 57ab74d..3bb2a17 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -230,8 +230,9 @@ static void error(char *x)
 		asm("hlt");
 }
 
-#if CONFIG_X86_NEED_RELOCS
-static void handle_relocations(void *output, unsigned long output_len)
+#ifdef CONFIG_X86_NEED_RELOCS
+static void handle_relocations(void *output_orig, void *output,
+			       unsigned long output_len)
 {
 	int *reloc;
 	unsigned long delta, map, ptr;
@@ -239,6 +240,20 @@ static void handle_relocations(void *output, unsigned long output_len)
 	unsigned long max_addr = min_addr + output_len;
 
 	/*
+	* 32bit always requires relocations to be performed. For x86_64,
+	* relocations need to be performed only if kaslr has chosen a
+	* different load address then kernel was originally loaded at.
+	*
+	* If we are here, either kaslr is not configured in or kaslr is disabled
+	* or kaslr has chosen not to change the load location of kernel. Don't
+	* perform any relocations.
+	*/
+#if CONFIG_X86_64
+	if (output_orig == output)
+		return;
+#endif
+
+	/*
 	 * Calculate the delta between where vmlinux was linked to load
 	 * and where it was actually loaded.
 	 */
@@ -299,7 +314,8 @@ static void handle_relocations(void *output, unsigned long output_len)
 #endif
 }
 #else
-static inline void handle_relocations(void *output, unsigned long output_len)
+static inline void handle_relocations(void *output_orig, void *output,
+				      unsigned long output_len)
 { }
 #endif
 
@@ -360,6 +376,8 @@ asmlinkage __visible void *decompress_kernel(void *rmode, memptr heap,
 				  unsigned char *output,
 				  unsigned long output_len)
 {
+	unsigned char *output_orig = output;
+
 	real_mode = rmode;
 
 	sanitize_boot_params(real_mode);
@@ -402,7 +420,7 @@ asmlinkage __visible void *decompress_kernel(void *rmode, memptr heap,
 	debug_putstr("\nDecompressing Linux... ");
 	decompress(input_data, input_len, NULL, NULL, output, NULL, error);
 	parse_elf(output);
-	handle_relocations(output, output_len);
+	handle_relocations(output_orig, output, output_len);
 	debug_putstr("done.\nBooting the kernel.\n");
 	return output;
 }
-- 
1.8.5.3

