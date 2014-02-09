Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752106AbaBIPsm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 10:48:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8863 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751806AbaBIPsl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 10:48:41 -0500
Date: Sun, 9 Feb 2014 16:50:07 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: Kent Overstreet <kmo@daterainc.com>
Cc: Jens Axboe <axboe@kernel.dk>, Shaohua Li <shli@kernel.org>,
        linux-kernel@vger.kernel.org, hch@infradead.org
Subject: Re: [patch 1/2]percpu_ida: fix a live lock
Message-ID: <20140209155006.GA16149@dhcp-26-207.brq.redhat.com>
References: <20131231033827.GA31994@kernel.org>
 <20140104210804.GA24199@kmo-pixel>
 <20140105131300.GB4186@kernel.org>
 <20140106204641.GB9037@kmo>
 <52CB1783.4050205@kernel.dk>
 <20140106214726.GD9037@kmo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140106214726.GD9037@kmo>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 06, 2014 at 01:47:26PM -0800, Kent Overstreet wrote:
> Ok, so I hadn't really given any thought to that kind of use case; insofar as I
> had I would've been skeptical percpu tag allocation made sense for 32 different
> tags at all.
> 
> We really don't want to screw over the users that aren't so constrained by the
> size of their tag space; there really is a huge performance tradeoff here
> (otherwise you're stealing tags and bouncing cachelines for _every_ tag
> allocation when the queue is full, and your percpu tag allocation is no longer
> very percpu).
> 
> I'm not sure what the best strategy is for NCQ-type max nr_tags, though -
> thoughts?
> 
> Easy thing to do for now is just to add another parameter to percpu_ida_init()
> for the number of tags that are allowed to sit unused on other cpu's freelists -
> users that have large relatively unbounded nr_tags can set that to nr_tags / 2,
> for NCQ you'd set it to 0.
> 
> I suspect we can do better for NCQ though, w.r.t. worst case performance.

Yeah, that was my first thought when I posted "percpu_ida: Allow variable
maximum number of cached tags" patch some few months ago. But I am back-
pedalling as it does not appear solves the fundamental problem - what is the
best threshold?

May be we can walk off with a per-cpu timeout that flushes batch nr of tags
from local caches to the pool? Each local allocation would restart the timer,
but once allocation requests stopped coming on a CPU the tags would not gather
dust in local caches.

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
