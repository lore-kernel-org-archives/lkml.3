Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765AbbAXLOn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 06:14:43 -0500
Received: from mail.skyhub.de ([78.46.96.112]:39502 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751557AbbAXLOi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 06:14:38 -0500
Date: Sat, 24 Jan 2015 12:14:30 +0100
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <h.peter.anvin@intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v2 0/2] add support for new persistent memory instructions
Message-ID: <20150124111430.GA10084@pd.tnic>
References: <1422045628-16225-1-git-send-email-ross.zwisler@linux.intel.com>
 <54C2D34D.7010709@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <54C2D34D.7010709@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2015 at 03:03:41PM -0800, H. Peter Anvin wrote:
> For the specific case of CLWB, we can use an "m" input rather than a
> "+m" output, simply because CLWB (or CLFLUSH* used as a standin for CLWB
> doesn't need to be ordered with respect to loads (whereas CLFLUSH* do).

Well, we could do something like:

        volatile struct { char x[64]; } *p = __p;

        if (static_cpu_has(X86_FEATURE_CLWB))
                asm volatile(".byte 0x66,0x0f,0xae,0x30" :: "m" (*p), "a" (p));
        else
                asm volatile(ALTERNATIVE(
                        ".byte 0x3e; clflush (%[pax])",
                        ".byte 0x66; clflush (%[pax])", /* clflushopt (%%rax) */
                        X86_FEATURE_CLFLUSHOPT)
                        : [p] "+m" (*p)
                        : [pax] "a" (p));

which would simplify the alternative macro too.

Generated asm looks ok to me (my objdump doesn't know CLWB yet :)):

0000000000000aa0 <myclflush>:
 aa0:   55                      push   %rbp
 aa1:   48 89 e5                mov    %rsp,%rbp
 aa4:   eb 0a                   jmp    ab0 <myclflush+0x10>
 aa6:   48 89 f8                mov    %rdi,%rax
 aa9:   66 0f ae 30             data16 xsaveopt (%rax)
 aad:   5d                      pop    %rbp
 aae:   c3                      retq
 aaf:   90                      nop
 ab0:   48 89 f8                mov    %rdi,%rax
 ab3:   3e 0f ae 38             clflush %ds:(%rax)
 ab7:   5d                      pop    %rbp
 ab8:   c3                      retq

> Should we use an SFENCE as a standin if pcommit is unavailable, in case
> we end up using CLFLUSHOPT?

Btw, is PCOMMIT a lightweight SFENCE for this persistent memory aspect
to make sure stuff has become persistent after executing it? But not all
stuff like SFENCE so SFENCE is the bigger hammer?

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
--
