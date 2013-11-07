Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751024Ab3KGFVu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 00:21:50 -0500
Received: from mail.eperm.de ([89.247.134.16]:34801 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750767Ab3KGFVs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 00:21:48 -0500
From: Stephan Mueller <smueller@chronox.de>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Pavel Machek <pavel@ucw.cz>, sandy harris <sandyinchina@gmail.com>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Nicholas Mc Guire <der.herr@hofr.at>
Subject: Re: [PATCH] CPU Jitter RNG: inclusion into kernel crypto API and /dev/random
Date: Thu, 07 Nov 2013 06:21:35 +0100
Message-ID: <3842150.yBzxVUWavK@tauon>
User-Agent: KMail/4.11.2 (Linux/3.11.6-200.fc19.x86_64; KDE/4.11.2; x86_64; ; )
In-Reply-To: <20131106130432.GK14235@thunk.org>
References: <2579337.FPgJGgHYdz@tauon> <9172761.DO0L6FkY0c@tauon> <20131106130432.GK14235@thunk.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 6. November 2013, 08:04:32 schrieb Theodore Ts'o:

Hi Theodore,

>On Wed, Nov 06, 2013 at 01:51:17PM +0100, Stephan Mueller wrote:
>> >That's unfortunate, since it leaves open the question of whether
>> >this
>> >jitter is something that could be at least somewhat predictable if
>> >you
>> >had a lot more information about the internal works of the CPU or
>> >not....
>> 
>> I do not understand that answer: I thought we are talking about the
>> search of non-predictable noise sources. If you cannot predict the
>> sequence even if you have the state of the CPU, that is what we are
>> looking for, is it not?
>
>I was asking the question about whether someone who knew more about
>the internal _workings_ of the CPU, note of the state of the CPU.
>This is not necessarily "the NSA guy", but someone who knows more
>about the internal workings of the Intel CPU (such as an Intel
>engineer --- and I've had Intel express misgivings about approaches
>which depend on "CPU jitter" approaches), or just someone who has
>spent a lot more time trying to examine the black box of the Intel CPU
>from the outside.

I try to get more information from my contacts to other vendors. But I 
am wondering what shall we do if the answer is (maybe even proven with 
some test results) that they see the same issue themselves and have no 
handle on it?

I mean, what is it that I would need to test and demonstrate to prove or 
disprove my RNG? We can certainly test very much, but one thing we 
cannot prove, and that is the fundamental jitter, provided it is a 
result of quantum fluctuations. Just as with any other noise source, 
basic fundamental principles are hard if not impossible to test.

I would again like to stress the fact that we see the root cause to a 
similar degree on all major CPUs that we have around us. All of these 
CPUs work differently and yet they show a common behavior, the execution 
time variations. I wonder whether this is already a good indication 
>
>I remember making my own home-grown encryption algorithm before I
>entered college, secure in my arrogance that I had created something
>so complicated that no one could crack it.  Of course, as I got older
>and wiser, I realized that it just meant it was just something *I*
>couldn't yet anaylze and crack.  The argument "the internal state of
>the CPU is sooooo large, and the state transitions ar sooooo complex
>that it *must* be unpredictable, because *I* can't predict them" seems
>to be a very similar mistake that I made many years ago when I was in
>high school.

Agreed, I do not want to state that nobody is able to obtain the state 
(especially considering that the CPUs *must* have some hardware 
debugging hooks somewhere that should allow dumping out the current 
state of the entire CPU to aid CPU development). However, we also have 
to consider our threat model: to me, an attacker can only reside in user 
state of the CPU. All that he can observe there can be used against us. 
Anything that he can only do when in supervisor state is not of 
interest, because gathering and maintaining entropy is the least of our 
worries in this case.
>
>Of course, some of the state in the CPU may not be unknown to the
>attacker, if it is derived by external events that are not visible to
>the attacker, such as a network interrupt.  But if that's the case,
>why not measure network interrupts directly?  We're much less likely
>to overestimate the amount of entropy we can extract the system in
>that case.

To aid that discussion, let us assume that the variations are solely 
based on the CPU state (which indications show that this is not the 
case). When you focus on only the interrupts (or only one interrupt for 
that matter) we limit the base from which we try to obtain entropy.

If you are concerned about the entropy level we add with the proposed 
jitter RNG, what about the following:

- when mixing in bits from the jitter RNG into the entropy pools of 
random.c, we increase the entropy estimator not by the equivalent amount 
of bits, but some fraction. For example:

...
ret = jent_read_entropy(&r->entropy_collector, rand, JENTBLOCKSIZE);
...
_mix_pool_bytes(r, rand, ret, NULL);
credit_entropy_bits(r, (ret * 8) / 2);

This code would only increase the entropy estimator by half of the 
obtained bits

- The jitter RNG allows specifying an oversampling rate where it 
oversamples the jitter by multiples of the given value. The default is 1 
(i.e. no oversampling). But we could set it to 2 (double oversampling). 
The code is here:

r->entropy_collector.osr = 1;

Ciao
Stephan
