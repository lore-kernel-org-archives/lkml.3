Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129Ab3JLUMZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 16:12:25 -0400
Received: from mail.eperm.de ([89.247.134.16]:47067 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753118Ab3JLUMX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 16:12:23 -0400
From: Stephan Mueller <smueller@chronox.de>
To: Sandy Harris <sandyinchina@gmail.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, LKML <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH] CPU Jitter RNG: inclusion into kernel crypto API and /dev/random
Date: Sat, 12 Oct 2013 22:12:18 +0200
Message-ID: <5356953.K0nNZDGpEZ@tauon>
User-Agent: KMail/4.11.2 (Linux/3.11.3-201.fc19.x86_64; KDE/4.11.2; x86_64; ; )
In-Reply-To: <CACXcFm=qdv9ktjYDGo+L=ssh+tCs7vVniznNpXyWVTBSB1CMRg@mail.gmail.com>
References: <2579337.FPgJGgHYdz@tauon> <CACXcFm=qdv9ktjYDGo+L=ssh+tCs7vVniznNpXyWVTBSB1CMRg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 11. Oktober 2013, 21:45:57 schrieb Sandy Harris:

Hi Sandy,

>On Fri, Oct 11, 2013 at 2:38 PM, Stephan Mueller <smueller@chronox.de>
>wrote:
>
>I like the basic idea. Here I'm alternately reading the email and the
>page you link to & commenting on both.

Thank you very much for reviewing both and sharing your thoughts.
>
>A nitpick in the paper is that you cite RFC 1750. That was superceded
>some years back by RFC 4086
>http://tools.ietf.org/html/rfc4086

Thank you for the link. I updated the reference in the paper. Though, 
the Von-Neumann unbias operation is way older than this RFC and I just 
listed the RFC to give people a reference.
>
>(Ted's comments in the actual driver had the same problem last
>I looked. That is excusable since they were written long ago.)
>
>I think you may be missing some other citations that should be
>there, to previous work along similar lines. One is the HAVEGE
>work, another:
>McGuire, Okech & Schiesser,
>Analysis of inherent randomness of the Linux kernel,
>http://lwn.net/images/conf/rtlws11/random-hardware.pdf

Thank you for the reminder. I added section 1.1.

>
>Paper has:
>
>" the time delta is partitioned into chunks of 1 bit starting at the
>lowest bit " .... The 64 1 bit chunks of the time value are XORed with
>each other to " form a 1 bit value.
>
>As I read that, you are just taking the parity. Why not use that
>simpler description & possibly one of several possible optimised
>algorithms for the task:
>http://graphics.stanford.edu/~seander/bithacks.html

I am fully aware that the bit operation is inefficient. Yet it is 
deliberately inefficient, because that "folding loop" performs actual 
work for the RNG (the collapse of 64 bits into one bit) and at the very 
same time, it is the fixed instruction set over which I measure the time 
variations. 

Thus, the folding loop can be considered as the entropy source at the 
same time. Thus, when making it shorter or more efficient, we alter the 
duration of the loop. With significantly shorter durations, the jitter 
measurements will get smaller.

That issue is the sole reason why that code part of the RNG shall be 
compiled without optimizations. The compiler is clever enough to arrange 
my inefficient operation into something faster when optimizing. You 
clearly see that with Clang: the unoptimized folding loop code takes 
about 300 nanoseconds on my i7 2nd gen. Optimized, it takes about 40 ns! 
At the same time, the jitter is lower (it is still sufficient, but the 
cushion is smaller).

As the RNG is not primarily about speed, the folding operation should 
stay inefficient.
>
>If what you are doing is not a parity computation, then you need a
>better description so people like me do not misread it.

It is not a parity computation that the folding loop performs. The code 
XORs each individual bit of the 64 bit stream with each other, whereas 
your cited document implies an ANDing of the bits (see section 
"Computing parity the naive way" of the cited document). The reason is 
that the different bits contain entropy -- the lower the bit index, the 
more entropy they are assumed to have. The only operation to retain 
entropy and yet collapse a bit string is to use XOR. Any other operation 
will result in the fact that you cannot make any statement about the 
entropy behavior any more.

The rationale about the folding loop is given in section 5.1 [2].

>
>A bit later you have:
>
>" After obtaining the 1 bit folded and unbiased time stamp,
>" how is it mixed into the entropy pool? ... The 1 bit folded
>" value is XORed with 1 bit from the entropy pool.
>
>This appears to be missing the cryptographically strong
>mixing step which most RNG code includes. If that is
>what you are doing, you need to provide some strong
>arguments to justify it.

The key here is that there is no cryptographic function needed for 
mixing as in fact I am not really mixing things. I am simply 
concatenating the new bit to the previously obtained bits. That is it.

The argument for doing that is that the time deltas are independent of 
each other. Yet, these deltas show variations which are collapsed into 
the one bit that is the result of the folding loop. Therefore, the 
individual bits are independent of each other and yet contain the 
variations of the jitter. Now, there is no need to apply a cryptographic 
function for further mixing.

The key here is that the variations in the time deltas must be *larger* 
than one bit. What does that mean? For example, if the variation would 
be, say 50% of 250 ns and 50% of 251 ns, we have 1 bit variation 
(considering that each individual measurement is independent of the 
others). Or, if you have 30% with 249ns, 20% with 250%, 25% with 251 and 
25% with 252ns, you have more than one bit. You see, that this line of 
thought brings us to the Shannon Entropy formula. And now we come to the 
200+ test systems that I tested on: all with the exception of one very 
old system showed a variation with the lower boundary of more than one 
bit. Therefore, each bit from the folding operation therefore contains 
one bit of entropy. So, why should I mix it even further with some 
crypto function?

>
>Sometimes doing without is justified; for example my
>code along these lines
>ftp://ftp.cs.sjtu.edu.cn:990/sandy/maxwell/
>does more mixing than I see in yours, but probably
>not enough overall. That's OK because I am just
>feeding into /dev/random which has plenty of
>mixing.
>
>It is OK for your code too if you are feeding into
>/dev/random, but it looks problematic if your code
>is expected to stand alone.

Please consider use case of the CPU Jitter RNG: it is intended as a seed 
source for deterministic RNGs. That is how the various integration 
patches for the kernel crypto API, /dev/random, OpenSSL, libgcrypt or 
even the stand-alone entropy feeding daemon operate. Thus, you have a 
whitening function when using it together with such DRNGs.

Yet, the code allows other users that may want entropy (NSS or even 
stand-alone DRNGs come to mind) to simply use that noise source without 
the burden of another whitening function to their DRNGs.

>
>Ah! You talk about whitening a bit later. However,
>you seem to make it optional, up to the user. I
>cannot see that that is a good idea.

Why is whitening a good idea in the first place when the statistical 
properties of your output already are white noise? When applying all 
kinds of statistical test to my non-whitened output, I do not see any 
statistical significant odd behavior -- ent (Chi-Square test, mean test, 
monte carlo simulation), dieharder tests, various tests from the German 
BSI, NIST test suite.

And if you say that your entropy source has problems, then your 
whitening function only disguises the fact but does not remedy it. 
Please refer to section 4.3 of my document in [2] where I have some 
"anti" tests with broken timers. Such brokenness would be immediately 
visible for anybody without a whitening function (such as the jitter 
RNG). But if the jitter RNG would use a whitening function, the missing 
entropy would not be visible.

Also, the RNG is intended as a seeding mechanism for all kinds of use 
cases. The typical one is the seeding of a DRNG of your choice. This is 
one more reason why I consider the use of a whitening function as not 
helpful.

>
>At the very least I think you need something like
>the linear transform from the ARIA cipher -- fast
>and cheap, 128 bits in & 128 out and it makes
>every output bit depend on every input bit. That
>might not be enough, though.

Can you please help me understand why you think that a whitening 
function (cryptographic or not) is needed in the case of the CPU Jitter 
RNG, provided that I can show that each individual bit coming from the 
folding operation has one bit of entropy?
>
>You require compilation without optimisation. How does
>that interact with kernel makefiles? Can you avoid
>undesirable optimisations in some other way, such as
>volatile declartions?

That is very easy to implement, see the kernel Makefile for my code:

...
obj-m += jitterentropy.o
CFLAGS_jitterentropy-base.o = -O0
jitterentropy-y := jitterentropy-base.o jitterentropy-drng.o
...

This code implies that only the compilation of jitterentropy-base.c is 
performed with -O0. Any other C file from my code or even the reminder 
of the kernel is compiled with the optimization the kernel developer 
deemed right.

>
>> I am asking whether this RNG would good as an inclusion into the
>> Linux
>> kernel for:
>> 
>> - kernel crypto API to provide a true random number generator as part
>> of this API (see [2] appendix B for a description)
>
>My first reaction is no. We have /dev/random for the userspace
>API and there is a decent kernel API too. I may change my
>mind here as I look more at your appendix & maybe the code.

The concern with /dev/random and its get_random_bytes() function is that 
inside the kernel, we only have the equivalent of /dev/urandom. 
Therefore, in the worst case, you have *no* guarantee that you obtain 
random numbers that are freshly seeded with hardware entropy.

For example, when you look into libgcrypt and you want to have "strong 
random numbers", libgcrypt seeds from /dev/random every 1000 or so 
random numbers produced from the DRNG.

Due to the ability of user space to obtain data via the nonblocking_pool 
using /dev/urandom and the use of the same pool for get_random_bytes, 
equally strong random numbers as, for example, libgcrypt would produce 
would not be available.

Therefore, the code linking with the kernel crypto API registers three 
RNGs:

- one X9.31 DRNG that is seeded "once in a while" with the CPU jitter

- one X9.31 DRNG that is seeded "frequently" with the CPU jitter

- and one direct access to the CPU jitter RNG

This is logically equivalent to what is done in libgcrypt.

Of course, we may replace the X9.31 with, say, an SP800-90A DRBG, if 
that becomes available.

Furthermore, one of the core ideas of the CPU jitter RNG is that you get 
away from the centralized noise source of /dev/random. Such central 
services are also the focus for hackers. The CPU Jitter RNG allows 
multiple instantiations of the noise source into independent components. 
Every "user" of random data may now have its own private copy of a noise 
source and its operation.
>
>> - inclusion into /dev/random as an entropy provider of last resort
>> when the entropy estimator falls low.
>
>Why only 'of last resort'? If it can provide good entropy, we should
>use it often.

I did not dare to be more than a provider of last resort at this point. 
The CPU jitter RNG is new and I guess people may want to study it first.

>From my point of view, it surely can become one "regular" source. But as 
it delivers entropy on demand, it may simply outpace any other entropy 
source of /dev/random. This means, in some normal use cases, my CPU 
jitter RNG would always be the provider of the majority of the entropy, 
by far. Therefore, my CPU Jitter RNG would alter the nature of 
/dev/random significantly.

If Ted thinks that this is ok, I am all for it and will change the 
patch. But I tried to be cautious and not to overwhelm people :-)
>
>> I will present the RNG at the Linux Symposium in Ottawa this year.
>> There I can give a detailed description of the design and testing.
>
>I live in Ottawa, don't know if I'll make it to the Symposium this
>year. Ted; I saw you at one Symposium; are you coming this
>year?

As mentioned before, I would really like to meet you there to have a cup 
of coffee over that matter.


Ciao
Stephan
