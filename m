Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751360AbaB0VZP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 16:25:15 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:39544 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155AbaB0VZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 16:25:12 -0500
Date: Thu, 27 Feb 2014 13:27:15 -0800
From: Kent Overstreet <kmo@daterainc.com>
To: Matthew Wilcox <willy@linux.intel.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Neil Brown <neilb@suse.de>,
        Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com,
        Lars Ellenberg <drbd-dev@lists.linbit.com>, drbd-user@lists.linbit.com,
        Asai Thambi S P <asamymuthupa@micron.com>,
        Sam Bradshaw <sbradshaw@micron.com>, linux-nvme@lists.infradead.org,
        Jiri Kosina <jkosina@suse.cz>, Geoff Levand <geoff@infradead.org>,
        Jim Paris <jim@jtan.com>, Joshua Morris <josh.h.morris@us.ibm.com>,
        Philip Kelleher <pjk1939@linux.vnet.ibm.com>,
        Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Peng Tao <bergwolf@gmail.com>
Subject: Re: [PATCH 1/9] block: Make generic_make_request handle arbitrary
 sized bios
Message-ID: <20140227212715.GA2834@kmo-pixel>
References: <1393457997-17618-1-git-send-email-kmo@daterainc.com>
 <1393457997-17618-2-git-send-email-kmo@daterainc.com>
 <20140227172254.GI5744@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140227172254.GI5744@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 12:22:54PM -0500, Matthew Wilcox wrote:
> On Wed, Feb 26, 2014 at 03:39:49PM -0800, Kent Overstreet wrote:
> > We do this by adding calls to blk_queue_split() to the various
> > make_request functions that need it - a few can already handle arbitrary
> > size bios. Note that we add the call _after_ any call to blk_queue_bounce();
> > this means that blk_queue_split() and blk_recalc_rq_segments() don't need to
> > be concerned with bouncing affecting segment merging.
> 
> > diff --git a/drivers/block/nvme-core.c b/drivers/block/nvme-core.c
> > index 51824d1f23..e4376b9613 100644
> > --- a/drivers/block/nvme-core.c
> > +++ b/drivers/block/nvme-core.c
> > @@ -737,6 +737,8 @@ static void nvme_make_request(struct request_queue *q, struct bio *bio)
> >  	struct nvme_queue *nvmeq = get_nvmeq(ns->dev);
> >  	int result = -EBUSY;
> >  
> > +	blk_queue_split(q, &bio, q->bio_split);
> > +
> >  	if (!nvmeq) {
> >  		put_nvmeq(NULL);
> >  		bio_endio(bio, -EIO);
> 
> I'd suggest that we do:
> 
> -	struct nvme_queue *nvmeq = get_nvmeq(ns->dev);
> +	struct nvme_queue *nvmeq;
>  	int result = -EBUSY;
> 
> +	blk_queue_split(q, &bio, q->bio_split);
> +
> +	nvmeq = get_nvmeq(ns->dev);
>  	if (!nvmeq) {
> 
> so that we're running the blk_queue_split() code outside the get_cpu()
> call.

Whoops, that's definitely a bug.

> Now, the NVMe driver has its own rules about when BIOs have to be split.
> Right now, that's way down inside the nvme_map_bio() call when we're
> walking the bio to compose the scatterlist.  Should we instead have an
> nvme_bio_split() routine that is called instead of blk_queue_split(),
> and we can simplify nvme_map_bio() since it'll know that it's working
> with bios that don't have to be split.
> 
> In fact, I think it would have little NVMe-specific in it at that point,
> so we could name __blk_bios_map_sg() better, export it to drivers and
> call it from nvme_map_bio(), which I think would make everybody happier.

Yes, definitely - and by doing it there we shoudn't even have to split
the bios, we can just process them incrementally. I can write a patch
for it later if you want to test it.
