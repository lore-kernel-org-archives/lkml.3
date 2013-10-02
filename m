Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889Ab3JBFKA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 01:10:00 -0400
Received: from ozlabs.org ([203.10.76.45]:34085 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751766Ab3JBFJ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 01:09:57 -0400
Date: Wed, 2 Oct 2013 15:09:40 +1000
From: Paul Mackerras <paulus@samba.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Gleb Natapov <gleb@redhat.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        linux-kernel@vger.kernel.org, agraf@suse.de, mpm@selenic.com,
        herbert@gondor.hengli.com.au, linuxppc-dev@ozlabs.org,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org, tytso@mit.edu
Subject: Re: [PATCH 3/3] KVM: PPC: Book3S: Add support for hwrng found on
 some powernv systems
Message-ID: <20131002050940.GA25363@drongo>
References: <1380177066-3835-1-git-send-email-michael@ellerman.id.au>
 <1380177066-3835-3-git-send-email-michael@ellerman.id.au>
 <5243F933.7000907@redhat.com>
 <20131001083426.GB27484@concordia>
 <20131001083908.GA17294@redhat.com>
 <1380620338.645.22.camel@pasglop>
 <524AAFAA.3010801@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <524AAFAA.3010801@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 01, 2013 at 01:19:06PM +0200, Paolo Bonzini wrote:

> Anyhow, I would like to know more about this hwrng and hypercall.
> 
> Does the hwrng return random numbers (like rdrand) or real entropy (like
> rdseed that Intel will add in Broadwell)?  What about the hypercall?

Well, firstly, your terminology is inaccurate.  Real entropy will give
you random numbers.  I think when you say "random numbers" you
actually mean "pseudo-random numbers".

Secondly, the RNG produces real entropy.  The way it works is that
there are 64 ring oscillators running at different frequencies (above
1GHz).  They get sampled at (typically) 1MHz and the samples get put
in a 64-entry FIFO, which is read by MMIO.  There is practically no
correlation between bits or between adjacent samples.  The only
deficiency is that the distribution of each bit is not always
precisely 50% zero / 50% one (it is somewhere between 40/60 and
60/40).

The whitening addresses this bias.  Looking at the stream of values
for a given bit, we XOR that stream with another stream that is
uncorrelated and has a 50/50 distribution (or very very close to
that), which gives a stream whose distribution is closer to 50/50 than
either input stream.  The second stream is effectively derived by
XORing together all 64 bits of some previous sample.  XORing together
many uncorrelated streams that are each close to 50/50 distribution
gives a stream that is much closer to a 50/50 distribution (by the
"piling up lemma").  The result passes all the dieharder tests.

> For example virtio-rng is specified to return actual entropy, it doesn't
> matter if it is from hardware or software.
> 
> In either case, the patches have problems.
> 
> 1) If the hwrng returns random numbers, the whitening you're doing is
> totally insufficient and patch 2 is forging entropy that doesn't exist.
> 
> 2) If the hwrng returns entropy, a read from the hwrng is going to even
> more expensive than an x86 rdrand (perhaps ~2000 cycles).  Hence, doing

The MMIO itself is reasonably quick if the FIFO is not empty, but the
long-term overall rate is limited by the sampling rate.

> the emulation in the kernel is even less necessary.  Also, if the hwrng
> returns entropy patch 1 is unnecessary: you do not need to waste
> precious entropy bits by passing them to arch_get_random_long; just run
> rngd in the host as that will put the entropy to much better use.

Not sure why they are particularly "precious"; we get 64 bits per
microsecond whether we use them or not.  What are you suggesting
arch_get_random_long() should do instead?

> 3) If the hypercall returns random numbers, then it is a pretty
> braindead interface since returning 8 bytes at a time limits the
> throughput to a handful of MB/s (compare to 200 MB/sec for x86 rdrand).
>  But more important: in this case drivers/char/hw_random/pseries-rng.c
> is completely broken and insecure, just like patch 2 in case (1) above.

Assuming that by "random numbers" you actually mean "pseudo-random
numbers", then this doesn't apply.

> 4) If the hypercall returns entropy (same as virtio-rng), the same
> considerations on speed apply.  If you can only produce entropy at say 1
> MB/s (so reading 8 bytes take 8 microseconds---which is actually very
> fast), it doesn't matter that much to spend 7 microseconds on a
> userspace roundtrip.  It's going to be only half the speed of bare
> metal, not 100 times slower.

8 bytes takes at most 1 microsecond, so the round-trip to userspace is
definitely noticeable.

Paul.
