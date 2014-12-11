Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933588AbaLKCrw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 21:47:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41662 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933176AbaLKCrv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 21:47:51 -0500
Message-ID: <5488FD32.9040100@redhat.com>
Date: Wed, 10 Dec 2014 21:10:58 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: Daniel J Blueman <daniel@quora.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH, 3.18] sleeping function called from invalid context
References: <CAMVG2su302Nvtp+fnaOjtLadJFtpPmVXiN5YfQ0JpT920YohuA@mail.gmail.com> <CALCETrXZpQyKbVkBMwqFq2wH908-V+WCuvtaTc1O9VNZFHrBUQ@mail.gmail.com> <CAMVG2svoTbm3k3W5POpLsJnpXBPpZRYVr+wmAQrWVGVtiQ=LRA@mail.gmail.com> <5488EA01.6020600@redhat.com> <CALCETrVGH0VbGDWEx-D=gU7o3keM6PgGfYLixADH-sgNxhxJDA@mail.gmail.com> <5488F432.5010405@redhat.com> <CALCETrV5jH6GJb=WVqMe7M1=JFPOWKm5r3QRkmF0jBy4joCyYA@mail.gmail.com>
In-Reply-To: <CALCETrV5jH6GJb=WVqMe7M1=JFPOWKm5r3QRkmF0jBy4joCyYA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 12/10/2014 08:53 PM, Andy Lutomirski wrote:
> On Wed, Dec 10, 2014 at 5:32 PM, Rik van Riel <riel@redhat.com>
> wrote:
>> -----BEGIN PGP SIGNED MESSAGE----- Hash: SHA1
>> 
>> On 12/10/2014 07:51 PM, Andy Lutomirski wrote:
>>> On Wed, Dec 10, 2014 at 4:49 PM, Rik van Riel
>>> <riel@redhat.com> wrote: On 12/10/2014 07:46 PM, Daniel J
>>> Blueman wrote:
>>>>>> Gah. I had some non-temporal copy changes in the wrong
>>>>>> tree. I'll check with a definitely clean tree and follow
>>>>>> up if it still occurs.
>>> 
>>> The exception handlers should definitely allow sleeping, so I 
>>> suspect those changes may be related.
>>> 
>>>> It would be really, really nice if we could arrange for 
>>>> kernel_fpu_begin to be unconditionally usable in anything
>>>> except NMI context.  The crypto code would be much less
>>>> scary, we could make non-temporal copies safe, etc.  Can we
>>>> have ponies, too?
>> 
>> Isn't it already?
>> 
>> I see nothing in __kernel_fpu_begin that looks like it would ever
>> need to sleep.
>> 
> 
> It never needs to sleep, but it does need somewhere to save the 
> previous state.  See irq_fpu_usable.
> 
> FWIW, I don't understand what the comments above 
> interrupted_kernel_fpu_idle are talking about.  The issue that I 
> understand is:
> 
> kernel_fpu_begin()
> 
> irq: kernel_fpu_begin() use xstate kernel_fpu_end()
> 
> we're screwed now :(
> 
> kernel_fpu_end()
> 
> IOW we need somewhere to put the state from the thing we
> interrupted.

Good point. An interruptible kernel_fpu_begin needs to provide a
place to put the state. Alternatively, the one that runs from irq
context could provide the place to store the current context, with
a kernel_fpu_begin_irq() function...

> This gets extra fun if some thread does something that takes a
> page fault that uses fpu that gets interrupted, etc.  Fortunately,
> I think that can't happen -- kernel_fpu_begin disables preemption.
> So I think we have a maximum of one active FPU context per thread
> plus some number per cpu.  Maybe we could have a percpu array of
> ten or twenty xstates to handle all possible nesting.
> 
> Also, can we just delete the non-eager code some day?

The XSAVEOPT and XRSTOR optimizations do not work across VMENTER
and VMEXIT, so with the eager code we end up always loading and
saving 384 bytes of state at every context switch, even for tasks
that never once touched the FPU.

That is 6 cache lines worth of unused stuff for each task
involved in the context switch. Somehow I am not convinced that
is a good idea...

- -- 
All rights reversed
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJUiP0yAAoJEM553pKExN6DD24H/jCcahi8z3LP6JEL4tpJUMpv
NIYuAdzdIbns4ycijSqYJSVGxZJEx2c7w8QSrRgTslx6zPfP2Q0MYZQ9J++CJbgQ
FZZcbnor6OL/KQtJWnPNSTN0ElBehWo+nZqK4SIbBoAwqJDQpBqo1Me9alxGoZ3P
SixN4NAwfDMP3nz0wNGuxV/Hr3/T1Hz5tDYS4226z5yhz84Sd4ODzAuu9NDGANHg
5g08uocMz6lpMlxO2m+bSElDxh6V0J6bqedgxzZbjVZM3zYk+txFw1TwmMSJoHT3
/rUzwfwGmA/8WDNWgSEscUZILJiEZgrGAtWVyJed0IZTg+A7MSqP9y57OXrDD60=
=YmP/
-----END PGP SIGNATURE-----
