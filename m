Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757543Ab3KMDM6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 22:12:58 -0500
Received: from mail.eperm.de ([89.247.134.16]:44669 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756238Ab3KMDMr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 22:12:47 -0500
From: Stephan Mueller <smueller@chronox.de>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Pavel Machek <pavel@ucw.cz>,
        sandy harris <sandyinchina@gmail.com>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, Nicholas Mc Guire <der.herr@hofr.at>
Subject: Re: [PATCH] CPU Jitter RNG: inclusion into kernel crypto API and /dev/random
Date: Wed, 13 Nov 2013 04:12:29 +0100
Message-ID: <1391779.T98KINxAMQ@myon.chronox.de>
User-Agent: KMail/4.11.2 (Linux/3.11.7-200.fc19.x86_64; KDE/4.11.2; x86_64; ; )
In-Reply-To: <527FEC56.5070306@ladisch.de>
References: <2579337.FPgJGgHYdz@tauon> <8100659.WdgUuKxd0z@myon.chronox.de> <527FEC56.5070306@ladisch.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, 10. November 2013, 21:28:06 schrieb Clemens Ladisch:

Hi Clemens,

> Stephan Mueller wrote:
> > Am Sonntag, 10. November 2013, 17:31:07 schrieb Clemens Ladisch:
> >> In the case of CPUs, the jitter you observe in delta
> >> times results in part from the complexities of the inner state, and in
> >> part from real random noise.  The first part is deterministic and might
> >> be predicted by anyone who has enough knowledge about the CPU's
> >> internals.
> > 
> > Right, and that is why I tried to eliminate the CPU mechanisms that may be
> > having a deterministic impact. If I miss a mechanism or your have other
> > suggestions, please help me.
> 
> Many CPUs allow to disable branch prediction, but this is very vendor
> specific (try to find MSR documentation).  The biggest offender probably
> is the out-of-order execution engine, which cannot be disabled.

I was also digging around in this area. My research showed so far that only on 
ARM one can disable the branch prediction unit. Unfortunately, I do not have 
an ARM available where I can do that. I have my Samsung phone, but that runs 
Android and I am not sure how to generate a kernel module here.

For x86, I have not found a way to disable the unit. Nonetheless, I tried to 
bring down the effect by "warming" the caches and the branch prediction up 
(see section 6.1.1 of the new version of the documentation). There I execute 
the testing 1000 times and use only the last result for further analysis.
> 
> >>> When you ask for testing of stuck values, what shall I really test for?
> >>> Shall I test adjacent measurements for the same or alternating values?
> >> 
> >> Same or alternating delta time values happen even on random CPUs.  You
> >> need a theory of how random and non-random CPUs work, and how this
> >> difference affects the delta times, before you can test for that.
> > 
> > Are you telling me that I should invent a formula and apply it?
> 
> I was not implying that the theory has nothing to do with the physical
> device.  It must correctly _describe_ the relevant physical processes.

Right, but currently I am not sure how I can find such description. In 
particular, I created a new round of testing which is even more interesting as 
the results do not allow to pinpoint the exact root cause. More to that in a 
separate email.

Do you have an idea?
> 
> >>> The test for the same values is caught with the Von-Neumann unbiaser.
> >> 
> >> No, the von Neumann unbiaser is run on the whitened bitstream, i.e.,
> >> _after_ the folding operation.
> > 
> > The folding is whitened? How do you reach that conclusion? Yes, the
> > folding is my (very simple) post-processing. But I am not calling it
> > whitened as all statistical problems the underlying variations have
> > *will* be still visible in the folded value.
> 
> If you don't want to call it "whitening", call it "randomness extraction"
> instead.  But its input is a series of delta times like this:
>   00000000000000000000000001010011
>   00000000000000000000000010011010
>   00000000000000000000000001011011
>   00000000000000000000000001100100
>   00000000000000000000000010111000
> and the purpose of the folding is to remove these zero patterns.

Not quite. Let me explain the motive behind the folding loop. To maintain 
entropy mathematically, there are only a few operations allowed. One of them 
is a bijective operation which implies that two strings combined with a 
bijective operation will form a new string which contains the maximum entropy 
of the initial strings. XOR is a bijective operation.

Hence, if you have a string with 10 bits that holds 5 bits of entropy and XOR 
it with a 20 bit string that holds 2 bits of entropy, you receive a string 
that is 20 bits in length and holds 5 bits of entropy.

In any case, with the bijective operation, it is not possible to loose entropy 
even when you use the bijective operation to add fully deterministic values to 
a bit stream that is believed to have entropy.

That said, the folding loop uses that line of thought. The loop XORs each bit 
with every other bit to receive one bit at the end. The idea is to collapse 
the initial bit stream by still retaining the entropy present in each 
individual bit. The goal is now that the resulting bit will hold one bit of 
entropy by "collecting" the combined entropy found in the individual bits.

That folding operation will loose entropy, if the overall entropy in the 
folded bit stream is more than one bit. But that point is our advantage, 
because it provides a safety margin, if the value to be folded really holds 
more than one bit of entropy. All my measurements in section 5.1 and appendix 
F just try to show that on every CPU there is always more than one bit of 
entropy.

There is a catch, however: what happens if each individual bit of the bit 
stream holds less than one bit? I.e. the entire bit stream may hold more than 
one bit, but when chopping the bit stream, the none of the individual bits may 
have one bit of entropy. As XOR only retains entropy but never enlarges 
entropy (like a concatenation would do), this would be a problem for the RNG. 
However, measurements and analyses given in section 5.2.1 come to the rescue: 
The measurements show that the folded value behaves like having one bit of 
entropy.

To support that conclusion, the folding loop is sometimes executed in 
multiples of 64. This looks strange at first look, but these multiples ensure 
that the distribution of the folding loop bits discussed in section 5.2.1 
stabilizes quickly. And with these multiple execution of the folding loop, the 
upper boundary of the entropy is defined.

Now coming back to your concern: It is surely possible to put the Von-Neumann 
unbiaser before the folding loop. But considering the argument above, no 
information is lost apart from entropy exceeding one bit due to the use of a 
bijective operation. This means, it would not matter whether to put the Von-
Neumann unbiaser before or after the folding. However, when putting it after 
the folding, the unbiaser will throw away more values and it would be more 
conservative with this approach (it is more likely to find adjacent 0 0 or 1 1 
combinations than identical adjacent time deltas).

Finally, the Von-Neumann unbiaser applies to individual bits. I am unsure how 
that would fit to the 64 bit time delta value that is the input to the folding 
loop.

> > There are so many assessments on entropy I make, I am surprised that I
> > am said to have no entropy assessment.
> 
> Again: Shannon entropy assumes that you have a sequence of independent
> and identically distributed random variables.  And you cannot prove
> these properties from the output; you need to know the process that
> generates the values.

I am absolutely on your side here. And as we cannot (yet?) fully conclude that 
the observations are independent, a safety margin must always be considered. 
The RNG has the following safety margins where it is more conservative than 
measurements indicate:

- the folding loop produces one bit where measurements of the time deltas that 
go into the folding loop are typically above 2 bits with the lower boundary. 
The upper boundary is typical at 6 bits or higher. Some systems (especially 
older CPUs) show variations that are less than 2 bits with the lower boundary. 
But all of them are well above one bit. (note, my first designs had a folding 
loop that results in three bits, but then I reduced it to two and finally to 
one bit to ensure a safety margin)

- the placement of the Von-Neumann unbiaser will throw away more bits than it 
would when it would be placed before the folding loop. That means that the 
noise source must produce more bits which are assembled into the final random 
number

- the execution of the folding loop with multiples of 64 chosen with another 
time stamp adds more uncertainty over the folding timing -- therefore we have 
an upper boundary for the entropy estimation. I am almost certain that the 
selection of the multiplier value is not independent of the time stamps 
gathered for the time delta measurement (due to using the four lowest bits of 
that time stamp to determine the multiplexer value). That means that the upper 
boundary calculated with the Shannon Entropy formula is certainly too high. 
But the "real" value is above the lower boundary.

Thanks for your thoughts.

Ciao
Stephan
-- 
| Cui bono? |
