Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751406Ab3AaFCk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 00:02:40 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:52624 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750744Ab3AaFCf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 00:02:35 -0500
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: "Patil, Rachna" <rachna@ti.com>, Koen Kooi <koen@dominion.thruhere.net>
CC: Russell King <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        Dmitry Torokhov <dtor@mail.ru>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "Hebbar, Gururaja" <gururaja.hebbar@ti.com>,
        Jonathan Cameron <jic23@cam.ac.uk>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH v4 5/8] MFD: ti_am335x_tscadc: Add DT support
Thread-Topic: [PATCH v4 5/8] MFD: ti_am335x_tscadc: Add DT support
Thread-Index: AQHN+eVtDadlPzEeCUiwIKBMOIKxvJhhXFuAgAElp4CAAGmuIA==
Date: Thu, 31 Jan 2013 05:02:04 +0000
Message-ID: <79CD15C6BA57404B839C016229A409A83EBEFAE8@DBDE01.ent.ti.com>
References: <1358999112-31192-1-git-send-email-rachna@ti.com>
 <1358999112-31192-6-git-send-email-rachna@ti.com>
 <A9839AA2-ABCD-4642-9766-D56824AC27AD@dominion.thruhere.net>
 <4CE347531D4CA947960AF71FF095B9323E9B1EE9@DBDE01.ent.ti.com>
In-Reply-To: <4CE347531D4CA947960AF71FF095B9323E9B1EE9@DBDE01.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2013 at 09:41:11, Patil, Rachna wrote:
> On Wed, Jan 30, 2013 at 16:10:09, Koen Kooi wrote:
> > 
> > Op 24 jan. 2013, om 04:45 heeft "Patil, Rachna" <rachna@ti.com> het volgende geschreven:
> > 
> > > From: "Patil, Rachna" <rachna@ti.com>
> > > 
> > > Make changes to add DT support in the MFD core driver.
> > > 
> > > Signed-off-by: Patil, Rachna <rachna@ti.com>
> > > ---
> > > Changes in v4:
> > > 	Non-standard properties prefixed with vendor name.
> > > 
> > > drivers/mfd/ti_am335x_tscadc.c |   28 +++++++++++++++++++++++-----
> > > 1 file changed, 23 insertions(+), 5 deletions(-)
> > > 
> > > diff --git a/drivers/mfd/ti_am335x_tscadc.c 
> > > b/drivers/mfd/ti_am335x_tscadc.c index e9f3fb5..87b446b 100644
> > > --- a/drivers/mfd/ti_am335x_tscadc.c
> > > +++ b/drivers/mfd/ti_am335x_tscadc.c
> > > @@ -22,6 +22,8 @@
> > > #include <linux/regmap.h>
> > > #include <linux/mfd/core.h>
> > > #include <linux/pm_runtime.h>
> > > +#include <linux/of.h>
> > > +#include <linux/of_device.h>
> > > 
> > > #include <linux/mfd/ti_am335x_tscadc.h> #include 
> > > <linux/input/ti_am335x_tsc.h>
> > > @@ -64,20 +66,31 @@ static	int ti_tscadc_probe(struct platform_device *pdev)
> > > 	struct resource		*res;
> > > 	struct clk		*clk;
> > > 	struct mfd_tscadc_board	*pdata = pdev->dev.platform_data;
> > > +	struct device_node	*node = pdev->dev.of_node;
> > > 	struct mfd_cell		*cell;
> > > 	int			err, ctrl;
> > > 	int			clk_value, clock_rate;
> > > -	int			tsc_wires, adc_channels = 0, total_channels;
> > > +	int			tsc_wires = 0, adc_channels = 0, total_channels;
> > > 
> > > -	if (!pdata) {
> > > +	if (!pdata && !pdev->dev.of_node) {
> > > 		dev_err(&pdev->dev, "Could not find platform data\n");
> > > 		return -EINVAL;
> > > 	}
> > > 
> > > -	if (pdata->adc_init)
> > > -		adc_channels = pdata->adc_init->adc_channels;
> > > +	if (pdev->dev.platform_data) {
> > > +		if (pdata->tsc_init)
> > > +			tsc_wires = pdata->tsc_init->wires;
> > > +
> > > +		if (pdata->adc_init)
> > > +			adc_channels = pdata->adc_init->adc_channels;
> > > +	} else {
> > > +		node = of_find_node_by_name(pdev->dev.of_node, "tsc");
> > > +		of_property_read_u32(node, "ti,wires", &tsc_wires);
> > > +
> > > +		node = of_find_node_by_name(pdev->dev.of_node, "adc");
> > > +		of_property_read_u32(node, "ti,adc-channels", &adc_channels);
> > > +	}
> > 
> > Since AM335x is DT only, why is there a platform data codepath and why is it the first branch it tries? And I guess the next question is related to the first: why doesn't it work when used with DT? When I copy over the nodes from the evm.dts to my board I get "tsc tsc: Missing platform data" in dmesg.
> 
> This IP came up 1st on AM335x, but it is not platform dependent. The driver can be used on other platforms where-in DT is not supported.
> According to the maintainers platform data takes precedence over DT. Hence the order.
> 

Rachana,

I see no point adding support for platform_data when you know that none of 
older platforms are going to use this driver and all future platforms _must_ 
follow device-tree model.

So I agree that you should remove board file dependency from the driver.


> I do not see "Missing platform data" error msg in the latest driver. I am not able to trace from where this got populated.
> 

Can you share the branch which you have tested?

Thanks,
Vaibhav

> > 
> > What are the chances this driver will work when applied on top of 3.8-rcX? Has it even been tested with that? Has it been tested at all?
> 
> This driver has been tested on top of v3.8-rc3 on a AM335x EVM.
> 
> Regards,
> Rachna
> 
> _______________________________________________
> devicetree-discuss mailing list
> devicetree-discuss@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/devicetree-discuss
> 

