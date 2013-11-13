Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759386Ab3KMPPj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 10:15:39 -0500
Received: from mail.eperm.de ([89.247.134.16]:55442 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759156Ab3KMPPh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 10:15:37 -0500
From: Stephan Mueller <smueller@chronox.de>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Pavel Machek <pavel@ucw.cz>,
        sandy harris <sandyinchina@gmail.com>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, Nicholas Mc Guire <der.herr@hofr.at>
Subject: Re: [PATCH] CPU Jitter RNG: inclusion into kernel crypto API and /dev/random
Date: Wed, 13 Nov 2013 16:15:26 +0100
Message-ID: <27146362.bQgmetPpTV@tauon>
User-Agent: KMail/4.11.2 (Linux/3.11.7-200.fc19.x86_64; KDE/4.11.2; x86_64; ; )
In-Reply-To: <528367D0.6010900@ladisch.de>
References: <2579337.FPgJGgHYdz@tauon> <1391779.T98KINxAMQ@myon.chronox.de> <528367D0.6010900@ladisch.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 13. November 2013, 12:51:44 schrieb Clemens Ladisch:

Hi Clemens,

>Stephan Mueller wrote:
>> Am Sonntag, 10. November 2013, 21:28:06 schrieb Clemens Ladisch:
>>> Many CPUs allow to disable branch prediction, but this is very
>>> vendor
>>> specific (try to find MSR documentation).  The biggest offender
>>> probably is the out-of-order execution engine, which cannot be
>>> disabled.> 
>> For x86, I have not found a way to disable the unit.
>
>My AMD processor can do this in the IC_CFG/DC_CFG MSRs.  (See the
>BKDG.)

Thanks for the hint, I will look into that one.
>
>The Intel Core family has other settings (such as data prefetching)
>that are configurable in the IA32_MISC_ENABLE MSR.

Thanks for the hint, I will check that as well.
>
>(And any setting that increases accesses to main memory is likey to
>introduce more entropy due to clock drift between the processor and the
>memory bus.  Or where do you assume the entropy comes from?)

You nailed it. When I disable the caches using the CR0 setting, I get a 
massive increase in variations and thus entropy.
>
>BTW: MFENCE is not guaranteed to flush the instruction pipeline; you
>need CPUID for that.

I was not aware of that. Can I simply call the CPUID instruction to read 
it or do I have to do something special?
>
>> XOR is a bijective operation.
>
>Only XOR with a constant, which is not what you're doing.

If you want to regain the full 64 bit input bit stream, then you are 
right.

But still, XOR is bijective with respect to the two bits that go into 
the operation. Before I released the RNG work, I had the mathematical 
side and the entropy consideration analyzed by a mathematician who is 
specialized in the field of cryptography and statistics. She actually 
said that this folding based on XOR is an appropriate way to collapse 
the string and yet retain entropy.
>
>>>> There are so many assessments on entropy I make, I am surprised
>>>> that I
>>>> am said to have no entropy assessment.
>>> 
>>> Again: Shannon entropy assumes that you have a sequence of
>>> independent
>>> and identically distributed random variables.  And you cannot prove
>>> these properties from the output; you need to know the process that
>>> generates the values.
>> 
>> I am absolutely on your side here. And as we cannot (yet?) fully
>> conclude that the observations are independent, a safety margin must
>> always be considered.
>If the observations are not independent, you cannot just assume that
>the estimate is off by a certain factor.  It means that the estimate
>is not applicable _at all_.

Well, I am not so sure here. If there are concerns on independence 
(which I currently do not have, but more to that below), I have always 
seen that safety margins are put in place. And that is what I tried here 
as well.
>
>> The RNG has the following safety margins where it is more
>> conservative than
>> measurements indicate:
>You _cannot_ measure entropy by looking at the output.  How would you
>differentiate between /dev/random and /dev/urandom?

I think regarding the independence you can very well draw the conclusion 
based on the output, because any dependencies will ultimately form a 
pattern. That pattern would initially be visible in the measurements 
that go into the folding loop. What I now must show is that these 
measurements do not have a pattern.

In addition, we need to keep in mind that the independence claim is 
relative just like the entropy itself.

If you have an output string that has no detectable patterns, i.e. looks 
like white noise, you can only assume that the observations are 
independent of each other. If there are patterns, you know that there 
are dependencies.

That statement may *not* apply any more if you look at the internals of 
the RNG. In such a case, you may have even strong dependencies.

The best example on this matter are deterministic RNGs with a 
cryptographic output function. When you see the output string, you only 
see white noise. As you cannot detect a pattern, you have to assume that 
the string provides independent observations. At least for you who looks 
from the outside cannot draw any conclusions from observing some output 
bit stream which would be the future bit stream. Yet, when you know the 
state of the RNG, you entire future output bit stream has no 
independence.

Coming back to the jitter RNG: I applied a large array of statistical 
tests and all of them concluded that the output is white noise, as 
explained in the documentation. That means when looking from the 
outside, there are no dependencies visible. Now you may say that this 
conclusion does not mean that there are no dependencies -- but I reply 
again, if there would be any, none of the array of statistical tests can 
detect it. So, how would an attacker detect patterns? And again, I 
cannot prove it just like nobody else cannot prove it for other hardware 
noise sources.

In addition, when we conclude that the output bit stream has no 
dependencies due to the absence of patterns and considering the folding 
operation not disguising patterns from the underlying measurements, I 
draw the conclusion that there are no patterns in the underlying 
measurements. The "Anti-Tests" I outline in section 4.3 show that if 
there would be patterns in the underlying measurements, it is 
immediately visible in the output bit stream.
>
>
>Regards,
>Clemens


Ciao
Stephan
