Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751794AbaEUC1S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 22:27:18 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:15254 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751714AbaEUC1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 22:27:16 -0400
Message-ID: <1400639227.9759.21.camel@pippen.local.home>
Subject: Re: [RFC] x86_64: A real proposal for iret-less return to kernel
From: Steven Rostedt <rostedt@goodmis.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Andi Kleen <andi@firstfloor.org>
Date: Tue, 20 May 2014 22:27:07 -0400
In-Reply-To: <CALCETrXudJ8BkNF_M-r4O40XLN+PnZ5TOZw0P7N4kqo3qngzyg@mail.gmail.com>
References: <CALCETrXudJ8BkNF_M-r4O40XLN+PnZ5TOZw0P7N4kqo3qngzyg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.1-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-05-20 at 17:53 -0700, Andy Lutomirski wrote:
> Here's a real proposal for iret-less return.  If this is correct, then
> NMIs will never nest, which will probably delete a lot more scariness
> than is added by the code I'm describing.

Perhaps we can add this for one window release before we rip out the NMI
nesting code. Perhaps we can add a BUG() if we detect a NMI nest?

> 
> The rest of this email is valid markdown :)  If I end up implementing
> this, this text will go straight into Documentation/x86/x86_64.
> 
> tl;dr: The only particularly tricky cases are exit from #DB, #BP, and
> #MC.  I think they're not so bad, though.
> 
> FWIW, if there's a way to read the NMI masking bit, this would be a
> lot simpler.  I don't know of any way to do that, though.

Is there such a thing on all x86?

> 
> `IRET`-less return
> ==================
> 
> There are at least two ways that we can return from a trap entry:
> `IRET` and `RET`.  They have a few important differences.
> 
>   * `IRET` is very slow on all current (2014) CPUs -- it seems to
>     take hundreds of cycles.  `RET` is fast.

s/fast/faster/ or /fast/much faster/

> 
>   * `IRET` unconditionally unmasks NMIs.  `RET` never unmasks NMIs.
> 
>   * `IRET` can change `CS`, `RSP`, `SS`, `RIP`, and `RFLAGS`
>     atomically.  `RET` can't; it requires a return address on the
>     stack, and it can't apply anything other than a small offset to
>     the stack pointer.  It can, in theory, change `CS`, but this
>     seems unlikely to be helpful.
> 
> Times when we must use `IRET`
> =============================
> 
>   * If we're returning to a different `CS` (i.e. if firmware is
>     doing something funny or if we're returning to userspace), then
>     `RET` won't help; we need to use `IRET` unless we're willing to
>     play fragile games with `SYSEXIT` or `SYSRET`.
> 
>   * If we are changing stacks, the we need to be extremely careful

s/the we/then we/

>     about using `RET`: using `RET` requires that we put the target
>     `RIP` on the target stack, so the target stack must be valid.
>     This means that we cannot use `RET` if, for example, a `SYSCALL`
>     just happened.
> 
>   * If we're returning from NMI, we `IRET` is mandatory: we need to

s/we/then/

>     unmask NMIs, and `IRET` is the only way to do that.
> 
> Note that, if `RFLAGS.IF` is set, then interrupts were enabled when
> we trapped, so `RET` is safe.

Is it? You mean if IF is set *and* we are in the kernel?

> 
> Times when we must use `RET`
> ============================
> 
> If there's an NMI on the stack, we must use `RET` until we're ready
> to re-enabled NMIs.

I'm a little confused by NMI on the stack. Do you mean NMI on the target
stack? If so, please state that.


> 
> Assumptions
> ===========
> 
>   * Neither the NMI, the MCE handler, nor anything that nests inside
>     them will ever change `CS` or run with an invalid stack.
> 
>   * Interrupts will never be enabled with an NMI on the stack

target stack?

> .
> 
>   * We explicitly do not assume that we can reliably determine
>     whether we were on user `GS` or kernel `GS` when a trap happens.
>     In current (3.15) kernels we can tell, but if we ever enable
>     `WRGSBASE` then we will lose that ability.
> 
>   * The IST interrupts are: #DB #BP #NM #DF #SS, and #MC.
> 
>   * We can add a per-cpu variable `nmi_mce_nest_count` that is nonzero
>     whenever an NMI or MCE is on the stack.  We'll increment it at the
>     very beginning of the NMI handler and clear it at the very end.
>     We will also increment it in `do_machine_check` before doing
>     anything that can cause an interrupt.  The result is that the only
>     interrupt that can happen with `nmi_mce_nest_count == 0` in NMI
>     context is an MCE at the beginning or end of the NMI handler.

Just note that this will probably be done in the C code, as NMI has
issues with gs being safe.

Also, should we call it "nmi" specifically. Perhaps
"ist_stack_nest_count", stating that the stack is ist to match
do_machine_check as well? Maybe that's not a good name either. Someone
else can come up with something that's a little more generic than NMI?

> 
> 
> The algorithm
> =============
> 
>   1. If the target `CS` is not the standard 64-bit kernel CPL0
>      selector, then never use `RET`.  This is safe: this will never
>      happen with an NMI on the stack.

target stack?

> 
>   2. If we are returning from a non-IST interrupt, then use `RET`.
>      Non-IST interrupts use the interrupted code's stack, so the
>      stack is always valid.
> 
>   3. If we are returning from #NM, then use `IRET`.
> 
>   4. If we are returning from #DF or #SS, then use `IRET`.  These
>      interrupts cannot occur inside an NMI, or, at the very least,
>      if they do happen, then they are not recoverable.
> 
>   5. If we are returning from #DB or #BP, then use `RET` if
>      `nmi_mce_nest_count != 0` and `IRET` otherwise.
> 
>   6. If we are returning from #MC, use `IRET`, unless the return address is
>      to the NMI entry or exit code, in which case we use `RET`.

Seems interesting.

-- Steve


