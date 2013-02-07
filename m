Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755805Ab3BGJZc (ORCPT <rfc822;list-kernel77@spinics.net>);
	Thu, 7 Feb 2013 04:25:32 -0500
Received: from fallback7.mail.ru ([94.100.176.135]:38174 "EHLO
	fallback7.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755140Ab3BGJZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 04:25:28 -0500
X-Greylist: delayed 2607 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Feb 2013 04:25:27 EST
From: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
To: =?UTF-8?B?RG9uZyBBaXNoZW5n?= <b29396@freescale.com>
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?B?U2FtdWVsIE9ydGl6?= <sameo@linux.intel.com>,
        =?UTF-8?B?TWFyayBCcm93bg==?= <broonie@opensource.wolfsonmicro.com>,
        =?UTF-8?B?RG9uZyBBaXNoZW5n?= <dong.aisheng@linaro.org>
Subject: =?UTF-8?B?UmVbMl06IFtQQVRDSF0gbWZkOiBzeXNjb246IEFkZGVkIHN1cHBvcnQgZm9y?=
 =?UTF-8?B?IHVzaW5nIHBsYXRmb3JtIGRyaXZlciByZXNvdXJjZXM=?=
Mime-Version: 1.0
X-Mailer: Mail.Ru Mailer 1.0
X-Originating-IP: [217.119.30.118]
Date: Thu, 07 Feb 2013 12:41:34 +0400
Reply-To: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
X-Priority: 3 (Normal)
Message-ID: <1360226494.178606955@f137.mail.ru>
Content-Type: text/plain; charset=utf-8
X-Spam: Not detected
X-Mras: Ok
In-Reply-To: <20130207072931.GT22003@b29396-Latitude-E6410>
References: <1359990040-5339-1-git-send-email-shc_work@mail.ru> <20130207072931.GT22003@b29396-Latitude-E6410>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by spinics.net id r179Perq007365

Hello.
...
> Thanks for the patch adding non-dt support. :-)
> 
> On Mon, Feb 04, 2013 at 07:00:40PM +0400, Alexander Shiyan wrote:
> > This patch adds support usage platform driver resources, i.e.
> > possibility works without oftree support. Additionally patch
> > removes CONFIG_OF dependency and adds helper for accessing
> > regmap by searching device by its name.
...
> > +static int syscon_match_name(struct device *dev, void *data)
> > +{
> > +	return !strcmp(dev_name(dev), (const char *)data);
> > +}
> > +
> > +struct regmap *syscon_regmap_lookup_by_name(const char *name)
> > +{
> > +	struct syscon *syscon;
> > +	struct device *dev;
> > +
> > +	dev = driver_find_device(&syscon_driver.driver, NULL, (void *)name,
> > +				 syscon_match_name);
> > +	if (!dev)
> > +		return ERR_PTR(-EPROBE_DEFER);
> > +
> > +	syscon = dev_get_drvdata(dev);
> > +
> > +	return syscon->regmap;
> > +}
> > +
> 
> How about syscon_dev_to_regmap(struct device *dev) as the exist dt version
> syscon_node_to_regmap since it's not affected by the name change of devices?

I am not completely understand what you mean. In my version which doing
search regmap by name, we can call this function with desired device name,
then use regmap:
struct regmap *r = syscon_regmap_lookup_by_name("syscon.1");

You suggest use "struct device" as parameter? I do not know what we should
use as parameter to the function in this case, since we can get "struct device"
only when register this device, i.e. in board support code, not from anywhere,
for example from another driver.
Fixme please.

...
> > +	if (IS_ENABLED(CONFIG_OF) && np) {
> > +		syscon->base = of_iomap(np, 0);
> > +		if (!syscon->base)
> > +			return -EADDRNOTAVAIL;
> > +
> > +		res = &res_of;
> > +		ret = of_address_to_resource(np, 0, res);
> > +		if (ret)
> > +			return ret;
> > +	} else {
> > +		res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > +		if (!res)
> > +			return -ENXIO;
> > +
> > +		if (!request_mem_region(res->start, resource_size(res),
> > +					dev_name(&pdev->dev)))
> > +			return -EBUSY;
> > +
> > +		syscon->base = ioremap(res->start, resource_size(res));
> > +		if (!syscon->base)
> > +			return -EADDRNOTAVAIL;
> 
> devm_request_and_ioremap?

We call of_iomap for DT-version,  for removal procedure - iounmap.
Will iounmap work properly with devm_-version, I'm not sure.
May be better to completely remove ".remove" (and module_exit) feature for driver?
It is loaded at startup always once compiled, and should always be in the system.

Thanks!
---
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
