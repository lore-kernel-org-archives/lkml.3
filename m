Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174Ab3LNTbj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 14:31:39 -0500
Received: from imap.thunk.org ([74.207.234.97]:40022 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753917Ab3LNTbZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 14:31:25 -0500
Date: Sat, 14 Dec 2013 14:23:07 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: George Spelvin <linux@horizon.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Replace /dev/random input mix polynomial with Brent's xorgen?
Message-ID: <20131214192307.GA10457@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	George Spelvin <linux@horizon.com>, linux-kernel@vger.kernel.org
References: <20131214090607.30797.qmail@science.horizon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131214090607.30797.qmail@science.horizon.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 14, 2013 at 04:06:07AM -0500, George Spelvin wrote:
> Richard Brent extended some efficient XOR-based PRNGs designed by George
> Marsaglia into a family of "xorgen" generators which are efficent,
> non-sparse, maximal-period polynomials of length 64, 128, 256,... 4096
> bits.
> 
> Anyway, the algorithm boils down to
> 
> t1 = x[i-r];	t2 = x[i-s];
> t1 ^= t1 << a;	t2 ^= t2 << c;
> t1 ^= t1 >> b;	t2 ^= t2 >> d;
> x[i] = t1 ^ t2;
> 
> For various constants r = 2..128, s < r, and shifts a, b, c and d.
> Both 32- and 64-bit versions are included.


The mixing function doesn't have to be a good quality PRNG, since
that's not its function.  One of the things that is highly desirable,
though, is that it "smears" recently mixed in data across the entire
pool as quickly as possible.  The above algorithm is more efficient
because it only needs to touch two memory locations --- but for our
use case, we want to be able to read from multiple memory locations.

In particular, it's important that when we mix the hash back into pool
to prevent backtracking attacks, and extract from the pool again and
re-hash (see extract_entropy), it's important that when we mix in the
hash, it affects the portion of the pool that we rehash.  We could
work around this if we changed the mixing function, true, but I'm not
sure I see the benefit of making this change.

I'm much more inclined to think about changing how we generate random
numbers from the output pool by switching from using SHA to AES in
some one-way random function mode (i.e., such as the Davies-Meyer
construction), since that is where we are spending most of our CPU
time in the random driver at the moment.

Regards,

						- Ted
