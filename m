Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942AbaHYQKg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 12:10:36 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:45126 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769AbaHYQKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 12:10:34 -0400
Message-ID: <53FB5FF7.8020504@kernel.org>
Date: Mon, 25 Aug 2014 17:10:31 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
CC: Adam.Thomson.Opensource@diasemi.com, knaack.h@gmx.de, lars@metafoo.de,
        pmeerw@pmeerw.net, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH] iio: core: Propagate error codes from OF layer to client
 drivers
References: <1408971437-10751-1-git-send-email-iivanov@mm-sol.com>
In-Reply-To: <1408971437-10751-1-git-send-email-iivanov@mm-sol.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/08/14 13:57, Ivan T. Ivanov wrote:
> Do not overwrite error codes returned from of_iio_channel_get().
> Error codes are used to distinguish between "io-channel-names"
> not present in DT bindings, property is optional, and IIO channel
> provider driver still not being loaded, defer probe.
> 
> Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
Cc'd Guenter who often takes an interest in this code (and wrote it ;)

Mostly seems logical to me, though I don't like the change of
priority in the last bit.  I've also just taken a fix for this
code so there may be some fuzz from that once it's propogated
through to mainline and back to the togreg tree of iio.git

Thanks,

Jonathan
> ---
>  drivers/iio/inkern.c | 24 ++++++++++++------------
>  1 file changed, 12 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/iio/inkern.c b/drivers/iio/inkern.c
> index c749700..66a6cde 100644
> --- a/drivers/iio/inkern.c
> +++ b/drivers/iio/inkern.c
> @@ -162,7 +162,7 @@ err_free_channel:
>  static struct iio_channel *of_iio_channel_get_by_name(struct device_node *np,
>  						      const char *name)
>  {
> -	struct iio_channel *chan = NULL;
> +	struct iio_channel *chan = ERR_PTR(-ENODEV);
>  
>  	/* Walk up the tree of devices looking for a matching iio channel */
>  	while (np) {
> @@ -183,7 +183,7 @@ static struct iio_channel *of_iio_channel_get_by_name(struct device_node *np,
>  		else if (name && index >= 0) {
>  			pr_err("ERROR: could not get IIO channel %s:%s(%i)\n",
>  				np->full_name, name ? name : "", index);
> -			return NULL;
> +			break;
>  		}
>  
>  		/*
> @@ -193,7 +193,7 @@ static struct iio_channel *of_iio_channel_get_by_name(struct device_node *np,
>  		 */
>  		np = np->parent;
>  		if (np && !of_get_property(np, "io-channel-ranges", NULL))
> -			return NULL;
> +			break;
>  	}
>  
>  	return chan;
> @@ -243,12 +243,12 @@ error_free_chans:
>  static inline struct iio_channel *
>  of_iio_channel_get_by_name(struct device_node *np, const char *name)
>  {
> -	return NULL;
> +	return ERR_PTR(-ENODEV);
>  }
>  
>  static inline struct iio_channel *of_iio_channel_get_all(struct device *dev)
>  {
> -	return NULL;
> +	return ERR_PTR(-ENODEV);
>  }
>  
>  #endif /* CONFIG_OF */
> @@ -312,14 +312,14 @@ struct iio_channel *iio_channel_get(struct device *dev,
>  	const char *name = dev ? dev_name(dev) : NULL;
>  	struct iio_channel *channel;
>  
> -	if (dev) {
> -		channel = of_iio_channel_get_by_name(dev->of_node,
> -						     channel_name);
> -		if (channel != NULL)
> -			return channel;
> -	}
> +	channel = iio_channel_get_sys(name, channel_name);
> +	if (!IS_ERR(channel))
> +		return channel;
> +
> +	if (!dev)
> +		return channel;
>  
> -	return iio_channel_get_sys(name, channel_name);
> +	return of_iio_channel_get_by_name(dev->of_node, channel_name);
>  }
Why reorder the logic?   This makes this patch less obviously
correct for limited obvious gain?

Previously the priority was clearly given to device tree bindings
wherease now it is given to board file provided map elements.  It
would be interesting to see boards with both provided, but it is
possible.
>  EXPORT_SYMBOL_GPL(iio_channel_get);
>  
> 
