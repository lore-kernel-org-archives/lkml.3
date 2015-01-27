Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932463AbbA0QQn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 11:16:43 -0500
Received: from mail1.bemta14.messagelabs.com ([193.109.254.107]:34176 "EHLO
	mail1.bemta14.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932436AbbA0QQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 11:16:38 -0500
X-Env-Sender: Adam.Thomson.Opensource@diasemi.com
X-Msg-Ref: server-14.tower-193.messagelabs.com!1422375393!31746282!1
X-Originating-IP: [94.185.165.51]
X-StarScan-Received: 
X-StarScan-Version: 6.12.5; banners=-,-,-
X-VirusChecked: Checked
From: "Opensource [Adam Thomson]" <Adam.Thomson.Opensource@diasemi.com>
To: Varka Bhadram <varkabhadram@gmail.com>,
        "Opensource [Adam Thomson]" <Adam.Thomson.Opensource@diasemi.com>,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Jonathan Cameron <jic23@kernel.org>, Hartmut Knaack <knaack.h@gmx.de>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        Sebastian Reichel <sre@kernel.org>,
        "Dmitry Eremin-Solenikov" <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Support Opensource" <Support.Opensource@diasemi.com>
Subject: RE: [PATCH v6 5/7] power: Add support for DA9150 Charger
Thread-Topic: [PATCH v6 5/7] power: Add support for DA9150 Charger
Thread-Index: AQHQNZGAcklmPzY0TkS8pve6Tv5mWJzKv5YAgAlnhLA=
Date: Tue, 27 Jan 2015 16:16:31 +0000
Message-ID: <2E89032DDAA8B9408CB92943514A0337AB529E6E@SW-EX-MBX01.diasemi.com>
References: <cover.1421854282.git.Adam.Thomson.Opensource@diasemi.com>
 <d9c5c61443e266880cab3cbe7502142439fe9886.1421854282.git.Adam.Thomson.Opensource@diasemi.com>
 <54BFD072.8000707@gmail.com>
In-Reply-To: <54BFD072.8000707@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.20.26.15]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0RGGkqK027047

On January 21, 2015 16:15, Varka Bhadram wrote:

> On Wednesday 21 January 2015 09:16 PM, Adam Thomson wrote:
> > This patch adds support for DA9150 Charger & Fuel-Gauge IC Charger.
> >
> > Signed-off-by: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
> > ---
> 
> (...)
> 
> > +static int da9150_charger_register_irq(struct platform_device *pdev,
> > +				       irq_handler_t handler,
> > +				       const char *irq_name)
> > +{
> > +	struct device *dev = &pdev->dev;
> > +	struct da9150_charger *charger = platform_get_drvdata(pdev);
> > +	int irq, ret;
> > +
> > +	irq = platform_get_irq_byname(pdev, irq_name);
> > +	if (irq < 0) {
> > +		dev_err(dev, "Failed to get IRQ CHG_STATUS: %d\n", irq);
> > +		return irq;
> > +	}
> > +
> > +	ret = request_threaded_irq(irq, NULL, handler, IRQF_ONESHOT, irq_name,
> > +				   charger);
> 
> Why don you use devm_* API..?

As mentioned in previous discussions, the order of tidy up is important so 
devm_* functions cannot be used here.

> 
> > +	if (ret)
> > +		dev_err(dev, "Failed to request IRQ %d: %d\n", irq, ret);
> > +
> > +	return ret;
> > +}
> > +
> > +static void da9150_charger_unregister_irq(struct platform_device *pdev,
> > +					  const char *irq_name)
> > +{
> > +	struct device *dev = &pdev->dev;
> > +	struct da9150_charger *charger = platform_get_drvdata(pdev);
> > +	int irq;
> > +
> > +	irq = platform_get_irq_byname(pdev, irq_name);
> > +	if (irq < 0) {
> > +		dev_err(dev, "Failed to get IRQ CHG_STATUS: %d\n", irq);
> > +		return;
> > +	}
> > +
> > +	free_irq(irq, charger);
> > +}
> > +
> > +static int da9150_charger_probe(struct platform_device *pdev)
> > +{
> > +	struct device *dev = &pdev->dev;
> > +	struct da9150 *da9150 = dev_get_drvdata(dev->parent);
> > +	struct da9150_charger *charger;
> > +	struct power_supply *usb, *battery;
> > +	u8 reg;
> > +	int ret;
> > +
> > +	charger = devm_kzalloc(dev, sizeof(struct da9150_charger), GFP_KERNEL);
> > +	if (charger == NULL)
> > +		return -ENOMEM;
> 
> sizeof(struct da9150_charger) can be replaced with sizeof(*charger)...
> 
> *!* operator can be used in comparison with NULL...
> 

Yes, but functionally no different. Can maybe change this around later, but
would like to avoid changing current patch set right now.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
