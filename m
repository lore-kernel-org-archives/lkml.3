Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751006Ab3JNNii (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 09:38:38 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:44250 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755Ab3JNNif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 09:38:35 -0400
MIME-Version: 1.0
In-Reply-To: <CACXcFm=_jmeKe2YYbHDi-jTGX-23hDsDeu_weWQkr2F_FpE_6g@mail.gmail.com>
References: <2579337.FPgJGgHYdz@tauon>
	<CACXcFm=qdv9ktjYDGo+L=ssh+tCs7vVniznNpXyWVTBSB1CMRg@mail.gmail.com>
	<5356953.K0nNZDGpEZ@tauon>
	<CACXcFm=_jmeKe2YYbHDi-jTGX-23hDsDeu_weWQkr2F_FpE_6g@mail.gmail.com>
Date: Mon, 14 Oct 2013 09:38:34 -0400
Message-ID: <CACXcFm=3Ee1+HGYRpsjhFMwqn2t15qAZNnMpZ8jOsE_HkB2CPg@mail.gmail.com>
Subject: Fwd: [PATCH] CPU Jitter RNG: inclusion into kernel crypto API and /dev/random
From: Sandy Harris <sandyinchina@gmail.com>
To: "Theodore Ts'o" <tytso@mit.edu>, LKML <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org, Stephan Mueller <smueller@chronox.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephan Mueller <smueller@chronox.de> wrote:

>>Paper has:
>>
>>" the time delta is partitioned into chunks of 1 bit starting at the
>>lowest bit " .... The 64 1 bit chunks of the time value are XORed with
>>each other to " form a 1 bit value.
>>
>>As I read that, you are just taking the parity. Why not use that
>>simpler description & possibly one of several possible optimised
>>algorithms for the task:
>>http://graphics.stanford.edu/~seander/bithacks.html
>
> I am fully aware that the bit operation is inefficient. Yet it is
> deliberately inefficient, because that "folding loop" performs actual
> work for the RNG (the collapse of 64 bits into one bit) and at the very
> same time, it is the fixed instruction set over which I measure the time
> variations.
>
> Thus, the folding loop can be considered as the entropy source ...
>
> As the RNG is not primarily about speed, the folding operation should
> stay inefficient.

OK, that makes sense.

>>If what you are doing is not a parity computation, then you need a
>>better description so people like me do not misread it.
>
> It is not a parity computation that the folding loop performs. The code
> XORs each individual bit of the 64 bit stream with each other, whereas
> your cited document implies an ANDing of the bits (see section
> "Computing parity the naive way" of the cited document).

No. The AND is used in a trick; x&(x-1) gives a value with exactly
one bit set, the lowest bit set in x. The code there just counts that
way for efficiency.

Parity asks whether the number of set bits is odd or even. For
example this is another way to find the parity of x.

   for( p = 0; x ; x >>= 1 )
         p ^= (x&1) ;

>From your description (I haven't looked at the code) you are
computing parity. If so, say that. If not, explain.

>>This appears to be missing the cryptographically strong
>>mixing step which most RNG code includes. If that is
>>what you are doing, you need to provide some strong
>>arguments to justify it.
>
> The key here is that there is no cryptographic function needed for
> mixing as in fact I am not really mixing things. I am simply
> concatenating the new bit to the previously obtained bits. That is it.
>
> The argument for doing that is that the time deltas are independent of
> each other. ...

> ... each bit from the folding operation therefore contains
> one bit of entropy. So, why should I mix it even further with some
> crypto function?

That does make sense, but in security code I tend to prefer a
belt-and-suspenders approach. Even believing that each
individual bit is truly random, I'd still mix some just in case.

> Can you please help me understand why you think that a whitening
> function (cryptographic or not) is needed in the case of the CPU Jitter
> RNG, provided that I can show that each individual bit coming from the
> folding operation has one bit of entropy?

Basically, sheer paranoia. I'd mix and whiten just on general
principles. Since efficiency is not a large concern, there is little
reason not to.

On the other hand, most RNGs use a hash because they need
to distill some large amount of low-entropy input into a smaller
high-entropy output. With high input entropy, you do not need
the hash and can choose some cheaper mixer.

>>> I will present the RNG at the Linux Symposium in Ottawa this year.
>>> ....
>>
>>I live in Ottawa, ...
>
> As mentioned before, I would really like to meet you there to have a cup
> of coffee over that matter.

Sounds good. Ted, will you be around?
