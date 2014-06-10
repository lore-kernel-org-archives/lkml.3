Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933821AbaFJDKU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 23:10:20 -0400
Received: from ns.horizon.com ([71.41.210.147]:62854 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932844AbaFJDKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 23:10:19 -0400
Date: 9 Jun 2014 23:10:17 -0400
Message-ID: <20140610031017.9893.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux@horizon.com, tytso@mit.edu
Subject: Re: drivers/char/random.c: more ruminations
Cc: hpa@linux.intel.com, linux-kernel@vger.kernel.org, mingo@kernel.org,
        price@mit.edu
In-Reply-To: <20140610012036.GA8092@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> I have an idea for a patch to change _xfer_secondary_pool
>> to use extract_buf rather than extract_entropy; is all that
>> FIPS stuff needed for purely internal transfers?

> That's not the part of extract_entropy() which is critical.  What's
> critical is the control over only transfering entropy when there is at
> least a certain minimum amount of entropy.  This provides the
> Yarrow-like avalanche property which is required to provide recovery
> after the internal state of the entropy pools have been exposed.

I do understand the importance of catastrophic reseeding, but
I don't see that implemented in extract_entropy().

Extract_entropy() itself contains a call to xfer_secondary_pool, but
that is a no-op in the case I'm considering (when it's called from
_xfer_secondary_pool) because in that case, r is the the input_pool,
which doesn't have an r->pull pool.

The number of bytes transferred is adjusted by account(), but
it's only adjusted downward.  (If it were adjusted up, that would be
a buffer overrun.)

Normal reads seem to ask for a reseed equal in size to read itself,
which is "ctastrophic" enough.

The only *minimum* reseed transfer size I can see is enforced in
_xfer_secondary_pool and push_to_pool, which use random_read_wakeup_bits
(default 64) as a minimum reseed.  (Prehaps increase this?)
standards, IMHO.)


Now, having said all that, I'll try to avoid embarrassing myself
in public again and ask... what am I missing?



On other matters...

If I play around with getting the entropy locking right, do you
have a strong preference for the single-lock or two-lock design?
I can't decide which to start with.

The latter is an extensive core code change, but I can easily convince
myself there are no deadlock issues.  That's the one I described
with separate adder and extractor locks and code paths, two "amount
of entropy ever added" variables, ane one "amont of entropy ever removed".

The single-lock design is hopefully less code, but (to me, at least) less
obviously deadlock-free.
