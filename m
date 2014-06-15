Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752122AbaFOUS1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 16:18:27 -0400
Received: from mail.kernel.org ([198.145.19.201]:39919 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750993AbaFOUSX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 16:18:23 -0400
Message-ID: <539E0001.60005@kernel.org>
Date: Sun, 15 Jun 2014 21:20:17 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-iio@vger.kernel.org,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org
CC: linux-kernel@vger.kernel.org, support.opensource@diasemi.com
Subject: Re: [PATCH 3/8] iio: of_iio_channel_get_by_name() returns non-null
 pointers for error legs
References: <cover.1402484954.git.Adam.Thomson.Opensource@diasemi.com> <0e7c03b0467ae1eace9dafebe6946d01d48e72f2.1402484954.git.Adam.Thomson.Opensource@diasemi.com>
In-Reply-To: <0e7c03b0467ae1eace9dafebe6946d01d48e72f2.1402484954.git.Adam.Thomson.Opensource@diasemi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/14 12:11, Adam Thomson wrote:
> Currently in the inkern.c code for IIO framework, the function
> of_iio_channel_get_by_name() will return a non-NULL pointer when
> it cannot find a channel using of_iio_channel_get() and when it
> tries to search for 'io-channel-ranges' property and fails. This
> is incorrect behaviour as the function which calls this expects
> a NULL pointer for failure. This patch rectifies the issue.
>
> Signed-off-by: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
Hi Adam,

Good find.  I've only recently sent a pull request for fixes upstream,
so I'll pick this up in a day or so once that has gone.

J
> ---
>   drivers/iio/inkern.c | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/iio/inkern.c b/drivers/iio/inkern.c
> index 0cf5f8e..1e8e94d 100644
> --- a/drivers/iio/inkern.c
> +++ b/drivers/iio/inkern.c
> @@ -183,7 +183,7 @@ static struct iio_channel *of_iio_channel_get_by_name(struct device_node *np,
>   		else if (name && index >= 0) {
>   			pr_err("ERROR: could not get IIO channel %s:%s(%i)\n",
>   				np->full_name, name ? name : "", index);
> -			return chan;
> +			return NULL;
>   		}
>
>   		/*
> @@ -193,8 +193,9 @@ static struct iio_channel *of_iio_channel_get_by_name(struct device_node *np,
>   		 */
>   		np = np->parent;
>   		if (np && !of_get_property(np, "io-channel-ranges", NULL))
> -			break;
> +			return NULL;
>   	}
> +
>   	return chan;
>   }
>
> @@ -317,6 +318,7 @@ struct iio_channel *iio_channel_get(struct device *dev,
>   		if (channel != NULL)
>   			return channel;
>   	}
> +
>   	return iio_channel_get_sys(name, channel_name);
>   }
>   EXPORT_SYMBOL_GPL(iio_channel_get);
> --
> 1.9.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

