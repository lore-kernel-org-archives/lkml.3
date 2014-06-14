Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751779AbaFNFZ3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 01:25:29 -0400
Received: from ns.horizon.com ([71.41.210.147]:49567 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751142AbaFNFZ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 01:25:28 -0400
Date: 14 Jun 2014 01:25:27 -0400
Message-ID: <20140614052527.14849.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux@horizon.com, tytso@mit.edu
Subject: Re: random: Benchamrking fast_mix2
Cc: hpa@linux.intel.com, linux-kernel@vger.kernel.org, mingo@kernel.org,
        price@mit.edu
In-Reply-To: <20140614030621.GB6447@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> At least for Intel, between its branch predictor and speculative
> execution engine, it doesn't make a difference.  

*Sigh*.  We need live measurement.  My testing (in your test
harness!) showed a noticeable (~10%) speedup.

> When I did a quick comparison of your 64-bit fast_mix2 variant, it's
> much slower than either the 32-bit fast_mix2, or the original fast_mix
> alrogithm.

That is f***ing *bizarre*.  For me, it's *significantly* faster.
You *are* compiling -m64, right?  Because I agree with you it'd
be stupid to try to use it on 32-bit machines.

Forcing max-speed CPU:
# ./perftest ./ted64
fast_mix: 419   fast_mix2: 419  fast_mix4: 318
fast_mix: 386   fast_mix2: 419  fast_mix4: 112
fast_mix: 419   fast_mix2: 510  fast_mix4: 328
fast_mix: 420   fast_mix2: 510  fast_mix4: 306
fast_mix: 420   fast_mix2: 510  fast_mix4: 317
fast_mix: 419   fast_mix2: 510  fast_mix4: 318
fast_mix: 362   fast_mix2: 510  fast_mix4: 317
fast_mix: 420   fast_mix2: 510  fast_mix4: 306
fast_mix: 419   fast_mix2: 499  fast_mix4: 318
fast_mix: 420   fast_mix2: 510  fast_mix4: 328

And not:
$ ./ted64
fast_mix: 328   fast_mix2: 430  fast_mix4: 272
fast_mix: 442   fast_mix2: 442  fast_mix4: 272
fast_mix: 442   fast_mix2: 430  fast_mix4: 272
fast_mix: 329   fast_mix2: 442  fast_mix4: 272
fast_mix: 329   fast_mix2: 430  fast_mix4: 272
fast_mix: 328   fast_mix2: 442  fast_mix4: 272
fast_mix: 329   fast_mix2: 431  fast_mix4: 272
fast_mix: 328   fast_mix2: 442  fast_mix4: 272
fast_mix: 328   fast_mix2: 431  fast_mix4: 272
fast_mix: 329   fast_mix2: 442  fast_mix4: 272

And on a Phenom:
$ /tmp/ted64
fast_mix: 250   fast_mix2: 174  fast_mix4: 109
fast_mix: 258   fast_mix2: 170  fast_mix4: 114
fast_mix: 371   fast_mix2: 285  fast_mix4: 109
fast_mix: 516   fast_mix2: 156  fast_mix4: 90
fast_mix: 140   fast_mix2: 184  fast_mix4: 170
fast_mix: 406   fast_mix2: 146  fast_mix4: 88
fast_mix: 185   fast_mix2: 114  fast_mix4: 94
fast_mix: 161   fast_mix2: 116  fast_mix4: 98
fast_mix: 152   fast_mix2: 104  fast_mix4: 94
fast_mix: 352   fast_mix2: 140  fast_mix4: 79

> So given that 32-bit processors tend to be slower, I'm pretty sure
> if we want to add a 64-bit optimization, we'll have to conditionalize
> it on BITS_PER_LONG == 64 and include both the original code and the
> 64-bit optimized code.

Sorry I neglected to say so earlier; that has *always* been my intention.
The 32-bit version is primary; the 64-bit version is a conditional
optimization.

If I can make it faster *and* have more avalanche (and less register
pressure, too), it seems worth the hassle of having two versions.
