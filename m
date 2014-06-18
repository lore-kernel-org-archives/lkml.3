Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966672AbaFRNEm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 09:04:42 -0400
Received: from gloria.sntech.de ([95.129.55.99]:47177 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966401AbaFRNEk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 09:04:40 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Rob Jones <rob.jones@codethink.co.uk>
Cc: linus.walleij@linaro.org, gnurou@gmail.com, lgirdwood@gmail.com,
        broonie@kernel.org, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org, ian.molton@codethink.co.uk,
        ben.dooks@codethink.co.uk
Subject: Re: [PATCH 2/3] drivers/base: devres.c: Add block copy func. for managed devices
Date: Wed, 18 Jun 2014 15:05:58 +0200
Message-ID: <1713451.AmufNoybT7@diego>
User-Agent: KMail/4.11.5 (Linux/3.13-1-amd64; KDE/4.11.3; x86_64; ; )
In-Reply-To: <1402411308-14182-3-git-send-email-rob.jones@codethink.co.uk>
References: <1402411308-14182-1-git-send-email-rob.jones@codethink.co.uk> <1402411308-14182-3-git-send-email-rob.jones@codethink.co.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 10. Juni 2014, 15:41:47 schrieb Rob Jones:
> Add function devm_kmemdup().
> Rationalise with devm_kstrdup() to avoid code duplication.
> 
> Reviewed-by: Ian Molton <ian.molton@codethink.co.uk>
> Signed-off-by: Rob Jones <rob.jones@codethink.co.uk>
> ---
>  drivers/base/devres.c  |   42 ++++++++++++++++++++++++++++++++++--------
>  include/linux/device.h |    2 ++
>  2 files changed, 36 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/base/devres.c b/drivers/base/devres.c
> index db4e264..978bbe2 100644
> --- a/drivers/base/devres.c
> +++ b/drivers/base/devres.c
> @@ -791,6 +791,20 @@ void * devm_kmalloc(struct device *dev, size_t size,
> gfp_t gfp) EXPORT_SYMBOL_GPL(devm_kmalloc);
> 
>  /**
> + * static function to avoid code duplication when duplicating buffers
> + */
> +static void *devm_kmemdup_nochecks(struct device *dev, const void *s,
> +				    size_t size, gfp_t gfp)
> +{
> +	void *buf;
> +
> +	buf = devm_kmalloc(dev, size, gfp);
> +	if (buf)
> +		memcpy(buf, s, size);
> +	return buf;
> +}
> +
> +/**
>   * devm_kstrdup - Allocate resource managed space and
>   *                copy an existing string into that.
>   * @dev: Device to allocate memory for
> @@ -802,21 +816,33 @@ EXPORT_SYMBOL_GPL(devm_kmalloc);
>   */
>  char *devm_kstrdup(struct device *dev, const char *s, gfp_t gfp)
>  {
> -	size_t size;
> -	char *buf;
> -
>  	if (!s)
>  		return NULL;
> 
> -	size = strlen(s) + 1;
> -	buf = devm_kmalloc(dev, size, gfp);
> -	if (buf)
> -		memcpy(buf, s, size);
> -	return buf;
> +	return devm_kmemdup_nochecks(dev, s, (strlen(s)+1), gfp);
>  }
>  EXPORT_SYMBOL_GPL(devm_kstrdup);

hmm, this looks like an unrelated change to me and may warrant a separate 
patch for the devm_kstrdup change.


> 
>  /**
> + * devm_kmemdup - Allocate resource managed space and
> + *                copy existing data into that.
> + * @dev: Device to allocate memory for
> + * @s: the memory block to duplicate
> + * @gfp: the GFP mask used in the devm_kmalloc() call when
> + *       allocating memory
> + * RETURNS:
> + * Pointer to allocated string on success, NULL on failure.
> + */
> +void *devm_kmemdup(struct device *dev, const void *s, size_t size, gfp_t
> gfp) +{
> +	if (!s || (size == 0))
> +		return NULL;
> +
> +	return devm_kmemdup_nochecks(dev, s, size, gfp);
> +}
> +EXPORT_SYMBOL_GPL(devm_kmemdup);
> +
> +/**
>   * devm_kfree - Resource-managed kfree
>   * @dev: Device this memory belongs to
>   * @p: Memory to free
> diff --git a/include/linux/device.h b/include/linux/device.h
> index d1d1c05..7ace116 100644
> --- a/include/linux/device.h
> +++ b/include/linux/device.h
> @@ -623,6 +623,8 @@ static inline void *devm_kcalloc(struct device *dev,
>  }
>  extern void devm_kfree(struct device *dev, void *p);
>  extern char *devm_kstrdup(struct device *dev, const char *s, gfp_t gfp);
> +extern void *devm_kmemdup(struct device *dev,
> +			  const void *s, size_t size, gfp_t gfp);
> 
>  void __iomem *devm_ioremap_resource(struct device *dev, struct resource
> *res); void __iomem *devm_request_and_ioremap(struct device *dev,

