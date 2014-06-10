Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690AbaFJPZy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 11:25:54 -0400
Received: from imap.thunk.org ([74.207.234.97]:59632 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751017AbaFJPZw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 11:25:52 -0400
Date: Tue, 10 Jun 2014 11:25:41 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: George Spelvin <linux@horizon.com>
Cc: hpa@linux.intel.com, linux-kernel@vger.kernel.org, mingo@kernel.org,
        price@mit.edu
Subject: Re: drivers/char/random.c: more ruminations
Message-ID: <20140610152541.GA12104@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	George Spelvin <linux@horizon.com>, hpa@linux.intel.com,
	linux-kernel@vger.kernel.org, mingo@kernel.org, price@mit.edu
References: <20140610012036.GA8092@thunk.org>
 <20140610031017.9893.qmail@ns.horizon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140610031017.9893.qmail@ns.horizon.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 09, 2014 at 11:10:17PM -0400, George Spelvin wrote:
> 
> Extract_entropy() itself contains a call to xfer_secondary_pool, but
> that is a no-op in the case I'm considering (when it's called from
> _xfer_secondary_pool) because in that case, r is the the input_pool,
> which doesn't have an r->pull pool.
> 
> The number of bytes transferred is adjusted by account(), but
> it's only adjusted downward.  (If it were adjusted up, that would be
> a buffer overrun.)

It's the adjustment downward which is what gives us the catastrophic
reseeding --- specifically, it's adjusting the number of bytes down to
zero until we can transfer enough entropy to make it intractable for
the adversary to test the 2**N possible pool states that might
correspond to the observed /dev/random output.

In general, this is how to mitigate a state compromise scenario; it's
to delay reseeding until there we have confidence that there is enough
entropy built up that the bad guys can't maintain their model of the
entropy pool state by observing some or all of the RNG output.
Adjusting the bytes down to zero is basically a way of delaying
reseeding.

As far as the FIPS wankery is considered, *all* of FIPS is wankery,
and most serious practitioners believe that the FIPS requirements have
net been actively negative for overall security.  ("Do not touch a
line of this file, including the comments, else it will cost us
hundreds of thousands of dollars in recertification fees" -- Apple, in
their SSL library code where the "goto fail" bug was found.)

The only reason why the FIPS code is there is because apparently it's
necessary for those foolish US government customers who require FIPS
certification of OpenSSL, and apparently since /dev/random is an input
to OpenSSL.  (It was also added while Matt Mackall was the maintainer;
I'm not entirely certain I would have accepted it, because I think
FIPS is actively harmful; OTOH, I was working for IBM at the time, and
IBM does make money from selling to silly customers who require FIPS,
so maybe I would have.)

I suspect that the FIPS check is not necessary for intra-pool
transfers, but quite frankly, I can't be bothered to care about
improving the efficiency of systems put into FIPS mode.  And there is
a possibility that changing it might break the FIPS certification.
Not that I care either way, but I'm just not motiviated to verify that
any change to improve FIPS efficiency might not break security for the
use cases that I actually care about.  :-/


> If I play around with getting the entropy locking right, do you
> have a strong preference for the single-lock or two-lock design?
> I can't decide which to start with.
> 
> The latter is an extensive core code change, but I can easily convince
> myself there are no deadlock issues.  That's the one I described
> with separate adder and extractor locks and code paths, two "amount
> of entropy ever added" variables, ane one "amont of entropy ever removed".
> 
> The single-lock design is hopefully less code, but (to me, at least) less
> obviously deadlock-free.

Since as near as I can tell, there isn't really real performance issue
here, what's most important to me is that (a) the changes are easily
auditable, and (b) the resulting code is easily auditable and
Obviously Correct.

The null hypothesis that any change would have to compete against is
adding a trylock to add_interrupt_randomness(), since the change is
small, and obviously not going to make things worse.

If we can do better than that in terms of the "the commit is easy to
read/audit" and "the resulting code is easy to read/audit", then
great.  But otherwise, it seems that the "add a trylock" is the
simplest way to make things better.

Does that make sense?

					- Ted

