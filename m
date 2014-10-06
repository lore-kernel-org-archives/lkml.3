Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752385AbaJFMGd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 08:06:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35427 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752199AbaJFMGc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 08:06:32 -0400
Date: Mon, 6 Oct 2014 15:09:53 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 06/16] virtio_blk: drop config_enable
Message-ID: <20141006120953.GA26549@redhat.com>
References: <1412525038-15871-1-git-send-email-mst@redhat.com>
 <1412525038-15871-7-git-send-email-mst@redhat.com>
 <20141006134229.45465bf7.cornelia.huck@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141006134229.45465bf7.cornelia.huck@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 06, 2014 at 01:42:29PM +0200, Cornelia Huck wrote:
> On Sun, 5 Oct 2014 19:07:07 +0300
> "Michael S. Tsirkin" <mst@redhat.com> wrote:
> 
> > Now that virtio core ensures config changes don't
> > arrive during probing, drop config_enable flag
> > in virtio blk.
> > On removal, flush is now sufficient to guarantee that
> > no change work is queued.
> > 
> > This help simplify the driver, and will allow
> > setting DRIVER_OK earlier without losing config
> > change notifications.
> > 
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > ---
> >  drivers/block/virtio_blk.c | 19 ++-----------------
> >  1 file changed, 2 insertions(+), 17 deletions(-)
> > 
> > diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
> > index 0a58140..c8cf6a1 100644
> > --- a/drivers/block/virtio_blk.c
> > +++ b/drivers/block/virtio_blk.c
> 
> > @@ -772,9 +766,7 @@ static void virtblk_remove(struct virtio_device *vdev)
> >  	int refc;
> > 
> >  	/* Prevent config work handler from accessing the device. */
> 
> /* Common code ensures no further work will be queued. */
> 
> instead?

No, I think you missed the point:
this comment now refers to the flush below: flush is required to
ensure work handler is not running.

Agree?

> > -	mutex_lock(&vblk->config_lock);
> > -	vblk->config_enable = false;
> > -	mutex_unlock(&vblk->config_lock);
> > +	flush_work(&vblk->config_work);
> > 
> >  	del_gendisk(vblk->disk);
> >  	blk_cleanup_queue(vblk->disk->queue);
> 
> > @@ -806,10 +796,6 @@ static int virtblk_freeze(struct virtio_device *vdev)
> >  	vdev->config->reset(vdev);
> > 
> >  	/* Prevent config work handler from accessing the device. */
> 
> dito on the comment

Same here and in -net.
Pls confirm.

> > -	mutex_lock(&vblk->config_lock);
> > -	vblk->config_enable = false;
> > -	mutex_unlock(&vblk->config_lock);
> > -
> >  	flush_work(&vblk->config_work);
> > 
> >  	blk_mq_stop_hw_queues(vblk->disk->queue);
