Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093Ab3CKLcx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 07:32:53 -0400
Received: from mga09.intel.com ([134.134.136.24]:2336 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753897Ab3CKLcv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 07:32:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,822,1355126400"; 
   d="scan'208";a="299025976"
From: "Shevchenko, Andriy" <andriy.shevchenko@intel.com>
To: linux-kernel <linux-kernel@vger.kernel.org>,
        "Koul, Vinod" <vinod.koul@intel.com>,
        Arnd Bergmann <arnd.bergmann@linaro.org>
CC: Viresh Kumar <viresh.kumar@linaro.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: A proposal to check the device in generic way
Thread-Topic: A proposal to check the device in generic way
Thread-Index: AQHOHkwes8g2THZZt02CceOgK5RzFQ==
Date: Mon, 11 Mar 2013 11:32:31 +0000
Message-ID: <1363001537.18714.3.camel@smile>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.237.72.173]
Content-Type: text/plain; charset="utf-8"
Content-ID: <0B74A1371B575B4FBDE0D763C9FE0F92@intel.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r2BBWq4W006819

Hello.

Currently in linux-next we have the following things:

$ git grep -n 'chan->device->dev->driver' drivers/dma/

drivers/dma/amba-pl08x.c:1594:  if (chan->device->dev->driver !=
&pl08x_amba_driver.drv)
drivers/dma/dmaengine.c:190:    return chan->device->dev->driver->owner;
drivers/dma/edma.c:609: if (chan->device->dev->driver ==
&edma_driver.driver) {
drivers/dma/omap-dma.c:654:     if (chan->device->dev->driver ==
&omap_dma_driver.driver) {
drivers/dma/pl330.c:2374:       if (chan->device->dev->driver !=
&pl330_driver.drv)
drivers/dma/sa11x0-dma.c:1080:  if (chan->device->dev->driver ==
&sa11x0_dma_driver.driver) 

I think it's a non-generic way to check which driver provides a channel
into filter function. First of all, I don't get why that comparison goes
as deep as driver structure. Isn't clearer to check chan->device->dev
against the struct dev passed in the custom parameter structure? Like:

struct filter_params {
 struct dev *dev;
 void *param;
};

bool filter_fn(struct dma_chan *chan, void *fparams)
{
  struct filter_params *p = fparams;
  if (chan->device->dev != p->dev)
   return false;
 ...
}

In case my idea has a right to live, what about to move such check inside
DMA engine code?

Opinions, comments?

Earlier I tried to discuss this with Arnd here: http://www.spinics.net/lists/arm-kernel/msg220716.html

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
