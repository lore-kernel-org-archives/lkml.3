Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751865AbaIJOIK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 10:08:10 -0400
Received: from imap.thunk.org ([74.207.234.97]:48330 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751355AbaIJOII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 10:08:08 -0400
Date: Wed, 10 Sep 2014 10:07:59 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] mm/sl[aou]b: make kfree() aware of error pointers
Message-ID: <20140910140759.GC31903@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Jiri Kosina <jkosina@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Dan Carpenter <dan.carpenter@oracle.com>
References: <alpine.LNX.2.00.1409092319370.5523@pobox.suse.cz>
 <20140909162114.44b3e98cf925f125e84a8a06@linux-foundation.org>
 <alpine.LNX.2.00.1409100702190.5523@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1409100702190.5523@pobox.suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 07:05:40AM +0200, Jiri Kosina wrote:
> > kfree() is quite a hot path to which this will add overhead.  And we
> > have (as far as we know) no code which will actually use this at
> > present.
> 
> We obviously don't, as such code will be causing explosions. This is meant 
> as a prevention of problems such as the one that has just been fixed in 
> ext4.

These sorts of things can happen a lot, unfortunately.  We had a
number of bugs in ext4 where ext4 would explode if a GFP_NOFS kmalloc
would fail.  These bugs have been around for a long time, and
apparently *none* of the RHEL/SLES/OUL enterprise linux
certification/QA efforts found them.

I only found them when an a Google-internal-only patch introduced an
mm behavioural change that caused GFP_NOFS allocations to fail under
extreme memory pressure.  And that's exactly the sort of thing that
would cause disasgters when you might have some function such as:

	ptr = function_that_does_an_kmalloc(...)
	if (IS_ERR(ptr)) {
		ret = PTR_ERR(ptr);
		goto cleanup);
	}
	bh = function_that_does_a_getblk(...)
	if (IS_ERR(bh)) {
		ret = PTR_ERR(bh);
		goto cleanup);
	}
	....

cleanup:
	if (bh)
		brelse(bh);
	if (ptr)
		kfree(ptr);


Normally, kfree and bh would be allocated, and so kfree() and brelse()
does the right thing.  But if something changes that causes functions
that in practice, never returned an allocation failure, suddenly
*does* start failing, then you get an explosion.  And/or, previous to
recent mainline patches, the kernel might BUG, and/or declare the file
system corrupt, forcing an fsck --- and when *large* number of systems
get stuck in an fsck at the same time, it tends to distress the system
administrators, far worse than if the kernel had merely exploded.  :-/

So I wouldn't be so sure that we don't have these sorts of bugs hiding
somewhere; and it's extremely easy for them to sneak in.  That being
said, I'm not in favor of making changes to kfree; I'd much rather
depending on better testing and static checkers to fix them, since
kfree *is* a hot path.

Cheers,

					- Ted
