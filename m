Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786AbaJFOI1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 10:08:27 -0400
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:59668 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758AbaJFOI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 10:08:26 -0400
Date: Mon, 6 Oct 2014 16:08:16 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 10/16] virtio: add API to enable VQs early
Message-ID: <20141006160816.68490a49.cornelia.huck@de.ibm.com>
In-Reply-To: <1412525038-15871-11-git-send-email-mst@redhat.com>
References: <1412525038-15871-1-git-send-email-mst@redhat.com>
	<1412525038-15871-11-git-send-email-mst@redhat.com>
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
x-cbid: 14100614-5024-0000-0000-0000018D5154
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 5 Oct 2014 19:07:19 +0300
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> virtio spec requires DRIVER_OK to be set before
> VQs are used, but some drivers use VQs before probe
> function returns.
> Since DRIVER_OK is set after probe, this violates the spec.

"Even though transitional devices support this behaviour, we want to
make it possible for those early callers to become spec compliant."

?

> 
> Add API for drivers to call before using VQs.
> 
> Sets DRIVER_OK internally.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  include/linux/virtio_config.h | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
> index e8f8f71..6127fc8 100644
> --- a/include/linux/virtio_config.h
> +++ b/include/linux/virtio_config.h
> @@ -109,6 +109,23 @@ struct virtqueue *virtio_find_single_vq(struct virtio_device *vdev,
>  	return vq;
>  }
> 
> +/**
> + * virtio_early_enable_vqs - enable vq use in probe function
> + * @vdev: the device
> + *
> + * Driver must call this to use vqs in the probe function.
> + *
> + * Note: vqs are enabled automatically after probe returns.
> + */
> +static inline
> +void virtio_early_enable_vqs(struct virtio_device *dev)
> +{
> +	unsigned status = dev->config->get_status(dev);
> +
> +	BUG_ON(status & VIRTIO_CONFIG_S_DRIVER_OK);
> +	dev->config->set_status(dev, status | VIRTIO_CONFIG_S_DRIVER_OK);
> +}
> +

Maybe virtio_enable_vqs_early() instead?

>  static inline
>  const char *virtio_bus_name(struct virtio_device *vdev)
>  {

