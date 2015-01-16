Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176AbbAPAwJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 19:52:09 -0500
Received: from smtp.outflux.net ([198.145.64.163]:43515 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753029AbbAPAwH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 19:52:07 -0500
Date: Thu, 15 Jan 2015 16:51:46 -0800
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Vivek Goyal <vgoyal@redhat.com>, Jan Beulich <JBeulich@suse.com>,
        Junjie Mao <eternal.n08@gmail.com>, Andi Kleen <ak@linux.intel.com>,
        Baoquan He <bhe@redhat.com>, "Thomas D." <whissi@whissi.de>
Subject: [PATCH] x86, boot: skip relocs when load address unchanged
Message-ID: <20150116005146.GA4212@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 64-bit, relocation is not required unless the load address gets
changed. Without this, relocations do unexpected things when the kernel
is above 4G.

Reported-by: Baoquan He <bhe@redhat.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: stable@vger.kernel.org
---
This is a reimplementation of Baoquan's "kaslr: check if kernel location is
changed", which performs the check without needing to change the function
declaration. This should have exactly the same effect, but I dropped Vivek's
Ack and Thomas's Test, since it's technically a different patch.
---
 arch/x86/boot/compressed/misc.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index dcc1c536cc21..a950864a64da 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -373,6 +373,8 @@ asmlinkage __visible void *decompress_kernel(void *rmode, memptr heap,
 				  unsigned long output_len,
 				  unsigned long run_size)
 {
+	unsigned char *output_orig = output;
+
 	real_mode = rmode;
 
 	sanitize_boot_params(real_mode);
@@ -421,7 +423,12 @@ asmlinkage __visible void *decompress_kernel(void *rmode, memptr heap,
 	debug_putstr("\nDecompressing Linux... ");
 	decompress(input_data, input_len, NULL, NULL, output, NULL, error);
 	parse_elf(output);
-	handle_relocations(output, output_len);
+	/*
+	 * 32-bit always performs relocations. 64-bit relocations are only
+	 * needed if kASLR has chosen a different load address.
+	 */
+	if (!IS_ENABLED(CONFIG_X86_64) || output != output_orig)
+		handle_relocations(output, output_len);
 	debug_putstr("done.\nBooting the kernel.\n");
 	return output;
 }
-- 
1.9.1


-- 
Kees Cook
Chrome OS Security
