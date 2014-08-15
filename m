Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751493AbaHOVxN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 17:53:13 -0400
Received: from ns.horizon.com ([71.41.210.147]:39341 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750763AbaHOVxM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 17:53:12 -0400
Date: 15 Aug 2014 17:53:10 -0400
Message-ID: <20140815215310.10847.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: peterz@infradead.org, zhaoxiu.zeng@gmail.com
Subject: Re: [PATCH 1/1] GCD: add binary GCD algorithm
Cc: akpm@linux-foundation.org, dhowells@redhat.com, jwboyer@redhat.com,
        linux-kernel@vger.kernel.org, linux@horizon.com, mingo@kernel.org,
        takahiro.akashi@linaro.org
In-Reply-To: <53EE3826.2040000@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's a variant using the even-odd speedup:
(Feel free to add my S-o-b if you use it.)

/*
 * This implements Brent & Kung's "even-odd" variant of the binary GCD
 * algorithm.  (Often attributed to Stein, but as Knith has noted, appears
 * a first-century Chinese math text.)
 * 
 * First, find the common powers of 2 from a and b.  Here, they are not
 * divided by that common power, but rather we form a bitmap r which
 * covers the least-significant bit set in either.
 * Let s = (r+1)/2 be the common factor of 2.
 *
 * Then, shift down both a and b until both are odd multiples of s.
 * Assuming a > b, then gcd(a, b) = gcd(a-b, b).  But a-b is an even
 * multiple of s and we can divide it by two at least once.
 *
 * Further, either a-b or a+b is a multiple of 4s, so by choosing between
 * the two we can divde by 4.  This is done by (in the case that a > b):
 * 1. Compute (a - b) / 2
 * 2. If this is an odd multiple of s (AND with r is non-zero), then
 *    add b to make an even multiiple of s.  (This cannot overflow,
 *    as it equals (a + b) / 2, which must be less than max(a, b).)
 * 3. Divide by 2 one or more more times until we are left with an odd
 *    multiple of r.
 * 4. The result replaces a, and we go back to finding the larger.
 *
 * While the algorothm is equally correct without step2 and the first
 * divide by 2, the benefit of adding it it can be evaluated with a CMOV
 * rather than a full conditional branch.
 */
unsigned long bgcd2(unsigned long a, unsigned long b)
{
	unsigned long r = a | b;	/* To find common powers of 2 */

	if (!a || !b)
		return r;

	r ^= r-1;	/* Only the msbit of r (r/2 + 1) really matters */

	if (!(a & r))
		goto a_even;
	if (!(b & r))
		goto b_even;

	while (a != b) {
		/* (a & r) == (b & r) == (r >> 1) != 0 */
		if (a > b) {
			a = (a - b) >> 1;
			if (a & r)
				a += b;
a_even:                 do
				a >>= 1;
			while (!(a & r));
		} else {
			b = (b - a) >> 1;
			if (b & r)
				b += a;
b_even:                 do
				b >>= 1;
			while (!(b & r));
		}
	}
	return b;
}
