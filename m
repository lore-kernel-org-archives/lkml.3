Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933629AbaFINe4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 09:34:56 -0400
Received: from imap.thunk.org ([74.207.234.97]:57444 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932525AbaFINex (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 09:34:53 -0400
Date: Mon, 9 Jun 2014 09:34:48 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: George Spelvin <linux@horizon.com>
Cc: hpa@linux.intel.com, linux-kernel@vger.kernel.org, mingo@kernel.org,
        price@mit.edu
Subject: Re: [RFC PATCH] drivers/char/random.c: Is reducing locking range
 like this safe?
Message-ID: <20140609133448.GA8418@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	George Spelvin <linux@horizon.com>, hpa@linux.intel.com,
	linux-kernel@vger.kernel.org, mingo@kernel.org, price@mit.edu
References: <20140609021820.2038.qmail@ns.horizon.com>
 <20140609040355.8126.qmail@ns.horizon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140609040355.8126.qmail@ns.horizon.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 09, 2014 at 12:03:55AM -0400, George Spelvin wrote:
> 
> That seems... noticeable.  Causing iterrupt latency problems is defintiely
> a theoretical extrapolation, however.

Actually, if you look very closely, or take a look at the commit
description for 902c098a3663de, you'll see that we're actually
updating the entropy pool from add_interrupt_randomness() w/o taking
any locks.  So that's actually not a problem.

What could be a problem is if we get really unlucky (an interrupt
update happening at the same time as an update from rngd), it's
possible we could end up with an entropy addition getting lost.  It's
not such a big deal if a contribution from add_interrupt_randomness()
gets lost, since we only giving one bit worth of entropy credit.  But
it's possible than a much larger input from rngd could potentially end
up getting overwritten from the fast_pool contribution.

This isn't a disaster per se, but it probably means that it's worth
taking a closer look at how we do the entropy pool mixing input to see
if we can actually a make a fully lockless add_entropy work correctly.
One approach might be to use atomics but of course then we have to
balance the increased overhead of using atomic_t types versus the
locking overhead.

Cheers,

						- Ted
