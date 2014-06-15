Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751444AbaFONBS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 09:01:18 -0400
Received: from imap.thunk.org ([74.207.234.97]:39568 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751299AbaFONBO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 09:01:14 -0400
Date: Sun, 15 Jun 2014 09:01:08 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: George Spelvin <linux@horizon.com>
Cc: hpa@linux.intel.com, linux-kernel@vger.kernel.org, mingo@kernel.org,
        price@mit.edu
Subject: Re: random: Benchamrking fast_mix2
Message-ID: <20140615130108.GB2180@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	George Spelvin <linux@horizon.com>, hpa@linux.intel.com,
	linux-kernel@vger.kernel.org, mingo@kernel.org, price@mit.edu
References: <20140615011713.GK6447@thunk.org>
 <20140615065803.6175.qmail@ns.horizon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140615065803.6175.qmail@ns.horizon.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 15, 2014 at 02:58:03AM -0400, George Spelvin wrote:
> Actually, could you hold off merging that for a bit?  Or if you really
> want to, add a comment that the rotate constants are preliminary and
> will be further optimized.
> 
> I posted that as WIP, just as evidence that something with better
> avalanche could be as fast or faster, and I'd like to go back and do a
> careful re-check of the analysis software, then do an exhaustive search
> for good rotate constants (there are only 1M possibilities, after all).
> 
> I believe the basic structure is solid, and you appear to be persuaded
> too, but this is an area littered with embarrassing failures by
> cryptographic amateurs and I'd like to be *very* careful before attaching
> my S-o-b to it.

Keep in mind that we're using this *just* as a mixing function.  It's
not like we have to worry about things like a chosen plaintext attack
--- the attacker can't look at the output of /dev/random, force time
to go backwards, and then force the CPU counter to be one bit
different, run time forwards, and then compare the new output of
/dev/random and try to do some kind of differential cryptanalysis, for
example.  Or if they could, the ability to run time backwards could be
used in much more entertaining ways.  (See also the recent movie,
"Edge of Tomorrow" :-)

And given my quick tests, I'm convinced that it's better than what we
had before, which is why I decided to commit the code.  We can further
deltas from what we have, so long as each step forward is an
improvement.

That's not to say that more analysis wouldn't be a bad thing, but I
have some other things I need to attend to; if you come up with better
rotational values, let me know, and when I do have more time, I can
come back to trying to do a bit more work on this particular front.

> The one thing I notice is that your analyze() function is measuring
> something totally different than what I'm measuring.
> 
> Considering fast_mix as a 128->128 bit function (i.e. ignoring
> the input XOR), you appear to be considering
> popcount(input[] ^ output[]), and then *minimizing* over a
> variety of inputs.

Yes, part of this comes from my bias from the previous mixing
function.  Since we were using a modified LFSR, it had the property
that if you repeatedly mixed with the input array containing all
zeroes, we would iterate over every possible state in the pool, with
equal probability.  So the XOR of the input array simply jumped us to
a different point in the 2**N cycle of possible states, such that even
if there was a bias where (for example) only the bottom 3 bits in the
input array were significant, those three bits of uncertainty could
potentially affect any bit in the entropy pool --- as opposed to only
twiddling the bottom three bits in the pool in the absence of having
the mixing function.

Anyway, for the purposes of the fast_mix, it's quite possible that
simply using the input_rotate and discarding everything else would
have been sufficient.  There was a bit of overdesign even at the
beginning.

Cheers,

						- Ted
