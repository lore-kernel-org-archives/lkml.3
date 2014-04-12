Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583AbaDLQiW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2014 12:38:22 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:44192 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbaDLQiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2014 12:38:19 -0400
Message-ID: <53496C49.9070900@kernel.org>
Date: Sat, 12 Apr 2014 17:39:37 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
CC: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [Patch v3 1/6] devres: introduce API "devm_kmemdup
References: <1397004988-31550-1-git-send-email-srinivas.pandruvada@linux.intel.com>
In-Reply-To: <1397004988-31550-1-git-send-email-srinivas.pandruvada@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/14 01:56, Srinivas Pandruvada wrote:
> Introduce devm_kmemdup, which uses resource managed kmalloc.
> There are several request from maintainers to add this instead
> of using kmemdup.
>
> Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
I've been trying to work out who else should be cc'd on this and
so far I've come up with Greg...

Looks like a straight forward addition to me though - plenty
of other possible users in IIO if nowhere else.
(mostly in other hid sensor drivers, but there we are ;)

> ---
>   Documentation/driver-model/devres.txt |  1 +
>   drivers/base/devres.c                 | 21 +++++++++++++++++++++
>   include/linux/device.h                |  2 ++
>   3 files changed, 24 insertions(+)
>
> diff --git a/Documentation/driver-model/devres.txt b/Documentation/driver-model/devres.txt
> index 4f7897e..4999518 100644
> --- a/Documentation/driver-model/devres.txt
> +++ b/Documentation/driver-model/devres.txt
> @@ -236,6 +236,7 @@ certainly invest a bit more effort into libata core layer).
>   MEM
>     devm_kzalloc()
>     devm_kfree()
> +  devm_kmemdup()
>
>   IIO
>     devm_iio_device_alloc()
> diff --git a/drivers/base/devres.c b/drivers/base/devres.c
> index db4e264..d0914cb 100644
> --- a/drivers/base/devres.c
> +++ b/drivers/base/devres.c
> @@ -831,3 +831,24 @@ void devm_kfree(struct device *dev, void *p)
>   	WARN_ON(rc);
>   }
>   EXPORT_SYMBOL_GPL(devm_kfree);
> +
> +/**
> + * devm_kmemdup - Resource-managed kmemdup
> + * @dev: Device this memory belongs to
> + * @src: Memory region to duplicate
> + * @len: Memory region length
> + * @gfp: GFP mask to use
> + *
> + * Duplicate region of a memory using resource managed kmalloc
> + */
> +void *devm_kmemdup(struct device *dev, const void *src, size_t len, gfp_t gfp)
> +{
> +	void *p;
> +
> +	p = devm_kmalloc(dev, len, gfp);
> +	if (p)
> +		memcpy(p, src, len);
> +
> +	return p;
> +}
> +EXPORT_SYMBOL_GPL(devm_kmemdup);
> diff --git a/include/linux/device.h b/include/linux/device.h
> index 233bbbe..0b3117a 100644
> --- a/include/linux/device.h
> +++ b/include/linux/device.h
> @@ -629,6 +629,8 @@ static inline void *devm_kcalloc(struct device *dev,
>   }
>   extern void devm_kfree(struct device *dev, void *p);
>   extern char *devm_kstrdup(struct device *dev, const char *s, gfp_t gfp);
> +extern void *devm_kmemdup(struct device *dev, const void *src, size_t len,
> +				gfp_t gfp);
>
>   void __iomem *devm_ioremap_resource(struct device *dev, struct resource *res);
>   void __iomem *devm_request_and_ioremap(struct device *dev,
>

