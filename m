Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752388AbaJFLdv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 07:33:51 -0400
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:59192 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319AbaJFLdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 07:33:47 -0400
Date: Mon, 6 Oct 2014 13:33:38 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 05/16] virtio: defer config changed notifications
Message-ID: <20141006133338.236a1175.cornelia.huck@de.ibm.com>
In-Reply-To: <1412525038-15871-6-git-send-email-mst@redhat.com>
References: <1412525038-15871-1-git-send-email-mst@redhat.com>
	<1412525038-15871-6-git-send-email-mst@redhat.com>
Organization: IBM Deutschland Research & Development GmbH Vorsitzende des
 Aufsichtsrats: Martina Koederitz =?UTF-8?B?R2VzY2jDpGZ0c2bDvGhydW5nOg==?=
 Dirk Wittkopp Sitz der Gesellschaft: =?UTF-8?B?QsO2Ymxpbmdlbg==?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14100611-0542-0000-0000-000001123774
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 5 Oct 2014 19:07:05 +0300
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> Defer config changed notifications that arrive during
> probe/scan/freeze/restore.
> 
> This will allow drivers to set DRIVER_OK earlier, without worrying about
> racing with config change interrupts.
> 
> This change will also benefit old hypervisors (before 2009)
> that send interrupts without checking DRIVER_OK: previously,
> the callback could race with driver-specific initialization.
> 
> This will also help simplify drivers.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  include/linux/virtio.h  |  6 ++++++
>  drivers/virtio/virtio.c | 55 +++++++++++++++++++++++++++++++++++++++++--------
>  2 files changed, 52 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
> index 657f817..578e02d 100644
> --- a/drivers/virtio/virtio.c
> +++ b/drivers/virtio/virtio.c
> @@ -117,6 +117,40 @@ void virtio_check_driver_offered_feature(const struct virtio_device *vdev,
>  }
>  EXPORT_SYMBOL_GPL(virtio_check_driver_offered_feature);
> 
> +static void __virtio_config_changed(struct virtio_device *dev)
> +{
> +	struct virtio_driver *drv = drv_to_virtio(dev->dev.driver);
> +
> +	if (!dev->config_enabled)
> +		dev->config_changed = true;
> +	else if (drv && drv->config_changed)
> +		drv->config_changed(dev);
> +}
> +
> +void virtio_config_changed(struct virtio_device *dev)
> +{
> +	spin_lock_irq(&dev->config_lock);
> +	__virtio_config_changed(dev);
> +	spin_unlock_irq(&dev->config_lock);

Hm, isn't this function called from the interrupt handler?

> +}
> +EXPORT_SYMBOL_GPL(virtio_config_changed);
> +
> +static void virtio_config_disable(struct virtio_device *dev)
> +{
> +	spin_lock_irq(&dev->config_lock);
> +	dev->config_enabled = false;
> +	spin_unlock_irq(&dev->config_lock);
> +}
> +
> +static void virtio_config_enable(struct virtio_device *dev)
> +{
> +	spin_lock_irq(&dev->config_lock);
> +	dev->config_enabled = true;
> +	__virtio_config_changed(dev);
> +	dev->config_changed = false;
> +	spin_unlock_irq(&dev->config_lock);
> +}
> +

Maybe call these virtio_config_change_{dis,en}able()?

>  static int virtio_dev_probe(struct device *_d)
>  {
>  	int err, i;

