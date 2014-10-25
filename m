Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751623AbaJYXQq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2014 19:16:46 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:57700 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386AbaJYXQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2014 19:16:45 -0400
MIME-Version: 1.0
In-Reply-To: <CAFLxGvyLewqhMoHhyBmLdeN5GxOG_-THWBc5bVoG6jY+Pi07VQ@mail.gmail.com>
References: <CALCETrUmA+5499fEqp7S-nfSBVxTEo76mA9r32zYQ41E3c+YhQ@mail.gmail.com>
 <CAFLxGvyLewqhMoHhyBmLdeN5GxOG_-THWBc5bVoG6jY+Pi07VQ@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sat, 25 Oct 2014 16:16:23 -0700
Message-ID: <CALCETrU7NBCcAF6zYjY06SGQt=StNk5kUzUfexKF1CNVaD_o5Q@mail.gmail.com>
Subject: Re: vmalloced stacks on x86_64?
To: Richard Weinberger <richard.weinberger@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 25, 2014 at 3:26 PM, Richard Weinberger
<richard.weinberger@gmail.com> wrote:
> On Sat, Oct 25, 2014 at 2:22 AM, Andy Lutomirski <luto@amacapital.net> wrote:
>> Is there any good reason not to use vmalloc for x86_64 stacks?
>>
>> The tricky bits I've thought of are:
>>
>>  - On any context switch, we probably need to probe the new stack
>> before switching to it.  That way, if it's going to fault due to an
>> out-of-sync pgd, we still have a stack available to handle the fault.
>>
>>  - Any time we change cr3, we may need to check that the pgd
>> corresponding to rsp is there.  If now, we need to sync it over.
>>
>>  - For simplicity, we probably want all stack ptes to be present all
>> the time.  This is fine; vmalloc already works that way.
>>
>>  - If we overrun the stack, we double-fault.  This should be easy to
>> detect: any double-fault where rsp is less than 20 bytes from the
>> bottom of the stack is a failure to deliver a non-IST exception due to
>>  a stack overflow.  The question is: what do we do if this happens?
>> We could just panic (guaranteed to work).  We could also try to
>> recover by killing the offending task, but that might be a bit
>> challenging, since we're in IST context.  We could do something truly
>> awful: increment RSP by a few hundred bytes, point RIP at do_exit, and
>> return from the double fault.
>>
>> Thoughts?  This shouldn't be all that much code.
>
> FWIW, grsecurity has this already.
> Maybe we can reuse their GRKERNSEC_KSTACKOVERFLOW feature.
> It allocates the kernel stack using vmalloc() and installs guard pages.
>

On brief inspection, grsecurity isn't actually vmallocing the stack.
It seems to be allocating it the normal way and then vmapping it.
That allows it to modify sg_set_buf to work on stack addresses (sigh).

After each switch_mm, it probes the whole kernel stack.  (This seems
dangerous to me -- if the live stack isn't mapped in the new mm, won't
that double-fault?)  I also see no evidence that it probes the new
stack when switching stacks.  I suspect that it only works because it
gets lucky.

If we're worried about on-stack DMA, we could (by config option or
otherwise) allow DMA on a vmalloced stack, at least through the sg
interfaces.  And we could WARN and fix it :)

--Andy

P.S.  I see what appears to be some of my code in grsec.  I feel
entirely justified in taking good bits of grsec and sticking them in
the upstream kernel.
