Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626Ab3D1KKm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Apr 2013 06:10:42 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:44655 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372Ab3D1KKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Apr 2013 06:10:40 -0400
Date: Sun, 28 Apr 2013 18:10:27 +0800
From: Shaohua Li <shli@kernel.org>
To: Markus <M4rkusXXL@web.de>
Cc: lkml <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
Subject: Re: hybrid raid1 with trim support [REGRESSION]
Message-ID: <20130428101027.GA1753@kernel.org>
References: <3387108.NX1Tlx8b5x@f209>
 <20130428005446.GA20018@kernel.org>
 <20130428010016.GA26411@kernel.org>
 <2069465.HvIQbCn58p@f209>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2069465.HvIQbCn58p@f209>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 28, 2013 at 11:40:42AM +0200, Markus wrote:
> Hi!
> 
> Thanks for your work. The patch seems to work for me on a vanilla 3.8.10, at 
> least the hdds are no longer dropped from the raid.
> The code now ignores some request? What was the reason the disks fell off the 
> raid? The discards are still passed to the ssd?
Thanks for testing, I'll send to Neil soon.

Yes, the discard will still be passed to SSD, we just ignore the request for harddisk.

Thanks,
Shaohua
 
> Thanks,
> Markus
> 
> 
> Shaohua Li schrieb am 28.04.2013:
> > On Sun, Apr 28, 2013 at 08:54:46AM +0800, Shaohua Li wrote:
> > > On Sat, Apr 27, 2013 at 06:29:49PM +0200, Markus wrote:
> > > > Hi!
> > > > 
> > > > Now I had the time to bisect, started with 3.7 as good and 3.8 as bad.
> > > > 0cfbcafcae8b7364b5fa96c2b26ccde7a3a296a9 is the bad commit. [1]
> > > > block: add plug for blkdev_issue_discard
> > > > 
> > > > While 3.8.10 was still bad, the same kernel with the reverted patch 
> applied is fine.
> > > Thanks for the reporting. Does below patch work for you?
> > Oops, there is a typo there, should be this one:
> > 
> > ---
> >  drivers/md/raid1.c  |    7 ++++++-
> >  drivers/md/raid10.c |    7 ++++++-
> >  2 files changed, 12 insertions(+), 2 deletions(-)
> > 
> > Index: linux/drivers/md/raid1.c
> > ===================================================================
> > --- linux.orig/drivers/md/raid1.c	2013-03-07 14:14:05.950824173 +0800
> > +++ linux/drivers/md/raid1.c	2013-04-28 08:57:17.874058434 +0800
> > @@ -981,7 +981,12 @@ static void raid1_unplug(struct blk_plug
> >  	while (bio) { /* submit pending writes */
> >  		struct bio *next = bio->bi_next;
> >  		bio->bi_next = NULL;
> > -		generic_make_request(bio);
> > +		if (unlikely((bio->bi_rw & REQ_DISCARD) &&
> > +		    !blk_queue_discard(bdev_get_queue(bio->bi_bdev))))
> > +			/* Just ignore it */
> > +			bio_endio(bio, 0);
> > +		else
> > +			generic_make_request(bio);
> >  		bio = next;
> >  	}
> >  	kfree(plug);
> > Index: linux/drivers/md/raid10.c
> > ===================================================================
> > --- linux.orig/drivers/md/raid10.c	2013-03-07 14:14:05.950824173 +0800
> > +++ linux/drivers/md/raid10.c	2013-04-28 08:57:44.765719067 +0800
> > @@ -1133,7 +1133,12 @@ static void raid10_unplug(struct blk_plu
> >  	while (bio) { /* submit pending writes */
> >  		struct bio *next = bio->bi_next;
> >  		bio->bi_next = NULL;
> > -		generic_make_request(bio);
> > +		if (unlikely((bio->bi_rw & REQ_DISCARD) &&
> > +		    !blk_queue_discard(bdev_get_queue(bio->bi_bdev))))
> > +			/* Just ignore it */
> > +			bio_endio(bio, 0);
> > +		else
> > +			generic_make_request(bio);
> >  		bio = next;
> >  	}
> >  	kfree(plug);
