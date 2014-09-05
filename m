Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932101AbaIEKV1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 06:21:27 -0400
Received: from mga01.intel.com ([192.55.52.88]:63678 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756626AbaIEKVZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 06:21:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,471,1406617200"; 
   d="scan'208";a="586711199"
From: "Chen, Alvin" <alvin.chen@intel.com>
To: "Shevchenko, Andriy" <andriy.shevchenko@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "Kweh, Hock Leong" <hock.leong.kweh@intel.com>,
        "sebastian@breakpoint.cc" <sebastian@breakpoint.cc>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "gnurou@gmail.com" <gnurou@gmail.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "Westerberg, Mika" <mika.westerberg@intel.com>,
        "dvhart@linux.intel.com" <dvhart@linux.intel.com>,
        "atull@opensource.altera.com" <atull@opensource.altera.com>
Subject: RE: [PATCH 1/3 v2] GPIO: gpio-dwapb: Enable platform driver binding
 to MFD driver
Thread-Topic: [PATCH 1/3 v2] GPIO: gpio-dwapb: Enable platform driver
 binding to MFD driver
Thread-Index: AQHPyNc/kBMLSfD+Nk6gyOY6CiHQz5vyMzuAgAAX0oA=
Date: Fri, 5 Sep 2014 10:20:53 +0000
Message-ID: <4656BEB6164FC34F8171C6538F1A595B2E9829DA@SHSMSX101.ccr.corp.intel.com>
References: <1409928798-31895-1-git-send-email-alvin.chen@intel.com>
	 <1409928798-31895-2-git-send-email-alvin.chen@intel.com>
 <1409908917.30155.84.camel@intel.com>
In-Reply-To: <1409908917.30155.84.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s85ALefU016527

> > -static void dwapb_irq_handler(u32 irq, struct irq_desc *desc)
> > +static u32 _dwapb_irq_handler(struct dwapb_gpio *gpio)
> 
> What about dwapb_do_irq() ?
OK, I will improve it.

> > +static irqreturn_t dwapb_irq_handler_mfd(int irq, void *dev_id) {
> > +	u32 worked;
> > +	struct dwapb_gpio *gpio = (struct dwapb_gpio *)dev_id;
> 
> No need to cast explicitly from void *.
OK.


> > -	port->bgc.gc.ngpio = ngpio;
> > -	port->bgc.gc.of_node = port_np;
> > +#ifdef CONFIG_OF_GPIO
> 
> Do we really need this #ifdef ?
> of_node will be NULL anyway, or I missed something?
Yes, otherwise, can't compile it. Please refer 'struct gpio_chip', 'gc.of_node' is in OF_GPIO micro also.

> > +	if (pp->irq)
> 
> irq == 0 is a valid hwirq (hardware irq) number. Yes, there is unlikely we have it
> somewhere, but still it's possible. And yes, IRQ framework doesn't work with
> virq == 0 (*virtual* irq), but accepts hwirq == 0. I recommend to use int type for
> irq line number, and recognize negative value (usually -1) as no irq needed /
> found.
Understand. But if you refer the original code, you can see:
irq = irq_of_parse_and_map(node, 0);
If (!irq) {
......
return;
}
>From above code, if irq=0, it indicates irq is not supported for OF devices. If we use '-1' to indicate irq is not supported. To make OF work, then our code should be:

irq = irq_of_parse_and_map(node, 0);
If (!irq) {
pp->irq = -1;
return;
} else {
pp->irq = irq;
}
Then the code looks strange.

How do you think?

> > +	bool is_of;
> 
> is_pdata_alloc (it might be not only OF case in future).
> 
OK


> > +	if (!pdata) {
> 
> (*)

> > +		pdata = dwapb_gpio_get_pdata_of(dev);
> > +		if (IS_ERR(pdata))
> > +			return PTR_ERR(pdata);
> 
> > +		is_of = true;
> > +	} else {
> > +		is_of = false;
> 
> Instead of above three lines, how about
> bool is_pdata_alloc = !pdata;
> 
> And (*) if (is_pdata_alloc) ...
> 
OK. I will improve this part.

> > +	if (is_of) {
> > +		dwapb_free_pdata_of(dev, pdata);
> > +		pdata = NULL;
> 
> Besides that pdata assignment is probably redundant, you may use plain
> kmalloc/kfree and avoid unnecessary devm_* calls.
> 
OK.

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
