Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889AbbATLm4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 06:42:56 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56503 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938AbbATLmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 06:42:54 -0500
Date: Tue, 20 Jan 2015 03:42:35 -0800
From: tip-bot for Kees Cook <tipbot@zytor.com>
Message-ID: <tip-f285f4a21c3253887caceed493089ece17579d59@git.kernel.org>
Cc: whissi@whissi.de, bhe@redhat.com, vgoyal@redhat.com, keescook@chromium.org,
        hpa@zytor.com, JBeulich@suse.com, linux-kernel@vger.kernel.org,
        eternal.n08@gmail.com, ak@linux.intel.com, mingo@kernel.org,
        tglx@linutronix.de
Reply-To: whissi@whissi.de, vgoyal@redhat.com, bhe@redhat.com,
        keescook@chromium.org, linux-kernel@vger.kernel.org, JBeulich@suse.com,
        hpa@zytor.com, ak@linux.intel.com, eternal.n08@gmail.com,
        mingo@kernel.org, tglx@linutronix.de
In-Reply-To: <20150116005146.GA4212@www.outflux.net>
References: <20150116005146.GA4212@www.outflux.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, boot:
  Skip relocs when load address unchanged
Git-Commit-ID: f285f4a21c3253887caceed493089ece17579d59
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

Commit-ID:  f285f4a21c3253887caceed493089ece17579d59
Gitweb:     http://git.kernel.org/tip/f285f4a21c3253887caceed493089ece17579d59
Author:     Kees Cook <keescook@chromium.org>
AuthorDate: Thu, 15 Jan 2015 16:51:46 -0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 20 Jan 2015 12:37:23 +0100

x86, boot: Skip relocs when load address unchanged

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
Cc: stable@vger.kernel.org
Link: http://lkml.kernel.org/r/20150116005146.GA4212@www.outflux.net
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/boot/compressed/misc.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index dcc1c53..a950864 100644
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
