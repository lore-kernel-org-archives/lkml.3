Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752422AbaJYW0M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2014 18:26:12 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:44403 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752396AbaJYW0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2014 18:26:08 -0400
MIME-Version: 1.0
In-Reply-To: <CALCETrUmA+5499fEqp7S-nfSBVxTEo76mA9r32zYQ41E3c+YhQ@mail.gmail.com>
References: <CALCETrUmA+5499fEqp7S-nfSBVxTEo76mA9r32zYQ41E3c+YhQ@mail.gmail.com>
Date: Sun, 26 Oct 2014 00:26:07 +0200
Message-ID: <CAFLxGvyLewqhMoHhyBmLdeN5GxOG_-THWBc5bVoG6jY+Pi07VQ@mail.gmail.com>
Subject: Re: vmalloced stacks on x86_64?
From: Richard Weinberger <richard.weinberger@gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 25, 2014 at 2:22 AM, Andy Lutomirski <luto@amacapital.net> wrote:
> Is there any good reason not to use vmalloc for x86_64 stacks?
>
> The tricky bits I've thought of are:
>
>  - On any context switch, we probably need to probe the new stack
> before switching to it.  That way, if it's going to fault due to an
> out-of-sync pgd, we still have a stack available to handle the fault.
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

FWIW, grsecurity has this already.
Maybe we can reuse their GRKERNSEC_KSTACKOVERFLOW feature.
It allocates the kernel stack using vmalloc() and installs guard pages.

-- 
Thanks,
//richard
