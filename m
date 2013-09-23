Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277Ab3IWHj4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 03:39:56 -0400
Received: from mailout06.t-online.de ([194.25.134.19]:40558 "EHLO
	mailout06.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558Ab3IWHjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 03:39:55 -0400
Message-ID: <523FF03F.3040208@web.de>
Date: Mon, 23 Sep 2013 09:39:43 +0200
From: =?ISO-8859-1?Q?J=F6rg-Volker_Peetz?= <jvpeetz@web.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130821 Icedove/17.0.8
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: "Theodore Ts'o" <tytso@mit.edu>,
        =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@logfs.org>,
        John Stultz <john.stultz@linaro.org>,
        Stephan Mueller <smueller@chronox.de>,
        LKML <linux-kernel@vger.kernel.org>, dave.taht@bufferbloat.net,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH,RFC] random: make fast_mix() honor its name
References: <20130910223326.GD11063@thunk.org> <522FB9F1.3070905@linaro.org> <20130911005047.GA13315@thunk.org> <20130912210717.GC3809@logfs.org> <20130912233155.GB5279@thunk.org> <20130916154026.GA23345@logfs.org> <20130921212510.GD8606@thunk.org> <20130921214118.GE8606@thunk.org> <20130922030553.GA21422@thunk.org> <523F5AB6.8070107@web.de> <20130922212752.GB7321@thunk.org>
In-Reply-To: <20130922212752.GB7321@thunk.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-ID: ZXTMFwZYwhpg3VqMbiBNrzlzTC2MlVyTohjbohl+BgGnlMr6BOxLxGxXwMJegT1g4c@t-dialin.net
X-TOI-MSGID: 5b5dcfc8-3a3d-42b7-9748-cc488f0a65b8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for your patience and elaborated answer.

Theodore Ts'o wrote, on 09/22/2013 23:27:
> On Sun, Sep 22, 2013 at 11:01:42PM +0200, Jörg-Volker Peetz wrote:
>> just out of interest I would like to ask why this mixing function has to be that
>> complicated. For example, even if the input is always 0 and the pool is seeded
>> with pool[0] = 1 (as in your test program) this algorithm generates some
>> (predictable) pseudo-random numbers in the pool. Is this necessary?
>>
>> To just mix in some random input filling the whole pool (seeded again with
>> pool[0] = 1) something as "simple" as
>>
>>           f->pool[0] = rol32(input[0], f->pool[2] & 31) ^ f->pool[1];
>>           f->pool[1] = rol32(input[1], f->pool[3] & 31) ^ f->pool[2];
>>           f->pool[2] = rol32(input[2], f->pool[0] & 31) ^ f->pool[3];
>>           f->pool[3] = rol32(input[3], f->pool[1] & 31) ^ f->pool[0];
>>
>> would suffice, although I didn't do any statistical tests.
> 
> The structure of the mixing functions in /dev/random has been well
> studied, and validatetd in a number of different academic papers.  So
> I prefer to stick with the basic architecture, even as it is scaled
> down for speed reasons and beause the pool is smaller.

I'm not arguing so much for speed but for simplicity and comprehensibility of
code. As far as I understand the task of fast_mix() is just to collect random
bits in a small buffer separated from the random pool?
Once in a while these collected bits are then mixed into the main random pool.
For that purpose, justifiably, a strong mixing function is used.

> One of the important things about the mixing function is that if the
> attacker knows the input values (of which the simplest example for
> analytic purposes is if the input values are all zero), we want there
> to be ample mixing across the pool.
> 
> If you look at your proposed mixing function, in the case where the
> input values are all zero, it devolves into:
> 
>            f->pool[0] = f->pool[1];
>            f->pool[1] = f->pool[2];
>            f->pool[2] = f->pool[3];
>            f->pool[3] = f->pool[0];
> 
> Yes, I know the input values will never be all zero, but in the case
> where the attacker knows what the input values are[1], but does not know
> the contents of the entropy pool, a very simplistic mixing function
> becomes relatively easy to analyze in the case where attacker knows
> the inputs and then outputs, and is trying to determine the internal
> state of the random driver.
> 
> Measuring the speed of the fast_mix function which I put together,
> it's already been speeded up compard to the original fast_mix function
> by a factor of six.  On my x86 laptop, I can run 10 million
> iterations in 0.14 seconds, so that translates to 14ns per fast_mix
> call.   (The original fast_mix function runs in 84 nanoseconds.)
> 
> So there is a cost-benefit tradeoff that we need to balance here.  If
> you have a system with 100k interrupts per second, performance is
> going to be poor no matter what, and it's not clear how common such
> systems really are.  Most modern hardware do have some kind of NAPI or
> other interrupt mitigation in place --- heck, even back in 1980's
> people had figured out how to improve the 8250 UART with the 16550A
> UART, which introdued a FIFO to decrease the interrupt load caused by
> serial ports, and things have only gotten better since then.
> 
> Out of curiosity, on your profiles, how many nanonseconds total is the
> total interrupt code path chewing up per interrupt?
> 
> Regards,
> 
> 						- Ted
> 
> [1] And on systems where we don't have get_cycles() or
> random_get_entropy(), it becomes much easier for the attacker to guess
> what at least half of the input values will be!
> 

