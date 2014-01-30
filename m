Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379AbaA3NrC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 08:47:02 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55292 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753200AbaA3Nq7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 08:46:59 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <1391079628.26079.82.camel@shinybook.infradead.org>
References: <1390996897.20153.123.camel@i7.infradead.org> <tip-9b3614ccfa5492f57f743f3856253f285b10a702@git.kernel.org> <20140130090902.GA2749@gmail.com> <1391079628.26079.82.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH v2] x86, boot: Fix word-size assumptions in has_eflag () inline asm
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 30 Jan 2014 05:45:50 -0800
To: David Woodhouse <dwmw2@infradead.org>, Ingo Molnar <mingo@kernel.org>
CC: linux-kernel@vger.kernel.org, keescook@chromium.org, tglx@linutronix.de,
        hpa@linux.intel.com, linux-tip-commits@vger.kernel.org
Message-ID: <a78f892e-ad61-4a51-9ffe-466b473d3cde@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This would seem like a job for <asm/asm.h>.

On January 30, 2014 3:00:28 AM PST, David Woodhouse <dwmw2@infradead.org> wrote:
>Commit dd78b97367bd575918204cc89107c1479d3fc1a7 ("x86, boot: Move CPU
>flags out of cpucheck") introduced ambiguous inline asm in the
>has_eflag() function. In 16-bit mode want the instruction to be
>'pushfl', but we just say 'pushf' and hope the compiler does what we
>wanted.
>
>When building with 'clang -m16', it won't, because clang doesn't use
>the horrid '.code16gcc' hack that even 'gcc -m16' uses internally.
>
>Say what we mean and don't make the compiler make assumptions.
>
>Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
>---
>
>Let me know if you'd rather have this as an incremental patch. I would
>have preferred checking for BITS_PER_LONG==64 rather than __x86_64__
>but it seems we set that to 64 even when building the 16-bit code.
>
> arch/x86/boot/cpuflags.c | 25 ++++++++++++++++++++-----
> 1 file changed, 20 insertions(+), 5 deletions(-)
>
>diff --git a/arch/x86/boot/cpuflags.c b/arch/x86/boot/cpuflags.c
>index a9fcb7c..431fa5f 100644
>--- a/arch/x86/boot/cpuflags.c
>+++ b/arch/x86/boot/cpuflags.c
>@@ -28,20 +28,35 @@ static int has_fpu(void)
> 	return fsw == 0 && (fcw & 0x103f) == 0x003f;
> }
> 
>+/*
>+ * For building the 16-bit code we want to explicitly specify 32-bit
>+ * push/pop operations, rather than just saying 'pushf' or 'popf' and
>+ * letting the compiler choose. But this is also included from the
>+ * compressed/ directory where it may be 64-bit code, and thus needs
>+ * to be 'pushfq' or 'popfq' in that case.
>+ */
>+#ifdef __x86_64__
>+#define PUSHF "pushfq"
>+#define POPF "popfq"
>+#else
>+#define PUSHF "pushfl"
>+#define POPF "popfl"
>+#endif
>+
> int has_eflag(unsigned long mask)
> {
> 	unsigned long f0, f1;
> 
>-	asm volatile("pushf	\n\t"
>-		     "pushf	\n\t"
>+	asm volatile(PUSHF "	\n\t"
>+		     PUSHF "	\n\t"
> 		     "pop %0	\n\t"
> 		     "mov %0,%1	\n\t"
> 		     "xor %2,%1	\n\t"
> 		     "push %1	\n\t"
>-		     "popf	\n\t"
>-		     "pushf	\n\t"
>+		     POPF "	\n\t"
>+		     PUSHF "	\n\t"
> 		     "pop %1	\n\t"
>-		     "popf"
>+		     POPF
> 		     : "=&r" (f0), "=&r" (f1)
> 		     : "ri" (mask));
> 

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
