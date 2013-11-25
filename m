Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281Ab3KYXkR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 18:40:17 -0500
Received: from gloria.sntech.de ([95.129.55.99]:34692 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751888Ab3KYXkP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 18:40:15 -0500
From: Heiko =?iso-8859-1?q?St=FCbner?= <heiko@sntech.de>
To: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH 2/2] rtc: add hym8563 rtc-driver
Date: Tue, 26 Nov 2013 00:40:01 +0100
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: Alessandro Zummo <a.zummo@towertech.it>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        Mike Turquette <mturquette@linaro.org>
References: <201311222254.07730.heiko@sntech.de> <201311222255.48943.heiko@sntech.de> <20131125120125.GD32081@e106331-lin.cambridge.arm.com>
In-Reply-To: <20131125120125.GD32081@e106331-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201311260040.01716.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 25. November 2013, 13:01:25 schrieb Mark Rutland:
> [...]
> 
> > +static int hym8563_probe(struct i2c_client *client,
> > +                        const struct i2c_device_id *id)
> > +{
> > +       struct hym8563 *hym8563;
> > +       int ret, gpio_int;
> > +
> > +       hym8563 = devm_kzalloc(&client->dev, sizeof(hym8563),
> > GFP_KERNEL); +       if (!hym8563)
> > +               return -ENOMEM;
> > +
> > +       hym8563->client = client;
> > +       i2c_set_clientdata(client, hym8563);
> > +
> > +       device_set_wakeup_capable(&client->dev, true);
> > +
> > +       gpio_int = of_get_gpio(client->dev.of_node, 0);
> > +       if (!gpio_is_valid(gpio_int)) {
> > +               dev_err(&client->dev, "failed to get interrupt gpio\n");
> > +               return -EINVAL;
> > +       }
> > +
> > +       ret = devm_gpio_request_one(&client->dev, gpio_int,
> > +                                     GPIOF_DIR_IN, "hym8563_int");
> > +       if (ret) {
> > +               dev_err(&client->dev, "request of gpio %d failed, %d\n",
> > +                       gpio_int, ret);
> > +               return ret;
> > +       }
> 
> From here on the gpio is never used or even stashed away anywhere.
> What's the point in requesting it and then leaking it?

As I understand it, requesting gpio also is useful as a mechanism to mark them 
as used and therefore prevent a gpio from wrongly being used multiple times.

So, I guess it would be better to either ignore client->irq and just use 
gpio_to_irq or use client->irq alone, without the gpio-functions at all.

But what would be preferrable?
