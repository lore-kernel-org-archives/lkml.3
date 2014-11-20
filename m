Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758166AbaKTVPz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 16:15:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34556 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758138AbaKTVPy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 16:15:54 -0500
Date: Thu, 20 Nov 2014 16:15:22 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, martin.petersen@oracle.com,
        hch@infradead.org, rusty@rustcorp.com.au, dm-devel@redhat.com
Subject: Re: virtio_blk: fix defaults for max_hw_sectors and max_segment_size
Message-ID: <20141120211521.GA846@redhat.com>
References: <20141120190058.GA31214@redhat.com>
 <20141120203044.GA9078@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141120203044.GA9078@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20 2014 at  3:30pm -0500,
Michael S. Tsirkin <mst@redhat.com> wrote:

> On Thu, Nov 20, 2014 at 02:00:59PM -0500, Mike Snitzer wrote:
> > virtio_blk incorrectly established -1U as the default for these
> > queue_limits.  Set these limits to sane default values to avoid crashing
> > the kernel.
...
> > Attempting to mkfs.xfs against a thin device from this thin-pool quickly
> > resulted in fs/direct-io.c:dio_send_cur_page()'s BUG_ON.
> 
> Why exactly does it BUG_ON?
> Did some memory allocation fail?

No idea, kernel log doesn't say.. all it has is "kernel BUG" pointing to
fs/direct-io.c:dio_send_cur_page()'s BUG_ON.

I could dig deeper on _why_ but honestly, there really isn't much point.
virtio-blk doesn't get to live in fantasy-land just because it happens
to think it is limitless.

> Will it still BUG_ON if host gives us high values?

Maybe, if/when virtio-blk allows the host to inject a value for
max_hw_sectors.  But my fix doesn't stack the host's limits up, it sets
a value that isn't prone to make the block/fs layers BUG.

> If linux makes assumptions about hardware limits, won't
> it be better to put them in blk core and not in
> individual drivers?

The individual block driver is meant to establish sane values for these
limits.

Block core _does_ have some sane wrappers for stacking these limits
(e.g. blk_stack_limits, etc).  All of those wrappers are meant to allow
for virtual drivers to build up limits that respect the underlying
hardware's limits.

But virtio-blk doesn't use any of them due to the virtio-blk driver
relying on the virtio-blk protocol to encapsulate each and every one of
them.

> > Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> > Cc: stable@vger.kernel.org
> > ---
> >  drivers/block/virtio_blk.c |    9 ++++++---
> >  1 files changed, 6 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
> > index c6a27d5..68efbdc 100644
> > --- a/drivers/block/virtio_blk.c
> > +++ b/drivers/block/virtio_blk.c
> > @@ -674,8 +674,11 @@ static int virtblk_probe(struct virtio_device *vdev)
> >  	/* No need to bounce any requests */
> >  	blk_queue_bounce_limit(q, BLK_BOUNCE_ANY);
> >  
> > -	/* No real sector limit. */
> > -	blk_queue_max_hw_sectors(q, -1U);
> > +	/*
> > +	 * Limited by disk's max_hw_sectors in host, but
> > +	 * without that info establish a sane default.
> > +	 */
> > +	blk_queue_max_hw_sectors(q, BLK_DEF_MAX_SECTORS);
> 
> I see
> drivers/usb/storage/scsiglue.c: blk_queue_max_hw_sectors(sdev->request_queue, 0x7FFFFF);
> 
> so maybe we should go higher, and use INT_MAX too?

No, higher doesn't help _at all_ if the driver itself doesn't actually
take care to stack the underlying driver's limits.  Without limits
stacking (which virtio-blk doesn't really have) it is the lack of
reality-based default values that is _the_ problem that enduced this
BUG.

blk_stack_limits() does a lot of min_t(top, bottom), etc.  So you want
the default "top" of a stacking driver to be high enough so as not to
artificially limit the resulting stacked limit.  Which is why we have
things like blk_set_stacking_limits().  You'll note that
blk_set_stacking_limits() properly establishes UINT_MAX, etc.  BUT it is
"proper" purely because drivers that call it (e.g. DM) also make use of
the block layer's limits stacking functions (again,
e.g. blk_stack_limits).

> >  
> >  	/* Host can optionally specify maximum segment size and number of
> >  	 * segments. */
> > @@ -684,7 +687,7 @@ static int virtblk_probe(struct virtio_device *vdev)
> >  	if (!err)
> >  		blk_queue_max_segment_size(q, v);
> >  	else
> > -		blk_queue_max_segment_size(q, -1U);
> > +		blk_queue_max_segment_size(q, BLK_MAX_SEGMENT_SIZE);
> >  
> >  	/* Host can optionally specify the block size of the device */
> >  	err = virtio_cread_feature(vdev, VIRTIO_BLK_F_BLK_SIZE,
> 
> Here too, I see some drivers asking for more:
> drivers/block/mtip32xx/mtip32xx.c: blk_queue_max_segment_size(dd->queue, 0x400000);

Those drivers you listed could be equally broken..

For virtio-blk the issue is that the limits it establishes don't reflect
the underlying host's hardware capabilties.  This was a virtio-blk time
bomb waiting to go off.

And to be clear, I just fixed the blk_queue_max_segment_size(q, -1U);
because it is blatantly wrong when we've established
BLK_MAX_SEGMENT_SIZE.

The bug that was reported is purely due to max_hw_sectors being 2TB and
the established max_sectors being 1TB.
