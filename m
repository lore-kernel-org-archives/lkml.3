Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161Ab3C1F7D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 01:59:03 -0400
Received: from mail-da0-f42.google.com ([209.85.210.42]:34687 "EHLO
	mail-da0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273Ab3C1F7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 01:59:01 -0400
Date: Wed, 27 Mar 2013 22:58:58 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: seb <sebastien.royen@gmail.com>
Cc: Bill Pemberton <wfp5p@virginia.edu>, linux-kernel@vger.kernel.org,
        seb <sebastien.royen@armadeus.com>
Subject: Re: [PATCH 1/1] Input: mma8450 - fix signed 12bits to 32bits
 conversion
Message-ID: <20130328055858.GA6523@core.coreip.homeip.net>
References: <1364372263-16848-1-git-send-email-sebastien.royen@armadeus.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364372263-16848-1-git-send-email-sebastien.royen@armadeus.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Seb,

On Wed, Mar 27, 2013 at 09:17:43AM +0100, seb wrote:
> Event value is wrong. Should be in range -2048 to 2047, but is in range 0 to 4095.
> Use int8_t to int conversion and remove 0xfff mask.
> 
> Signed-off-by: seb <sebastien.royen@armadeus.com>
> ---
>  drivers/input/misc/mma8450.c |   15 ++++++++++-----
>  1 file changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/input/misc/mma8450.c b/drivers/input/misc/mma8450.c
> index 480557f..c3781a1 100644
> --- a/drivers/input/misc/mma8450.c
> +++ b/drivers/input/misc/mma8450.c
> @@ -110,7 +110,7 @@ static void mma8450_poll(struct input_polled_dev *dev)
>  	struct mma8450 *m = dev->private;
>  	int x, y, z;
>  	int ret;
> -	u8 buf[6];
> +	int8_t buf[6];
>  
>  	ret = mma8450_read(m, MMA8450_STATUS);
>  	if (ret < 0)
> @@ -119,13 +119,18 @@ static void mma8450_poll(struct input_polled_dev *dev)
>  	if (!(ret & MMA8450_STATUS_ZXYDR))
>  		return;
>  
> -	ret = mma8450_read_block(m, MMA8450_OUT_X_LSB, buf, sizeof(buf));
> +	ret = mma8450_read_block(m, MMA8450_OUT_X_LSB, (u8*)buf, sizeof(buf));
>  	if (ret < 0)
>  		return;
>  
> -	x = ((buf[1] << 4) & 0xff0) | (buf[0] & 0xf);
> -	y = ((buf[3] << 4) & 0xff0) | (buf[2] & 0xf);
> -	z = ((buf[5] << 4) & 0xff0) | (buf[4] & 0xf);
> +	/* convert 8 MSB from int8_t to int */
> +	x = buf[1];
> +	y = buf[3];
> +	z = buf[5];
> +	/* add 4 LSB */
> +	x = (x << 4) | (buf[0] & 0xf);
> +	y = (y << 4) | (buf[2] & 0xf);
> +	z = (z << 4) | (buf[4] & 0xf);

Should we just say:

	x = ((int)(s8)buf[1] << 4) | (buf[0] & 0xf);
	y = ...
	z = ...

and leave the rest as is?

Thanks.

-- 
Dmitry
