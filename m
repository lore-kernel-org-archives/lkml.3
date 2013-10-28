Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757602Ab3J1WeP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 18:34:15 -0400
Received: from imap.thunk.org ([74.207.234.97]:51787 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756240Ab3J1WeK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 18:34:10 -0400
Date: Mon, 28 Oct 2013 17:45:49 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Stephan Mueller <smueller@chronox.de>
Cc: sandy harris <sandyinchina@gmail.com>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH] CPU Jitter RNG: inclusion into kernel crypto API and
 /dev/random
Message-ID: <20131028214549.GA31746@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Stephan Mueller <smueller@chronox.de>,
	sandy harris <sandyinchina@gmail.com>, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
References: <2579337.FPgJGgHYdz@tauon>
 <2049321.gMV6JUDze7@tauon>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2049321.gMV6JUDze7@tauon>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fundamentally, what worries me about this scheme (actually, causes the
hair on the back of my neck to rise up on end) is this statement in
your documentation[1]:

   When looking at the sequence of time deltas gathered
   during testing [D] , no pattern can be detected. Therefore, the
   fluctuation and the resulting distribution are not based on a
   repeating pattern and must be considered random.

[1] http://www.chronox.de/jent/doc/CPU-Jitter-NPTRNG.html

Just because we can't detect a pattern does **not** mean that it is
not based on a repeating pattern, and therefore must be considered
random.  We can't detect a pattern in RDRAND, so does that mean it's
automatically random?  Why, no.

If all you have is the output of "AES_ENCRPYT(NSA_KEY, i++)". and
NSA_KEY is not known to you, you won't be able to detect a pattern,
either.  But I can guarantee to you that it's not random...

It may be that there is some very complex state which is hidden inside
the the CPU execution pipeline, the L1 cache, etc., etc.  But just
because *you* can't figure it out, and just because *I* can't figure
it out doesn't mean that it is ipso facto something which a really
bright NSA analyst working in Fort Meade can't figure out.  (Or heck,
a really clever Intel engineer who has full visibility into the
internal design of an Intel CPU....)

Now, it may be that in practice, an adversary won't be able to carry
out a practical attack because there will be external interrupts that
the adversary won't be able to put into his or her model of your CPU
--- for example, from network interrupts or keyboard interrupts.  But
in that case, it's to measure just the interrupt, because it may be
that the 32 interrupts that you got while extracting 128 bits of
entropy from your jitter engine was only 32 bits of entropy, and the
rest could be determined by someone with sufficient knowledge and
understanding of the internal guts of the CPU.  (Treating this
obscurity as security is probably not a good idea; we have to assume
the NSA can get its hands on anything it wants, even internal,
super-secret, "black cover" Intel documents.  :-)

To be honest, I have exactly the same worry about relying on HDD
interrupts.  The theoretical basis of this resulting in true
randomness is based on a 1994 paper by Don Davis: "Cryptographic
randomness from air turbulence in disk drives"[2]:

[2] http://world.std.com/~dtd/random/forward.pdf

The problem is that almost two decades later, the technology of HDD's,
and certainly SSD (which didn't exist back then) have changed quite a
lot.  It is not obvious to me how much entropy you can really get from
observing the disk completion times if you assume that the adversary
has complete knowledge to the relative timing and block numbers of the
disk accesses from the OS (for example, if we boot multiple mobile
phone from flash for the first time, how many bits of entropy are
there really?)

But at least back in 1994, there was an attempt to come up with a
physical theory as to where the entropy was coming from, and then as
much work as possible to rule out other possible causes of the
uncertainty.

So if you want to really convince the world that CPU jitter is random,
it's not enough to claim that it you can't see a pattern.  What you
need to do is to remove all possible sources of the uncertainty, and
show that there is still no discernable pattern after you do things
like (a) run in kernel space, on an otherwise quiscent computer, (b)
disable interrupts, so that any uncertainty can't be coming from
interrupts, etc., Try to rule it all out, and then see if you still
get uncertainty.

If you think it is from DRAM timing, first try accessing the same
memory location in kernel code with the interrupts off, over and over
again, so that the memory is pinned into L1 cache.  You should be able
to get consistent results.  If you can, then if you then try to read
from DRAM with the L1 and L2 caches disabled, and with interrupts
turned off, etc, and see if you get consistent results or inconsistent
results.  If you get consistent results in both cases, then your
hypothesis is disproven.  If you get consistent results with the
memory pinned in L1 cache, and inconsistent results when the L1 and L2
cache are disabled, then maybe the timing of DRAM reads really are
introducing entropy.  But the point is you need to test each part of
the system in isolation, so you can point at a specific part of the
system and say, *that*'s where at least some uncertainty which an
adversary can not reverse engineer, and here is the physical process
from which the choatic air patterns, or quantum effects, etc., which
is hypothesized to cause the uncertainty.

And note that when you do this, you can't use any unbiasing or
whitening techniques --- you want to use the raw timings, and then do
things like look very hard for any kind of patterns; Don Davis used
FFT's because he wanted to look for any patterns that might be
introduced by the rotating plattern, which would presumably would show
up in a frequency domain analysis even if it was invisible in the time
domain.

If you don't do all of this work, there is no way to know for sure
where the entropy is coming from.  And if you don't know, that's when
you have to be very, very conservative, and use a very large
engineering safety margin.  Currently we use the high resolution CPU
counter, plus the interrupted IP, and we mix all of this together from
64 interrupts, and we count this as a single bit of entropy.  I *hope*
that at least one of those interrupts has sufficient unpredictably,
perhaps because the remote attacker can't know when a LAN interrupt
has happened, such that have a single bit of entropy.

Maybe someone can prove that there is more entropy because of some
instability between the oscillator used by the CPU clock and the one
used by the ethernet NIC, and so I'm being hopelessly
over-conservative.  Perhaps; but until we know for sure, using a
similar analysis to what I described above, I'd much rather be slow
than be potentially insecure.

The jitter "entropy collector" may be able to generate more
"randomness" much more quickly, but is the resulting numbers really
more secure?  Other people will have to judge for themselves, but this
is why I'm not convinced.

Best regards,

					- Ted
