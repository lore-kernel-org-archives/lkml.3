Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357Ab3KNKvT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 05:51:19 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:44788 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752514Ab3KNKvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 05:51:10 -0500
X-Sasl-enc: SudsStN4GhIbliDKzHusL3B/JuXnur89aWBDT4KJM6gO 1384426265
Message-ID: <5284AB17.5050802@ladisch.de>
Date: Thu, 14 Nov 2013 11:51:03 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Stephan Mueller <smueller@chronox.de>
CC: "Theodore Ts'o" <tytso@mit.edu>, Pavel Machek <pavel@ucw.cz>,
        sandy harris <sandyinchina@gmail.com>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, Nicholas Mc Guire <der.herr@hofr.at>
Subject: Re: [PATCH] CPU Jitter RNG: inclusion into kernel crypto API and
 /dev/random
References: <2579337.FPgJGgHYdz@tauon> <1391779.T98KINxAMQ@myon.chronox.de> <528367D0.6010900@ladisch.de> <27146362.bQgmetPpTV@tauon>
In-Reply-To: <27146362.bQgmetPpTV@tauon>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephan Mueller wrote:
> Am Mittwoch, 13. November 2013, 12:51:44 schrieb Clemens Ladisch:
>> (And any setting that increases accesses to main memory is likey to
>> introduce more entropy due to clock drift between the processor and the
>> memory bus.  Or where do you assume the entropy comes from?)
>
> You nailed it. When I disable the caches using the CR0 setting, I get a
> massive increase in variations and thus entropy.

Now this would be an opportunity to use the number of main memory
accesses to estimate entropy.  (And when you're running out of the
cache, i.e., deterministically, is there any entropy?)

>>> XOR is a bijective operation.
>>
>> Only XOR with a constant, which is not what you're doing.
>
> If you want to regain the full 64 bit input bit stream, then you are
> right.
>
> But still, XOR is bijective with respect to the two bits that go into
> the operation.

Please look up what "bijective" actually means:
<http://en.wikipedia.org/wiki/Bijection>

> folding based on XOR is an appropriate way to collapse the string and
> yet retain entropy.

Correct, but the reason for that is not being bijective.

>> If the observations are not independent, you cannot just assume that
>> the estimate is off by a certain factor.  It means that the estimate
>> is not applicable _at all_.
>
> Well, I am not so sure here.

So, what is the factor that you are saying is large enough?

>>> The RNG has the following safety margins where it is more conservative than
>>> measurements indicate:
>>
>> You _cannot_ measure entropy by looking at the output.  How would you
>> differentiate between /dev/random and /dev/urandom?
>
> I think regarding the independence you can very well draw the conclusion
> based on the output, because any dependencies will ultimately form a
> pattern.

The output of a pure PRNG (such as /dev/urandom without entropy) is
dependent on the internal state, but there are no patterns detectable
from the output alone.

> In addition, we need to keep in mind that the independence claim is
> relative

No, independence is a property of the process that generates the
samples.

> If you have an output string that has no detectable patterns, i.e. looks
> like white noise, you can only assume that the observations are
> independent of each other. If there are patterns, you know that there
> are dependencies.
>
> That statement may *not* apply any more if you look at the internals of
> the RNG. In such a case, you may have even strong dependencies.
>
> The best example on this matter are deterministic RNGs with a
> cryptographic output function. When you see the output string, you only
> see white noise. As you cannot detect a pattern, you have to assume that
> the string provides independent observations. At least for you who looks
> from the outside cannot draw any conclusions from observing some output
> bit stream which would be the future bit stream. Yet, when you know the
> state of the RNG, you entire future output bit stream has no
> independence.

You cannot restrict the analysis to observations from the outside;
there are many people who can know about the CPU's internal structure.

> Coming back to the jitter RNG: I applied a large array of statistical
> tests and all of them concluded that the output is white noise, as
> explained in the documentation. That means when looking from the
> outside, there are no dependencies visible. Now you may say that this
> conclusion does not mean that there are no dependencies -- but I reply
> again, if there would be any, none of the array of statistical tests can
> detect it. So, how would an attacker detect patterns?

An attacker would not try to detect patterns; he would apply knowledge
of the internals.

Statistical tests are useful only for detecting the absence of entropy,
not for the opposite.


All your arguments about the output of the CPU jitter RNG also apply to
the output of /dev/urandom.  So are you saying that it would be a good
idea to loop the output of /dev/urandom back into /dev/random?


Regards,
Clemens
