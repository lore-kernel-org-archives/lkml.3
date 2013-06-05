Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459Ab3FENXk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 09:23:40 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54392 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754599Ab3FENXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 09:23:39 -0400
Message-ID: <51AF3BD7.5070001@canonical.com>
Date: Wed, 05 Jun 2013 15:23:35 +0200
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Seung-Woo Kim <sw0312.kim@samsung.com>
CC: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        linaro-mm-sig@lists.linaro.org, sumit.semwal@linaro.org,
        airlied@linux.ie, daniel.vetter@ffwll.ch, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 1/2] dma-buf: add importer private data to attachment
References: <1369990487-23510-1-git-send-email-sw0312.kim@samsung.com> <1369990487-23510-2-git-send-email-sw0312.kim@samsung.com>
In-Reply-To: <1369990487-23510-2-git-send-email-sw0312.kim@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 31-05-13 10:54, Seung-Woo Kim schreef:
> dma-buf attachment has only exporter private data, but importer private data
> can be useful for importer especially to re-import the same dma-buf.
> To use importer private data in attachment of the device, the function to
> search attachment in the attachment list of dma-buf is also added.
>
> Signed-off-by: Seung-Woo Kim <sw0312.kim@samsung.com>
> ---
>  drivers/base/dma-buf.c  |   31 +++++++++++++++++++++++++++++++
>  include/linux/dma-buf.h |    4 ++++
>  2 files changed, 35 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/base/dma-buf.c b/drivers/base/dma-buf.c
> index 08fe897..a1eaaf2 100644
> --- a/drivers/base/dma-buf.c
> +++ b/drivers/base/dma-buf.c
> @@ -259,6 +259,37 @@ err_attach:
>  EXPORT_SYMBOL_GPL(dma_buf_attach);
>  
>  /**
> + * dma_buf_get_attachment - Get attachment with the device from dma_buf's
> + * attachments list
> + * @dmabuf:	[in]	buffer to find device from.
> + * @dev:	[in]	device to be found.
> + *
> + * Returns struct dma_buf_attachment * attaching the device; may return
> + * negative error codes.
> + *
> + */
> +struct dma_buf_attachment *dma_buf_get_attachment(struct dma_buf *dmabuf,
> +						  struct device *dev)
> +{
> +	struct dma_buf_attachment *attach;
> +
> +	if (WARN_ON(!dmabuf || !dev))
> +		return ERR_PTR(-EINVAL);
> +
> +	mutex_lock(&dmabuf->lock);
> +	list_for_each_entry(attach, &dmabuf->attachments, node) {
> +		if (attach->dev == dev) {
> +			mutex_unlock(&dmabuf->lock);
> +			return attach;
> +		}
> +	}
> +	mutex_unlock(&dmabuf->lock);
> +
> +	return ERR_PTR(-ENODEV);
> +}
> +EXPORT_SYMBOL_GPL(dma_buf_get_attachment);
NAK in any form..

Spot the race condition between dma_buf_get_attachment and dma_buf_attach....

~Maarten

