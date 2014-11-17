Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752011AbaKQJhV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 04:37:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35150 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751679AbaKQJhU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 04:37:20 -0500
Date: Mon, 17 Nov 2014 11:37:01 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: rusty@rustcorp.com.au, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Cornelia Huck <cornelia.huck@de.ibm.com>,
        Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: Re: [PATCH V3 1/2] virtio: introduce methods of sanitizing device
 features
Message-ID: <20141117093701.GC20133@redhat.com>
References: <1416215838-21700-1-git-send-email-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416215838-21700-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2014 at 05:17:17PM +0800, Jason Wang wrote:
> Buggy host may advertised buggy host features (a usual case is that host
> advertise a feature whose dependencies were missed). In this case, driver
> should detect and disable the buggy features by itself.
> 
> This patch introduces driver specific sanitize_features() method which is
> called just before features finalizing to detect and disable buggy features
> advertised by host.
> 
> Virtio-net will be the first user.
> 
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Cc: Cornelia Huck <cornelia.huck@de.ibm.com>
> Cc: Wanlong Gao <gaowanlong@cn.fujitsu.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>

Hmm this conflicts with virtio 1.0 work: we drop
features as bitmap there.

> ---
> Changes from V2:
> - fix typo
> - rename fix_features to sanitize_features
> ---
>  drivers/virtio/virtio.c       |  4 ++++
>  include/linux/virtio.h        |  1 +
>  include/linux/virtio_config.h | 12 ++++++++++++
>  3 files changed, 17 insertions(+)
> 
> diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
> index df598dd..6a86b4f 100644
> --- a/drivers/virtio/virtio.c
> +++ b/drivers/virtio/virtio.c
> @@ -181,6 +181,10 @@ static int virtio_dev_probe(struct device *_d)
>  		if (device_features & (1 << i))
>  			set_bit(i, dev->features);
>  
> +	/* Sanitize buggy features advertised by host */
> +	if (drv->sanitize_features)
> +		drv->sanitize_features(dev);
> +
>  	dev->config->finalize_features(dev);
>  
>  	err = drv->probe(dev);
> diff --git a/include/linux/virtio.h b/include/linux/virtio.h
> index 65261a7..5aed283 100644
> --- a/include/linux/virtio.h
> +++ b/include/linux/virtio.h
> @@ -142,6 +142,7 @@ struct virtio_driver {
>  	void (*scan)(struct virtio_device *dev);
>  	void (*remove)(struct virtio_device *dev);
>  	void (*config_changed)(struct virtio_device *dev);
> +	void (*sanitize_features)(struct virtio_device *dev);
>  #ifdef CONFIG_PM
>  	int (*freeze)(struct virtio_device *dev);
>  	int (*restore)(struct virtio_device *dev);
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
> +
> +	virtio_check_driver_offered_feature(vdev, fbit);
> +
> +	clear_bit(fbit, vdev->features);
> +}
> +
>  static inline
>  struct virtqueue *virtio_find_single_vq(struct virtio_device *vdev,
>  					vq_callback_t *c, const char *n)
> -- 
> 1.9.1
