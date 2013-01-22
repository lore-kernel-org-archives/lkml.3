Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445Ab3AVLvG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 06:51:06 -0500
Received: from ams-iport-3.cisco.com ([144.254.224.146]:64731 "EHLO
	ams-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723Ab3AVLvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 06:51:04 -0500
X-IronPort-AV: E=Sophos;i="4.84,514,1355097600"; 
   d="scan'208";a="11245709"
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
Subject: Re: [PATCH v2] media: adv7343: accept configuration through platform data
Date: Tue, 22 Jan 2013 12:50:38 +0100
User-Agent: KMail/1.13.7 (Linux/3.7-1.slh.1-aptosid-amd64; KDE/4.8.4; x86_64; ; )
Cc: LMML <linux-media@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
References: <1358831990-17616-1-git-send-email-prabhakar.lad@ti.com>
In-Reply-To: <1358831990-17616-1-git-send-email-prabhakar.lad@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201301221250.38733.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 22 January 2013 06:19:50 Prabhakar Lad wrote:
> From: Lad, Prabhakar <prabhakar.lad@ti.com>
> 
> The current code was implemented with some default configurations,
> this default configuration works on board and doesn't work on other.
> 
> This patch accepts the configuration through platform data and configures
> the encoder depending on the data passed.
> 
> Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
>   Changes for v2:
>   1: Fixed review comments pointed by Hans.
> 
>  drivers/media/i2c/adv7343.c |   36 +++++++++++++++++++++++++----
>  include/media/adv7343.h     |   52 +++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 83 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/media/i2c/adv7343.c b/drivers/media/i2c/adv7343.c
> index 2b5aa67..a058058 100644
> --- a/drivers/media/i2c/adv7343.c
> +++ b/drivers/media/i2c/adv7343.c
> @@ -43,6 +43,7 @@ MODULE_PARM_DESC(debug, "Debug level 0-1");
>  struct adv7343_state {
>  	struct v4l2_subdev sd;
>  	struct v4l2_ctrl_handler hdl;
> +	const struct adv7343_platform_data *pdata;
>  	u8 reg00;
>  	u8 reg01;
>  	u8 reg02;
> @@ -215,12 +216,23 @@ static int adv7343_setoutput(struct v4l2_subdev *sd, u32 output_type)
>  	/* Enable Appropriate DAC */
>  	val = state->reg00 & 0x03;
>  
> -	if (output_type == ADV7343_COMPOSITE_ID)
> -		val |= ADV7343_COMPOSITE_POWER_VALUE;
> -	else if (output_type == ADV7343_COMPONENT_ID)
> -		val |= ADV7343_COMPONENT_POWER_VALUE;
> +	/* configure default configuration */
> +	if (!state->pdata)
> +		if (output_type == ADV7343_COMPOSITE_ID)
> +			val |= ADV7343_COMPOSITE_POWER_VALUE;
> +		else if (output_type == ADV7343_COMPONENT_ID)
> +			val |= ADV7343_COMPONENT_POWER_VALUE;
> +		else
> +			val |= ADV7343_SVIDEO_POWER_VALUE;
>  	else
> -		val |= ADV7343_SVIDEO_POWER_VALUE;
> +		val = state->pdata->mode_config.sleep_mode << 0 |
> +		      state->pdata->mode_config.pll_control << 1 |
> +		      state->pdata->mode_config.dac_3 << 2 |
> +		      state->pdata->mode_config.dac_2 << 3 |
> +		      state->pdata->mode_config.dac_1 << 4 |
> +		      state->pdata->mode_config.dac_6 << 5 |
> +		      state->pdata->mode_config.dac_5 << 6 |
> +		      state->pdata->mode_config.dac_4 << 7;
>  
>  	err = adv7343_write(sd, ADV7343_POWER_MODE_REG, val);
>  	if (err < 0)
> @@ -238,6 +250,17 @@ static int adv7343_setoutput(struct v4l2_subdev *sd, u32 output_type)
>  
>  	/* configure SD DAC Output 2 and SD DAC Output 1 bit to zero */
>  	val = state->reg82 & (SD_DAC_1_DI & SD_DAC_2_DI);
> +
> +	if (state->pdata && state->pdata->sd_config.sd_dac_out1)
> +		val = val | (state->pdata->sd_config.sd_dac_out1 << 1);
> +	else if (state->pdata && !state->pdata->sd_config.sd_dac_out1)
> +		val = val & ~(state->pdata->sd_config.sd_dac_out1 << 1);
> +
> +	if (state->pdata && state->pdata->sd_config.sd_dac_out2)
> +		val = val | (state->pdata->sd_config.sd_dac_out2 << 2);
> +	else if (state->pdata && !state->pdata->sd_config.sd_dac_out2)
> +		val = val & ~(state->pdata->sd_config.sd_dac_out2 << 2);
> +
>  	err = adv7343_write(sd, ADV7343_SD_MODE_REG2, val);
>  	if (err < 0)
>  		goto setoutput_exit;
> @@ -401,6 +424,9 @@ static int adv7343_probe(struct i2c_client *client,
>  	if (state == NULL)
>  		return -ENOMEM;
>  
> +	/* Copy board specific information here */
> +	state->pdata = client->dev.platform_data;
> +
>  	state->reg00	= 0x80;
>  	state->reg01	= 0x00;
>  	state->reg02	= 0x20;
> diff --git a/include/media/adv7343.h b/include/media/adv7343.h
> index d6f8a4e..944757b 100644
> --- a/include/media/adv7343.h
> +++ b/include/media/adv7343.h
> @@ -20,4 +20,56 @@
>  #define ADV7343_COMPONENT_ID	(1)
>  #define ADV7343_SVIDEO_ID	(2)
>  
> +/**
> + * adv7343_power_mode - power mode configuration.
> + * @sleep_mode: on enable the current consumption is reduced to micro ampere
> + *		level. All DACs and the internal PLL circuit are disabled.
> + *		Registers can be read from and written in sleep mode.
> + * @pll_control: PLL and oversampling control. This control allows internal
> + *		 PLL 1 circuit to be powered down and the oversampling to be
> + *		 switched off.
> + * @dac_1: power on/off DAC 1.
> + * @dac_2: power on/off DAC 2.
> + * @dac_3: power on/off DAC 3.
> + * @dac_4: power on/off DAC 4.
> + * @dac_5: power on/off DAC 5.
> + * @dac_6: power on/off DAC 6.
> + *
> + * Power mode register (Register 0x0), for more info refer REGISTER MAP ACCESS
> + * section of datasheet[1], table 17 page no 30.
> + *
> + * [1] http://www.analog.com/static/imported-files/data_sheets/ADV7342_7343.pdf
> + */
> +struct adv7343_power_mode {
> +	bool sleep_mode;
> +	bool pll_control;
> +	bool dac_1;
> +	bool dac_2;
> +	bool dac_3;
> +	bool dac_4;
> +	bool dac_5;
> +	bool dac_6;
> +};
> +
> +/**
> + * struct adv7343_sd_config - SD Only Output Configuration.
> + * @sd_dac_out1: Configure SD DAC Output 1.
> + * @sd_dac_out2: Configure SD DAC Output 2.
> + */
> +struct adv7343_sd_config {
> +	/* SD only Output Configuration */
> +	bool sd_dac_out1;
> +	bool sd_dac_out2;
> +};
> +
> +/**
> + * struct adv7343_platform_data - Platform data values and access functions.
> + * @mode_config: Configuration for power mode.
> + * @sd_config: SD Only Configuration.
> + */
> +struct adv7343_platform_data {
> +	struct adv7343_power_mode mode_config;
> +	struct adv7343_sd_config sd_config;
> +};
> +
>  #endif				/* End of #ifndef ADV7343_H */
> 
