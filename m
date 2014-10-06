Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752552AbaJFMHI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 08:07:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58727 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752449AbaJFMHE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 08:07:04 -0400
Date: Mon, 6 Oct 2014 15:10:31 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 08/16] virtio_net: drop config_enable
Message-ID: <20141006121031.GB26549@redhat.com>
References: <1412525038-15871-1-git-send-email-mst@redhat.com>
 <1412525038-15871-9-git-send-email-mst@redhat.com>
 <20141006135036.77fea7de.cornelia.huck@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141006135036.77fea7de.cornelia.huck@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 06, 2014 at 01:50:36PM +0200, Cornelia Huck wrote:
> On Sun, 5 Oct 2014 19:07:13 +0300
> "Michael S. Tsirkin" <mst@redhat.com> wrote:
> 
> > Now that virtio core ensures config changes don't arrive during probing,
> > drop config_enable flag in virtio net.
> > On removal, flush is now sufficient to guarantee that no change work is
> > queued.
> > 
> > This help simplify the driver, and will allow setting DRIVER_OK earlier
> > without losing config change notifications.
> > 
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > ---
> >  drivers/net/virtio_net.c | 23 ++---------------------
> >  1 file changed, 2 insertions(+), 21 deletions(-)
> > 
> > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > index 59caa06..fa17afa 100644
> > --- a/drivers/net/virtio_net.c
> > +++ b/drivers/net/virtio_net.c
> 
> > @@ -1876,16 +1869,12 @@ static void virtnet_remove(struct virtio_device *vdev)
> >  	unregister_hotcpu_notifier(&vi->nb);
> > 
> >  	/* Prevent config work handler from accessing the device. */
> 
> Same comment as for the equivalent comment in the virtio-blk code.

Same answer :)

> > -	mutex_lock(&vi->config_lock);
> > -	vi->config_enable = false;
> > -	mutex_unlock(&vi->config_lock);
> > +	flush_work(&vi->config_work);
> > 
> >  	unregister_netdev(vi->dev);
> > 
> >  	remove_vq_common(vi);
> > 
> > -	flush_work(&vi->config_work);
> > -
> >  	free_percpu(vi->stats);
> >  	free_netdev(vi->dev);
> >  }
> > @@ -1899,9 +1888,7 @@ static int virtnet_freeze(struct virtio_device *vdev)
> >  	unregister_hotcpu_notifier(&vi->nb);
> > 
> >  	/* Prevent config work handler from accessing the device */
> 
> dito

Same here.

> > -	mutex_lock(&vi->config_lock);
> > -	vi->config_enable = false;
> > -	mutex_unlock(&vi->config_lock);
> > +	flush_work(&vi->config_work);
> > 
> >  	netif_device_detach(vi->dev);
> >  	cancel_delayed_work_sync(&vi->refill);
