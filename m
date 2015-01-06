Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127AbbAFBCM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 20:02:12 -0500
Received: from mail-la0-f47.google.com ([209.85.215.47]:44386 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325AbbAFBCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 20:02:09 -0500
MIME-Version: 1.0
In-Reply-To: <54ab2ffa301102cd6e@agluck-desk.sc.intel.com>
References: <CALCETrV6=aWoAckieQkPJ4BCr9VzU=9080EmLfeL4ZWm+Hr55g@mail.gmail.com>
 <54ab2ffa301102cd6e@agluck-desk.sc.intel.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 5 Jan 2015 17:01:46 -0800
Message-ID: <CALCETrV+mchcQ5SgBO8+xLvw9rrHm4yvq+wZtQsD1EMMGzAMEw@mail.gmail.com>
Subject: Re: [PATCH] x86, mce: Get rid of TIF_MCE_NOTIFY and associated mce tricks
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Borislav Petkov <bp@alien8.de>, Paul McKenney <paulmck@linux.vnet.ibm.com>,
        X86 ML <x86@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        Josh Triplett <josh@joshtriplett.org>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 5, 2015 at 4:44 PM, Luck, Tony <tony.luck@intel.com> wrote:
> We now switch to the kernel stack when a machine check interrupts
> during user mode.  This means that we can perform recovery actions
> in the tail of do_machine_check()
>
> Signed-off-by: Tony Luck <tony.luck@intel.com>
>
> ---
> On top of Andy's x86/paranoid branch
> Andy: Should I really move that:
>         pr_err("Uncorrected hardware memory error ...
> inside the ist_begin_non_atomic() section?
>

I think I like it as is.

[...]

> @@ -1220,6 +1177,26 @@ void do_machine_check(struct pt_regs *regs, long error_code)
>         mce_wrmsrl(MSR_IA32_MCG_STATUS, 0);
>  out:
>         sync_core();
> +
> +       if (recover_paddr == ~0ull)
> +               goto done;
> +
> +       pr_err("Uncorrected hardware memory error in user-access at %llx",
> +                recover_paddr);

printk is safe from IRQ context, so this should be okay unless we've
totally screwed up.  And, if we totally screwed up, seeing this before
the BUGs in ist_begin_non_atomic would be nice.

> +       /*
> +        * We must call memory_failure() here even if the current process is
> +        * doomed. We still need to mark the page as poisoned and alert any
> +        * other users of the page.
> +        */
> +       ist_begin_non_atomic(regs);
> +       local_irq_enable();
> +       if (memory_failure(recover_paddr >> PAGE_SHIFT, MCE_VECTOR, flags) < 0) {
> +               pr_err("Memory error not recovered");
> +               force_sig(SIGBUS, current);
> +       }
> +       local_irq_disable();
> +       ist_end_non_atomic();
> +done:
>         ist_exit(regs, prev_state);
>  }

For the context-related bits:

Reviewed-by: Andy Lutomirski <luto@amacapital.net>

Should I stick this in my -next branch so it can stew?

--Andy


-- 
Andy Lutomirski
AMA Capital Management, LLC
