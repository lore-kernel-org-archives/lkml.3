Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933942AbbA1B6u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 20:58:50 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41426 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933235AbbA1BiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 20:38:23 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Baoquan He <bhe@redhat.com>, Kees Cook <keescook@chromium.org>,
        "Thomas D." <whissi@whissi.de>, Vivek Goyal <vgoyal@redhat.com>,
        Jan Beulich <JBeulich@suse.com>, Junjie Mao <eternal.n08@gmail.com>,
        Andi Kleen <ak@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 3.14 25/77] x86, boot: Skip relocs when load address unchanged
Date: Tue, 27 Jan 2015 17:27:03 -0800
Message-Id: <20150128012746.725341230@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150128012745.971137091@linuxfoundation.org>
References: <20150128012745.971137091@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/boot/compressed/misc.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -396,6 +396,8 @@ asmlinkage void *decompress_kernel(void
 				  unsigned long output_len,
 				  unsigned long run_size)
 {
+	unsigned char *output_orig = output;
+
 	real_mode = rmode;
 
 	sanitize_boot_params(real_mode);
@@ -444,7 +446,12 @@ asmlinkage void *decompress_kernel(void
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


