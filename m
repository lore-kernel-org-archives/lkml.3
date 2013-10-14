Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755589Ab3JNOMl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 10:12:41 -0400
Received: from mail.eperm.de ([89.247.134.16]:42904 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751018Ab3JNOMk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 10:12:40 -0400
From: Stephan Mueller <smueller@chronox.de>
To: Sandy Harris <sandyinchina@gmail.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, LKML <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org
Subject: Re: Fwd: [PATCH] CPU Jitter RNG: inclusion into kernel crypto API and /dev/random
Date: Mon, 14 Oct 2013 16:12:24 +0200
Message-ID: <5084508.OCAIYQezeq@tauon>
User-Agent: KMail/4.11.2 (Linux/3.11.3-201.fc19.x86_64; KDE/4.11.2; x86_64; ; )
In-Reply-To: <CACXcFm=3Ee1+HGYRpsjhFMwqn2t15qAZNnMpZ8jOsE_HkB2CPg@mail.gmail.com>
References: <2579337.FPgJGgHYdz@tauon> <CACXcFm=_jmeKe2YYbHDi-jTGX-23hDsDeu_weWQkr2F_FpE_6g@mail.gmail.com> <CACXcFm=3Ee1+HGYRpsjhFMwqn2t15qAZNnMpZ8jOsE_HkB2CPg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 14. Oktober 2013, 09:38:34 schrieb Sandy Harris:

Hi Sandy,

>Stephan Mueller <smueller@chronox.de> wrote:
>
>>>If what you are doing is not a parity computation, then you need a
>>>better description so people like me do not misread it.
>>>
>> It is not a parity computation that the folding loop performs. The
>> code XORs each individual bit of the 64 bit stream with each other,
>> whereas your cited document implies an ANDing of the bits (see
>> section "Computing parity the naive way" of the cited document).
>
>No. The AND is used in a trick; x&(x-1) gives a value with exactly
>one bit set, the lowest bit set in x. The code there just counts that
>way for efficiency.
>
>Parity asks whether the number of set bits is odd or even. For
>example this is another way to find the parity of x.
>
>   for( p = 0; x ; x >>= 1 )
>         p ^= (x&1) ;
>
>From your description (I haven't looked at the code) you are
>computing parity. If so, say that. If not, explain.

I re-read the referenced documentation. Yes, what I do is a parity 
calculation. But I do not want to think that way, although technically 
it is.

The reason and the goal of the implementation is the following: To 
maintain a mathematical model in which the entropy is preserved, I can 
only perform the following operations:

1. Use of concatenation which in terms of entropy implies that two 
values concatenated with each other add the entropy the two values 
contain. For example: string a contains 4 bits of entropy, string b 
contains 6 bits of entropy. Now, when concatenating both, I get 10 bits 
of entropy in the combined string.

2. The use of XOR implies that the resulting value has the maximum 
entropy of the two individual strings. With the same example above, a 
XOR b implies that the resulting string has 6 bits of entropy.

Any other operation will loose entropy in a way that is not easily to be 
modeled.

Now, back to the folding loop: I know that the lower bits have some 
entropy. When collapsing them into one single bit, I "slice" the 64 bit 
timer value into 64 1 bit values and XOR the 64 bit values together. The 
goal is to preserve the entropy each bit holds.

(PS: I am aware that in case none of the individual bits would contain 
one full bit of entropy, the folding operation may --mathematically 
spoken-- not deliver one full bit of entropy. However, after speaking 
with a mathematician, that slight inconsistency is ok, if I can show 
that the distribution of the folded bit is 50% zeros and 50% ones. That 
is what I did in section 5.2.1. Thus, the conclusion is that I receive 
one bit of entropy after the folding loop.)

Yes, that is equal to parity calculation. But the reference to a parity 
calculation is not defined when you want to apply a mathematical model 
to entropy maintenance. Thus, I would rather like to have a consistent 
design description that I can easily apply to the entropy discussion.

>
>>>This appears to be missing the cryptographically strong
>>>mixing step which most RNG code includes. If that is
>>>what you are doing, you need to provide some strong
>>>arguments to justify it.
>>>
>> The key here is that there is no cryptographic function needed for
>> mixing as in fact I am not really mixing things. I am simply
>> concatenating the new bit to the previously obtained bits. That is
>> it.
>> 
>> The argument for doing that is that the time deltas are independent
>> of
>> each other. ...
>> 
>> ... each bit from the folding operation therefore contains
>> one bit of entropy. So, why should I mix it even further with some
>> crypto function?
>
>That does make sense, but in security code I tend to prefer a
>belt-and-suspenders approach. Even believing that each
>individual bit is truly random, I'd still mix some just in case.

I am with you on the potential for further mixing. However, please note 
that the standard hashes are all surjective and not bijective. Thus, 
they implicitly loose entropy (albeit it is not much). Therefore, a good 
mixing function would be a symmetric cipher.

Also, I tried to have my code portable to a large variety of target 
systems. All of them have crypto libraries with a great number of cipher 
implementation, but which suffer from the lack of entropy. Thus, I 
concluded that I do not want to re-invent the wheel by reimplementing 
some cipher, but only provide what is missing: a decentral entropy 
source that delivers entropy on demand in kernel and user space.

Who would be a user of the CPU Jitter RNG? I hardly believe that a 
normal end user would use it, but rather it would be provided via some 
crypto lib. And the authors of a crypto lib surely know how to handle 
the seed source (I hope).

This all is the reason why I implemented the different links to various 
crypto libraries, where the kernel crypto API is one of it. The CPU 
Jitter RNG is no a stand-alone system, but always linked with a DRNG 
that is frequently seeded by the CPU Jitter RNG.
>
>> Can you please help me understand why you think that a whitening
>> function (cryptographic or not) is needed in the case of the CPU
>> Jitter RNG, provided that I can show that each individual bit coming
>> from the folding operation has one bit of entropy?
>
>Basically, sheer paranoia. I'd mix and whiten just on general
>principles. Since efficiency is not a large concern, there is little
>reason not to.

I am ok with that, when you consider the surjective/bijective argument 
above. Still, as mentioned above, I think that will be covered by the 
"users" of the CPU jitter RNG.
>
>On the other hand, most RNGs use a hash because they need
>to distill some large amount of low-entropy input into a smaller
>high-entropy output. With high input entropy, you do not need
>the hash and can choose some cheaper mixer.

IMHO, that decision is left to the user of the code. Some users are 
forced to use some DRNGs (e.g. FIPS comes to mind). Thus, I do not want 
to do things that will need to be re-done in a slightly different way 
again. This is what I see as inefficient complexity that I truly want to 
avoid.
>
>>>> I will present the RNG at the Linux Symposium in Ottawa this year.
>>>> ....
>>>
>>>I live in Ottawa, ...
>>>
>> As mentioned before, I would really like to meet you there to have a
>> cup of coffee over that matter.
>
>Sounds good. Ted, will you be around?


Thanks
Stephan
