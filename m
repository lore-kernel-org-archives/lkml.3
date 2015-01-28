Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760977AbbA2KqT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 05:46:19 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44737 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753965AbbA2I7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 03:59:45 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Vivek Goyal <vgoyal@redhat.com>, Jan Beulich <JBeulich@suse.com>,
        Junjie Mao <eternal.n08@gmail.com>, Andi Kleen <ak@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 158/176] x86, boot: Skip relocs when load address unchanged
Date: Wed, 28 Jan 2015 15:29:48 +0100
Message-Id: <361b0f0434f6f8ee902eaad1b2d2c6baa6d4257b.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit f285f4a21c3253887caceed493089ece17579d59 upstream.

On 64-bit, relocation is not required unless the load address gets
changed. Without this, relocations do unexpected things when the kernel
is above 4G.

Reported-by: Baoquan He <bhe@redhat.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Tested-by: Thomas D. <whissi@whissi.de>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Jan Beulich <JBeulich@suse.com>
Cc: Junjie Mao <eternal.n08@gmail.com>
Cc: Andi Kleen <ak@linux.intel.com>
Link: http://lkml.kernel.org/r/20150116005146.GA4212@www.outflux.net
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/x86/boot/compressed/misc.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index 434f077d2c4d..1b05afd8cd7f 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -401,6 +401,8 @@ asmlinkage void decompress_kernel(void *rmode, memptr heap,
 				  unsigned char *output,
 				  unsigned long output_len)
 {
+	unsigned char *output_orig = output;
+
 	real_mode = rmode;
 
 	sanitize_boot_params(real_mode);
@@ -439,7 +441,12 @@ asmlinkage void decompress_kernel(void *rmode, memptr heap,
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
 	return;
 }
-- 
2.2.2

