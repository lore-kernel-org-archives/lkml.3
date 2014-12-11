Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934314AbaLKJvG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 04:51:06 -0500
Received: from mga02.intel.com ([134.134.136.20]:39120 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932802AbaLKJvE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 04:51:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,556,1413270000"; 
   d="scan'208";a="652132755"
From: "Tan, Raymond" <raymond.tan@intel.com>
To: Lee Jones <lee.jones@linaro.org>,
        "mturquette@linaro.org" <mturquette@linaro.org>
CC: Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chen, Alvin" <alvin.chen@intel.com>,
        "Shevchenko, Andriy" <andriy.shevchenko@intel.com>,
        "Tan, Raymond" <raymond.tan@intel.com>
Subject: RE: [PATCH v2 1/1] mfd: intel_quark_i2c_gpio: Add Intel Quark X1000
 I2C-GPIO MFD Driver
Thread-Topic: [PATCH v2 1/1] mfd: intel_quark_i2c_gpio: Add Intel Quark
 X1000 I2C-GPIO MFD Driver
Thread-Index: AQHP/bXYZmohCNFV50aM73389PLXvZxmJsYAgAm1agCAAUJJgIAAAHWAgBkz3GA=
Date: Thu, 11 Dec 2014 09:50:43 +0000
Message-ID: <F0CA9E243F4F424B836EAC30E41BF4CF5C7B8859@PGSMSX104.gar.corp.intel.com>
References: <1415713349-16065-1-git-send-email-raymond.tan@intel.com>
 <1415713349-16065-2-git-send-email-raymond.tan@intel.com>
 <20141118172156.GF13959@x1>
 <F0CA9E243F4F424B836EAC30E41BF4CF5C7989F2@PGSMSX104.gar.corp.intel.com>
 <20141125165105.GP4241@x1> <20141125165243.GQ4241@x1>
In-Reply-To: <20141125165243.GQ4241@x1>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.30.20.206]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sBB9pHwh011531

Hi Mike and Lee Jones,

I've updated the patch (v3) with the input from previous reviews, hope this will help to facilitate a better review. I've kept the clk portion relatively unchanged except removing the usage of global variables, instead I've put them in a struct and set as drvdata for later use during the removal of the driver for unregistering the clk and clk_lookup.

Warm Regards, 

Â Raymond Tan
Software Engineer
Malaysia IT Flex Services
INET: 8-253-0075
Flex Website: http://flexservices.intel.com 

> -----Original Message-----
> From: Lee Jones [mailto:lee.jones@linaro.org]
> Sent: Wednesday, November 26, 2014 12:53 AM
> To: Tan, Raymond; mturquette@linaro.org
> Cc: Samuel Ortiz; linux-kernel@vger.kernel.org; Chen, Alvin; Shevchenko,
> Andriy
> Subject: Re: [PATCH v2 1/1] mfd: intel_quark_i2c_gpio: Add Intel Quark
> X1000 I2C-GPIO MFD Driver
> 
> Crap!  Forgot to Cc Mike.
> 
> Fingers faster than brain.
> 
> > Mike,
> >
> > Something for you down below.
> >
> > > > > In Quark X1000, there's a single PCI device that provides both
> > > > > an I2C controller and a GPIO controller. This MFD driver will
> > > > > split the 2 devices for their respective drivers.
> > > > >
> > > > > This patch is based on Josef Ahmad's initial work for Quark enabling.
> > > > >
> > > > > Reviewed-by: Andy Shevchenko
> <andriy.shevchenko@linux.intel.com>
> > > > > Signed-off-by: Weike Chen <alvin.chen@intel.com>
> > > > > Signed-off-by: Raymond Tan <raymond.tan@intel.com>
> > > > > ---
> > > > >  drivers/mfd/Kconfig                |   11 ++
> > > > >  drivers/mfd/Makefile               |    1 +
> > > > >  drivers/mfd/intel_quark_i2c_gpio.c |  298
> > > > > ++++++++++++++++++++++++++++++++++++
> > > > >  3 files changed, 310 insertions(+)  create mode 100644
> > > > > drivers/mfd/intel_quark_i2c_gpio.c
> >
> > [...]
> >
> > > > > +	depends on COMMON_CLK
> > > >
> > > > I don't think you should depend on this.  Just use the API and
> > > > fail if it doesn't find the clock you're after.
> > >
> > > This was added to make sure the clk initialization and other clk related
> calls will work with the MFD.
> >
> > [...]
> >
> > > > > +struct clk *intel_quark_i2c_clk; struct clk_lookup
> > > > > +*intel_quark_i2c_clk_lookups;
> > > >
> > > > Why do these need to be global?
> > >
> > > I was trying to keep these as runtime allocated variables, and cleaned up
> with removal of the driver / upon error handling.
> >
> > They still can be.  But they need to be in a struct somewhere and not
> > global.
> >
> > [...]
> >
> > > > > +static int intel_quark_register_i2c_clk(struct pci_dev *pdev) {
> > > > > +	intel_quark_i2c_clk_lookups = devm_kcalloc(
> > > > > +
> > > > > +		&pdev->dev, INTEL_QUARK_I2C_NCLK,
> > > > > +		sizeof(*intel_quark_i2c_clk_lookups), GFP_KERNEL);
> > > > > +
> > > > > +	if (!intel_quark_i2c_clk_lookups)
> > > > > +		return -ENOMEM;
> > > > > +
> > > > > +	intel_quark_i2c_clk_lookups[0].dev_id =
> > > > > +INTEL_QUARK_I2C_CONTROLLER_CLK;
> > > > > +
> > > > > +	intel_quark_i2c_clk = clk_register_fixed_rate(
> > > > > +		&pdev->dev, INTEL_QUARK_I2C_CONTROLLER_CLK,
> NULL,
> > > > > +		CLK_IS_ROOT, INTEL_QUARK_I2C_CLK_HZ);
> > > > > +
> > > > > +	return clk_register_clkdevs(intel_quark_i2c_clk,
> > > > > +		intel_quark_i2c_clk_lookups,
> INTEL_QUARK_I2C_NCLK);
> > > >
> > > > We don't normally register clks from MFD.  Normally they are
> > > > registered in drivers/clk and fetched when a device requires them.
> > > > Why is this different?
> > >
> > > This is a static clk and on this platform, there's no clk hardware
> > > to have the clk driver to initialize this and add into the global
> > > struct for use later by i2c controller. The hardware on the platform
> > > itself is same, and the current driver (i2c_designware_platform)
> > > requires the clk for its operation. Due to this, I decided to have
> > > the clk initialize in the MFD before the device being added, which
> > > later will trigger the probe on the i2c controller driver.
> >
> > Mike,
> >
> > Can I get your input on this please?
> >
> > [...]
> >
> > > > > +	pdata = intel_quark_get_i2c_mode(pdev);
> > > > > +	if (IS_ERR(pdata))
> > > > > +		return PTR_ERR(pdata);
> > > >
> > > > Bring this functionality into here?
> > >
> > > Were you referring the contents of intel_quark_get_i2c_mode(), and
> avoid the additional function call instead?
> >
> > Right.  Please rid intel_quark_get_i2c_mode().
> >
> > [...]
> >
> 
> --
> Lee Jones
> Linaro STMicroelectronics Landing Team Lead Linaro.org â”‚ Open source
> software for ARM SoCs Follow Linaro: Facebook | Twitter | Blog
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
