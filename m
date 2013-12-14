Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752392Ab3LNJGN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 04:06:13 -0500
Received: from science.horizon.com ([71.41.210.146]:15300 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752040Ab3LNJGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 04:06:09 -0500
Date: 14 Dec 2013 04:06:07 -0500
Message-ID: <20131214090607.30797.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: tytso@mit.edu
Subject: Replace /dev/random input mix polynomial with Brent's xorgen?
Cc: linux@horizon.com, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Brent extended some efficient XOR-based PRNGs designed by George
Marsaglia into a family of "xorgen" generators which are efficent,
non-sparse, maximal-period polynomials of length 64, 128, 256,... 4096
bits.

(It ends there because proving period 2^n-1 requires knowing the
factorization of 2^n-1, and 2^8192-1 = (2^4096+1)*(2^2048+1)*...*(2^1+1).
The factorization of 2^4096+1 = F_12 is currently stuck on an 1133-digit
composite residue; see http://caramel.loria.fr/f12.txt)

http://maths-people.anu.edu.au/~brent/pub/pub224.html
"Some long-period random number generators using shifts and xors",

Related background papers:
http://www.jstatsoft.org/v08/i14/paper
"Xorshift RNGs"
http://maths-people.anu.edu.au/~brent/pub/pub218.html
"Note on Marsaglia's xorshift RNGs"

Anyway, the algorithm boils down to

t1 = x[i-r];	t2 = x[i-s];
t1 ^= t1 << a;	t2 ^= t2 << c;
t1 ^= t1 >> b;	t2 ^= t2 >> d;
x[i] = t1 ^ t2;

For various constants r = 2..128, s < r, and shifts a, b, c and d.
Both 32- and 64-bit versions are included.

This is both more efficient and (especually using 64-bit words) more
thorough than the current code, for sizes up to 4096 bits.  Although the
current code has tables for larger pools, everything larger than 32x128 =
4096 bits is currenty commented out and not used.

Would you be interested in a patch to revise _mix_pool_bytes()?

I'm also thinking of revising the input rotate-by-7 to use
Marsaglia's original xorshift as a whitener.
