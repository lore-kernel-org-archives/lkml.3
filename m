Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933543AbaLKByJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 20:54:09 -0500
Received: from mail-la0-f43.google.com ([209.85.215.43]:41801 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932937AbaLKByH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 20:54:07 -0500
MIME-Version: 1.0
In-Reply-To: <5488F432.5010405@redhat.com>
References: <CAMVG2su302Nvtp+fnaOjtLadJFtpPmVXiN5YfQ0JpT920YohuA@mail.gmail.com>
 <CALCETrXZpQyKbVkBMwqFq2wH908-V+WCuvtaTc1O9VNZFHrBUQ@mail.gmail.com>
 <CAMVG2svoTbm3k3W5POpLsJnpXBPpZRYVr+wmAQrWVGVtiQ=LRA@mail.gmail.com>
 <5488EA01.6020600@redhat.com> <CALCETrVGH0VbGDWEx-D=gU7o3keM6PgGfYLixADH-sgNxhxJDA@mail.gmail.com>
 <5488F432.5010405@redhat.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 10 Dec 2014 17:53:44 -0800
Message-ID: <CALCETrV5jH6GJb=WVqMe7M1=JFPOWKm5r3QRkmF0jBy4joCyYA@mail.gmail.com>
Subject: Re: [PATCH, 3.18] sleeping function called from invalid context
To: Rik van Riel <riel@redhat.com>
Cc: Daniel J Blueman <daniel@quora.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2014 at 5:32 PM, Rik van Riel <riel@redhat.com> wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> On 12/10/2014 07:51 PM, Andy Lutomirski wrote:
>> On Wed, Dec 10, 2014 at 4:49 PM, Rik van Riel <riel@redhat.com>
>> wrote: On 12/10/2014 07:46 PM, Daniel J Blueman wrote:
>>>>> Gah. I had some non-temporal copy changes in the wrong tree.
>>>>> I'll check with a definitely clean tree and follow up if it
>>>>> still occurs.
>>
>> The exception handlers should definitely allow sleeping, so I
>> suspect those changes may be related.
>>
>>> It would be really, really nice if we could arrange for
>>> kernel_fpu_begin to be unconditionally usable in anything except
>>> NMI context.  The crypto code would be much less scary, we could
>>> make non-temporal copies safe, etc.  Can we have ponies, too?
>
> Isn't it already?
>
> I see nothing in __kernel_fpu_begin that looks like it would
> ever need to sleep.
>

It never needs to sleep, but it does need somewhere to save the
previous state.  See irq_fpu_usable.

FWIW, I don't understand what the comments above
interrupted_kernel_fpu_idle are talking about.  The issue that I
understand is:

kernel_fpu_begin()

irq:
  kernel_fpu_begin()
  use xstate
  kernel_fpu_end()

we're screwed now :(

kernel_fpu_end()

IOW we need somewhere to put the state from the thing we interrupted.
This gets extra fun if some thread does something that takes a page
fault that uses fpu that gets interrupted, etc.  Fortunately, I think
that can't happen -- kernel_fpu_begin disables preemption.  So I think
we have a maximum of one active FPU context per thread plus some
number per cpu.  Maybe we could have a percpu array of ten or twenty
xstates to handle all possible nesting.

Also, can we just delete the non-eager code some day?

--Andy
