Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933836Ab3ECOlR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 10:41:17 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:52587 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933750Ab3ECOfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 10:35:03 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
Subject: Re: [PATCH RFC v3] media: i2c: mt9p031: add OF support
Date: Fri, 3 May 2013 16:34:38 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: LMML <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org
References: <1367563919-2880-1-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1367563919-2880-1-git-send-email-prabhakar.csengg@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201305031634.39129.arnd@arndb.de>
X-Provags-ID: V02:K0:2wzERxabqkGSeiYUDzGIdSXc9J43UD25nq07iIU7cH0
 oz9BXgoW2PZOeCk+9nmbQbaKD7+t9fwM8a8cBdMxC5h2Ynwiwb
 CbUPjdGHSTMGdODJE9qvxTMnAGRcMWS4VS8QIrnHWgaCbpw0BZ
 iwYraUVazYvCMGdlUUhZrUsZJdFmHpqXkC3vwGThFu3pAfJAts
 5vesCNflh74Rxyc188Erdo9U1FpG/3hAJJEi9xK+usy6/HzCmz
 +/wQ0Sx4wO0G9BCeP1kwCsTyUMrqnaLZxT7eTCl+qMTZ2gLuQM
 YJKfqOyVdV7S2Pee4f6j86OWXjMijTMPjWg6kFjHXbCrxweW02
 JpHNNiAYHFRHfzVHLN0E=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 May 2013, Prabhakar Lad wrote:
> 
> +static struct mt9p031_platform_data *
> +mt9p031_get_pdata(struct i2c_client *client)
> +{
> +       struct device_node *np;
> +       struct mt9p031_platform_data *pdata;
> +
> +       if (!IS_ENABLED(CONFIG_OF) || !client->dev.of_node)
> +               return client->dev.platform_data;
> +
> +       np = v4l2_of_get_next_endpoint(client->dev.of_node, NULL);
> +       if (!np)
> +               return NULL;
> +
> +       pdata = devm_kzalloc(&client->dev, sizeof(struct mt9p031_platform_data),
> +                            GFP_KERNEL);
> +       if (!pdata)
> +               return NULL;
> +
> +       pdata->reset = of_get_named_gpio(client->dev.of_node, "gpio-reset", 0);
> +       of_property_read_u32(np, "input-clock-frequency", &pdata->ext_freq);
> +       of_property_read_u32(np, "pixel-clock-frequency", &pdata->target_freq);
> +
> +       return pdata;
> +}

Ok, good.

> @@ -955,7 +998,17 @@ static int mt9p031_probe(struct i2c_client *client,
>         mt9p031->pdata = pdata;
>         mt9p031->output_control = MT9P031_OUTPUT_CONTROL_DEF;
>         mt9p031->mode2 = MT9P031_READ_MODE_2_ROW_BLC;
> -       mt9p031->model = did->driver_data;
> +
> +       if (!client->dev.of_node) {
> +               mt9p031->model = (enum mt9p031_model)did->driver_data;
> +       } else {
> +               const struct of_device_id *of_id;
> +
> +               of_id = of_match_device(of_match_ptr(mt9p031_of_match),
> +                                       &client->dev);
> +               if (of_id)
> +                       mt9p031->model = (enum mt9p031_model)of_id->data;
> +       }
>         mt9p031->reset = -1;

Is this actually required? I thought the i2c core just compared the
part of the "compatible" value after the first comma to the string, so
"mt9p031->model = (enum mt9p031_model)did->driver_data" should work
in both cases.

	Arnd
