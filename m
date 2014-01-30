Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916AbaA3WYP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 17:24:15 -0500
Received: from mail-ve0-f173.google.com ([209.85.128.173]:36570 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752945AbaA3WYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 17:24:12 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.10.1401301442170.2769@minerva.lan>
References: <alpine.DEB.2.10.1401301442170.2769@minerva.lan>
Date: Thu, 30 Jan 2014 14:24:12 -0800
X-Google-Sender-Auth: NEUNdzDX6jm6mE4K-pdYhS3a7B4
Message-ID: <CA+55aFz_CYQGxukpRb5zF5SZ9ZWqpvohoUzqdEb-3+bR_FMnWA@mail.gmail.com>
Subject: Re: [PATCH] Make math_state_restore() save and restore the interrupt flag
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Nate Eldredge <nate@thatsmathematics.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        stable <stable@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Maarten Baert <maarten-baert@hotmail.com>, Jan Kara <jack@suse.cz>,
        George Spelvin <linux@horizon.com>, sbsiddha@gmail.com,
        Pekka Riikonen <priikone@iki.fi>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 30, 2014 at 2:01 PM, Nate Eldredge
<nate@thatsmathematics.com> wrote:
>
> If math_state_restore() is called in a task that has not used math, it
> needs to allocate some memory (via init_fpu()).  Since this can sleep,
> it enables interrupts first.  Currently, it always disables them
> afterwards, regardless of whether or not they were enabled on entry.
> (See commit aa283f4927 where this was introduced.)  This doesn't make
> sense, so instead have it put interrupts back the way they were.

Hmm. What doesn't make sense is to have interrupts disabled in the
caller - since clearly math_state_restore() may actually let
interrupts in.

So while I definitely think your patch fixes a bug, I'm wondering if
we shouldn't look deeper at this issue. The comment above says

 * Must be called with kernel preemption disabled (eg with local
 * local interrupts as in the case of do_device_not_available).

which *kind* of makes sense, but at the same time only reinforces that
whole "if there are reasons why the irq has to be disabled, we can't
just randomly enable it for allocations".

So I really get the feeling that there are more bugs than just the "it
exits with irqs disabled" issue.

>                 The aesni-intel code (encrypting the core
> file that we are writing) needs the FPU and quite properly wraps its
> code in kernel_fpu_{begin,end}(), the latter of which calls
> math_state_restore().

Ok, and this is interesting too.

kernel_fpu_{begin|end}() shouldn't mess around with tsk_used_math(), I
feel. If the task hasn't used math, no reason to allocate any
save-space, because kernel_fpu_end() will just throw it all away
anyway.

Plus we want to be able to do those things from interrupts, and:
 - we can't have blocking allocations
 - we should try to not mess with these kinds of process states from
interrupts anyway

So I think that math_state_restore() and the use_eager_fpu() changes
were actually seriously buggy here wrt that whole !tsk_used_math()
case.

I'm adding in some people here, because I think in the end this bug
was introduced by commit 304bceda6a18 ("x86, fpu: use non-lazy fpu
restore for processors supporting xsave") that introduced that
math_state_restore() in kernel_fpu_end(), but we have other commits
(like 5187b28ff08: "x86: Allow FPU to be used at interrupt time even
with eagerfpu") that seem tangential too and might be part of why it
actually *triggers* now.

Comments?

               Linus
