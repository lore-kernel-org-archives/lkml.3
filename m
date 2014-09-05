Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932191AbaIEMEQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 08:04:16 -0400
Received: from mga09.intel.com ([134.134.136.24]:21225 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932171AbaIEMEO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 08:04:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,472,1406617200"; 
   d="scan'208";a="598475282"
From: "Shevchenko, Andriy" <andriy.shevchenko@intel.com>
To: "Chen, Alvin" <alvin.chen@intel.com>
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
Subject: Re: [PATCH 1/3 v2] GPIO: gpio-dwapb: Enable platform driver binding
 to MFD driver
Thread-Topic: [PATCH 1/3 v2] GPIO: gpio-dwapb: Enable platform driver
 binding to MFD driver
Thread-Index: AQHPyNc/kBMLSfD+Nk6gyOY6CiHQz5vyMzuAgAAX0oCAABToAA==
Date: Fri, 5 Sep 2014 12:02:01 +0000
Message-ID: <1409918522.30155.89.camel@intel.com>
References: <1409928798-31895-1-git-send-email-alvin.chen@intel.com>
	 <1409928798-31895-2-git-send-email-alvin.chen@intel.com>
	 <1409908917.30155.84.camel@intel.com>
	 <4656BEB6164FC34F8171C6538F1A595B2E9829DA@SHSMSX101.ccr.corp.intel.com>
In-Reply-To: <4656BEB6164FC34F8171C6538F1A595B2E9829DA@SHSMSX101.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.237.72.168]
Content-Type: text/plain; charset="utf-8"
Content-ID: <4716A4D10706B54DB49DB39C9F341257@intel.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s85C4PYh017073

On Fri, 2014-09-05 at 10:20 +0000, Chen, Alvin wrote:
> > > -	port->bgc.gc.ngpio = ngpio;
> > > -	port->bgc.gc.of_node = port_np;
> > > +#ifdef CONFIG_OF_GPIO
> > 
> > Do we really need this #ifdef ?
> > of_node will be NULL anyway, or I missed something?
> Yes, otherwise, can't compile it. Please refer 'struct gpio_chip', 'gc.of_node' is in OF_GPIO micro also.

Ah, okay. Thus, it depends to Linus opinion, since I, for example, would
like to see this field present in the structure independently of
OF_GPIO.

> 
> > > +	if (pp->irq)
> > 
> > irq == 0 is a valid hwirq (hardware irq) number. Yes, there is unlikely we have it
> > somewhere, but still it's possible. And yes, IRQ framework doesn't work with
> > virq == 0 (*virtual* irq), but accepts hwirq == 0. I recommend to use int type for
> > irq line number, and recognize negative value (usually -1) as no irq needed /
> > found.
> Understand. But if you refer the original code, you can see:
> irq = irq_of_parse_and_map(node, 0);
> If (!irq) {
> ......
> return;
> }
> From above code, if irq=0, it indicates irq is not supported for OF devices. If we use '-1' to indicate irq is not supported. To make OF work, then our code should be:

Yes, like I said above. You introduce hw irq in the pdata, which could
be 0.


> irq = irq_of_parse_and_map(node, 0);
> If (!irq) {
> pp->irq = -1;
> return;
> } else {
> pp->irq = irq;
> }
> Then the code looks strange.
> 
> How do you think?

If I understood correctly you messed up with hwirq vs. virq.
Otherwise you have mention that you are using virq everywhere (I guess
you may rename the field in the structure), but in this case the field
in the platform_data looks a bit strange. Linus, what do you think?


P.S. Please, remove my Reviewed-by tag since code is changed enough.

-- 
Andy Shevchenko <andriy.shevchenko@intel.com>
Intel Finland Oy
---------------------------------------------------------------------
Intel Finland Oy
Registered Address: PL 281, 00181 Helsinki 
Business Identity Code: 0357606 - 4 
Domiciled in Helsinki 

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
