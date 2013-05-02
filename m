Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759245Ab3EBNTB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 09:19:01 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:37905 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758558Ab3EBNS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 09:18:59 -0400
MIME-Version: 1.0
In-Reply-To: <1561679.1AUpDgdnFy@avalon>
References: <1367475754-19477-1-git-send-email-prabhakar.csengg@gmail.com>
 <20130502065518.GN32299@pengutronix.de> <CA+V-a8tbbgbyNF37_u-cbWQCDphhb0q+wQSGnBdYVS90o+HSXw@mail.gmail.com>
 <1561679.1AUpDgdnFy@avalon>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Thu, 2 May 2013 18:48:37 +0530
Message-ID: <CA+V-a8sXNhiHhu9HJgFKCAZGZwvqptLy56Akqqu+xDVQ-4amyg@mail.gmail.com>
Subject: Re: [PATCH RFC v2] media: i2c: mt9p031: add OF support
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>, LMML <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,

Thanks for the review.

On Thu, May 2, 2013 at 4:32 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Prabhakar,
>
> Thank you for the patch.
>
> On Thursday 02 May 2013 12:34:25 Prabhakar Lad wrote:
>> On Thu, May 2, 2013 at 12:25 PM, Sascha Hauer wrote:
>> > On Thu, May 02, 2013 at 11:52:34AM +0530, Prabhakar Lad wrote:
>> >> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>> >>
>> >> add OF support for the mt9p031 sensor driver.
>> >> Alongside this patch sorts the header inclusion alphabetically.
>>
>> [Snip]
>>
>> >> +#if defined(CONFIG_OF)
>> >> +static struct mt9p031_platform_data *
>> >> +     mt9p031_get_pdata(struct i2c_client *client)
>
> Please align this line on the left.
>
OK

>> >> +{
>> >> +     if (client->dev.of_node) {
>> >
>> > By inverting the logic here and returning immediately you can safe an
>> > indention level for the bulk of this function.
>>
>> OK
>>
>> >> +             struct device_node *np;
>> >> +             struct mt9p031_platform_data *pdata;
>> >> +
>> >> +             np = v4l2_of_get_next_endpoint(client->dev.of_node, NULL);
>> >> +             if (!np)
>> >> +                     return NULL;
>> >> +
>> >> +             pdata = devm_kzalloc(&client->dev,
>> >> +                                  sizeof(struct mt9p031_platform_data),
>> >> +                                  GFP_KERNEL);
>> >> +             if (!pdata) {
>> >> +                     dev_err(&client->dev,
>> >> +                             "mt9p031 failed allocate memeory\n");
>> >> +                     return NULL;
>> >
>> > s/memeory/memory/
>> >
>> > Better drop this message completely. If you are really out of memory
>> > you'll notice it quite fast anyway.
>>
>> alright I'll drop the message.
>>
>> >> +             }
>> >> +             pdata->reset = of_get_named_gpio(client->dev.of_node,
>> >> +                                              "gpio-reset", 0);
>> >> +             if (!gpio_is_valid(pdata->reset))
>> >> +                     pdata->reset = -1;
>
> I've just sent a patch that converts the manual -1 checks in the driver to
> gpio_is_valid(). You can thus drop these two lines.
>
OK I'll drop this check.

>> >> +             if (of_property_read_u32(np, "input-clock-frequency",
>> >> +                                      &pdata->ext_freq))
>> >> +                     return NULL;
>> >> +
>> >> +             if (of_property_read_u32(np, "pixel-clock-frequency",
>> >> +                                      &pdata->target_freq))
>> >> +                     return NULL;
>> >
>> > returning NULL here means that when these properties are missing the
>> > driver bails out with the message "No platform data\n" which is not
>> > very helpful for users. How about just ignoring this here and return
>> > pdata? The driver will probably print a more useful message later when
>> > it notices that the clock params are invalid.
>>
>> Yes would be good idea of not returning NULL.
>>
>> >> +
>> >> +             return pdata;
>> >> +     }
>> >> +
>> >> +     return client->dev.platform_data;
>> >> +}
>> >> +#else
>> >> +static struct mt9p031_platform_data *
>> >> +     mt9p031_get_pdata(struct i2c_client *client)
>> >> +{
>> >> +     return client->dev.platform_data;
>> >> +}
>> >> +#endif
>> >> +
>> >>
>> >>  static int mt9p031_probe(struct i2c_client *client,
>> >>                        const struct i2c_device_id *did)
>> >>  {
>> >> -     struct mt9p031_platform_data *pdata = client->dev.platform_data;
>> >> +     struct mt9p031_platform_data *pdata = mt9p031_get_pdata(client);
>> >>
>> >>       struct i2c_adapter *adapter = to_i2c_adapter(client->dev.parent);
>> >>       struct mt9p031 *mt9p031;
>> >>       unsigned int i;
>> >> @@ -1070,8 +1120,16 @@ static const struct i2c_device_id mt9p031_id[] = {
>> >>
>> >>  };
>> >>  MODULE_DEVICE_TABLE(i2c, mt9p031_id);
>> >>
>> >> +static const struct of_device_id mt9p031_of_match[] = {
>> >> +     { .compatible = "aptina,mt9p031", },
>> >> +     { .compatible = "aptina,mt9p031m", },
>> >> +     {},
>> >> +};
>> >
>> > I would have expected something like:
>> >
>> > static const struct of_device_id mt9p031_of_match[] = {
>> >         {
>> >                 .compatible = "aptina,mt9p031-sensor",
>> >                 .data = (void *)MT9P031_MODEL_COLOR,
>> >         }, {
>> >                 .compatible = "aptina,mt9p031m-sensor",
>> >                 .data = (void *)MT9P031_MODEL_MONOCHROME,
>> >         }, {
>> >                 /* sentinel */
>> >         },
>> > };
>> >
>> >         of_id = of_match_device(mt9p031_of_match, &client->dev);
>> >         if (of_id)
>> >                 mt9p031->model = (enum mt9p031_model)of_id->data;
>> >
>> > To handle monochrome sensors.
>>
>> OK will do the same.
>
> And please guard the table with #ifdef CONFIG_OF.
>
But guarding the table #ifdef CONFIG_OF would cause compilation failure
for below code when CONFIG_OF is undefined in probe

of_id = of_match_device(of_match_ptr(mt9p031_of_match),
			&client->dev);
if (of_id)
	mt9p031->model = (enum mt9p031_model)of_id->data;

and also in mt9p031_i2c_driver structure,
of_match_table = of_match_ptr(mt9p031_of_match),

which force me to define mt9p031_of_match to NULL when
CONFIG_OF is undefined

Regards,
--Prabhakar Lad
