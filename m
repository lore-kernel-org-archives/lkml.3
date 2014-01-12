Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751219AbaALUzy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 15:55:54 -0500
Received: from ns.pmeerw.net ([87.118.82.44]:60526 "EHLO pmeerw.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750999AbaALUzx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 15:55:53 -0500
Date: Sun, 12 Jan 2014 21:55:49 +0100 (CET)
From: Peter Meerwald <pmeerw@pmeerw.net>
To: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
cc: jic23@kernel.org, pali.rohar@gmail.com, pavel@ucw.cz,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ivaylo Dimitrov <freemangordon@abv.bg>
Subject: Re: [PATCH] iio: tsl2563: Initialize channels
In-Reply-To: <1389556464-692-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
Message-ID: <alpine.DEB.2.01.1401122150210.9334@pmeerw.net>
References: <1389556464-692-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> Correctly initialize device channels, otherwise writing the calibration
> values to sysfs nodes does not work

I think the fix should rather be

	if (chan->channel2 == IIO_MOD_LIGHT_BOTH)
		chip->calib0 = calib_from_sysfs(val);
	else if (chan->channel2 == IIO_MOD_LIGHT_IR)
		chip->calib1 = calib_from_sysfs(val);
	else
		return -EINVAL;

since only the INTENSITY channels have a CALIBSCALE info

the light channel incorrectly sets .indexed = 1 and .channel = 0 which 
should be unnecessary since there is only one IIO_LIGHT channel

regards, p.

> ---
>  drivers/iio/light/tsl2563.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/iio/light/tsl2563.c b/drivers/iio/light/tsl2563.c
> index 5e5d9de..a663ea2 100644
> --- a/drivers/iio/light/tsl2563.c
> +++ b/drivers/iio/light/tsl2563.c
> @@ -460,7 +460,7 @@ static int tsl2563_write_raw(struct iio_dev *indio_dev,
>  {
>  	struct tsl2563_chip *chip = iio_priv(indio_dev);
>  
> -	if (chan->channel == IIO_MOD_LIGHT_BOTH)
> +	if (chan->channel == 0)
>  		chip->calib0 = calib_from_sysfs(val);
>  	else
>  		chip->calib1 = calib_from_sysfs(val);
> @@ -543,11 +543,12 @@ static const struct iio_event_spec tsl2563_events[] = {
>  static const struct iio_chan_spec tsl2563_channels[] = {
>  	{
>  		.type = IIO_LIGHT,
> +		.channel = 0,
>  		.indexed = 1,
>  		.info_mask_separate = BIT(IIO_CHAN_INFO_PROCESSED),
> -		.channel = 0,
>  	}, {
>  		.type = IIO_INTENSITY,
> +		.channel = 0,
>  		.modified = 1,
>  		.channel2 = IIO_MOD_LIGHT_BOTH,
>  		.info_mask_separate = BIT(IIO_CHAN_INFO_RAW) |
> @@ -556,6 +557,7 @@ static const struct iio_chan_spec tsl2563_channels[] = {
>  		.num_event_specs = ARRAY_SIZE(tsl2563_events),
>  	}, {
>  		.type = IIO_INTENSITY,
> +		.channel = 1,
>  		.modified = 1,
>  		.channel2 = IIO_MOD_LIGHT_IR,
>  		.info_mask_separate = BIT(IIO_CHAN_INFO_RAW) |
> 

-- 

Peter Meerwald
+43-664-2444418 (mobile)
