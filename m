Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933060AbaFLLSw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 07:18:52 -0400
Received: from ns.horizon.com ([71.41.210.147]:27094 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755268AbaFLLSv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 07:18:51 -0400
Date: 12 Jun 2014 07:18:50 -0400
Message-ID: <20140612111850.26176.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux@horizon.com, tytso@mit.edu
Subject: Re: random: Benchamrking fast_mix2
Cc: hpa@linux.intel.com, linux-kernel@vger.kernel.org, mingo@kernel.org,
        price@mit.edu
In-Reply-To: <20140612041318.11805.qmail@ns.horizon.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ted, just as an example of a possible tweak, the following change seems
to sightly improve speed without reducing diffusion.  (It now looks a
bit more like the Skein mix() function.)

I'll look for more even more efficient kernels.  It appears that the
inital XOR is costing a lot; 8 memory fetches take a while.  Spacing that
out a bit would help, but it having input partway through the round ends
up requiring a major surgery to my avalanche-measuring code.

These rotation constants aren't final, but tweaking them shouldn't affect
the speed.

IMHO *one* pass of this is as good as the current fast_mix, and two
are considerably better.  Three achieve almost complete avalanche,
but aren't really necessary.

Since the pass is made of two identical halves, half-passes are also
possible.  Either using only 2 rotate constants, or by unrolling
the last half-pass.

// (29/66353) score = 49/121/123:  6 27 16 14

 		a += b;			c += d;
+		b = rol32(a, 6);	d = rol32(c, 27);
 		d ^= a;			b ^= c;
-		a = rol32(a, 15);	c = rol32(c, 21);

		a += b;			c += d;
+		b = rol32(a, 16);	d = rol32(c, 14);
		d ^= a;			b ^= c;
-		a = rol32(a, 3);	c = rol32(c, 7);


Of course, using wider words works fantastically.
These constants give 76 bits if avalanche after 2 rounds,
essentially full after 3:

extern void fast_mix2(struct fast_pool *f, __u32 const input[4])
{

	uint64_t a = ((uint64_t *)f->pool)[0] ^ ((uint64_t const *)input)[0];
	uint64_t b = ((uint64_t *)f->pool)[1] ^ ((uint64_t const *)input)[1];
	int i;

	for (i = 0; i < 3; i++) {
		a += b; b = rol64(b, 52);
		b ^= a; a = rol64(a, 10);
		a += b; b = rol64(b, 47);
		b ^= a; a = rol64(a, 17);
	}

	((uint64_t *)f->pool)[0] = a;
	((uint64_t *)f->pool)[1] = b;
	f->count++;
}

And it measures as faster than fast_mix even with 3 rounds:
# ./perftest ./ted64
fast_mix: 499   fast_mix2: 430
fast_mix: 431   fast_mix2: 430
fast_mix: 510   fast_mix2: 419
fast_mix: 430   fast_mix2: 419
fast_mix: 430   fast_mix2: 419
fast_mix: 431   fast_mix2: 419
fast_mix: 431   fast_mix2: 430
fast_mix: 510   fast_mix2: 419
fast_mix: 510   fast_mix2: 431
fast_mix: 510   fast_mix2: 430

And with 2 it's even faster.
(But so is fast_mix; there appears to be
significant timing instability here.)
# ./perftest ./ted64
fast_mix: 430   fast_mix2: 306
fast_mix: 431   fast_mix2: 306
fast_mix: 442   fast_mix2: 306
fast_mix: 442   fast_mix2: 306
fast_mix: 442   fast_mix2: 306
fast_mix: 442   fast_mix2: 363
fast_mix: 442   fast_mix2: 306
fast_mix: 442   fast_mix2: 329
fast_mix: 408   fast_mix2: 306
fast_mix: 442   fast_mix2: 329
