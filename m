Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194Ab3BCKOO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 05:14:14 -0500
Received: from mail-qa0-f41.google.com ([209.85.216.41]:48264 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752960Ab3BCKOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 05:14:11 -0500
MIME-Version: 1.0
In-Reply-To: <510C43A0.7090906@gmail.com>
References: <1359464832-8875-1-git-send-email-prabhakar.lad@ti.com> <510C43A0.7090906@gmail.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Sun, 3 Feb 2013 15:43:49 +0530
Message-ID: <CA+V-a8u6VADw_HfbBN4ESGUXTSMKfVyKZaEf1bhVGACof6qZ8A@mail.gmail.com>
Subject: Re: [PATCH RFC v2] media: tvp514x: add OF support
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: LMML <linux-media@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sylwester,

Thanks for the review.

On Sat, Feb 2, 2013 at 4:07 AM, Sylwester Nawrocki
<sylvester.nawrocki@gmail.com> wrote:
> Hi Prabhakar,
>
> On 01/29/2013 02:07 PM, Prabhakar Lad wrote:
> [...]
>
>> diff --git a/Documentation/devicetree/bindings/media/i2c/tvp514x.txt
>> b/Documentation/devicetree/bindings/media/i2c/tvp514x.txt
>> new file mode 100644
>> index 0000000..55d3ffd
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/media/i2c/tvp514x.txt
>> @@ -0,0 +1,38 @@
>> +* Texas Instruments TVP514x video decoder
>> +
>> +The TVP5146/TVP5146m2/TVP5147/TVP5147m1 device is high quality,
>> single-chip
>> +digital video decoder that digitizes and decodes all popular baseband
>> analog
>> +video formats into digital video component. The tvp514x decoder supports
>> analog-
>> +to-digital (A/D) conversion of component RGB and YPbPr signals as well as
>> A/D
>> +conversion and decoding of NTSC, PAL and SECAM composite and S-video into
>> +component YCbCr.
>> +
>> +Required Properties :
>> +- compatible: Must be "ti,tvp514x-decoder"
>
>
> There are no significant differences among TVP514* devices as listed above,
> you would like to handle above ?
>
> I'm just wondering if you don't need ,for instance, two separate compatible
> properties, e.g. "ti,tvp5146-decoder" and "ti,tvp5147-decoder" ?
>
There are few differences in init/power sequence tough, I would still
like to have
single compatible property "ti,tvp514x-decoder", If you feel we need separate
property I will change it please let me know on this.

>
>> +- hsync-active: HSYNC Polarity configuration for current interface.
>> +- vsync-active: VSYNC Polarity configuration for current interface.
>> +- data-active: Clock polarity of the current interface.
>
>
> I guess you mean "pclk-sample: Clock polarity..." ?
>
>
yeah this needs to be 'pclk-sample' property, thanks for pointing it.

>> +
>> +Example:
>> +
>> +i2c0@1c22000 {
>> +       ...
>> +       ...
>> +
>> +       tvp514x@5c {
>> +               compatible = "ti,tvp514x-decoder";
>> +               reg =<0x5c>;
>> +
>> +               port {
>> +                       tvp514x_1: endpoint {
>> +                               /* Active high (Defaults to 0) */
>> +                               hsync-active =<1>;
>> +                               /* Active high (Defaults to 0) */
>> +                               hsync-active =<1>;
>
>
> Should it be vsync-active ?
>
Yes, I'll change it.
>
>> +                               /* Active low (Defaults to 0) */
>> +                               data-active =<0>;
>
>
> and this pclk-sample ?
>
Yes.

>> +                       };
>> +               };
>> +       };
>> +       ...
>> +};
>> diff --git a/drivers/media/i2c/tvp514x.c b/drivers/media/i2c/tvp514x.c
>> index a4f0a70..24ce759 100644
>> --- a/drivers/media/i2c/tvp514x.c
>> +++ b/drivers/media/i2c/tvp514x.c
>> @@ -12,6 +12,7 @@
>>    *     Hardik Shah<hardik.shah@ti.com>
>>    *     Manjunath Hadli<mrh@ti.com>
>>    *     Karicheri Muralidharan<m-karicheri2@ti.com>
>> + *     Prabhakar Lad<prabhakar.lad@ti.com>
>>    *
>>    * This package is free software; you can redistribute it and/or modify
>>    * it under the terms of the GNU General Public License version 2 as
>> @@ -33,7 +34,9 @@
>>   #include<linux/delay.h>
>>   #include<linux/videodev2.h>
>>   #include<linux/module.h>
>> +#include<linux/of_device.h>
>>
>> +#include<media/v4l2-of.h>
>>   #include<media/v4l2-async.h>
>>   #include<media/v4l2-device.h>
>>   #include<media/v4l2-common.h>
>> @@ -930,6 +933,58 @@ static struct tvp514x_decoder tvp514x_dev = {
>>
>>   };
>>
>> +#if defined(CONFIG_OF)
>> +static const struct of_device_id tvp514x_of_match[] = {
>> +       {.compatible = "ti,tvp514x-decoder", },
>> +       {},
>> +};
>> +MODULE_DEVICE_TABLE(of, tvp514x_of_match);
>> +
>> +static struct tvp514x_platform_data
>> +       *tvp514x_get_pdata(struct i2c_client *client)
>> +{
>> +       if (!client->dev.platform_data&&  client->dev.of_node) {
>>
>> +               struct tvp514x_platform_data *pdata;
>> +               struct v4l2_of_endpoint bus_cfg;
>> +               struct device_node *endpoint;
>> +
>> +               pdata = devm_kzalloc(&client->dev,
>> +                               sizeof(struct tvp514x_platform_data),
>> +                               GFP_KERNEL);
>> +               client->dev.platform_data = pdata;
>
>
> Do you really need to set client->dev.platform_data this way ?
> What about passing struct tvp514x_decoder pointer to this function
> and initializing struct tvp514x_decoder::pdata instead ?
>
>
Yes that can work too, I'll do the same.

>> +               if (!pdata)
>> +                       return NULL;
>> +
>> +               endpoint = of_get_child_by_name(client->dev.of_node,
>> "port");
>> +               if (endpoint)
>> +                       endpoint = of_get_child_by_name(endpoint,
>> "endpoint");
>
>
> I think you could replace these two calls above with
>
>                 endpoint = v4l2_of_get_next_endpoint(client->dev.of_node);
>
Ok

> Now I see I should have modified this function to ensure it works also when
> 'port' nodes are grouped in a 'ports' node.
>
So V5 series of V4l OF parser doesn't have this fix ?

Regards,
--Prabhakar

>> +               if (!endpoint) {
>> +                       v4l2_info(client, "Using default data!!\n");
>> +               } else {
>> +                       v4l2_of_parse_parallel_bus(endpoint,&bus_cfg);
>> +
>> +                       if (bus_cfg.mbus_flags&
>> V4L2_MBUS_HSYNC_ACTIVE_HIGH)
>>
>> +                               pdata->hs_polarity = 1;
>> +                       if (bus_cfg.mbus_flags&
>> V4L2_MBUS_VSYNC_ACTIVE_HIGH)
>>
>> +                               pdata->vs_polarity = 1;
>> +                       if (bus_cfg.mbus_flags&
>> V4L2_MBUS_PCLK_SAMPLE_RISING)
>>
>> +                               pdata->clk_polarity = 1;
>> +               }
>> +       }
>> +
>> +       return client->dev.platform_data;
>> +}
>> +#else
>> +#define tvp514x_of_match NULL
>> +
>> +static struct tvp514x_platform_data
>> +       *tvp514x_get_pdata(struct i2c_client *client)
>> +{
>> +       return client->dev.platform_data;
>> +}
>> +#endif
>> +
>>   /**
>>    * tvp514x_probe() - decoder driver i2c probe handler
>>    * @client: i2c driver client device structure
>> @@ -941,6 +996,7 @@ static struct tvp514x_decoder tvp514x_dev = {
>>   static int
>>   tvp514x_probe(struct i2c_client *client, const struct i2c_device_id *id)
>>   {
>> +       struct tvp514x_platform_data *pdata;
>>         struct tvp514x_decoder *decoder;
>>         struct v4l2_subdev *sd;
>>         int ret;
>> @@ -949,22 +1005,25 @@ tvp514x_probe(struct i2c_client *client, const
>> struct i2c_device_id *id)
>>         if (!i2c_check_functionality(client->adapter,
>> I2C_FUNC_SMBUS_BYTE_DATA))
>>                 return -EIO;
>>
>> +       pdata = tvp514x_get_pdata(client);
>> +       if (!pdata) {
>> +               v4l2_err(client, "No platform data!!\n");
>> +               return -EPROBE_DEFER;
>> +       }
>> +
>>         decoder = devm_kzalloc(&client->dev, sizeof(*decoder),
>> GFP_KERNEL);
>>         if (!decoder)
>>                 return -ENOMEM;
>>
>>         /* Initialize the tvp514x_decoder with default configuration */
>>         *decoder = tvp514x_dev;
>> -       if (!client->dev.platform_data) {
>> -               v4l2_err(client, "No platform data!!\n");
>> -               return -EPROBE_DEFER;
>> -       }
>> +
>>         /* Copy default register configuration */
>>         memcpy(decoder->tvp514x_regs, tvp514x_reg_list_default,
>>                         sizeof(tvp514x_reg_list_default));
>>
>>         /* Copy board specific information here */
>> -       decoder->pdata = client->dev.platform_data;
>> +       decoder->pdata = pdata;
>>
>>         /**
>>          * Fetch platform specific data, and configure the
>> @@ -1096,6 +1155,7 @@ MODULE_DEVICE_TABLE(i2c, tvp514x_id);
>>
>>   static struct i2c_driver tvp514x_driver = {
>>         .driver = {
>> +               .of_match_table = tvp514x_of_match,
>>                 .owner = THIS_MODULE,
>>                 .name = TVP514X_MODULE_NAME,
>>         },
>
>
> --
>
> Regards,
> Sylwester
