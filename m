Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060AbaKJBwr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 20:52:47 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:8400 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741AbaKJBwp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 20:52:45 -0500
From: "Yang, Wenyou" <Wenyou.Yang@atmel.com>
To: Wolfram Sang <wsa@the-dreams.de>
CC: "Desroches, Ludovic" <Ludovic.Desroches@atmel.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Ferre, Nicolas" <Nicolas.FERRE@atmel.com>,
        "khilman@kernel.org" <khilman@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH v3 3/3] i2c/at91: adopt pinctrl support
Thread-Topic: [PATCH v3 3/3] i2c/at91: adopt pinctrl support
Thread-Index: AQHP71dcxmuf4N5DpUaCQRSiZL5N8pxWl7wAgAKTvDA=
Date: Mon, 10 Nov 2014 01:49:35 +0000
Message-ID: <B256D81BAE5131468A838E5D7A243641BFC689B2@penmbx01>
References: <1414133417-11530-1-git-send-email-wenyou.yang@atmel.com>
 <1414133417-11530-4-git-send-email-wenyou.yang@atmel.com>
 <20141108180314.GD4900@katana>
In-Reply-To: <20141108180314.GD4900@katana>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.168.5.13]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wolfram,

> -----Original Message-----
> From: Wolfram Sang [mailto:wsa@the-dreams.de]
> Sent: Sunday, November 09, 2014 2:03 AM
> To: Yang, Wenyou
> Cc: Desroches, Ludovic; linux-i2c@vger.kernel.org; linux-kernel@vger.kernel.org;
> Ferre, Nicolas; khilman@kernel.org; linux-arm-kernel@lists.infradead.org
> Subject: Re: [PATCH v3 3/3] i2c/at91: adopt pinctrl support
> 
> On Fri, Oct 24, 2014 at 02:50:17PM +0800, Wenyou Yang wrote:
> > Amend the i2c at91 pin controller to optionally take a pin control
> > handle and set the state of the pins to:
> >
> > - "default" on boot, resume and before performing an transfer
> > - "sleep" on suspend()
> >
> > This should make it possible to optimize energy usage for the pins
> > both for the suspend/resume cycle
> >
> > Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
> > ---
> >  drivers/i2c/busses/i2c-at91.c |    7 +++++++
> >  1 file changed, 7 insertions(+)
> >
> > diff --git a/drivers/i2c/busses/i2c-at91.c
> > b/drivers/i2c/busses/i2c-at91.c index 6a84a2a..290caf1 100644
> > --- a/drivers/i2c/busses/i2c-at91.c
> > +++ b/drivers/i2c/busses/i2c-at91.c
> > @@ -32,6 +32,7 @@
> >  #include <linux/slab.h>
> >  #include <linux/platform_data/dma-atmel.h>  #include
> > <linux/pm_runtime.h>
> > +#include <linux/pinctrl/consumer.h>
> >
> >  #define DEFAULT_TWI_CLK_HZ		100000		/* max 400 Kbits/s
> */
> >  #define AT91_I2C_TIMEOUT	msecs_to_jiffies(100)	/* transfer timeout */
> > @@ -747,6 +748,8 @@ static int at91_twi_probe(struct platform_device *pdev)
> >  	u32 phy_addr;
> >  	u32 bus_clk_rate;
> >
> > +	pinctrl_pm_select_default_state(&pdev->dev);
> > +
> 
> Do we really need this in probe? Isn't that default? I'm not sure, though...
No, we don't need it.
It is called by the function pinctrl_bind_pins(struct device *dev)  in drivers/base/pinctrl.c

I will remove it, and send it again.

> 
> >  	dev = devm_kzalloc(&pdev->dev, sizeof(*dev), GFP_KERNEL);
> >  	if (!dev)
> >  		return -ENOMEM;
> > @@ -851,6 +854,8 @@ static int at91_twi_runtime_suspend(struct device
> > *dev)
> >
> >  	clk_disable_unprepare(twi_dev->clk);
> >
> > +	pinctrl_pm_select_sleep_state(dev);
> > +
> >  	return 0;
> >  }
> >
> > @@ -858,6 +863,8 @@ static int at91_twi_runtime_resume(struct device
> > *dev)  {
> >  	struct at91_twi_dev *twi_dev = dev_get_drvdata(dev);
> >
> > +	pinctrl_pm_select_default_state(dev);
> > +
> >  	return clk_prepare_enable(twi_dev->clk);  }
> >
> > --
> > 1.7.9.5
> >

Best Regards,
Wenyou Yang
