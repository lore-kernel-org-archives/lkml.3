Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756071AbbAZR1J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 12:27:09 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:38755 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517AbbAZR1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 12:27:07 -0500
Date: Mon, 26 Jan 2015 09:27:06 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: David Herrmann <dh.herrmann@gmail.com>, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH RFC] loop: make partition scanning reliable
Message-ID: <20150126172706.GA15278@infradead.org>
References: <1422267319-8428-1-git-send-email-dh.herrmann@gmail.com>
 <20150126161328.GA21242@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150126161328.GA21242@htj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2015 at 11:13:28AM -0500, Tejun Heo wrote:
> > @@ -159,12 +159,15 @@ static int blkdev_reread_part(struct block_device *bdev)
> >  		return -EINVAL;
> >  	if (!capable(CAP_SYS_ADMIN))
> >  		return -EACCES;
> > -	if (!mutex_trylock(&bdev->bd_mutex))
> > +	if (!skipbusy)
> > +		mutex_lock(&bdev->bd_mutex);
> > +	else if (!mutex_trylock(&bdev->bd_mutex))
> >  		return -EBUSY;
> 
> Do we actually need the mutex_trylock() path?  Why can't we just
> always grab the mutex?

I wondered about this, too.  The trylock goes all the way back
to when Al first factored out the partition re-reading into common
code ("[PATCH] partition table flush/read cleanup" in the historic tree
converted from bk), and even before that most drivers used a weird
dev_lock_part() consruct operating on a kdev_t, wich looked like a
trylock.

Given that blkdev_reread_part is invoked directly from the ioctl method
without any additional locking it seems fairly pointless for the
case where it's issue from userspace.  In addition to that the loop
driver, nbd and dasd issue it from a driver, as does the root mounting
code for md.

I would be surprised if any of these callers needs it, but a careful
audit would be useful.

I'd also really prefer a patch that makes loop, nbd and dasd call
blkdev_reread_part directly instead of by ioctl_by_bdev as a first
stage preparation, followed by the locking changes  and the changes
to loop.c in separate patch so each does one thing and can be properly
documented.
