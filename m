Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752406Ab3LOIfD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 03:35:03 -0500
Received: from science.horizon.com ([71.41.210.146]:21864 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751110Ab3LOIfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 03:35:01 -0500
Date: 15 Dec 2013 03:34:59 -0500
Message-ID: <20131215083459.22068.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux@horizon.com, tytso@mit.edu
Subject: Re: Replace /dev/random input mix polynomial with Brent's xorgen?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20131215022147.GA24124@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Agreed, but that's we have the input_rotate.  Do you have analysis or
> arguments why we Richard Brent's construction would do a better job?
> 
> BTW, one other design requirement I had when desining the mixing
> function was if you fix in all zero's, the result was a reversible
> mixing of the bits; in other words, "dd if=/dev/zero of=/dev/random"
> is guaranteed to not lose any entropy caused by self-cancellation.

To address your second paragraph first: both the existing and Brent's
construction are linear feedback shift registers.  The only difference
is the polynomial.

Becuase it's a bijective function (a permutation), the input of any
fixed string to the pool is an invertible operation, and therefore cannot
lose entropy.  I agree that this property is essential, and it remains.

The difference is that currently the mxing is done using a word-wise
polynomial, followed by some ad-hoc bit mixing within the word using
the twist table.  Brent's design is more integrated and mixes all the
bits in a uniform manner.

It is, however, a relatively minor tweak, nothing fundamental.

> I'm not convinced we need to worry about cache timing attacks, since
> they typically involve a chosen plaintext attack and a fixed key ---
> and the attacker isn't going to know what we are going to be
> encrypting, let alone be able to chose the plaintext.

You're describing standard key-recovery attacks.  For /dev/random,
just knowing the *ciphertext* constitutes a successful attack.

In fact, even partial (a few bits of) knowledge about the ciphertext is
a violation of the intended security guarantee.

I haven't gone through a full analysis, but there are plenty of functions
available with fixed access patterns and timing, where the issue simply
Goes Away.  Why not use one?

> Even if that were not the case, see the paper, "Are AES x86 Cache Timing
> Attacks Still Feasible?":
>
>	http://cseweb.ucsd.edu/~hovav/dist/aes_cache.pdf

The paper's first point, that hardware support makes all this moot, is
of course true, and I agree it's difficult, but the rest is addressing
x86 running a web browser!

What about all the all the small routers, Raspberry Pis and the like
generating lots of session keys without a lot of UI code bloat?
And with simpler cache structures without hardware prefetchers and
other confounding factors.

And it seems to be making the point that a per-core L1 means that you
have to probe the L2.  But hyperthreading means that you can have
an attacking thread sharing L1 with the encryption.


The exact hash function is not critical, but it seems that there are
secure alternatives that are faster (Rijndael's key schedule is simple,
but when used as a hash, rekeying per block needs to be included), don't
need lookup tables (smaller minimum kernel!), and have fixed timing so I
don't need to even think about whether a cache timing attack is practical.

If hardware AES support changes those factors, then by all means use AES.
I just think the combination of all three factors militate against AES for
the standard software fallback.
