Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751619AbaJYXcF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2014 19:32:05 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751490AbaJYXcE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2014 19:32:04 -0400
Message-ID: <544C32EF.60901@nod.at>
Date: Sun, 26 Oct 2014 01:31:59 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: vmalloced stacks on x86_64?
References: <CALCETrUmA+5499fEqp7S-nfSBVxTEo76mA9r32zYQ41E3c+YhQ@mail.gmail.com> <CAFLxGvyLewqhMoHhyBmLdeN5GxOG_-THWBc5bVoG6jY+Pi07VQ@mail.gmail.com> <CALCETrU7NBCcAF6zYjY06SGQt=StNk5kUzUfexKF1CNVaD_o5Q@mail.gmail.com>
In-Reply-To: <CALCETrU7NBCcAF6zYjY06SGQt=StNk5kUzUfexKF1CNVaD_o5Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 26.10.2014 um 01:16 schrieb Andy Lutomirski:
> On Sat, Oct 25, 2014 at 3:26 PM, Richard Weinberger
> <richard.weinberger@gmail.com> wrote:
>> On Sat, Oct 25, 2014 at 2:22 AM, Andy Lutomirski <luto@amacapital.net> wrote:
>>> Is there any good reason not to use vmalloc for x86_64 stacks?
>>>
>>> The tricky bits I've thought of are:
>>>
>>>  - On any context switch, we probably need to probe the new stack
>>> before switching to it.  That way, if it's going to fault due to an
>>> out-of-sync pgd, we still have a stack available to handle the fault.
>>>
>>>  - Any time we change cr3, we may need to check that the pgd
>>> corresponding to rsp is there.  If now, we need to sync it over.
>>>
>>>  - For simplicity, we probably want all stack ptes to be present all
>>> the time.  This is fine; vmalloc already works that way.
>>>
>>>  - If we overrun the stack, we double-fault.  This should be easy to
>>> detect: any double-fault where rsp is less than 20 bytes from the
>>> bottom of the stack is a failure to deliver a non-IST exception due to
>>>  a stack overflow.  The question is: what do we do if this happens?
>>> We could just panic (guaranteed to work).  We could also try to
>>> recover by killing the offending task, but that might be a bit
>>> challenging, since we're in IST context.  We could do something truly
>>> awful: increment RSP by a few hundred bytes, point RIP at do_exit, and
>>> return from the double fault.
>>>
>>> Thoughts?  This shouldn't be all that much code.
>>
>> FWIW, grsecurity has this already.
>> Maybe we can reuse their GRKERNSEC_KSTACKOVERFLOW feature.
>> It allocates the kernel stack using vmalloc() and installs guard pages.
>>
> 
> On brief inspection, grsecurity isn't actually vmallocing the stack.
> It seems to be allocating it the normal way and then vmapping it.
> That allows it to modify sg_set_buf to work on stack addresses (sigh).

Oh, you're right. They have changed it. (But not the Kconfig help of course)
Last time I looked they did a vmalloc().
I'm not sure which version of the patch was but I think it was code like that one:
http://www.grsecurity.net/~spender/kstackovf32.diff

Thanks,
//richard
