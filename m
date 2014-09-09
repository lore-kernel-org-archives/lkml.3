Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932208AbaIIGZz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 02:25:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28407 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932069AbaIIGZy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 02:25:54 -0400
Date: Tue, 9 Sep 2014 14:24:16 +0800
From: Baoquan He <bhe@redhat.com>
To: Kees Cook <keescook@chromium.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Deutschmann <whissi@whissi.de>,
        Dave Young <dyoung@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Vivek Goyal <vgoyal@redhat.com>, WANG Chao <chaowang@redhat.com>
Subject: Re: [PATCH 1/4] kaslr: check user's config too when handle
 relocations
Message-ID: <20140909062416.GA2872@dhcp-16-105.nay.redhat.com>
References: <1409926097-2101-1-git-send-email-bhe@redhat.com>
 <1409926097-2101-2-git-send-email-bhe@redhat.com>
 <CAGXu5j+ih52B+ert+OF2wtm07wZDS_u6S0H7bwfycpJuBXT2_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5j+ih52B+ert+OF2wtm07wZDS_u6S0H7bwfycpJuBXT2_w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/14 at 10:11am, Kees Cook wrote:
> I don't think this is correct. If you look at a02150610776 ("x86,
> relocs: Move ELF relocation handling to C"), we always did relocations
> on 32-bit when CONFIG_RELOCATABLE was set, so I think this will fail
> badly on 32-bit. 64-bit only needs relocation when
> CONFIG_RANDOMIZE_BASE is set, so this is probably what needs to be
> tested here instead. I think a better option would be, in
> decompress_kernel(), to compare output before and after
> choose_kernel_location(). If it's the same on 64-bit,
> handle_relocations() can be skipped. (Perhaps pass the before/after to
> handle_relocations() and it can perform the logic.)
> 
> -Kees

Hi Kees,

Checking handle_relocations() again, I just didn't notice it's mandatory
to do the relocations handling in i386. So in this function delta is
checked to see if it's a kaslr relocation handling. This might be a
little confusing. But I am fine with it.

Per your comment, you prefer to compare the output before and after
choose_kernel_location(). That's also good, Lu Yinghai posted a draft
patch in this way before, however the checking and the delta calculation
are not correct. I changed that and test all cases, it works well. So
do you like this it? If yes  I will repost it.

>From 13471bd838c52a0e143c2aee81e3863cfff585bd Mon Sep 17 00:00:00 2001
From: Baoquan He <bhe@redhat.com>
Date: Mon, 25 Aug 2014 14:57:43 +0800
Subject: [PATCH] kaslr: check if kernel location is changed

Signed-off-by: Baoquan He <bhe@redhat.com>
---
 arch/x86/boot/compressed/misc.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index 57ab74d..887f404 100644
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
@@ -242,6 +243,9 @@ static void handle_relocations(void *output, unsigned long output_len)
 	 * Calculate the delta between where vmlinux was linked to load
 	 * and where it was actually loaded.
 	 */
+	if (output_orig == output)
+		return;
+
 	delta = min_addr - LOAD_PHYSICAL_ADDR;
 	if (!delta) {
 		debug_putstr("No relocation needed... ");
@@ -299,7 +303,8 @@ static void handle_relocations(void *output, unsigned long output_len)
 #endif
 }
 #else
-static inline void handle_relocations(void *output, unsigned long output_len)
+static inline void handle_relocations(void *output_orig, void *output,
+				      unsigned long output_len)
 { }
 #endif
 
@@ -360,6 +365,8 @@ asmlinkage __visible void *decompress_kernel(void *rmode, memptr heap,
 				  unsigned char *output,
 				  unsigned long output_len)
 {
+	unsigned char *output_orig = output;
+
 	real_mode = rmode;
 
 	sanitize_boot_params(real_mode);
@@ -402,7 +409,7 @@ asmlinkage __visible void *decompress_kernel(void *rmode, memptr heap,
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

