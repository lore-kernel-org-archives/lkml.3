Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735AbaBJKcf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 05:32:35 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:44008 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166AbaBJKcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 05:32:18 -0500
Date: Mon, 10 Feb 2014 02:32:11 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: Kent Overstreet <kmo@daterainc.com>, Jens Axboe <axboe@kernel.dk>,
        Shaohua Li <shli@kernel.org>, linux-kernel@vger.kernel.org,
        hch@infradead.org
Subject: Re: [patch 1/2]percpu_ida: fix a live lock
Message-ID: <20140210103211.GA28396@infradead.org>
References: <20131231033827.GA31994@kernel.org>
 <20140104210804.GA24199@kmo-pixel>
 <20140105131300.GB4186@kernel.org>
 <20140106204641.GB9037@kmo>
 <52CB1783.4050205@kernel.dk>
 <20140106214726.GD9037@kmo>
 <20140209155006.GA16149@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140209155006.GA16149@dhcp-26-207.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 09, 2014 at 04:50:07PM +0100, Alexander Gordeev wrote:
> Yeah, that was my first thought when I posted "percpu_ida: Allow variable
> maximum number of cached tags" patch some few months ago. But I am back-
> pedalling as it does not appear solves the fundamental problem - what is the
> best threshold?
> 
> May be we can walk off with a per-cpu timeout that flushes batch nr of tags
> from local caches to the pool? Each local allocation would restart the timer,
> but once allocation requests stopped coming on a CPU the tags would not gather
> dust in local caches.

We'll defintively need a fix to be able to allow the whole tag space.
For large numbers of tags per device the flush might work, but for
devices with low number of tags we need something more efficient.  The
case of less tags than CPUs isn't that unusual either and we probably
want to switch to an allocator without per cpu allocations for them to
avoid all this.  E.g. for many ATA devices we just have a single tag,
and many scsi drivers also only want single digit outstanding commands
per LUN.
