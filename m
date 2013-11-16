Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559Ab3KPAdi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 19:33:38 -0500
Received: from imap.thunk.org ([74.207.234.97]:58897 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751456Ab3KPAdb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 19:33:31 -0500
Date: Fri, 15 Nov 2013 19:33:24 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: /dev/random changes for 3.13
Message-ID: <20131116003324.GC16722@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20131114020332.GA10961@thunk.org>
 <20131114065212.GA13618@thunk.org>
 <CA+55aFyyENCDErpcYGcy4qf2M8mBtRo_9_nT0HaUPuY+kozk7g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyyENCDErpcYGcy4qf2M8mBtRo_9_nT0HaUPuY+kozk7g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 15, 2013 at 01:58:05PM -0800, Linus Torvalds wrote:
> Ok, I finally got around to the random tree, but your proposed merge
> resolution makes no sense, so I didn't end up applying it.
> 
> > - -     r->entropy_total += nbits;
> >         if (!r->initialized && nbits > 0) {
> > +               r->entropy_total += nbits;
> 
> This part undoes your commit 6265e169cd31 ("random: push extra entropy
> to the output pools"), and the "entropy_total" field will now never be
> non-zero when "r->initialized" is set....

You're right, I totally screwed that up.  Part of the problem is that
I should have cleaned up the if statement in commit 6265e169cd31 so
that it looked like this:

        r->entropy_total += nbits;
        if (!r->initialized && (r->entropy_total > 128)) {
                        r->initialized = 1;
                        r->entropy_total = 0;
                }
        }

... and so at the top of the dev branch, it should have looked like
this:

        r->entropy_total += nbits;
        if (!r->initialized && (r->entropy_total > 128)) {
		if (r == &nonblocking_pool)
			pr_notice("random: %s pool is initialized\n", r->name);
		r->initialized = 1;
		r->entropy_total = 0;
        }

Instead, I had a more complicated structure which confused me when I
cleaned up the merge.

So I'm going to propose the following merge resolution:

diff --cc drivers/char/random.c
index cdf4cfb,4fe5609..0000000
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@@ -654,14 -601,12 +654,13 @@@ retry
  	if (cmpxchg(&r->entropy_count, orig, entropy_count) != orig)
  		goto retry;
  
 -	if (!r->initialized && nbits > 0) {
 -		r->entropy_total += nbits;
 -		if (r->entropy_total > 128) {
 -			r->initialized = 1;
 -			if (r == &nonblocking_pool)
 -				prandom_reseed_late();
 +	r->entropy_total += nbits;
- 	if (!r->initialized && nbits > 0) {
- 		if (r->entropy_total > 128) {
- 			if (r == &nonblocking_pool)
- 				pr_notice("random: %s pool is initialized\n",
- 					  r->name);
- 			r->initialized = 1;
- 			r->entropy_total = 0;
++	if (!r->initialized && (r->entropy_total > 128)) {
++		r->initialized = 1;
++		r->entropy_total = 0;
++		if (r == &nonblocking_pool) {
++			prandom_reseed_late();
++			pr_notice("random: %s pool is initialized\n", r->name);
  		}
  	}

It does fold a cleanup in with the merge resolution, but it's not
actually changing anything in terms of code behavior, and it makes the
resulting merge much more obvious.

Are you OK with that?

						- Ted
