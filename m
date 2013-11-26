Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757395Ab3KZS6O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 13:58:14 -0500
Received: from mail.active-venture.com ([67.228.131.205]:58489 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754070Ab3KZS6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 13:58:11 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <5294EF42.3090001@roeck-us.net>
Date: Tue, 26 Nov 2013 10:58:10 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>, Wim Van Sebroeck <wim@iguana.be>
CC: Fabio Porcedda <fabio.porcedda@gmail.com>,
        Sachin Kamat <sachin.kamat@linaro.org>, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] watchdog: core: Fix watchdog_init_timeout() when
 invalid param / valid dt
References: <1385490173-7511-1-git-send-email-dianders@chromium.org> <1385490173-7511-2-git-send-email-dianders@chromium.org>
In-Reply-To: <1385490173-7511-2-git-send-email-dianders@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2013 10:22 AM, Doug Anderson wrote:
> There was a minor bug in watchdog_init_timeout() where it would return
> an error code if someone specified an invalid parameter on the
> command line but then there was a valid parameter in the device tree
> as "timeout-sec".
>
> Signed-off-by: Doug Anderson <dianders@chromium.org>

I thought that was on purpose.

Problem as I see it is that users would expect the timeout to be set to
the provided parameter, which would be silently ignored and replaced
by timeout-sec if the parameter is wrong and timeout-sec is specified.
Seems to me that the user should be informed about the problem,
and not be permitted to provide invalid parameters.

Thanks,
Guenter

> ---
>   drivers/watchdog/watchdog_core.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/watchdog/watchdog_core.c b/drivers/watchdog/watchdog_core.c
> index cec9b55..8d27753 100644
> --- a/drivers/watchdog/watchdog_core.c
> +++ b/drivers/watchdog/watchdog_core.c
> @@ -82,12 +82,12 @@ int watchdog_init_timeout(struct watchdog_device *wdd,
>   		wdd->timeout = timeout_parm;
>   		return ret;
>   	}
> -	if (timeout_parm)
> -		ret = -EINVAL;
>
> -	/* try to get the timeout_sec property */
> +	/* if no device tree then we're done */
>   	if (dev == NULL || dev->of_node == NULL)
> -		return ret;
> +		return (timeout_parm) ? -EINVAL : ret;

( ) is unnecessary.

> +
> +	/* try to get the timeout_sec property */
>   	of_property_read_u32(dev->of_node, "timeout-sec", &t);
>   	if (!watchdog_timeout_invalid(wdd, t) && t)
>   		wdd->timeout = t;
>

