Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751831AbaLZLlD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 06:41:03 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:44841 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497AbaLZLk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 06:40:59 -0500
Message-ID: <549D4948.1040403@kernel.org>
Date: Fri, 26 Dec 2014 11:40:56 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Karol Wrona <k.wrona@samsung.com>, linux-iio@vger.kernel.org,
        Hartmut Knaack <knaack.h@gmx.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>, linux-kernel@vger.kernel.org
CC: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Karol Wrona <wrona.vy@gmail.com>
Subject: Re: [PATCH v2 2/3] iio: kfifo: Add resource management devm_iio_kfifo_allocate/free
References: <1419010766-13557-1-git-send-email-k.wrona@samsung.com> <1419010766-13557-3-git-send-email-k.wrona@samsung.com>
In-Reply-To: <1419010766-13557-3-git-send-email-k.wrona@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/12/14 17:39, Karol Wrona wrote:
> iio kfifo allocate/free gained their devm_ wrappers.
> 
> Signed-off-by: Karol Wrona <k.wrona@samsung.com>
> Suggested-by: Jonathan Cameron <jic23@kernel.org>
Applied to the togreg branch of iio.git.

One addition - added to the list of devm functions in
Documentation/device-model/devres.txt


> ---
>  drivers/iio/kfifo_buf.c       |   54 +++++++++++++++++++++++++++++++++++++++++
>  include/linux/iio/kfifo_buf.h |    3 +++
>  2 files changed, 57 insertions(+)
> 
> diff --git a/drivers/iio/kfifo_buf.c b/drivers/iio/kfifo_buf.c
> index a383291..5d44099 100644
> --- a/drivers/iio/kfifo_buf.c
> +++ b/drivers/iio/kfifo_buf.c
> @@ -191,4 +191,58 @@ void iio_kfifo_free(struct iio_buffer *r)
>  }
>  EXPORT_SYMBOL(iio_kfifo_free);
>  
> +static void devm_iio_kfifo_release(struct device *dev, void *res)
> +{
> +	iio_kfifo_free(*(struct iio_buffer **)res);
> +}
> +
> +static int devm_iio_kfifo_match(struct device *dev, void *res, void *data)
> +{
> +	struct iio_buffer **r = res;
> +
> +	if (WARN_ON(!r || !*r))
> +		return 0;
> +
> +	return *r == data;
> +}
> +
> +/**
> + * devm_iio_fifo_allocate - Resource-managed iio_kfifo_allocate()
> + * @dev:		Device to allocate kfifo buffer for
> + *
> + * RETURNS:
> + * Pointer to allocated iio_buffer on success, NULL on failure.
> + */
> +struct iio_buffer *devm_iio_kfifo_allocate(struct device *dev)
> +{
> +	struct iio_buffer **ptr, *r;
> +
> +	ptr = devres_alloc(devm_iio_kfifo_release, sizeof(*ptr), GFP_KERNEL);
> +	if (!ptr)
> +		return NULL;
> +
> +	r = iio_kfifo_allocate();
> +	if (r) {
> +		*ptr = r;
> +		devres_add(dev, ptr);
> +	} else {
> +		devres_free(ptr);
> +	}
> +
> +	return r;
> +}
> +EXPORT_SYMBOL(devm_iio_kfifo_allocate);
> +
> +/**
> + * devm_iio_fifo_free - Resource-managed iio_kfifo_free()
> + * @dev:		Device the buffer belongs to
> + * @r:			The buffer associated with the device
> + */
> +void devm_iio_kfifo_free(struct device *dev, struct iio_buffer *r)
> +{
> +	WARN_ON(devres_release(dev, devm_iio_kfifo_release,
> +			       devm_iio_kfifo_match, r));
> +}
> +EXPORT_SYMBOL(devm_iio_kfifo_free);
> +
>  MODULE_LICENSE("GPL");
> diff --git a/include/linux/iio/kfifo_buf.h b/include/linux/iio/kfifo_buf.h
> index 1a8d57a..1683bc7 100644
> --- a/include/linux/iio/kfifo_buf.h
> +++ b/include/linux/iio/kfifo_buf.h
> @@ -8,4 +8,7 @@
>  struct iio_buffer *iio_kfifo_allocate(void);
>  void iio_kfifo_free(struct iio_buffer *r);
>  
> +struct iio_buffer *devm_iio_kfifo_allocate(struct device *dev);
> +void devm_iio_kfifo_free(struct device *dev, struct iio_buffer *r);
> +
>  #endif
> 

