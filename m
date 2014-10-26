Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750965AbaJZELy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 00:11:54 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:53543 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbaJZELx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 00:11:53 -0400
MIME-Version: 1.0
In-Reply-To: <CALCETrUmA+5499fEqp7S-nfSBVxTEo76mA9r32zYQ41E3c+YhQ@mail.gmail.com>
References: <CALCETrUmA+5499fEqp7S-nfSBVxTEo76mA9r32zYQ41E3c+YhQ@mail.gmail.com>
Date: Sun, 26 Oct 2014 05:11:51 +0100
Message-ID: <CAFTL4hz87W1G2atf3mt+aG72Q-z8MwxFpguQgtT9kvHYE7pKEw@mail.gmail.com>
Subject: Re: vmalloced stacks on x86_64?
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Richard Weinberger <richard.weinberger@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-10-25 2:22 GMT+02:00 Andy Lutomirski <luto@amacapital.net>:
> Is there any good reason not to use vmalloc for x86_64 stacks?
>
> The tricky bits I've thought of are:
>
>  - On any context switch, we probably need to probe the new stack
> before switching to it.  That way, if it's going to fault due to an
> out-of-sync pgd, we still have a stack available to handle the fault.

Would that prevent from any further fault on a vmalloc'ed kernel
stack? We would need to ensure that pre-faulting, say the first byte,
is enough to sync the whole new stack entirely otherwise we risk
another future fault and some places really aren't safely faulted.

>
>  - Any time we change cr3, we may need to check that the pgd
> corresponding to rsp is there.  If now, we need to sync it over.
>
>  - For simplicity, we probably want all stack ptes to be present all
> the time.  This is fine; vmalloc already works that way.
>
>  - If we overrun the stack, we double-fault.  This should be easy to
> detect: any double-fault where rsp is less than 20 bytes from the
> bottom of the stack is a failure to deliver a non-IST exception due to
>  a stack overflow.  The question is: what do we do if this happens?
> We could just panic (guaranteed to work).  We could also try to
> recover by killing the offending task, but that might be a bit
> challenging, since we're in IST context.  We could do something truly
> awful: increment RSP by a few hundred bytes, point RIP at do_exit, and
> return from the double fault.
>
> Thoughts?  This shouldn't be all that much code.
