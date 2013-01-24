Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527Ab3AXKrj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 05:47:39 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:38069 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753116Ab3AXKrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 05:47:31 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
Cc: LMML <linux-media@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        devicetree-discuss@lists.ozlabs.org, LDOC <linux-doc@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH RFC] media: tvp514x: add OF support
Date: Thu, 24 Jan 2013 11:47:30 +0100
Message-ID: <23844927.kqVXuK0AjF@avalon>
User-Agent: KMail/4.9.5 (Linux/3.6.11-gentoo; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1359018740-6399-1-git-send-email-prabhakar.lad@ti.com>
References: <1359018740-6399-1-git-send-email-prabhakar.lad@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Prabhakar,

Thank you for the patch.

Sylwester and Guennadi have posted a DT bindings proposal for V4L2 devices. 
Shouldn't you base this patch on those bindings ?

On Thursday 24 January 2013 14:42:20 Prabhakar Lad wrote:
> From: Lad, Prabhakar <prabhakar.lad@ti.com>
> 
> add OF support for the tvp514x driver.
> 
> Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
>  This patch is on top of following patches:
>  1: https://patchwork.kernel.org/patch/1930941/
>  2: http://patchwork.linuxtv.org/patch/16193/
>  3: https://patchwork.kernel.org/patch/1944901/
> 
>  .../devicetree/bindings/media/i2c/tvp514x.txt      |   30 ++++++++++
>  drivers/media/i2c/tvp514x.c                        |   60 +++++++++++++++--
>  2 files changed, 85 insertions(+), 5 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/media/i2c/tvp514x.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/i2c/tvp514x.txt
> b/Documentation/devicetree/bindings/media/i2c/tvp514x.txt new file mode
> 100644
> index 0000000..3cce323
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/i2c/tvp514x.txt
> @@ -0,0 +1,30 @@
> +* Texas Instruments TVP514x video decoder
> +
> +The TVP5146/TVP5146m2/TVP5147/TVP5147m1 device is high quality, single-chip
> +digital video decoder that digitizes and decodes all popular baseband
> analog +video formats into digital video component. The tvp514x decoder
> supports analog- +to-digital (A/D) conversion of component RGB and YPbPr
> signals as well as A/D +conversion and decoding of NTSC, PAL and SECAM
> composite and S-video into +component YCbCr.
> +
> +Required Properties :
> +- compatible: Must be "ti,tvp514x-decoder"
> +- hsync-active: HSYNC Polarity configuration for current interface.
> +- vsync-active: VSYNC Polarity configuration for current interface.
> +- data-active: Clock polarity of the current interface.
> +
> +Example:
> +
> +i2c0@1c22000 {
> +	...
> +	...
> +
> +	tvp514x@5c {
> +		compatible = "ti,tvp514x-decoder";
> +		reg = <0x5c>;
> +		hsync-active = <1>;	/* Active low (Defaults to 0) */
> +		hsync-active = <1>;	/* Active low (Defaults to 0) */
> +		data-active = <0>;	/* Active low (Defaults to 0) */
> +	};
> +	...
> +};
> diff --git a/drivers/media/i2c/tvp514x.c b/drivers/media/i2c/tvp514x.c
> index a4f0a70..0e2b15c 100644
> --- a/drivers/media/i2c/tvp514x.c
> +++ b/drivers/media/i2c/tvp514x.c
> @@ -12,6 +12,7 @@
>   *     Hardik Shah <hardik.shah@ti.com>
>   *     Manjunath Hadli <mrh@ti.com>
>   *     Karicheri Muralidharan <m-karicheri2@ti.com>
> + *     Prabhakar Lad <prabhakar.lad@ti.com>
>   *
>   * This package is free software; you can redistribute it and/or modify
>   * it under the terms of the GNU General Public License version 2 as
> @@ -930,6 +931,50 @@ static struct tvp514x_decoder tvp514x_dev = {
> 
>  };
> 
> +#if defined(CONFIG_OF)
> +static const struct of_device_id tvp514x_of_match[] = {
> +	{.compatible = "ti,tvp514x-decoder", },
> +	{},
> +}
> +MODULE_DEVICE_TABLE(of, tvp514x_of_match);
> +
> +static struct tvp514x_platform_data
> +	*tvp514x_get_pdata(struct i2c_client *client)
> +{
> +	if (!client->dev.platform_data && client->dev.of_node) {
> +		struct tvp514x_platform_data *pdata;
> +		u32 prop;
> +
> +		pdata = devm_kzalloc(&client->dev,
> +				sizeof(struct tvp514x_platform_data),
> +				GFP_KERNEL);
> +		client->dev.platform_data = pdata;
> +		if (!pdata)
> +			return NULL;
> +		if (!of_property_read_u32(client->dev.of_node,
> +			"data-active", &prop))
> +			pdata->clk_polarity = prop;
> +		if (!of_property_read_u32(client->dev.of_node,
> +			"hsync-active", &prop))
> +			pdata->hs_polarity = prop;
> +		if (!of_property_read_u32(client->dev.of_node,
> +			"vsync-active", &prop))
> +			pdata->vs_polarity = prop;
> +
> +	}
> +
> +	return client->dev.platform_data;
> +}
> +#else
> +#define tvp514x_of_match NULL
> +
> +static struct tvp514x_platform_data
> +	*tvp514x_get_pdata(struct i2c_client *client)
> +{
> +	return client->dev.platform_data;
> +}
> +#endif
> +
>  /**
>   * tvp514x_probe() - decoder driver i2c probe handler
>   * @client: i2c driver client device structure
> @@ -941,6 +986,7 @@ static struct tvp514x_decoder tvp514x_dev = {
>  static int
>  tvp514x_probe(struct i2c_client *client, const struct i2c_device_id *id)
>  {
> +	struct tvp514x_platform_data *pdata;
>  	struct tvp514x_decoder *decoder;
>  	struct v4l2_subdev *sd;
>  	int ret;
> @@ -949,22 +995,25 @@ tvp514x_probe(struct i2c_client *client, const struct
> i2c_device_id *id) if (!i2c_check_functionality(client->adapter,
> I2C_FUNC_SMBUS_BYTE_DATA)) return -EIO;
> 
> +	pdata = tvp514x_get_pdata(client);
> +	if (!pdata) {
> +		v4l2_err(client, "No platform data!!\n");
> +		return -EPROBE_DEFER;
> +	}
> +
>  	decoder = devm_kzalloc(&client->dev, sizeof(*decoder), GFP_KERNEL);
>  	if (!decoder)
>  		return -ENOMEM;
> 
>  	/* Initialize the tvp514x_decoder with default configuration */
>  	*decoder = tvp514x_dev;
> -	if (!client->dev.platform_data) {
> -		v4l2_err(client, "No platform data!!\n");
> -		return -EPROBE_DEFER;
> -	}
> +
>  	/* Copy default register configuration */
>  	memcpy(decoder->tvp514x_regs, tvp514x_reg_list_default,
>  			sizeof(tvp514x_reg_list_default));
> 
>  	/* Copy board specific information here */
> -	decoder->pdata = client->dev.platform_data;
> +	decoder->pdata = pdata;
> 
>  	/**
>  	 * Fetch platform specific data, and configure the
> @@ -1096,6 +1145,7 @@ MODULE_DEVICE_TABLE(i2c, tvp514x_id);
> 
>  static struct i2c_driver tvp514x_driver = {
>  	.driver = {
> +		.of_match_table = tvp514x_of_match,
>  		.owner = THIS_MODULE,
>  		.name = TVP514X_MODULE_NAME,
>  	},
-- 
Regards,

Laurent Pinchart

