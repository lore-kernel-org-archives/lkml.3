Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753112AbaFMPwt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 11:52:49 -0400
Received: from imap.thunk.org ([74.207.234.97]:37688 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753034AbaFMPwr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 11:52:47 -0400
Date: Fri, 13 Jun 2014 11:52:41 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: George Spelvin <linux@horizon.com>
Cc: hpa@linux.intel.com, linux-kernel@vger.kernel.org, mingo@kernel.org,
        price@mit.edu
Subject: Re: random: Benchamrking fast_mix2
Message-ID: <20140613155241.GA4265@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	George Spelvin <linux@horizon.com>, hpa@linux.intel.com,
	linux-kernel@vger.kernel.org, mingo@kernel.org, price@mit.edu
References: <20140612204622.GB3112@thunk.org>
 <20140613002304.17318.qmail@ns.horizon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140613002304.17318.qmail@ns.horizon.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2014 at 08:23:04PM -0400, George Spelvin wrote:
> Another cache we might be hitting is the branch predictor.  Could you try
> unrolling fast_mix2 and fast_mix4 and see what difference that makes?
> (I'd send you a patch but you could probably do it by hand faster than
> appying one.)

Unrolling doesn't make much difference; which isn't surprising given
that almost all of the differences go away when I commented out the
udelay().  Basically, at this point what we're primarily measuring is
how good various CPU's caches work, especially across context switches
where other code gets to run in between.

If that's the case, all else being equal, removing the extra memory
reference for twist_table[] does make sense, and something else I've
considered doing is to remove the input[] array entirely, and have
add_interrupt_randomness[] xor values directly into the pool, and then
let thast fast_mix function stir the pool.

It's harder to benchmark this, but at this point, I think we know
enough to be confident that this will be a win on at least some
platforms, and so long as it's not a massvie lose from what we had
before, I'll be fine with it.

I also think that it's going to be worthwhile to do the RDTSC
measurement in vitro, and calculate average and max latencies, since
it's clear that there are real limitations to userspace benchmarking.

Cheers,

						- Ted
