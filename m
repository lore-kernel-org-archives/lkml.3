Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752221AbaBCNhW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 08:37:22 -0500
Received: from mail.eperm.de ([89.247.134.16]:43991 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750884AbaBCNhU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 08:37:20 -0500
From: Stephan Mueller <smueller@chronox.de>
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        macro@linux-mips.org, ralf@linux-mips.org, dave.taht@gmail.com,
        blogic@openwrt.org, andrewmcgr@gmail.com, geert@linux-m68k.org,
        tg@mirbsd.de
Subject: Re: [PATCH,RFC] random: collect cpu randomness
Date: Mon, 03 Feb 2014 14:36:58 +0100
Message-ID: <6596457.bT4VGACiji@tauon>
User-Agent: KMail/4.11.5 (Linux/3.12.7-300.fc20.x86_64; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140203012420.GB9499@logfs.org>
References: <20140202203617.GA9499@logfs.org> <16782692.5vMS7Bhbvf@myon.chronox.de> <20140203012420.GB9499@logfs.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, 2. Februar 2014, 20:24:21 schrieb Jörn Engel:

Hi Jörn,

>On Sun, 2 February 2014 22:25:31 +0100, Stephan Mueller wrote:
>> Am Sonntag, 2. Februar 2014, 15:36:17 schrieb Jörn Engel:
>> > Collects entropy from random behaviour all modern cpus exhibit. 
>> > The
>> > scheduler and slab allocator are instrumented for this purpose. 
>> > How
>> > much randomness can be gathered is clearly hardware-dependent and
>> > hard
>> > to estimate.  Therefore the entropy estimate is zero, but random
>> > bits
>> > still get mixed into the pools.
>> 
>> May I ask what the purpose of the patches is when no entropy is
>> implied? I see that the pool is stirred more. But is that really a
>> problem that needs addressing?
>
>For my part, I think the whole business of estimating entropy is
>bordering on the esoteric.  If the hash on the output side is any
>good, you have a completely unpredictable prng once the entropy pool
>is unpredictable.  Additional random bits are nice, but not all that
>useful.  Blocking /dev/random based on entropy estimates is likewise
>not all that useful.

I really like that statement, because for the most part I concur :-)

However, there are a number of cryptographers out there, which insist on 
such entropy assessments and even the blocking behavior. For example, I 
work with cryptographers from the German BSI. We created a quantitative 
assessment of /dev/random for them (see [1]). During the discussion, I 
learned that the key reason they like /dev/random and dislike 
/dev/urandom is the fact that /dev/random ensures that any output of 
data is always backed by hardware entropy. In order to ensure that you 
always have hardware entropy that backs your output, you somehow must 
quantify that hardware entropy. Thus, a dropping of the entropy 
estimation would be catastrophic for them.

When you look at NIST and the base discussions in SP800-90A, you see 
that for deterministic RNGs, NIST is not that strict as BSI. Yet, they 
require a DRNG to be reseeded with entropy after a (large) number of 
generated bits. For that reseeding process, some entropy estimation is 
needed. But when looking at SP800-90B, things get hairy again where some 
strict entropy estimations are needed.

Even if you subscribe to the notion that an RNG only needs some X bits 
of entropy for starters and then can spin indefinitely on this entropy, 
there is still a need on estimating entropy, at least at the beginning.
>
>Key phrase is "once the entropy pool is unpredictable".  So early in
>bootup it may make sense to estimate the entropy.  But here the

I am fully in agreement here.

>problem is that you cannot measure entropy, at least not within a
>single system and a reasonable amount of time.  That leaves you with a
>heuristic that, like all heuristics, is wrong.

No argument here :-)

(side note: The interesting thing is that the /dev/random heuristic on 
entropy seems to underestimate the entropy present in events where the 
heuristic assumes low entropy, but way overestimates entropy where the 
heuristic entropy assumes high entropy)
>
>I personally care more about generating high-quality randomness as
>soon as possible and with low cost to the system.  Feel free to
>disagree or set your priorities differently.

Fully in agreement

[..]
>> First, the noise source you add is constantly triggered throughout
>> the
>> execution of the kernel. Entropy is very important, we (who are
>> interested in crypto) know that. But how often is entropy needed?
>> Other folks wonder about the speed of the kernel. And with these two
>> patches, every kmalloc and every scheduling invocation now dives
>> into the random.c code to do something. I would think this is a bit
>> expensive, especially to stir the pool without increasing the
>> entropy estimator. I think entropy collection should be performed
>> when it is needed and not throughout the lifetime of the system.
>Please measure how expensive it really is.  My measurement gave me a
>"doesn't matter" result, surprising as it may seem.

That sounds really good.
>
>If the cost actually matters, we can either disable or rate-limit the
>randomness collection at some point after boot.  But that would bring
>us back into the estimation business.
>
>> It seems I have a bad timing, because just two days ago I released a
>> new attempt on the CPU jitter RNG [1] with a new noise source, and I
>> was just about to prepare a release email. With that attempt, both
>> issues raised above are addressed, including a theoretical
>> foundation of the noise source.
>> 
>> [1] http://www.chronox.de/
>
>I am not married to my patch.  If the approach makes sense, let's
>merge it.  If the approach does not make sense or there is a better
>alternative, drop it on the floor.
>
>The problem I see with your approach is this:
>"The only prerequisite is the availability of a high-resolution timer
>that is available in modern CPUs."

Right, and with the absence of a high-resolution counter, my RNG breaks 
down. Though, I have more goals than to just run my RNG inside the Linux 
kernel and thus the reliance on only the timer.

However, during my testing on also embedded systems, a significant 
number have them -- at least a counter that is integrated with the 
clock_source framework.

Allow me to explain my RNG and the new developments in a separate email 
to not hijack your thread here.

I think both have merits, considering that based on your statement, the 
integration into schedule/kmalloc code paths is not that expensive.
>
>Given a modern CPU with a high-resolution timer, you will almost
>certainly collect enough randomness for good random numbers.  Problem
>solved and additional improvements are useless.
>
>But on embedded systems with less modern CPUs, few interrupt sources,
>no user interface, etc. you may have trouble collecting enough
>randomness or doing it soon enough.  That is the problem worth fixing.
>It is also a hard problem to fix and I am not entirely convinced I
>found a good approach.

I do not think that there can be a right approach given the variety of 
systems Linux can run on. Though, the current random.c definitely is 
challenged in embedded systems, but also on "normal" headless systems 
with SSDs. Thus, any proposal of using new entropy sources is good.

[1] 
https://www.bsi.bund.de/DE/Publikationen/Studien/LinuxRNG/index_htm.html

Ciao
Stephan
