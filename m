Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751650AbaFMAXH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 20:23:07 -0400
Received: from ns.horizon.com ([71.41.210.147]:56372 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750777AbaFMAXG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 20:23:06 -0400
Date: 12 Jun 2014 20:23:04 -0400
Message-ID: <20140613002304.17318.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux@horizon.com, tytso@mit.edu
Subject: Re: random: Benchamrking fast_mix2
Cc: hpa@linux.intel.com, linux-kernel@vger.kernel.org, mingo@kernel.org,
        price@mit.edu
In-Reply-To: <20140612204622.GB3112@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So I just tried your modified 32-bit mixing function where you the
> rotation to the middle step instead of the last step.  With the
> usleep(), it doesn't make any difference:
> 
> # schedtool -R -p 1 -e /tmp/fast_mix2_48
> fast_mix: 212  fast_mix2: 400	fast_mix3: 400
> fast_mix: 208  fast_mix2: 408	fast_mix3: 388
> fast_mix: 208  fast_mix2: 396	fast_mix3: 404
> fast_mix: 224  fast_mix2: 408	fast_mix3: 392
> fast_mix: 200  fast_mix2: 404	fast_mix3: 404
> fast_mix: 208  fast_mix2: 412	fast_mix3: 396
> fast_mix: 208  fast_mix2: 392	fast_mix3: 392
> fast_mix: 212  fast_mix2: 408	fast_mix3: 388
> fast_mix: 200  fast_mix2: 716	fast_mix3: 773
> fast_mix: 426  fast_mix2: 717	fast_mix3: 728

> And here is my testing using your 64-bit variant:
> 
> # schedtool -R -p 1 -e /tmp/fast_mix2_49
> fast_mix: 294  fast_mix2: 476  fast_mix4: 442
> fast_mix: 286  fast_mix2: 1058 fast_mix4: 448
> fast_mix: 958  fast_mix2: 460  fast_mix4: 1002
> fast_mix: 940  fast_mix2: 1176 fast_mix4: 826
> fast_mix: 476  fast_mix2: 840  fast_mix4: 826
> fast_mix: 462  fast_mix2: 840  fast_mix4: 826
> fast_mix: 462  fast_mix2: 826  fast_mix4: 826
> fast_mix: 462  fast_mix2: 826  fast_mix4: 826
> fast_mix: 462  fast_mix2: 826  fast_mix4: 826
> fast_mix: 462  fast_mix2: 840  fast_mix4: 826

> The bottom line is that what we are primarily measuring here is all
> different cache effects.  And these are going to be quite different on
> different microarchitectures.

So adding fast_mix4 doubled the time taken by fast_mix.
Yeah, that's trustworthy timing! :-)

Still, you do seem to observe a pretty consistent factor of about 2x
difference, which confuses me because I can't reproduce it.

But it's hard to reach definite conclusions with this much measurement noise.

Another cache we might be hitting is the branch predictor.  Could you try
unrolling fast_mix2 and fast_mix4 and see what difference that makes?
(I'd send you a patch but you could probably do it by hand faster than
appying one.)

It only makes a slight difference on my high-end Intel box, but almost
doubles the speed on the Phenom:

Rolled (64-bit core, 2 rounds):
fast_mix: 293   fast_mix2: 205
fast_mix: 257   fast_mix2: 162
fast_mix: 170   fast_mix2: 137
fast_mix: 283   fast_mix2: 218
fast_mix: 270   fast_mix2: 185
fast_mix: 288   fast_mix2: 199
fast_mix: 423   fast_mix2: 131
fast_mix: 286   fast_mix2: 218
fast_mix: 681   fast_mix2: 165
fast_mix: 268   fast_mix2: 190

Unrolled (64-bit core, 2 rounds):
fast_mix: 394   fast_mix2: 108
fast_mix: 145   fast_mix2: 80
fast_mix: 270   fast_mix2: 112
fast_mix: 145   fast_mix2: 81
fast_mix: 145   fast_mix2: 79
fast_mix: 662   fast_mix2: 107
fast_mix: 145   fast_mix2: 78
fast_mix: 140   fast_mix2: 127
fast_mix: 164   fast_mix2: 182
fast_mix: 205   fast_mix2: 79

Since the original fast_mix is unrolled, a penalty there wouldn't
hit it.

> That being said, I wouldn't be at all surprised if there are some
> CPU's where the extract memory dereference to the twist_table[] would
> definitely hurt, since Intel's amazing cache architecture(tm) is no
> doubt covering a lot of sins.  I wouldn't be at all surprised if some
> of these new mixing functions would fare much better if we tried
> benchmarking them on an 32-bit ARM processor, for example....

Yes, Intel's D-caches are quite impressive.
