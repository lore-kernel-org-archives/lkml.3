Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892AbaJGO4H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 10:56:07 -0400
Received: from mail1.bemta5.messagelabs.com ([195.245.231.144]:10799 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753570AbaJGO4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 10:56:04 -0400
X-Env-Sender: Adam.Thomson.Opensource@diasemi.com
X-Msg-Ref: server-4.tower-179.messagelabs.com!1412693757!38314990!1
X-Originating-IP: [94.185.165.51]
X-StarScan-Received: 
X-StarScan-Version: 6.12.2; banners=-,-,-
X-VirusChecked: Checked
From: "Opensource [Adam Thomson]" <Adam.Thomson.Opensource@diasemi.com>
To: Jonathan Cameron <jic23@kernel.org>,
        "Opensource [Adam Thomson]" <Adam.Thomson.Opensource@diasemi.com>,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
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
        Joe Perches <joe@perches.com>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Support Opensource" <Support.Opensource@diasemi.com>
Subject: RE: [PATCH 3/8] iio: Add support for DA9150 GPADC
Thread-Topic: [PATCH 3/8] iio: Add support for DA9150 GPADC
Thread-Index: AQHP1xygEywc6IiNg0GMK98+C7G0f5wUwoQAgA/5qRA=
Date: Tue, 7 Oct 2014 14:55:55 +0000
Message-ID: <2E89032DDAA8B9408CB92943514A0337AB518D23@SW-EX-MBX01.diasemi.com>
References: <cover.1411396718.git.Adam.Thomson.Opensource@diasemi.com>
 <ee4c56931f326d8ee9c1313c44456bce2dec8b8c.1411396719.git.Adam.Thomson.Opensource@diasemi.com>
 <5426964A.3050407@kernel.org>
In-Reply-To: <5426964A.3050407@kernel.org>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id s97EuCjr017270

On September 27, 2014 11:50, Jonathan Cameron wrote:

> On 23/09/14 11:53, Adam Thomson wrote:
> > This patch adds support for DA9150 Charger & Fuel-Gauge IC GPADC.

> > +
> > +static inline int da9150_gpadc_gpio_6v_voltage_now(int raw_val)
> > +{
> > +	/* Convert to mV */
> > +	return (6 * ((raw_val * 1000) + 500)) / 1024;
> These could all be expressed as raw values with offsets
> and scales (and that would be preferred).
> E.g. This one has offset 500000 and scale 6000/1024 or even
> better use IIO_VAL_FRACTIONAL_LOG2 for scale with val1 = 6000
> and val2 = (log_2 1024) = 10.
> 

What you've suggested isn't correct. The problem here is that the offset is
added first to the raw ADC reading, without factoring the ADC value accordingly
to match the factor of the offset. If we take the original equation provided for
this channel of the ADC, the offset is actually 0.5 which should be added to the
raw ADC value. This doesn't fit into the implementation in the kernel as we
can't use floating point. If we multiply the offset but not the raw ADC value,
then add them before applying the scale factor, then the result is wrong at the
end. Basically you need a scale for the raw ADC value to match the offset scale
so you can achieve the correct results, which is what my calculation does.
But that seems impossible with the current raw|offset|scale method.

> > +	ret = iio_map_array_register(indio_dev, da9150_gpadc_default_maps);
> > +	if (ret) {
> > +		dev_err(dev, "Failed to register IIO maps: %d\n", ret);
> > +		return ret;
> > +	}
> I'd suggest doing the devm_request_thread_irq before the iio_map_array
> stuff.  This is purely to avoid the order during remove not being
> obviously correct as it isn't the reverse of during probe.

Ok, should still work ok that way so can update.

> > +static int da9150_gpadc_remove(struct platform_device *pdev)
> > +{
> > +	struct iio_dev *indio_dev = platform_get_drvdata(pdev);
> > +
> > +	iio_map_array_unregister(indio_dev);
> Twice in one day.  I'm definitely thinking we should add a
> devm version of iio_map_array_register...

I assume you mean here that iio_device_unregister() should come first? Will
update.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
