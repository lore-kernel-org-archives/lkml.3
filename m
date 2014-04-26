Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752651AbaDZXmN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 19:42:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60767 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751716AbaDZXmK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 19:42:10 -0400
Date: Sun, 27 Apr 2014 01:42:05 +0200
From: Mateusz Guzik <mguzik@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Lionel Debroux <lionel_debroux@yahoo.fr>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] drm: make variable named "refcount" atomic, like most
 refcounts in the kernel.
Message-ID: <20140426234204.GD17562@mguzik.redhat.com>
References: <248367.21250.bm@smtp144.mail.ir2.yahoo.com>
 <20140426170305.GA17562@mguzik.redhat.com>
 <535C128D.3070604@yahoo.fr>
 <20140426230056.GH18016@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140426230056.GH18016@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 27, 2014 at 12:00:56AM +0100, Al Viro wrote:
> (..)Non-atomic variant would be
> 	if (++*p < 0) {
> 		--*p;
> 		whine
> 		send SIGKILL to ourselves
> 	}
> which is nowhere near a sane mitigation in this case.  Much saner one would
> be (*IF* the overflow is, indeed, possible and if simple s/int/long/ wouldn't
> be a better fix) something along the lines of
> 	mutex_lock(&item->mutex);
> 	if (unlikely(item->refcount == INT_MAX)) {
> 		ret = -EINVAL;
> 		<maybe whine and/or raise SIGKILL>
> 		goto out_err;
> 	}
> 	<what we do there right now>
> 
> Mind you, I would be quite surprised if it turned out to be even
> theoretically possible to get that overflow here (judging by the look
> of callers, you'll run out of device numbers long before), but that's
> a separate story.
> 
> The point is, your "useful feature" is anything but, when applied without
> careful analysis of the situation; it's *not* a universal improvement.

I would argue even functions doing mere ptr->count++ and so on would be
useful.

For instance people who are fuzzing kernels looking for refcount
leaks/overupts could place low thresholds in these functions (along with
atomic ops) to increase chances that problems will manifest themselves.

(and this would help more people who report such problems)

The kernel locking itself up afterwards is not a problem for them.

That is provided there is enough hand-coded refcount code, if this would
be the only consumer (which will most likely never leak anyway) then this
is defnitely not worth it.

-- 
Mateusz Guzik
