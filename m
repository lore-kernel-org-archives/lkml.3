Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933443AbaKMQ0b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 11:26:31 -0500
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.163]:47040 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753304AbaKMQ03 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 11:26:29 -0500
X-RZG-AUTH: :JGIXVUS7cutRB/49FwqZ7WcKdUCnXG6JabOfSXKWrat/gtPsyuSM
X-RZG-CLASS-ID: mo00
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH v2 1/5] video: omapdss: Add opa362 driver
From: "Dr. H. Nikolaus Schaller" <hns@goldelico.com>
In-Reply-To: <54649B43.1000801@ti.com>
Date: Thu, 13 Nov 2014 17:25:41 +0100
Cc: Marek Belisko <marek@goldelico.com>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        bcousson@baylibre.com, tony@atomide.com, linux@arm.linux.org.uk,
        plagnioj@jcrosoft.com, grant.likely@linaro.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-fbdev@vger.kernel.org, gta04-owner@goldelico.com
Content-Transfer-Encoding: 8BIT
Message-Id: <9FD016B8-4EA2-4A0D-B790-6494AB449B31@goldelico.com>
References: <1415830247-31633-1-git-send-email-marek@goldelico.com> <1415830247-31633-2-git-send-email-marek@goldelico.com> <54649B43.1000801@ti.com>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Am 13.11.2014 um 12:51 schrieb Tomi Valkeinen <tomi.valkeinen@ti.com>:

> On 13/11/14 00:10, Marek Belisko wrote:
>> opa362 is amplifier for video and can be connected to the tvout pads
>> of the OMAP3. It has one gpio control for enable/disable of the output
>> (high impedance).
>> 
>> Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
>> ---
>> drivers/video/fbdev/omap2/displays-new/Kconfig     |   6 +
>> drivers/video/fbdev/omap2/displays-new/Makefile    |   1 +
>> .../fbdev/omap2/displays-new/amplifier-opa362.c    | 343 +++++++++++++++++++++
> 
> I think it would be better to rename this to encoder-opa362.c. It's not

When developing this driver we did simply rename the encoder-tfp410 file,
but thent hough that it does not fit into the „encoder“ category, because we
would expect something digital or digital to analog „encoding“ which it does not.

> encoder as such, but it falls into the same category.

But we can change it.

> 
>> include/video/omap-panel-data.h                    |  12 +
>> 4 files changed, 362 insertions(+)
>> create mode 100644 drivers/video/fbdev/omap2/displays-new/amplifier-opa362.c
>> 
>> diff --git a/drivers/video/fbdev/omap2/displays-new/Kconfig b/drivers/video/fbdev/omap2/displays-new/Kconfig
>> index e6cfc38..211b3ec 100644
>> --- a/drivers/video/fbdev/omap2/displays-new/Kconfig
>> +++ b/drivers/video/fbdev/omap2/displays-new/Kconfig
>> @@ -1,6 +1,12 @@
>> menu "OMAP Display Device Drivers (new device model)"
>>         depends on OMAP2_DSS
>> 
>> +config DISPLAY_AMPLIFIER_OPA362
> 
> Here also use ENCODER instead.
> 
>> +        tristate "external analog amplifier with output disable/high-Z (e.g. OPA362)"
>> +	help
>> +	  Driver to enable an external analog TV amplifier (e.g. OPA362)
>> +	  through a GPIO.
> 
> The indentation above seems funny.
> 
> The text looks a bit odd. So is this a driver for OPA362, or is this a
> generic driver for any similar devices? Most of the names and code makes
> me think this is a driver for OPA362, but the text above quite clearly
> gives the impression that this is a driver for any analog video amp,
> with single enable gpio.

Hm. We can imagine that there are other devices with similar functionality
and gpio but we have not tested any. So it is indeed better to describe it as
a pure OPA362 driver.

> 
>> +
>> config DISPLAY_ENCODER_TFP410
>>         tristate "TFP410 DPI to DVI Encoder"
>> 	help
>> diff --git a/drivers/video/fbdev/omap2/displays-new/Makefile b/drivers/video/fbdev/omap2/displays-new/Makefile
>> index 0323a8a..b311542 100644
>> --- a/drivers/video/fbdev/omap2/displays-new/Makefile
>> +++ b/drivers/video/fbdev/omap2/displays-new/Makefile
>> @@ -1,3 +1,4 @@
>> +obj-$(CONFIG_DISPLAY_AMPLIFIER_OPA362) += amplifier-opa362.o
>> obj-$(CONFIG_DISPLAY_ENCODER_TFP410) += encoder-tfp410.o
>> obj-$(CONFIG_DISPLAY_ENCODER_TPD12S015) += encoder-tpd12s015.o
>> obj-$(CONFIG_DISPLAY_CONNECTOR_DVI) += connector-dvi.o
>> diff --git a/drivers/video/fbdev/omap2/displays-new/amplifier-opa362.c b/drivers/video/fbdev/omap2/displays-new/amplifier-opa362.c
>> new file mode 100644
>> index 0000000..8065a28
>> --- /dev/null
>> +++ b/drivers/video/fbdev/omap2/displays-new/amplifier-opa362.c
>> @@ -0,0 +1,343 @@
>> +/*
>> + * OPA362 analog video amplifier with output/power control
>> + *
>> + * Copyright (C) 2014 Golden Delicious Computers
>> + * Author: H. Nikolaus Schaller <hns@goldelico.com>
>> + *
>> + * based on encoder-tfp410
>> + *
>> + * Copyright (C) 2013 Texas Instruments
>> + * Author: Tomi Valkeinen <tomi.valkeinen@ti.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify it
>> + * under the terms of the GNU General Public License version 2 as published by
>> + * the Free Software Foundation.
>> + */
>> +
>> +#include <linux/gpio.h>
>> +#include <linux/module.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/slab.h>
>> +#include <linux/of_gpio.h>
>> +
>> +#include <video/omapdss.h>
>> +#include <video/omap-panel-data.h>
>> +
>> +struct panel_drv_data {
>> +	struct omap_dss_device dssdev;
>> +	struct omap_dss_device *in;
>> +
>> +	int enable_gpio;
>> +
>> +	struct omap_video_timings timings;
>> +};
>> +
>> +#define to_panel_data(x) container_of(x, struct panel_drv_data, dssdev)
>> +
>> +static int opa362_connect(struct omap_dss_device *dssdev,
>> +		struct omap_dss_device *dst)
>> +{
>> +	struct panel_drv_data *ddata = to_panel_data(dssdev);
>> +	struct omap_dss_device *in = ddata->in;
>> +	int r;
>> +
>> +	dev_dbg(dssdev->dev, "connect\n");
>> +
>> +	if (omapdss_device_is_connected(dssdev))
>> +		return -EBUSY;
>> +
>> +	r = in->ops.atv->connect(in, dssdev);
>> +	if (r)
>> +		return r;
>> +
>> +	dst->src = dssdev;
>> +	dssdev->dst = dst;
>> +
>> +	return 0;
>> +}
>> +
>> +static void opa362_disconnect(struct omap_dss_device *dssdev,
>> +		struct omap_dss_device *dst)
>> +{
>> +	struct panel_drv_data *ddata = to_panel_data(dssdev);
>> +	struct omap_dss_device *in = ddata->in;
>> +
>> +	dev_dbg(dssdev->dev, "disconnect\n");
>> +
>> +	WARN_ON(!omapdss_device_is_connected(dssdev));
>> +	if (!omapdss_device_is_connected(dssdev))
>> +		return;
>> +
>> +	WARN_ON(dst != dssdev->dst);
>> +	if (dst != dssdev->dst)
>> +		return;
>> +
>> +	dst->src = NULL;
>> +	dssdev->dst = NULL;
>> +
>> +	in->ops.atv->disconnect(in, &ddata->dssdev);
>> +}
>> +
>> +static int opa362_enable(struct omap_dss_device *dssdev)
>> +{
>> +	struct panel_drv_data *ddata = to_panel_data(dssdev);
>> +	struct omap_dss_device *in = ddata->in;
>> +	int r;
>> +
>> +	dev_dbg(dssdev->dev, "enable\n");
>> +
>> +	if (!omapdss_device_is_connected(dssdev))
>> +		return -ENODEV;
>> +
>> +	if (omapdss_device_is_enabled(dssdev))
>> +		return 0;
>> +
>> +	in->ops.atv->set_timings(in, &ddata->timings);
>> +	/* fixme: should we receive the invert from our consumer, i.e. the connector? */
>> +	in->ops.atv->invert_vid_out_polarity(in, true);
> 
> Well this does seem to be broken. I don't know what the answer to the
> question above is, but the code doesn't work properly.
> 
> In the opa362_invert_vid_out_polarity function below, you get the invert
> boolean from the connector. This you pass to the OMAP venc. However,
> above you always override that value in venc with true.
> 
> So, either the invert_vid_out_polarity value has to be always true or
> false, because _OPA362_ requires it to be true or false, OR you need use
> the value from the connector.
> 
> Seeing the comment in opa362_invert_vid_out_polarity, my guess is the
> latter, and the call above should be removed.

Yes, you are right - this is not systematic.

But the problem is that we can’t ask the connector here what it wants
to see. It might (or might not) call our opa362_invert_vid_out_polarity() later
which we can then forward to overwrite the inital state of this opa362_enable().

What it should be is something like

in->ops.atv->invert_vid_out_polarity(in, ! out->ops.atv->get_expected_vid_output_polarity())

but that does not exist and I am not sure if you want to introduce it.

So I only see the option that we always use 

in->ops.atv->invert_vid_out_polarity(in, true);

and do a sanity check in opa362_invert_vid_out_polarity() to block a connector
that is requesting the wrong polarity.

> 
>> +
>> +	r = in->ops.atv->enable(in);
>> +	if (r)
>> +		return r;
>> +
>> +	if (gpio_is_valid(ddata->enable_gpio))
>> +		gpio_set_value_cansleep(ddata->enable_gpio, 1);
>> +
>> +	dssdev->state = OMAP_DSS_DISPLAY_ACTIVE;
>> +
>> +	return 0;
>> +}
>> +
>> +static void opa362_disable(struct omap_dss_device *dssdev)
>> +{
>> +	struct panel_drv_data *ddata = to_panel_data(dssdev);
>> +	struct omap_dss_device *in = ddata->in;
>> +
>> +	dev_dbg(dssdev->dev, "disable\n");
>> +
>> +	if (!omapdss_device_is_enabled(dssdev))
>> +		return;
>> +
>> +	if (gpio_is_valid(ddata->enable_gpio))
>> +		gpio_set_value_cansleep(ddata->enable_gpio, 0);
>> +
>> +	in->ops.atv->disable(in);
>> +
>> +	dssdev->state = OMAP_DSS_DISPLAY_DISABLED;
>> +}
>> +
>> +static void opa362_set_timings(struct omap_dss_device *dssdev,
>> +		struct omap_video_timings *timings)
>> +{
>> +	struct panel_drv_data *ddata = to_panel_data(dssdev);
>> +	struct omap_dss_device *in = ddata->in;
>> +
>> +	dev_dbg(dssdev->dev, "set_timings\n");
>> +
>> +	ddata->timings = *timings;
>> +	dssdev->panel.timings = *timings;
>> +
>> +	in->ops.atv->set_timings(in, timings);
>> +}
>> +
>> +static void opa362_get_timings(struct omap_dss_device *dssdev,
>> +		struct omap_video_timings *timings)
>> +{
>> +	struct panel_drv_data *ddata = to_panel_data(dssdev);
>> +
>> +	dev_dbg(dssdev->dev, "get_timings\n");
>> +
>> +	*timings = ddata->timings;
>> +}
>> +
>> +static int opa362_check_timings(struct omap_dss_device *dssdev,
>> +		struct omap_video_timings *timings)
>> +{
>> +	struct panel_drv_data *ddata = to_panel_data(dssdev);
>> +	struct omap_dss_device *in = ddata->in;
>> +
>> +	dev_dbg(dssdev->dev, "check_timings\n");
>> +
>> +	return in->ops.atv->check_timings(in, timings);
>> +}
>> +
>> +static void opa362_set_type(struct omap_dss_device *dssdev,
>> +		enum omap_dss_venc_type type)
>> +{
>> +	/* we can only drive a COMPOSITE output */
>> +	WARN_ON(type != OMAP_DSS_VENC_TYPE_COMPOSITE);
>> +
>> +}
>> +
>> +static void opa362_invert_vid_out_polarity(struct omap_dss_device *dssdev,
>> +		bool invert_polarity)
>> +{
>> +	struct panel_drv_data *ddata = to_panel_data(dssdev);
>> +	struct omap_dss_device *in = ddata->in;
>> +
>> +	/* OPA362 inverts the polarity */
>> +	in->ops.atv->invert_vid_out_polarity(in, !invert_polarity);
>> +}
>> +
>> +static const struct omapdss_atv_ops opa362_atv_ops = {
>> +	.connect	= opa362_connect,
>> +	.disconnect	= opa362_disconnect,
>> +
>> +	.enable		= opa362_enable,
>> +	.disable	= opa362_disable,
>> +
>> +	.check_timings	= opa362_check_timings,
>> +	.set_timings	= opa362_set_timings,
>> +	.get_timings	= opa362_get_timings,
>> +
>> +	.set_type	= opa362_set_type,
>> +	.invert_vid_out_polarity	= opa362_invert_vid_out_polarity,
>> +};
>> +
>> +static int opa362_probe_pdata(struct platform_device *pdev)
>> +{
>> +	struct panel_drv_data *ddata = platform_get_drvdata(pdev);
>> +	struct amplifier_opa362_platform_data *pdata;
>> +	struct omap_dss_device *dssdev, *in;
>> +
>> +	pdata = dev_get_platdata(&pdev->dev);
>> +
>> +	ddata->enable_gpio = pdata->enable_gpio;
>> +
>> +	in = omap_dss_find_output(pdata->source);
>> +	if (in == NULL) {
>> +		dev_err(&pdev->dev, "Failed to find video source\n");
>> +		return -ENODEV;
>> +	}
>> +
>> +	ddata->in = in;
>> +
>> +	dssdev = &ddata->dssdev;
>> +	dssdev->name = pdata->name;
>> +
>> +	return 0;
>> +}
> 
> We are going to support only DT boot at some point. Thus I think the
> whole platform data code should be left out.

Is there already a decision? I think it should not be done before. And it
does not harm to still have it.

> 
>> +
>> +static int opa362_probe_of(struct platform_device *pdev)
>> +{
>> +	struct panel_drv_data *ddata = platform_get_drvdata(pdev);
>> +	struct device_node *node = pdev->dev.of_node;
>> +	struct omap_dss_device *in;
>> +	int gpio;
>> +
>> +	gpio = of_get_gpio(node, 0);
>> +
>> +	if (gpio_is_valid(gpio) || gpio == -ENOENT) {
>> +		ddata->enable_gpio = gpio;
>> +	} else {
>> +		dev_err(&pdev->dev, "failed to parse enable gpio\n");
>> +		return gpio;
>> +	}
> 
> You should use the new GPIO API to get full support from the DT data.
> For an example, see panel-dpi.c's enable_gpio.

Ok.

BR,
Nikolaus

