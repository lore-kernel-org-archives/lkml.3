Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756899Ab3D2LLd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 07:11:33 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:63447 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754242Ab3D2LLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 07:11:30 -0400
MIME-Version: 1.0
In-Reply-To: <20130429082128.GG32299@pengutronix.de>
References: <1367222401-26649-1-git-send-email-prabhakar.csengg@gmail.com> <20130429082128.GG32299@pengutronix.de>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Mon, 29 Apr 2013 16:41:07 +0530
Message-ID: <CA+V-a8uM61Rzqa2y9b6FZVin2FWHg6o9kO7fqHupqq2dcBT3SA@mail.gmail.com>
Subject: Re: [PATCH RFC] media: i2c: mt9p031: add OF support
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: LMML <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>, linux-doc@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sascha,

Thanks for the quick review.

On Mon, Apr 29, 2013 at 1:51 PM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
<Snip>

>> +Required Properties :
>> +- compatible : value should be either one among the following
>> +     (a) "aptina,mt9p031-sensor" for mt9p031 sensor
>> +     (b) "aptina,mt9p031m-sensor" for mt9p031m sensor
>> +
>> +- ext_freq: Input clock frequency.
>> +
>> +- target_freq:  Pixel clock frequency.
>
> For devicetree properties '-' is preferred over '_'. Most devicetree
> bindings we already have suggest that we shoud use 'frequency' and no
> abbreviation. probably 'clock-frequency' should be used.
>
Yeah i missed it..  following is the proposed bindings,
let me know if something is wrong with it.

Required Properties :
- compatible : value should be either one among the following
	(a) "aptina,mt9p031-sensor" for mt9p031 sensor
	(b) "aptina,mt9p031m-sensor" for mt9p031m sensor

- input-clock-frequency: Input clock frequency.

- pixel-clock-frequency: Pixel clock frequency.

Optional Properties :
-gpio-reset: Chip reset GPIO (If not specified defaults to -1)

Example:

i2c0@1c22000 {
	...
	...
	mt9p031@5d {
		compatible = "aptina,mt9p031-sensor";
		reg = <0x5d>;

		port {
			mt9p031_1: endpoint {
				input-clock-frequency = <6000000>;
				pixel-clock-frequency = <96000000>;
				gpio-reset = <&gpio3 30 0>;
			};
		};
	};
	...
};

>> +
>> +Optional Properties :
>> +-reset: Chip reset GPIO (If not specified defaults to -1)
>
> gpios must be specified as phandles, see of_get_named_gpio().
>
Fixed it.

>> +
>> +Example:
>> +
>> +i2c0@1c22000 {
>> +     ...
>> +     ...
>> +     mt9p031@5d {
>> +             compatible = "aptina,mt9p031-sensor";
>> +             reg = <0x5d>;
>> +
>> +             port {
>> +                     mt9p031_1: endpoint {
>> +                             ext_freq = <6000000>;
>> +                             target_freq = <96000000>;
>> +                     };
>> +             };
>> +     };
>> +     ...
>> +};
>> \ No newline at end of file
>> diff --git a/drivers/media/i2c/mt9p031.c b/drivers/media/i2c/mt9p031.c
>> index 28cf95b..66078a6 100644
>> --- a/drivers/media/i2c/mt9p031.c
>> +++ b/drivers/media/i2c/mt9p031.c
>> @@ -23,11 +23,13 @@
>>  #include <linux/regulator/consumer.h>
>>  #include <linux/slab.h>
>>  #include <linux/videodev2.h>
>> +#include <linux/of_device.h>
>>
>>  #include <media/mt9p031.h>
>>  #include <media/v4l2-chip-ident.h>
>>  #include <media/v4l2-ctrls.h>
>>  #include <media/v4l2-device.h>
>> +#include <media/v4l2-of.h>
>>  #include <media/v4l2-subdev.h>
>>
>>  #include "aptina-pll.h"
>> @@ -928,10 +930,66 @@ static const struct v4l2_subdev_internal_ops mt9p031_subdev_internal_ops = {
>>   * Driver initialization and probing
>>   */
>>
>> +#if defined(CONFIG_OF)
>> +static const struct of_device_id mt9p031_of_match[] = {
>> +     {.compatible = "aptina,mt9p031-sensor", },
>> +     {.compatible = "aptina,mt9p031m-sensor", },
>> +     {},
>> +};
>> +MODULE_DEVICE_TABLE(of, mt9p031_of_match);
>> +
>> +static struct mt9p031_platform_data
>> +     *mt9p031_get_pdata(struct i2c_client *client)
>> +
>> +{
>> +     if (!client->dev.platform_data && client->dev.of_node) {
>
> Just because the Kernel is compiled with devicetree support does not
> necessarily mean you actually boot from devicetree. You must still
> handle platform data properly.
>
OK. which one should be given higher preference  client->dev.of_node
or the client->dev.platform_data ?

>> +             struct device_node *np;
>> +             struct mt9p031_platform_data *pdata;
>> +             int ret;
>> +
>> +             np = v4l2_of_get_next_endpoint(client->dev.of_node, NULL);
>> +             if (!np)
>> +                     return NULL;
>> +
>> +             pdata = devm_kzalloc(&client->dev,
>> +                                  sizeof(struct mt9p031_platform_data),
>> +                                  GFP_KERNEL);
>> +             if (!pdata) {
>> +                     pr_warn("mt9p031 failed allocate memeory\n");
>
> Use dev_* for messages inside drivers.
>
Fixed it.

Regards,
--Prabhakar Lad
