Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751413AbaCVMbX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 08:31:23 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:60092 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932AbaCVMbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 08:31:18 -0400
Message-ID: <532D82C9.6010401@googlemail.com>
Date: Sat, 22 Mar 2014 13:32:09 +0100
From: =?ISO-8859-15?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Shuah Khan <shuah.kh@samsung.com>, m.chehab@samsung.com
CC: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        shuahkhan@gmail.com
Subject: Re: [PATCH] media: em28xx-video - change em28xx_scaler_set() to use
 em28xx_reg_len()
References: <1395435890-15100-1-git-send-email-shuah.kh@samsung.com>
In-Reply-To: <1395435890-15100-1-git-send-email-shuah.kh@samsung.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Am 21.03.2014 22:04, schrieb Shuah Khan:
> Change em28xx_scaler_set() to use em28xx_reg_len() to get register
> lengths for EM28XX_R30_HSCALELOW and EM28XX_R32_VSCALELOW registers,
> instead of hard-coding the length. Moved em28xx_reg_len() definition
> for it to be visible to em28xx_scaler_set().
>
> Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
> ---
>  drivers/media/usb/em28xx/em28xx-video.c |   29 ++++++++++++++++-------------
>  1 file changed, 16 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
> index 19af6b3..f8a91de 100644
> --- a/drivers/media/usb/em28xx/em28xx-video.c
> +++ b/drivers/media/usb/em28xx/em28xx-video.c
> @@ -272,6 +272,18 @@ static void em28xx_capture_area_set(struct em28xx *dev, u8 hstart, u8 vstart,
>  	}
>  }
>  
> +static int em28xx_reg_len(int reg)
> +{
> +	switch (reg) {
> +	case EM28XX_R40_AC97LSB:
> +	case EM28XX_R30_HSCALELOW:
> +	case EM28XX_R32_VSCALELOW:
> +		return 2;
> +	default:
> +		return 1;
> +	}
> +}
> +
>  static int em28xx_scaler_set(struct em28xx *dev, u16 h, u16 v)
>  {
>  	u8 mode;
> @@ -284,11 +296,13 @@ static int em28xx_scaler_set(struct em28xx *dev, u16 h, u16 v)
>  
>  		buf[0] = h;
>  		buf[1] = h >> 8;
> -		em28xx_write_regs(dev, EM28XX_R30_HSCALELOW, (char *)buf, 2);
> +		em28xx_write_regs(dev, EM28XX_R30_HSCALELOW, (char *)buf,
> +				  em28xx_reg_len(EM28XX_R30_HSCALELOW));
>  
>  		buf[0] = v;
>  		buf[1] = v >> 8;
> -		em28xx_write_regs(dev, EM28XX_R32_VSCALELOW, (char *)buf, 2);
> +		em28xx_write_regs(dev, EM28XX_R32_VSCALELOW, (char *)buf,
> +				  em28xx_reg_len(EM28XX_R32_VSCALELOW));
Hmm... registers 0x30 and 0x32 are always 2 bytes long.
So this change would needlessly complicate the code.

Or do you know more than us, e.g. from looking into the datasheets ? ;-)

>  		/* it seems that both H and V scalers must be active
>  		   to work correctly */
>  		mode = (h || v) ? 0x30 : 0x00;
> @@ -1583,17 +1597,6 @@ static int vidioc_g_chip_info(struct file *file, void *priv,
>  	return 0;
>  }
>  
> -static int em28xx_reg_len(int reg)
> -{
> -	switch (reg) {
> -	case EM28XX_R40_AC97LSB:
> -	case EM28XX_R30_HSCALELOW:
> -	case EM28XX_R32_VSCALELOW:
> -		return 2;
> -	default:
> -		return 1;
> -	}
> -}
>  
>  static int vidioc_g_register(struct file *file, void *priv,
>  			     struct v4l2_dbg_register *reg)

