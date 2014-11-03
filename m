Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530AbaKCNM6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 08:12:58 -0500
Received: from galahad.ideasonboard.com ([185.26.127.97]:54196 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952AbaKCNMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 08:12:54 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, m.chehab@samsung.com, hverkuil@xs4all.nl
Subject: Re: [PATCH v4] media: spi: Add support for LMH0395
Date: Mon, 03 Nov 2014 15:13:04 +0200
Message-ID: <1630377.tEqlt7fWO7@avalon>
User-Agent: KMail/4.12.5 (Linux/3.16.5-gentoo; KDE/4.12.5; x86_64; ; )
In-Reply-To: <1410342234-7444-1-git-send-email-jean-michel.hautbois@vodalys.com>
References: <1410342234-7444-1-git-send-email-jean-michel.hautbois@vodalys.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean-Michel,

Thank you for the patch.

On Wednesday 10 September 2014 11:43:54 Jean-Michel Hautbois wrote:
> This device is a SPI based device from TI.
> It is a 3 Gbps HD/SD SDI Dual Output Low Power
> Extended Reach Adaptive Cable Equalizer.
> 
> LMH0395 enables the use of up to two outputs.
> These can be configured using DT.
> 
> Controls should be accessible from userspace too.
> This will have to be done later.
> 
> v2: Add DT support
> v3: Change the bit set/clear in output_type as disabled means 'set the bit'
> v4: Clearer description of endpoints usage in Doc, and some init changes.
>     Add a dependency on OF and don't test CONFIG_OF anymore.
> 
> Signed-off-by: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
> ---
>  .../devicetree/bindings/media/spi/lmh0395.txt      |  48 +++
>  MAINTAINERS                                        |   6 +
>  drivers/media/spi/Kconfig                          |  14 +
>  drivers/media/spi/Makefile                         |   1 +
>  drivers/media/spi/lmh0395.c                        | 354 ++++++++++++++++++
>  5 files changed, 423 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/spi/lmh0395.txt
>  create mode 100644 drivers/media/spi/Kconfig
>  create mode 100644 drivers/media/spi/Makefile
>  create mode 100644 drivers/media/spi/lmh0395.c
> 
> diff --git a/Documentation/devicetree/bindings/media/spi/lmh0395.txt
> b/Documentation/devicetree/bindings/media/spi/lmh0395.txt new file mode
> 100644
> index 0000000..7cc0026
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/spi/lmh0395.txt
> @@ -0,0 +1,48 @@
> +* Texas Instruments lmh0395 3G HD/SD SDI equalizer
> +
> +The LMH0395 3 Gbps HD/SD SDI Dual Output Low Power Extended Reach Adaptive
> +Cable Equalizer is designed to equalize data transmitted over cable (or any
> +media with similar dispersive loss characteristics).
> +The equalizer operates over a wide range of data rates from 125 Mbps to
> 2.97 Gbps
> +and supports SMPTE 424M, SMPTE 292M, SMPTE344M, SMPTE 259M, and DVB-ASI
> standards.

That's copied verbatim from the datasheet and not very relevant from a DT 
bindings point of view. I would rather explain what the chip does. Something 
like

"The LMH0395 is an SDI equalizer designed to extend the reach of SDI signals 
transmitted over cable by equalizing the input signal and generating clean 
outputs. It has one differential input and two differential output that can be 
independently controlled."

> +
> +Required Properties :
> +- compatible: Must be "ti,lmh0395"
> +
> +The device node must contain one 'port' child node per device input and
> output
> +port, in accordance with the video interface bindings defined in
> +Documentation/devicetree/bindings/media/video-interfaces.txt. The port
> nodes
> +are numbered as follows.
> +
> +  Port			LMH0395
> +------------------------------------------------------------
> +  SDI input		0
> +  SDI output		1,2

While there shouldn't be much doubt about SDO0 corresponding to port 1 and 
SDO1 to port 2, I'd like that to be mentioned explicitly.

The device node must contain one 'port' child node per device input and output
port, in accordance with the video interface bindings defined in 
Documentation/devicetree/bindings/media/video-interfaces.txt.

The LMH0395 has three ports numbered as follows.

Description            Number
------------------------------------------------------------
SDI (SDI input)		0
SDO0 (SDI output 0)	1
SDO1 (SDI output 1)	2

> +Example:
> +
> +ecspi@02010000 {
> +	...
> +	...
> +
> +	lmh0395@1 {
> +		compatible = "ti,lmh0395";
> +		reg = <1>;
> +		spi-max-frequency = <20000000>;
> +		ports {

You need to add

#address-cells = <1>;
#size-cells = <0>;

here.

> +			port@0 {
> +				reg = <0>;
> +				sdi0_in: endpoint {};
> +			};
> +			port@1 {
> +				reg = <1>;
> +				sdi0_out0: endpoint {};
> +			};
> +			port@2 {
> +				reg = <2>;
> +				/* endpoint not specified, disable output */
> +			};
> +		};
> +	};
> +	...
> +};
> diff --git a/MAINTAINERS b/MAINTAINERS
> index cf24bb5..ca42b9e 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -9141,6 +9141,12 @@ S:	Maintained
>  F:	sound/soc/codecs/lm49453*
>  F:	sound/soc/codecs/isabelle*
> 
> +TI LMH0395 DRIVER
> +M:	Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
> +L:	linux-media@vger.kernel.org
> +S:	Maintained
> +F:	drivers/media/spi/lmh0395*
> +
>  TI LP855x BACKLIGHT DRIVER
>  M:	Milo Kim <milo.kim@ti.com>
>  S:	Maintained
> diff --git a/drivers/media/spi/Kconfig b/drivers/media/spi/Kconfig
> new file mode 100644
> index 0000000..bcb1ab1
> --- /dev/null
> +++ b/drivers/media/spi/Kconfig
> @@ -0,0 +1,14 @@
> +if VIDEO_V4L2
> +
> +config VIDEO_LMH0395
> +	tristate "LMH0395 equalizer"
> +	depends on VIDEO_V4L2 && SPI && MEDIA_CONTROLLER && OF
> +	---help---
> +	  Support for TI LMH0395 3G HD/SD SDI Dual Output Low Power
> +	  Extended Reach Adaptive Cable Equalizer.
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called lmh0395.
> +
> +
> +endif
> diff --git a/drivers/media/spi/Makefile b/drivers/media/spi/Makefile
> new file mode 100644
> index 0000000..6c587e5
> --- /dev/null
> +++ b/drivers/media/spi/Makefile
> @@ -0,0 +1 @@
> +obj-$(CONFIG_VIDEO_LMH0395)	+= lmh0395.o
> diff --git a/drivers/media/spi/lmh0395.c b/drivers/media/spi/lmh0395.c
> new file mode 100644
> index 0000000..3eca0df
> --- /dev/null
> +++ b/drivers/media/spi/lmh0395.c
> @@ -0,0 +1,354 @@
> +/*
> + * LMH0395 SPI driver.
> + * Copyright (C) 2014  Jean-Michel Hautbois
> + *
> + * 3G HD/SD SDI Dual Output Low Power Extended Reach Adaptive Cable
> Equalizer
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/ioctl.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/types.h>
> +#include <linux/slab.h>
> +#include <linux/uaccess.h>
> +#include <linux/spi/spi.h>

Please keep the headers alphabetically ordered.

> +#include <linux/videodev2.h>
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-of.h>
> +
> +static int debug;
> +module_param(debug, int, 0644);
> +MODULE_PARM_DESC(debug, "debug level (0-1)");

I wonder whether this is really needed. If you follow my proposal to implement 
the log_status handler most v4l2_dbg call will turn into info calls. Of the 
two remaining v4l2_dbg calls one could be removed (please see below again), 
and the other turned into a dev_dbg.

> +
> +#define	LMH0395_SPI_CMD_WRITE	0x00
> +#define	LMH0395_SPI_CMD_READ	0x80
> +
> +/* Registers of LMH0395 */
> +#define LMH0395_GENERAL_CTRL		0x00
> +#define LMH0395_OUTPUT_DRIVER		0x01
> +#define LMH0395_LAUNCH_AMP_CTRL		0x02
> +#define LMH0395_MUTE_REF		0x03
> +#define LMH0395_DEVICE_ID		0x04
> +#define	LMH0395_RATE_INDICATOR		0x05
> +#define	LMH0395_CABLE_LENGTH_INDICATOR	0x06
> +#define	LMH0395_LAUNCH_AMP_INDICATION	0x07
> +
> +/* This is a one input, dual output device */
> +#define LMH0395_SDI_INPUT	0
> +#define LMH0395_SDI_OUT0	1
> +#define LMH0395_SDI_OUT1	2
> +
> +#define LMH0395_PADS_NUM	3
> +
> +/* Register LMH0395_MUTE_REF bits [7:6] */
> +enum lmh0395_output_type {
> +	LMH0395_OUTPUT_TYPE_NONE,
> +	LMH0395_OUTPUT_TYPE_SDO0,
> +	LMH0395_OUTPUT_TYPE_SDO1,
> +	LMH0395_OUTPUT_TYPE_BOTH
> +};
> +
> +static const char * const output_strs[] = {
> +	"No Output Driver",
> +	"Output Driver 0",
> +	"Output Driver 1",
> +	"Output Driver 0+1",
> +};
> +
> +
> +/* spi implementation */
> +
> +static int lmh0395_spi_write(struct spi_device *spi, u8 reg, u8 data)
> +{
> +	int err;
> +	u8 cmd[2];
> +
> +	cmd[0] = LMH0395_SPI_CMD_WRITE | reg;
> +	cmd[1] = data;
> +
> +	err = spi_write(spi, cmd, 2);
> +	if (err < 0) {
> +		dev_err(&spi->dev, "SPI failed to select reg\n");

I don't think the message is really accurate. "SPI write failed" would seem a 
better description to me. I would also print the error value, that can be 
useful for debugging.

> +		return err;
> +	}
> +
> +	return err;
> +}
> +
> +static int lmh0395_spi_read(struct spi_device *spi, u8 reg, u8 *data)
> +{
> +	int err;
> +	u8 cmd[2];
> +	u8 read_data[2];
> +
> +	cmd[0] = LMH0395_SPI_CMD_READ | reg;
> +	cmd[1] = 0xff;
> +
> +	err = spi_write(spi, cmd, 2);
> +	if (err < 0) {
> +		dev_err(&spi->dev, "SPI failed to select reg\n");

Same here and below, the error value can be useful.

> +		return err;
> +	}
> +
> +	err = spi_read(spi, read_data, 2);
> +	if (err < 0) {
> +		dev_err(&spi->dev, "SPI failed to read reg\n");
> +		return err;
> +	}
> +	/* The first 8 bits is the adress used, drop it */
> +	*data = read_data[1];
> +
> +	return err;
> +}
> +
> +struct lmh0395_state {
> +	struct v4l2_subdev sd;
> +	struct media_pad pads[LMH0395_PADS_NUM];
> +	enum lmh0395_output_type output_type;
> +};
> +
> +static inline struct lmh0395_state *to_state(struct v4l2_subdev *sd)
> +{
> +	return container_of(sd, struct lmh0395_state, sd);
> +}
> +
> +static int lmh0395_set_output_type(struct v4l2_subdev *sd, u32 output)
> +{
> +	struct lmh0395_state *state = to_state(sd);
> +	struct spi_device *spi = v4l2_get_subdevdata(sd);
> +	u8 muteref_reg;
> +
> +	switch (output) {
> +	case LMH0395_OUTPUT_TYPE_SDO0:
> +		lmh0395_spi_read(spi, LMH0395_MUTE_REF, &muteref_reg);
> +		muteref_reg &= ~(1 << 6);
> +		break;
> +	case LMH0395_OUTPUT_TYPE_SDO1:
> +		lmh0395_spi_read(spi, LMH0395_MUTE_REF, &muteref_reg);
> +		muteref_reg &= (1 << 7);
> +		break;
> +	case LMH0395_OUTPUT_TYPE_BOTH:
> +		lmh0395_spi_read(spi, LMH0395_MUTE_REF, &muteref_reg);
> +		muteref_reg |= 0x00 << 6;

This line does absolutely nothing.

> +		break;
> +	case LMH0395_OUTPUT_TYPE_NONE:
> +		lmh0395_spi_read(spi, LMH0395_MUTE_REF, &muteref_reg);
> +		muteref_reg |= 0x11 << 6;

0x11 << 6, really ?

> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +	v4l2_dbg(1, debug, sd, "Selecting %s output type\n",
> +					output_strs[output]);
> +
> +	/* The following settings will have to be dynamic */
> +	muteref_reg &= ~(0x1f); /* Muteref enable */
> +	muteref_reg |= 1 << 5; /* Digital Muteref */

Just set all the bits explicitly and get rid of the various reads in the case 
statements above, the function will be simpler.

> +	lmh0395_spi_write(spi, LMH0395_MUTE_REF, muteref_reg);
> +
> +	state->output_type = output;
> +	return 0;
> +
> +}
> +
> +static int lmh0395_get_rate(struct v4l2_subdev *sd, u8 *rate)
> +{
> +	struct spi_device *spi = v4l2_get_subdevdata(sd);
> +	int err;
> +	u8 ctrl;
> +
> +	err = lmh0395_spi_read(spi, LMH0395_RATE_INDICATOR, &ctrl);
> +	if (err < 0)
> +		return err;
> +
> +	*rate = ctrl & 0x20;
> +	v4l2_dbg(1, debug, sd, "Rate : %s\n", (ctrl & 0x20)?"3G/HD":"SD");

You need spaces around the ? and the :.

> +	return 0;
> +}
> +
> +static int lmh0395_get_cable_length(struct v4l2_subdev *sd, u8 rate)
> +{
> +	struct spi_device *spi = v4l2_get_subdevdata(sd);
> +	u8 length;
> +	u8 cli;
> +	int err;
> +
> +	err = lmh0395_spi_read(spi, LMH0395_CABLE_LENGTH_INDICATOR, &cli);
> +	if (err < 0)
> +		return err;
> +
> +	/* The cable length indicator (CLI) provides an indication of the
> +	 * length of the cable attached to input. CLI is accessible via bits
> +	 * [7:0] of SPI register 06h.
> +	 * The 8-bit setting ranges in decimal value from 0 to 247
> +	 * ("00000000" to "11110111" binary), corresponding to 0 to 400m of
> +	 * Belden 1694A cable.
> +	 * For 3G and HD input, CLI is 1.25m per step.
> +	 * For SD input, CLI is 1.25m per step, less 20m, from 0 to 191 decimal
> +	 * and 3.5m per step from 192 to 247 decimal.
> +	 */
> +
> +	length = cli*5/4;
> +	if (rate == 0) {
> +		if (cli <= 191)
> +			length -= 20;
> +		else
> +			length = ((191*5/4)-20) + ((cli-191)*7/2);
> +
> +	}
> +	v4l2_dbg(1, debug, sd, "Length estimated (BELDEN 1694A cables) : %dm\n",
> +			length);
> +	return 0;
> +}
> +
> +static int lmh0395_get_control(struct v4l2_subdev *sd)
> +{
> +	int err;
> +	struct spi_device *spi = v4l2_get_subdevdata(sd);
> +	u8 ctrl;
> +	u8 rate;
> +
> +	err = lmh0395_spi_read(spi, LMH0395_GENERAL_CTRL, &ctrl);
> +	if (err < 0)
> +		return err;
> +
> +	if (ctrl & 0x80) {
> +		v4l2_dbg(1, debug, sd, "Carrier detected\n");
> +		lmh0395_get_rate(sd, &rate);
> +		lmh0395_get_cable_length(sd, rate);
> +	}
> +	return 0;
> +}

This function is only called at probe time. Is it really useful ? If you want 
to keep it you should turn it into a subdev log_status handler instead.

> +static int lmh0395_s_routing(struct v4l2_subdev *sd, u32 input, u32 output,
> +				u32 config)
> +{
> +	struct lmh0395_state *state = to_state(sd);
> +	int err = 0;
> +
> +	if (state->output_type != output)
> +		err = lmh0395_set_output_type(sd, output);
> +
> +	return err;

        if (state->output_type == output)
                return 0;

        return lmh0395_set_output_type(sd, output);

You can then get rid of the err variable.

I don't really like this implementation though, the output argument is device-
specific, you thus require explicit knowledge of the LMH0395 in your bridge 
driver.

I'm not sure what the config argument is used for, but naively I would have 
used it to tell whether to enable (1) or disable (0) the route from input to 
output. The input value should then always be 0, and the output value can be 1 
or 2. Another option would be to use the new S_ROUTING userspace ioctl I've 
proposed in 
http://git.linuxtv.org/cgit.cgi/pinchartl/media.git/commit/?h=xilinx-wip&id=fc094c354338861673464ed4b8fa198089fe7bf0.

Hans, could you comment on that ?

> +}
> +
> +static const struct v4l2_subdev_video_ops lmh0395_video_ops = {
> +	.s_routing = lmh0395_s_routing,
> +};
> +
> +static const struct v4l2_subdev_ops lmh0395_ops = {
> +	.video = &lmh0395_video_ops,
> +};
> +
> +static const struct spi_device_id lmh0395_id[] = {
> +	{ "lmh0395", 0 },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(spi, lmh0395_id);
> +
> +static const struct of_device_id lmh0395_of_match[] = {
> +	{.compatible = "ti,lmh0395", },
> +	{ /* sentinel */ },
> +};
> +MODULE_DEVICE_TABLE(of, lmh0395_of_match);
> +
> +static int lmh0395_probe(struct spi_device *spi)
> +{
> +	u8 device_id;
> +	struct lmh0395_state *state;
> +	struct v4l2_subdev *sd;
> +	int err;
> +
> +	err = lmh0395_spi_read(spi, LMH0395_DEVICE_ID, &device_id);
> +	if (err < 0)
> +		return err;
> +
> +	dev_dbg(&spi->dev, "device_id 0x%x\n", device_id);

Shouldn't you validate the device ID value ?

> +	/* Now that the device is here, let's init V4L2 */
> +	state = devm_kzalloc(&spi->dev, sizeof(*state), GFP_KERNEL);
> +	if (!state)
> +		return -ENOMEM;
> +
> +	sd = &state->sd;
> +	v4l2_spi_subdev_init(sd, spi, &lmh0395_ops);
> +
> +	v4l2_dbg(1, debug, sd, "Configuring equalizer\n");

Is this message really useful ? It will always be printed after the device_id 
message above, and thus adds little value. 

> +	lmh0395_get_control(sd);
> +	/* Default is no output */
> +	lmh0395_set_output_type(sd, LMH0395_OUTPUT_TYPE_NONE);
> +
> +	if (spi->dev.of_node) {
> +		struct device_node *n = NULL;
> +		struct of_endpoint ep;
> +
> +		while ((n = of_graph_get_next_endpoint(spi->dev.of_node, n))
> +								!= NULL) {

Philipp Zabel has submitted a patch named "of: Add for_each_endpoint_of_node 
helper macro" that should get merged in v3.19. The patch series modifies the 
behaviour of of_graph_get_next_endpoint() to drop the reference to the prev 
node. This would thus create a problem in the driver, which you should fix by 
using the for_each_endpoint_of_node() macro.

> +			of_graph_parse_endpoint(n, &ep);

You should check the return value.

> +			dev_dbg(&spi->dev, "endpoint %d on port %d\n",
> +						ep.id, ep.port);
> +			/* port 1 => SDO0 */
> +			if (ep.port >= 1)
> +				lmh0395_set_output_type(sd, ep.port);
> +			of_node_put(n);
> +		}
> +	} else {
> +		dev_dbg(&spi->dev, "No DT configuration\n");

Is that a case you want to support ?

> +	}
> +
> +	state->sd.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
> +	state->pads[LMH0395_SDI_INPUT].flags = MEDIA_PAD_FL_SINK;
> +	state->pads[LMH0395_SDI_OUT0].flags = MEDIA_PAD_FL_SOURCE;
> +	state->pads[LMH0395_SDI_OUT1].flags = MEDIA_PAD_FL_SOURCE;
> +	err = media_entity_init(&sd->entity, LMH0395_PADS_NUM, state->pads, 0);
> +	if (err)
> +		return err;
> +
> +	err = v4l2_async_register_subdev(sd);
> +	if (err < 0) {
> +		media_entity_cleanup(&sd->entity);
> +		return err;
> +	}
> +
> +	dev_dbg(&spi->dev, "device probed\n");
> +
> +	return 0;
> +}
> +
> +static int lmh0395_remove(struct spi_device *spi)
> +{
> +	struct v4l2_subdev *sd = spi_get_drvdata(spi);
> +
> +	v4l2_async_unregister_subdev(sd);
> +	media_entity_cleanup(&sd->entity);
> +	return 0;
> +}
> +
> +

There's an extra blank line here.

> +static struct spi_driver lmh0395_driver = {
> +	.driver = {
> +		.of_match_table = lmh0395_of_match,
> +		.name = "lmh0395",
> +		.owner = THIS_MODULE,
> +	},
> +	.probe = lmh0395_probe,
> +	.remove = lmh0395_remove,
> +	.id_table = lmh0395_id,
> +};
> +
> +module_spi_driver(lmh0395_driver);
> +
> +MODULE_DESCRIPTION("spi device driver for LMH0395 equalizer");
> +MODULE_AUTHOR("Jean-Michel Hautbois");
> +MODULE_LICENSE("GPL");

-- 
Regards,

Laurent Pinchart

