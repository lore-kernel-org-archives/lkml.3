Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932189AbaKMIqR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 03:46:17 -0500
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:37841 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120AbaKMIqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 03:46:15 -0500
Date: Thu, 13 Nov 2014 09:46:04 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Jason Wang <jasowang@redhat.com>
Cc: rusty@rustcorp.com.au, mst@redhat.com,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/2] virito: introduce methods of fixing device features
Message-ID: <20141113094604.1f248c3d.cornelia.huck@de.ibm.com>
In-Reply-To: <1415857974-23326-1-git-send-email-jasowang@redhat.com>
References: <1415857974-23326-1-git-send-email-jasowang@redhat.com>
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
x-cbid: 14111308-0041-0000-0000-0000021AA686
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Nov 2014 13:52:53 +0800
Jason Wang <jasowang@redhat.com> wrote:

typo in subject-prefix: s/virito/virtio/

> Buggy host may advertised buggy host features (a usual case is that host
> advertise a feature whose dependencies were missed). In this case, driver
> should detect and disable the buggy features by itself.
> 
> This patch introduces driver specific fix_features() method which is called
> just before features finalizing to detect and disable buggy features
> advertised by host.

So the basic problem this patch fixes is that an individual driver may
only specify a static set of features but cannot specify any
dependencies, right? Adding a sanitizer step makes sense, I guess.

> 
> Virtio-net will be the first user.
> 
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>  drivers/virtio/virtio.c       |  4 ++++
>  include/linux/virtio.h        |  1 +
>  include/linux/virtio_config.h | 12 ++++++++++++
>  3 files changed, 17 insertions(+)
> 
> diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
> index df598dd..7001d6e 100644
> --- a/drivers/virtio/virtio.c
> +++ b/drivers/virtio/virtio.c
> @@ -181,6 +181,10 @@ static int virtio_dev_probe(struct device *_d)
>  		if (device_features & (1 << i))
>  			set_bit(i, dev->features);
> 
> +	/* Fix buggy features advertised by host */
> +	if (drv->fix_features)
> +		drv->fix_features(dev);

I'd probably call this "sanitize_features" instead.

> +
>  	dev->config->finalize_features(dev);
> 
>  	err = drv->probe(dev);

> diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
> index 7f4ef66..7bd89ea 100644
> --- a/include/linux/virtio_config.h
> +++ b/include/linux/virtio_config.h
> @@ -96,6 +96,18 @@ static inline bool virtio_has_feature(const struct virtio_device *vdev,
>  	return test_bit(fbit, vdev->features);
>  }
> 
> +static inline void virtio_disable_feature(struct virtio_device *vdev,
> +                                          unsigned int fbit)
> +{
> +	BUG_ON(fbit >= VIRTIO_TRANSPORT_F_START);
> +	BUG_ON(vdev->config->get_status(vdev) &
> +	       ~(VIRTIO_CONFIG_S_ACKNOWLEDGE | VIRTIO_CONFIG_S_DRIVER));

When we add virtio-1 support, we can add a check for FEATURES_OK here,
so we're really on the safe side.

> +
> +	virtio_check_driver_offered_feature(vdev, fbit);
> +
> +	clear_bit(fbit, vdev->features);
> +}
> +
>  static inline
>  struct virtqueue *virtio_find_single_vq(struct virtio_device *vdev,
>  					vq_callback_t *c, const char *n)

The approach looks good to me.

