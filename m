Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751119AbaFOAXh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 20:23:37 -0400
Received: from ns.horizon.com ([71.41.210.147]:22811 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750861AbaFOAXg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 20:23:36 -0400
Date: 14 Jun 2014 20:23:33 -0400
Message-ID: <20140615002333.24750.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux@horizon.com, tytso@mit.edu
Subject: Re: random: Benchamrking fast_mix2
Cc: hpa@linux.intel.com, linux-kernel@vger.kernel.org, mingo@kernel.org,
        price@mit.edu
In-Reply-To: <20140614163334.GJ6447@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'll need to do a bit more looking to convince myself that 2
> iterations is better from a mixing perspective, but this looks like it
> might be a promising replacement for the 32-bit mixer.

This was tested with a hacked-up copy of Bob Jenkins' testing code.

It tests a few random starting values, and finds the minimum number of
outputs bits affected by an input delta for:

- Each input bit or pair of bits
- The function run forward or in reverse
- XOR, subtraction and addtion delta metrics.  (5x2 = 10 in total)

The example I posted:

// (29/66353) score = 49/121/123:  6 27 16 14

	a += b;			c += d;
	b = rol32(a, 6);	d = rol32(c, 27);
	d ^= a;			b ^= c;

	a += b;			c += d;
	b = rol32(a, 16);	d = rol32(c, 14);
	d ^= a;			b ^= c;

has, after 2 rounds, a minimum avalanche of 49 bits, taken over all of
the variables just mentioned.  The only thing maximized over is the
different starting values.

That seems adequate for something that's only being asked to preserve
1 bit of entropy.

(BTW, the way the deltas are defined, the maximum possibe score is 124.)
