Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753656AbbAUS5N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 13:57:13 -0500
Received: from service87.mimecast.com ([91.220.42.44]:54125 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbbAUS5G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 13:57:06 -0500
Message-ID: <54BFF679.6010705@arm.com>
Date: Wed, 21 Jan 2015 18:56:57 +0000
From: Robin Murphy <robin.murphy@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Sumit Semwal <sumit.semwal@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
CC: "t.stanislaws@samsung.com" <t.stanislaws@samsung.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "robdclark@gmail.com" <robdclark@gmail.com>,
        "daniel@ffwll.ch" <daniel@ffwll.ch>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>
Subject: Re: [RFCv2 1/2] device: add dma_params->max_segment_count
References: <1421813807-9178-1-git-send-email-sumit.semwal@linaro.org> <1421813807-9178-2-git-send-email-sumit.semwal@linaro.org>
In-Reply-To: <1421813807-9178-2-git-send-email-sumit.semwal@linaro.org>
X-OriginalArrivalTime: 21 Jan 2015 18:57:01.0617 (UTC) FILETIME=[0A3D2210:01D035AC]
X-MC-Unique: 115012118570400201
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sumit,

On 21/01/15 04:16, Sumit Semwal wrote:
> From: Rob Clark <robdclark@gmail.com>
>
> For devices which have constraints about maximum number of segments in
> an sglist.  For example, a device which could only deal with contiguous
> buffers would set max_segment_count to 1.
>
> The initial motivation is for devices sharing buffers via dma-buf,
> to allow the buffer exporter to know the constraints of other
> devices which have attached to the buffer.  The dma_mask and fields
> in 'struct device_dma_parameters' tell the exporter everything else
> that is needed, except whether the importer has constraints about
> maximum number of segments.
>
> Signed-off-by: Rob Clark <robdclark@gmail.com>
>   [sumits: Minor updates wrt comments on the first version]
> Signed-off-by: Sumit Semwal <sumit.semwal@linaro.org>
> ---
>   include/linux/device.h      |  1 +
>   include/linux/dma-mapping.h | 19 +++++++++++++++++++
>   2 files changed, 20 insertions(+)
>
> diff --git a/include/linux/device.h b/include/linux/device.h
> index fb50673..a32f9b6 100644
> --- a/include/linux/device.h
> +++ b/include/linux/device.h
> @@ -647,6 +647,7 @@ struct device_dma_parameters {
>   	 * sg limitations.
>   	 */
>   	unsigned int max_segment_size;
> +	unsigned int max_segment_count;    /* INT_MAX for unlimited */
>   	unsigned long segment_boundary_mask;
>   };
>
> diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
> index c3007cb..38e2835 100644
> --- a/include/linux/dma-mapping.h
> +++ b/include/linux/dma-mapping.h
> @@ -154,6 +154,25 @@ static inline unsigned int dma_set_max_seg_size(struct device *dev,
>   		return -EIO;
>   }
>
> +#define DMA_SEGMENTS_MAX_SEG_COUNT ((unsigned int) INT_MAX)
> +
> +static inline unsigned int dma_get_max_seg_count(struct device *dev)
> +{
> +	return dev->dma_parms ?
> +			dev->dma_parms->max_segment_count :
> +			DMA_SEGMENTS_MAX_SEG_COUNT;
> +}

I know this copies the style of the existing code, but unfortunately it 
also copies the subtle brokenness. Plenty of drivers seem to set up a 
dma_parms struct just for max_segment_size, thus chances are you'll come 
across a max_segment_count of 0 sooner or later. How badly is that going 
to break things? I posted a fix recently[1] having hit this problem with 
segment_boundary_mask in IOMMU code.

> +
> +static inline int dma_set_max_seg_count(struct device *dev,
> +						unsigned int count)
> +{
> +	if (dev->dma_parms) {
> +		dev->dma_parms->max_segment_count = count;
> +		return 0;
> +	} else

This "else" is just as unnecessary as the other two I've taken out ;)


Robin.

[1]:http://article.gmane.org/gmane.linux.kernel.iommu/8175/

> +		return -EIO;
> +}
> +
>   static inline unsigned long dma_get_seg_boundary(struct device *dev)
>   {
>   	return dev->dma_parms ?
>


