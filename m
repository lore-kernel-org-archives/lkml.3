Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154AbaANAPS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 19:15:18 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:53392 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098AbaANAPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 19:15:14 -0500
X-AuditID: 9c930179-b7c5fae000006619-27-52d48190366e
Date: Tue, 14 Jan 2014 09:15:55 +0900
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Nitin Gupta <ngupta@vflare.org>,
        Jerome Marchand <jmarchan@redhat.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH 1/7] zram: fix race between reset and flushing pending
 work
Message-ID: <20140114001555.GV1992@bbox>
References: <1389611942-15544-1-git-send-email-minchan@kernel.org>
 <1389611942-15544-2-git-send-email-minchan@kernel.org>
 <20140113155527.5731d24ca86f01bfd5ec716f@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140113155527.5731d24ca86f01bfd5ec716f@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 13, 2014 at 03:55:27PM -0800, Andrew Morton wrote:
> On Mon, 13 Jan 2014 20:18:56 +0900 Minchan Kim <minchan@kernel.org> wrote:
> 
> > Dan and Sergey reported that there is a racy between reset and
> > flushing of pending work so that it could make oops by freeing
> > zram->meta in reset while zram_slot_free can access zram->meta
> > if new request is adding during the race window.
> > 
> > This patch moves flush after taking init_lock so it prevents
> > new request so that it closes the race.
> > 
> > ..
> >
> > --- a/drivers/block/zram/zram_drv.c
> > +++ b/drivers/block/zram/zram_drv.c
> > @@ -553,14 +553,14 @@ static void zram_reset_device(struct zram *zram, bool reset_capacity)
> >  	size_t index;
> >  	struct zram_meta *meta;
> >  
> > -	flush_work(&zram->free_work);
> > -
> >  	down_write(&zram->init_lock);
> >  	if (!zram->init_done) {
> >  		up_write(&zram->init_lock);
> >  		return;
> >  	}
> >  
> > +	flush_work(&zram->free_work);
> > +
> >  	meta = zram->meta;
> >  	zram->init_done = 0;
> 
> This makes zram.lock nest inside zram.init_lock, which afaict is new
> behaviour.

Originally, it was nested so it's not new. :)
Look at zram_make_request which hold init_lock and then zram_bvec_rw
hold zram->lock.

> 
> That all seems OK and logical - has it been well tested with lockdep?

Yeb.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Kind regards,
Minchan Kim
