Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751318Ab3KGF0S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 00:26:18 -0500
Received: from mail.eperm.de ([89.247.134.16]:55131 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750822Ab3KGF0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 00:26:16 -0500
From: Stephan Mueller <smueller@chronox.de>
To: Nicholas Mc Guire <der.herr@hofr.at>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Pavel Machek <pavel@ucw.cz>,
        sandy harris <sandyinchina@gmail.com>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH] CPU Jitter RNG: inclusion into kernel crypto API and /dev/random
Date: Thu, 07 Nov 2013 06:26:06 +0100
Message-ID: <4606253.6dPOReUPaz@tauon>
User-Agent: KMail/4.11.2 (Linux/3.11.6-200.fc19.x86_64; KDE/4.11.2; x86_64; ; )
In-Reply-To: <20131107010357.GC1950@opentech.at>
References: <2579337.FPgJGgHYdz@tauon> <9172761.DO0L6FkY0c@tauon> <20131107010357.GC1950@opentech.at>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 7. November 2013, 02:03:57 schrieb Nicholas Mc Guire:

Hi Nicholas,

>On Wed, 06 Nov 2013, Stephan Mueller wrote:
>> Am Mittwoch, 6. November 2013, 07:43:54 schrieb Theodore Ts'o:
>> 
>> Hi Theodore,
>> 
>> >On Wed, Nov 06, 2013 at 12:49:45PM +0100, Stephan Mueller wrote:
>> >> Here is a quote from his answer to my question whether he was able
>> >> to
>> >> identify the root cause:
>> >> 
>> >> "its inherent in the microtiming of Hardware and there is nothing
>> >> you
>> >> can do about it if you want the root cause is quantum physics"
>> >
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
>unpredictabilitty of the individual event does not imply that you do
>not have the ability to "guess" with more than 50% - that is just
>because it is not predictable
>does not mean itt is bias-free (and more importantly here that the bias
>is not influenced by controllable factors like load). Attached is a
>simple demonstration of this problem (gauss.c) that runs in user-space
>and harvestts entropy by race occurrence, while the distribution is a
>nice normal distribution (on multticore it is an overlay of multtiple
>normal distributions - one per core-pairing possible) it is not load
>independent. Never the less the individual event (race/no-race) is not
>predictable.

Thank you for sharing your ideas and code.

There is one deviation of my RNG from your considerations. My RNG is not 
around race contention (i.e. your software-based uncertainty) but a 
simple measurement of how long some instruction take to execute.

So, how can I induce skews? By trying to disable CPU logic or fudge with 
the CPU support (like cache attacks, etc). My tests have shown that 
disabling some CPU logic may diminish timing variations, but they are 
still sufficiently large to support the RNG.

So, when we already have variations that are sufficient (i.e. the 
entropy is sufficient), using the CPU features that initially have been 
disabled but are now added on top of an already sufficient set of 
variations cannot diminish the entropy that is already present. Even 
when we assume we have full control over the CPU features, I do not see 
a way how we can use these features to cancel already existing 
variations out.

Or do you have an idea how that can be established? Note, we all must 
assume that an attacker is only in user state. Anything else is 
meaningless.

>> Besides, how on earth shall an attacker even gain knowledge about the
>> state of the CPU or disable CPU mechanisms? Oh, I forgot, your NSA
>> guy. But if he is able to do that, all discussions are moot because
>> he simply disables any noise sources by flipping a bit, reads the
>> memory that is used to hold the state of the RNG or just overwrites
>> the memory locations where data is collected, because the general
>> protection mechanisms offered by the kernel and the underlying
>> hardware are broken.
>No need to gain knowledge of the internal CPU state itt would be
>sufficient to be able to put the CPU in a sub-state-space in which
>the distribution is shifted. it may be enough to reduce the truely
>random bits of some key only by a few bits to make it suceptible to
>brute force attacks.

Note, the proposed RNG contains an unbias operation (the Von-Neumann 
unbiaser) which is proven to remove any bias when it is established that 
the individual observations are independent. And the way the 
observations are generated ensures that they are independent. Thus, a 
skew should not be a concern here.

Ciao
Stephan
