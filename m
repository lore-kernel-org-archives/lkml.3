Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932597AbaFJAVA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 20:21:00 -0400
Received: from ns.horizon.com ([71.41.210.147]:42334 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753727AbaFJAU7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 20:20:59 -0400
Date: 9 Jun 2014 20:20:57 -0400
Message-ID: <20140610002057.21845.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux@horizon.com, tytso@mit.edu
Subject: drivers/char/random.c: more ruminations
Cc: hpa@linux.intel.com, linux-kernel@vger.kernel.org, mingo@kernel.org,
        price@mit.edu
In-Reply-To: <20140609155046.GA8993@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My original reason for writing turned into a never mind...

I came up with a clever and intricate algorithm for preventing
a bulk writer from DoSing add_interrupt_randomness via the proposed
additional locking on the input_pool.

Then I re-checked the code and saw that only the (trusted) RNDADDENTROPY
call is allowed to write to the input_pool.  A plain write(2) is copied
to the two output pools.

And writing to the input_pool can never try to take a lock on an
output pool; spilling is done in a workqueue.


I'm getting to a dangerous place: I think I'm starting to understand this.
I should probably turn that into a doc patch.


I have an idea for a patch to change _xfer_secondary_pool
to use extract_buf rather than extract_entropy; is all that
FIPS stuff needed for purely internal transfers?


Also, shouldn't the r->last_pulled holdoff in xfer_secondary_pool be
really limited to actual transfers?  I.e. reorder the conditions as:

static void xfer_secondary_pool(struct entropy_store *r, size_t nbytes)
{
	if (!r->pull ||
	    r->entropy_count >= (nbytes << (ENTROPY_SHIFT + 3)) ||
	    r->entropy_count >= r->poolinfo->poolfracbits)
		return;

	if (r->limit == 0 && random_min_urandom_seed) {
		unsigned long now = jiffies;

		if (time_before(now,
				r->last_pulled + random_min_urandom_seed * HZ))
			return;
		r->last_pulled = now;
	}
	_xfer_secondary_pool(r, nbytes);
}
