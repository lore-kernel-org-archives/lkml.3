Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757883AbaGQWIY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 18:08:24 -0400
Received: from imap.thunk.org ([74.207.234.97]:41930 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752829AbaGQWIW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 18:08:22 -0400
Date: Thu, 17 Jul 2014 18:08:06 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH] random: limit the contribution of the hw rng to at most
 half
Message-ID: <20140717220806.GW1491@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org
References: <1405591436-15445-1-git-send-email-tytso@mit.edu>
 <53C80A6D.5010201@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53C80A6D.5010201@zytor.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 10:39:57AM -0700, H. Peter Anvin wrote:
> 
> I saw exactly one complaint to that nature, but that was from someone
> who really wanted the "nordrand" option (at which point I observed that
> it had inadvertently left RDSEED enabled which quickly got rectified.)
> The implication was that this was a request from a specific customer who
> presumably have their own "audited" hardware RNG.

There was another complaint more recently, that wasn't related to
nordrand.  And I was rather disturbed that in
add_interrupt_randomness() 97% of the entropy was coming from RDSEED.
I'm willing to have some of the entropy come from RDSEED by default,
but 97% seems to really way too much.

And the emergency refill code in random_read() was extremely
problematic.  First of all, we're dropping 512 bytes on the stack,
which is kind of bad, but hopefully all of the code paths which call
random_read() won't have a terribly deep stack.  Secondly, even after
the emergency refill, we block anyway.  Which is kind of OK, but what
it means is that we are pulling 512 bytes from RDSEED, and giving
credit for 2048 bits of entropy; but since we block until the next
contribution from interrupt randomness, that means we get 1 bit from
the entropy randomness, and 2048 bits of entropy from RDSEED --- which
means that from the standpoint of entropy accounting, 99.95%
(2048/2049) of the entropy is coming from RDSEED when reading from
/dev/random when its entropy pool is empty.

Remember, regardless of whether or not you believe (as a former head
of NSA's technology directorate recently claimed) that the DUAL-EC p
and q were generated using NSA's standard high-quality HW RNG system
which they use to generate all of their crypto variables, or (as the
NIST advisory panel has recently concluded) that it was highly likely
that DUAL-EC was backdoored, it's the optics that matter, because
those of us without top-drawer SI security clearances can't prove
things one way or another.

And when 99.95% of the entropy when reading large quantities of keying
material from /dev/random is coming from RDSEED, that just has
terrible, terrible optics....

						- Ted
