Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909AbaFJVUk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 17:20:40 -0400
Received: from imap.thunk.org ([74.207.234.97]:60413 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753143AbaFJVUi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 17:20:38 -0400
Date: Tue, 10 Jun 2014 17:20:32 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: George Spelvin <linux@horizon.com>
Cc: hpa@linux.intel.com, linux-kernel@vger.kernel.org, mingo@kernel.org,
        price@mit.edu
Subject: Re: drivers/char/random.c: more ruminations
Message-ID: <20140610212032.GG12104@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	George Spelvin <linux@horizon.com>, hpa@linux.intel.com,
	linux-kernel@vger.kernel.org, mingo@kernel.org, price@MIT.EDU
References: <20140610152541.GA12104@thunk.org>
 <20140610204028.14101.qmail@ns.horizon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140610204028.14101.qmail@ns.horizon.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2014 at 04:40:28PM -0400, George Spelvin wrote:
> 
> Look, maybe it's easier to see in the draft patch appended.
> I added a comment pointing out the catastrophic reseeding.

Yes, I see what you're trying to do.

What I'd suggest is that you do this in a series of small patches.
Each patch should solve one problem at a time, so it's easy to audit
each one.  For example, adding a trylock to add_interrupt_randomness()
should do that, and ***only*** that.  This fixes the case where
add_interrupt_randomness() races with RNDADDENTROPY's call to
write_pool().

Yes, there are other potential problems, especially relating to
whether we need to atomically update the entropy credit and the input
pool.  And actually, it doesn't matter, since we never try to extract
more than the input pool's has limit set to 1, and so we never extract
more entropy than the entropy counter.  So if we add the entropy, it's
impossible that it will get used before we update the entropy counter.

This is why changes should be separate commits, so we can review each
one of them separately.

Similarly, your comment about memset vs. explicit_bzero is a valid
one, but that's a problem that should be fixed in a separate commit.
And yes, that's a real problem --- I've confirmed this using gcc -S,
and it's not just a problem in drivers/char/random.c, but also in a
number of use cases under crypto/*.c.  But that's a problem that
should be fixed separately, and to be honest, I'd actually consider
this problem than some of the other issues we've talked about in this
thread.

This is also why I objected to your change to use the stale stack
contents for the input array.  That does something different from the
rest of the changes in the patch.  I'm sorry if keep harping on this,
but this is critically important.  It also means that we can accept
the small, obviously correct changes, while we discuss the larger,
more invasive changes.  It also makes it easier to backport the
smaller and more important changes to stable kernels.

> I don't care about the efficiency either; I just wanted to avoid the
> stack usage of a "u32 tmp[OUTPUT_POOL_WORDS]" when the actual extraction
> is done in EXTRACT_SIZE chunks anyhway.

Huh?  The FIPS wankery requires:

      __u8 tmp[10];

not

	u32 tmp[OUTPUT_POOL_WORDS];

and when you replace the former with the latter, but still try to move 

The xfer_seconary_pool code does use OUTPUT_POOL_WORDS*sizeof(32), but
only declare tmp as a 10-byte char array, it looks like you're end up
overflowing the stack (have you actually tested your draft patch?)

In any case, this is another reason why I really request people to
send a series of git commits, where each one is small, easy to read,
and Obviously Correct.

When you try to make multiple changes in a single commit, it makes
things harder to review, and that opens up "goto fail" sort of errors.
(Well, hopefully not because I spend a lot of time very carefully
scrutinizing patches, and if I don't have time, I won't apply the
patch until I do have time.  So put another way, if you want to
increase the likelihood that I'll process your patches quicktly, it's
to your advantage to keep each separate commit small and obviously
correct(tm).  Yes, this means that sometimes when you start making
changes, and run into other cleanups, you may need to use commands
like "git stash", create a separate commit that does just the
cleanup", and then "git stash pop" to resume work --- or use quilt or
guilt if that's more convenient for you, but small patches really,
REALLY, helps the review process.)

> > The null hypothesis that any change would have to compete against is
> > adding a trylock to add_interrupt_randomness(), since the change is
> > small, and obviously not going to make things worse.
> 
> Er, you seem to underestimate the changes.  It also involves moving the
> existing locks outward to encompass entropy accounting in many places in
> the code (after which the cmpxchg in credit_entropy is no longer needed
> and may be deleted).

Sure, but you can put the deletion of the cmpxchg and the out[] array
in separate commits, where the tree remains building and secure at
each step.

I generally have the biggest problems with academics who want modify
the random number generator, where they dump a several thousand line
diff on my porch, and then wonder why I don't just blindly apply it....

     	   	      	   	      - Ted
