Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581Ab3JALSx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 07:18:53 -0400
Received: from mail-ea0-f181.google.com ([209.85.215.181]:51048 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408Ab3JALSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 07:18:51 -0400
Message-ID: <524AAFAA.3010801@redhat.com>
Date: Tue, 01 Oct 2013 13:19:06 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130923 Thunderbird/17.0.9
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Gleb Natapov <gleb@redhat.com>, Michael Ellerman <michael@ellerman.id.au>,
        linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        agraf@suse.de, mpm@selenic.com, herbert@gondor.hengli.com.au,
        linuxppc-dev@ozlabs.org, kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        tytso@mit.edu
Subject: Re: [PATCH 3/3] KVM: PPC: Book3S: Add support for hwrng found on
 some powernv systems
References: <1380177066-3835-1-git-send-email-michael@ellerman.id.au>  <1380177066-3835-3-git-send-email-michael@ellerman.id.au>  <5243F933.7000907@redhat.com> <20131001083426.GB27484@concordia>  <20131001083908.GA17294@redhat.com> <1380620338.645.22.camel@pasglop>
In-Reply-To: <1380620338.645.22.camel@pasglop>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 01/10/2013 11:38, Benjamin Herrenschmidt ha scritto:
> So for the sake of that dogma you are going to make us do something that
> is about 100 times slower ? (and possibly involves more lines of code)

If it's 100 times slower there is something else that's wrong.  It's
most likely not 100 times slower, and this makes me wonder if you or
Michael actually timed the code at all.

> It's not just speed ... H_RANDOM is going to be called by the guest
> kernel. A round trip to qemu is going to introduce a kernel jitter
> (complete stop of operations of the kernel on that virtual processor) of
> a full exit + round trip to qemu + back to the kernel to get to some
> source of random number ...  this is going to be in the dozens of ns at
> least.

I guess you mean dozens of *micro*seconds, which is somewhat exaggerated
but not too much.  On x86 some reasonable timings are:

  100 cycles            bare metal rdrand
  2000 cycles           guest->hypervisor->guest
  15000 cycles          guest->userspace->guest

(100 cycles = 40 ns = 200 MB/sec; 2000 cycles = ~1 microseconds; 15000
cycles = ~7.5 microseconds).  Even on 5 year old hardware, a userspace
roundtrip is around a dozen microseconds.


Anyhow, I would like to know more about this hwrng and hypercall.

Does the hwrng return random numbers (like rdrand) or real entropy (like
rdseed that Intel will add in Broadwell)?  What about the hypercall?
For example virtio-rng is specified to return actual entropy, it doesn't
matter if it is from hardware or software.

In either case, the patches have problems.

1) If the hwrng returns random numbers, the whitening you're doing is
totally insufficient and patch 2 is forging entropy that doesn't exist.

2) If the hwrng returns entropy, a read from the hwrng is going to even
more expensive than an x86 rdrand (perhaps ~2000 cycles).  Hence, doing
the emulation in the kernel is even less necessary.  Also, if the hwrng
returns entropy patch 1 is unnecessary: you do not need to waste
precious entropy bits by passing them to arch_get_random_long; just run
rngd in the host as that will put the entropy to much better use.

3) If the hypercall returns random numbers, then it is a pretty
braindead interface since returning 8 bytes at a time limits the
throughput to a handful of MB/s (compare to 200 MB/sec for x86 rdrand).
 But more important: in this case drivers/char/hw_random/pseries-rng.c
is completely broken and insecure, just like patch 2 in case (1) above.

4) If the hypercall returns entropy (same as virtio-rng), the same
considerations on speed apply.  If you can only produce entropy at say 1
MB/s (so reading 8 bytes take 8 microseconds---which is actually very
fast), it doesn't matter that much to spend 7 microseconds on a
userspace roundtrip.  It's going to be only half the speed of bare
metal, not 100 times slower.


Also, you will need _anyway_ extra code that is not present here to
either disable the rng based on userspace command-line, or to emulate
the rng from userspace.  It is absolutely _not_ acceptable to have a
hypercall disappear across migration.  You're repeatedly ignoring these
issues, but rest assured that they will come back and bite you
spectacularly.

Based on all this, I would simply ignore the part of the spec where they
say "the hypercall should return numbers from a hardware source".  All
that matters in virtualization is to have a good source of _entropy_.
Then you can run rngd without randomness checks, which will more than
recover the cost of userspace roundtrips.

In any case, deciding where to get that entropy from is definitely
outside the scope of KVM, and in fact QEMU already has a configurable
mechanism for that.

Paolo
