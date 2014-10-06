Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752452AbaJFL4n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 07:56:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21220 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752175AbaJFL4l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 07:56:41 -0400
Date: Mon, 6 Oct 2014 15:00:07 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 05/16] virtio: defer config changed notifications
Message-ID: <20141006120007.GA26328@redhat.com>
References: <1412525038-15871-1-git-send-email-mst@redhat.com>
 <1412525038-15871-6-git-send-email-mst@redhat.com>
 <20141006133338.236a1175.cornelia.huck@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141006133338.236a1175.cornelia.huck@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 06, 2014 at 01:33:38PM +0200, Cornelia Huck wrote:
> On Sun, 5 Oct 2014 19:07:05 +0300
> "Michael S. Tsirkin" <mst@redhat.com> wrote:
> 
> > Defer config changed notifications that arrive during
> > probe/scan/freeze/restore.
> > 
> > This will allow drivers to set DRIVER_OK earlier, without worrying about
> > racing with config change interrupts.
> > 
> > This change will also benefit old hypervisors (before 2009)
> > that send interrupts without checking DRIVER_OK: previously,
> > the callback could race with driver-specific initialization.
> > 
> > This will also help simplify drivers.
> > 
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > ---
> >  include/linux/virtio.h  |  6 ++++++
> >  drivers/virtio/virtio.c | 55 +++++++++++++++++++++++++++++++++++++++++--------
> >  2 files changed, 52 insertions(+), 9 deletions(-)
> > 
> > diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
> > index 657f817..578e02d 100644
> > --- a/drivers/virtio/virtio.c
> > +++ b/drivers/virtio/virtio.c
> > @@ -117,6 +117,40 @@ void virtio_check_driver_offered_feature(const struct virtio_device *vdev,
> >  }
> >  EXPORT_SYMBOL_GPL(virtio_check_driver_offered_feature);
> > 
> > +static void __virtio_config_changed(struct virtio_device *dev)
> > +{
> > +	struct virtio_driver *drv = drv_to_virtio(dev->dev.driver);
> > +
> > +	if (!dev->config_enabled)
> > +		dev->config_changed = true;
> > +	else if (drv && drv->config_changed)
> > +		drv->config_changed(dev);
> > +}
> > +
> > +void virtio_config_changed(struct virtio_device *dev)
> > +{
> > +	spin_lock_irq(&dev->config_lock);
> > +	__virtio_config_changed(dev);
> > +	spin_unlock_irq(&dev->config_lock);
> 
> Hm, isn't this function called from the interrupt handler?
>

Good catch, will fix up, thanks!
 
> > +}
> > +EXPORT_SYMBOL_GPL(virtio_config_changed);
> > +
> > +static void virtio_config_disable(struct virtio_device *dev)
> > +{
> > +	spin_lock_irq(&dev->config_lock);
> > +	dev->config_enabled = false;
> > +	spin_unlock_irq(&dev->config_lock);
> > +}
> > +
> > +static void virtio_config_enable(struct virtio_device *dev)
> > +{
> > +	spin_lock_irq(&dev->config_lock);
> > +	dev->config_enabled = true;
> > +	__virtio_config_changed(dev);
> > +	dev->config_changed = false;
> > +	spin_unlock_irq(&dev->config_lock);
> > +}
> > +
> 
> Maybe call these virtio_config_change_{dis,en}able()?
> 
> >  static int virtio_dev_probe(struct device *_d)
> >  {
> >  	int err, i;
