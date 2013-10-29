Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473Ab3J2Imv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 04:42:51 -0400
Received: from mail.eperm.de ([89.247.134.16]:41018 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751932Ab3J2Imq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 04:42:46 -0400
From: Stephan Mueller <smueller@chronox.de>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: sandy harris <sandyinchina@gmail.com>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH] CPU Jitter RNG: inclusion into kernel crypto API and /dev/random
Date: Tue, 29 Oct 2013 09:42:30 +0100
Message-ID: <3160817.9DcncHidey@tauon>
User-Agent: KMail/4.11.2 (Linux/3.11.6-200.fc19.x86_64; KDE/4.11.2; x86_64; ; )
In-Reply-To: <20131028214549.GA31746@thunk.org>
References: <2579337.FPgJGgHYdz@tauon> <2049321.gMV6JUDze7@tauon> <20131028214549.GA31746@thunk.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 28. Oktober 2013, 17:45:49 schrieb Theodore Ts'o:

Hi Theodore,

first of all, thank you for your thoughts.

And, before we continue any discussion, please consider that all the big 
testing that is done to analyze the jitter so far did (a) not include 
any whitening schema (cryptographic or otherwise) and (b) did not even 
include the processing done inside the RNG. The testing in appendix F of 
the documentation just measures the execution time of some instructions 
-- the very heart of the RNG, and not more. And only if these show 
variations, then I conclude the RNG can be used.

[...]
>
>It may be that there is some very complex state which is hidden inside
>the the CPU execution pipeline, the L1 cache, etc., etc.  But just
>because *you* can't figure it out, and just because *I* can't figure
>it out doesn't mean that it is ipso facto something which a really
>bright NSA analyst working in Fort Meade can't figure out.  (Or heck,
>a really clever Intel engineer who has full visibility into the
>internal design of an Intel CPU....)

I concur here. But so are all sources of /dev/random too. As you have 
outlined later, your HDD fluctuations may not be as trustworthy as we 
think. The key strokes and their timings can be obtained from 
electromagnetic emanation. Lastly, the use of the fast_pool using 
interrupts may still show a correlation with the other noise sources as 
they all generate interrupts. But I diverge as we talk about my RNG and 
do not analyze random.c.

So, I guess we all agree on the notion that entropy is *relative*. Some 
information may be more entropic to one than to the other. However, for 
us, it shall be entropy enough to counter our adversary.
>
>Now, it may be that in practice, an adversary won't be able to carry
>out a practical attack because there will be external interrupts that
>the adversary won't be able to put into his or her model of your CPU
>--- for example, from network interrupts or keyboard interrupts.  But
>in that case, it's to measure just the interrupt, because it may be
>that the 32 interrupts that you got while extracting 128 bits of
>entropy from your jitter engine was only 32 bits of entropy, and the
>rest could be determined by someone with sufficient knowledge and
>understanding of the internal guts of the CPU.  (Treating this
>obscurity as security is probably not a good idea; we have to assume
>the NSA can get its hands on anything it wants, even internal,
>super-secret, "black cover" Intel documents.  :-)

Again, I concur. But since I have seen the jitter with quite similar 
size on all the major CPUs we have around us (Intel, AMD, Sparc, POWER, 
PowerPC, ARM, MIPS, zSeries), I guess you need to update your statement 
to "... even internal, super-secret, "black cover" documents that are 
synchronized among all the different chip vendors". :-)

[...]

Thanks again to your ideas below in testing the issue more.
>
>So if you want to really convince the world that CPU jitter is random,
>it's not enough to claim that it you can't see a pattern.  What you
>need to do is to remove all possible sources of the uncertainty, and
>show that there is still no discernable pattern after you do things
>like (a) run in kernel space, on an otherwise quiscent computer, (b)

Re: (a) that is what I already did. The kernel implementation of the RNG 
is capable of that testing. Moreover, that is what I already did in 
section 5.1. It is easy for everybody to redo the testing by simply 
compiling the kernel module, load it and look into  
/sys/kernel/debug/jitterentropy. There you find some files that are 
direct interfaces to the RNG. In particular, the file stat-fold is the 
key to redo the testing that covers appendix F of my document (as 
mentioned above, there is no postprocessing of the raw variations when 
you read that file).

>disable interrupts, so that any uncertainty can't be coming from
>interrupts, etc., Try to rule it all out, and then see if you still
>get uncertainty.

When I did testing on all systems, interrupts are easily visible by the 
larger "variations". When compiling the test results in appendix F, all 
measurements that are a tad higher than the majority of the variations 
are simply removed to focus on the worst case. I.e. the measurements and 
the results *already* exclude any interrupts, scheduling impacts.

Regarding, caches, may I ask you to look into appendix F.46 of the 
current document version? I conducted tests that tried to disable / 
remove the impact of: system call context switches, flushing the 
instruction pipeline, flushing of all caches, disabling preemtion, 
flushing TLB, executing the code exclusively on one CPU core, disabling 
of power management and frequency scaling.

All these tests show *no* deterioration in jitter, i.e. the jitter is 
still there. The only exception is the power management where I see some 
small jitter drop off, which is analyzed and concluded to be 
unproblematic.

>
>If you think it is from DRAM timing, first try accessing the same
>memory location in kernel code with the interrupts off, over and over
>again, so that the memory is pinned into L1 cache.  You should be able

That is what the testing already does. I constantly access some piece of 
memory millions of times and measure the execution time of the operation 
on that memory location. As mentioned above, interrupts are disregarded 
in any case.

And, jitter is there.

>to get consistent results.  If you can, then if you then try to read
>from DRAM with the L1 and L2 caches disabled, and with interrupts

Based on this suggestion, I now added the tests in Appendix F.46.8 where 
I disable the caches and the tests in Appendix F.46.9 where I disable 
the caches and interrupts.

The results show that the jitter even goes way up -- thus, jitter that 
is sufficient is even more present when disabling the caches and 
interrupts.

>turned off, etc, and see if you get consistent results or inconsistent
>results.  If you get consistent results in both cases, then your
>hypothesis is disproven.  If you get consistent results with the

Currently, the hypothesis is *not* disproven.

>memory pinned in L1 cache, and inconsistent results when the L1 and L2
>cache are disabled, then maybe the timing of DRAM reads really are
>introducing entropy.  But the point is you need to test each part of
>the system in isolation, so you can point at a specific part of the
>system and say, *that*'s where at least some uncertainty which an
>adversary can not reverse engineer, and here is the physical process
>from which the choatic air patterns, or quantum effects, etc., which
>is hypothesized to cause the uncertainty.

As I tried quite a number of different variations on disabling / 
enabling features in appendix F.46, I am out of ideas what else I should 
try.
>
>And note that when you do this, you can't use any unbiasing or
>whitening techniques --- you want to use the raw timings, and then do
>things like look very hard for any kind of patterns; Don Davis used

Again, there is no whitening, and not even the RNG processing involved. 
All I am doing is simple timing analysis of some fixed set of 
instructions -- i.e. the very heart of the RNG.

[..]
>
>The jitter "entropy collector" may be able to generate more
>"randomness" much more quickly, but is the resulting numbers really
>more secure?  Other people will have to judge for themselves, but this
>is why I'm not convinced.

May I ask to recheck appendix F.46 again?

Thanks
Stephan
