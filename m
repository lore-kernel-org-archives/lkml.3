Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758024Ab3ENPd6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 11:33:58 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:44985 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753369Ab3ENPd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 11:33:57 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Lad Prabhakar <prabhakar.csengg@gmail.com>
Cc: LMML <linux-media@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH 5/5] media: i2c: tvp7002: add OF support
Date: Tue, 14 May 2013 17:34:15 +0200
Message-ID: <4149647.zqpmlIlQDP@avalon>
User-Agent: KMail/4.10.2 (Linux/3.7.10-gentoo-r1; KDE/4.10.2; x86_64; ; )
In-Reply-To: <1368528334-13595-6-git-send-email-prabhakar.csengg@gmail.com>
References: <1368528334-13595-1-git-send-email-prabhakar.csengg@gmail.com> <1368528334-13595-6-git-send-email-prabhakar.csengg@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Prabhakar,

Thank you for the patch.

On Tuesday 14 May 2013 16:15:34 Lad Prabhakar wrote:
> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> 
> add OF support for the tvp7002 driver.
> 
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Cc: Sakari Ailus <sakari.ailus@iki.fi>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: Rob Landley <rob@landley.net>
> Cc: devicetree-discuss@lists.ozlabs.org
> Cc: linux-doc@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: davinci-linux-open-source@linux.davincidsp.com
> ---
>  .../devicetree/bindings/media/i2c/tvp7002.txt      |   42 +++++++++++++
>  drivers/media/i2c/tvp7002.c                        |   64 +++++++++++++++--
>  2 files changed, 99 insertions(+), 7 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/media/i2c/tvp7002.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/i2c/tvp7002.txt
> b/Documentation/devicetree/bindings/media/i2c/tvp7002.txt new file mode
> 100644
> index 0000000..1ebd8b1
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/i2c/tvp7002.txt
> @@ -0,0 +1,42 @@
> +* Texas Instruments TV7002 video decoder
> +
> +The TVP7002 device supports digitizing of video and graphics signal in RGB
> and
> +YPbPr color space.
> +
> +Required Properties :
> +- compatible : Must be "ti,tvp7002"
> +
> +- hsync-active: HSYNC Polarity configuration for endpoint.
> +
> +- vsync-active: VSYNC Polarity configuration for endpoint.
> +
> +- pclk-sample: Clock polarity of the endpoint.
> +
> +- ti,tvp7002-fid-polarity: Active-high Field ID polarity of the endpoint.
> +
> +- ti,tvp7002-sog-polarity: Sync on Green output polarity of the endpoint.

Would it make sense to define field-active and sog-active properties in the 
V4L2 bindings instead of having per-chip properties ?

> +For further reading of port node refer
> Documentation/devicetree/bindings/media/ +video-interfaces.txt.
> +
> +Example:
> +
> +	i2c0@1c22000 {
> +		...
> +		...
> +		tvp7002@5c {
> +			compatible = "ti,tvp7002";
> +			reg = <0x5c>;
> +
> +			port {
> +				tvp7002_1: endpoint {
> +					hsync-active = <1>;
> +					vsync-active = <1>;
> +					pclk-sample = <0>;
> +					ti,tvp7002-fid-polarity;
> +					ti,tvp7002-sog-polarity;
> +				};
> +			};
> +		};
> +		...
> +	};
> diff --git a/drivers/media/i2c/tvp7002.c b/drivers/media/i2c/tvp7002.c
> index d5113d1..942e0d8 100644
> --- a/drivers/media/i2c/tvp7002.c
> +++ b/drivers/media/i2c/tvp7002.c
> @@ -35,6 +35,7 @@
>  #include <media/v4l2-chip-ident.h>
>  #include <media/v4l2-ctrls.h>
>  #include <media/v4l2-device.h>
> +#include <media/v4l2-of.h>
> 
>  #include "tvp7002_reg.h"
> 
> @@ -976,6 +977,46 @@ static const struct v4l2_subdev_ops tvp7002_ops = {
>  	.pad = &tvp7002_pad_ops,
>  };
> 
> +static struct tvp7002_config *
> +tvp7002_get_pdata(struct i2c_client *client)
> +{
> +	struct v4l2_of_endpoint bus_cfg;
> +	struct tvp7002_config *pdata;
> +	struct device_node *endpoint;
> +	unsigned int flags;
> +
> +	if (!IS_ENABLED(CONFIG_OF) || !client->dev.of_node)
> +		return client->dev.platform_data;
> +
> +	endpoint = v4l2_of_get_next_endpoint(client->dev.of_node, NULL);
> +	if (!endpoint)
> +		return NULL;
> +
> +	pdata = devm_kzalloc(&client->dev, sizeof(*pdata), GFP_KERNEL);
> +	if (!pdata)
> +		return NULL;
> +
> +	v4l2_of_parse_endpoint(endpoint, &bus_cfg);
> +	flags = bus_cfg.bus.parallel.flags;
> +
> +	if (flags & V4L2_MBUS_HSYNC_ACTIVE_HIGH)
> +		pdata->hs_polarity = 1;
> +
> +	if (flags & V4L2_MBUS_VSYNC_ACTIVE_HIGH)
> +		pdata->vs_polarity = 1;
> +
> +	if (flags & V4L2_MBUS_PCLK_SAMPLE_RISING)
> +		pdata->clk_polarity = 1;
> +
> +	pdata->fid_polarity = of_property_read_bool(endpoint,
> +						    "ti,tvp7002-fid-polarity");
> +
> +	pdata->sog_polarity = of_property_read_bool(endpoint,
> +						    "ti,tvp7002-sog-polarity");
> +
> +	return pdata;
> +}
> +
>  /*
>   * tvp7002_probe - Probe a TVP7002 device
>   * @c: ptr to i2c_client struct
> @@ -987,32 +1028,32 @@ static const struct v4l2_subdev_ops tvp7002_ops = {
>   */
>  static int tvp7002_probe(struct i2c_client *c, const struct i2c_device_id
> *id) {
> +	struct tvp7002_config *pdata = tvp7002_get_pdata(c);
>  	struct v4l2_subdev *sd;
>  	struct tvp7002 *device;
>  	struct v4l2_dv_timings timings;
>  	int polarity_a;
>  	int polarity_b;
>  	u8 revision;
> -
>  	int error;
> 
> +	if (pdata == NULL) {
> +		dev_err(&c->dev, "No platform data\n");
> +		return -EINVAL;
> +	}
> +
>  	/* Check if the adapter supports the needed features */
>  	if (!i2c_check_functionality(c->adapter,
>  		I2C_FUNC_SMBUS_READ_BYTE | I2C_FUNC_SMBUS_WRITE_BYTE_DATA))
>  		return -EIO;
> 
> -	if (!c->dev.platform_data) {
> -		v4l_err(c, "No platform data!!\n");
> -		return -ENODEV;
> -	}
> -
>  	device = devm_kzalloc(&c->dev, sizeof(struct tvp7002), GFP_KERNEL);
> 
>  	if (!device)
>  		return -ENOMEM;
> 
>  	sd = &device->sd;
> -	device->pdata = c->dev.platform_data;
> +	device->pdata = pdata;
>  	device->current_timings = tvp7002_timings;
> 
>  	/* Tell v4l2 the device is ready */
> @@ -1119,9 +1160,18 @@ static const struct i2c_device_id tvp7002_id[] = {
>  };
>  MODULE_DEVICE_TABLE(i2c, tvp7002_id);
> 
> +#if IS_ENABLED(CONFIG_OF)
> +static const struct of_device_id tvp7002_of_match[] = {
> +	{ .compatible = "ti,tvp7002", },
> +	{ /* sentinel */ },
> +};
> +MODULE_DEVICE_TABLE(of, tvp7002_of_match);
> +#endif
> +
>  /* I2C driver data */
>  static struct i2c_driver tvp7002_driver = {
>  	.driver = {
> +		.of_match_table = of_match_ptr(tvp7002_of_match),
>  		.owner = THIS_MODULE,
>  		.name = TVP7002_MODULE_NAME,
>  	},
-- 
Regards,

Laurent Pinchart

