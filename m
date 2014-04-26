Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626AbaDZXBD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 19:01:03 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:36785 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461AbaDZXBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 19:01:00 -0400
Date: Sun, 27 Apr 2014 00:00:56 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Lionel Debroux <lionel_debroux@yahoo.fr>
Cc: Mateusz Guzik <mguzik@redhat.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] drm: make variable named "refcount" atomic, like most
 refcounts in the kernel.
Message-ID: <20140426230056.GH18016@ZenIV.linux.org.uk>
References: <248367.21250.bm@smtp144.mail.ir2.yahoo.com>
 <20140426170305.GA17562@mguzik.redhat.com>
 <535C128D.3070604@yahoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <535C128D.3070604@yahoo.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 26, 2014 at 10:09:49PM +0200, Lionel Debroux wrote:

> > I believe this change is in grsecurity so that overflow detector can
> > be used,
> That's my understanding as well.
> > there is clearly no reason to use mere atomic ops.
> Yeah, sorry. At least, you're stating it in a nice way.

Which clearly does not work either.

> > It may be that kernel devs would accept a patch implementing generic
> > refcount manipulation primitives without atomicity guarantees, which
> > could be used in cases like this.
> > 
> > Then atomic and non-atomic versions could be used to detect
> > overflows and overputs at least in debug kernels.
> That's a more constructive suggestion indeed, on a useful feature :)

	So more detailed explanation is in order.  Very well.

	You really need to find out what grsec changes in atomic_inc()
semantics.  Because semantics is changed, and simple "grsec folks say
it's an improvement" does *NOT* translate into "let's do that change
everywhere".  Non-atomic variant would be
	if (++*p < 0) {
		--*p;
		whine
		send SIGKILL to ourselves
	}
which is nowhere near a sane mitigation in this case.  Much saner one would
be (*IF* the overflow is, indeed, possible and if simple s/int/long/ wouldn't
be a better fix) something along the lines of
	mutex_lock(&item->mutex);
	if (unlikely(item->refcount == INT_MAX)) {
		ret = -EINVAL;
		<maybe whine and/or raise SIGKILL>
		goto out_err;
	}
	<what we do there right now>

Mind you, I would be quite surprised if it turned out to be even
theoretically possible to get that overflow here (judging by the look
of callers, you'll run out of device numbers long before), but that's
a separate story.

The point is, your "useful feature" is anything but, when applied without
careful analysis of the situation; it's *not* a universal improvement.
And I stand by the cargo cult comment; you've posted a patch that, aside of
being completely pointless from the atomicity point of view, had done
nothing whatsoever on the mainline kernel.  Moreover, even if we had that
kind of atomic_inc semantics, your change would at the very least require
some analysis of the surrounding code.  Which you have replaced with
"grsec folks had done it that way".  Great, and maybe they even had done
that review, but then you should've asked them to give it to you - or do it
yourself if you don't want to bother them.
