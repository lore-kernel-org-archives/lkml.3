Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342AbaKYQvP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 11:51:15 -0500
Received: from mail-ig0-f176.google.com ([209.85.213.176]:62083 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356AbaKYQvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 11:51:11 -0500
Date: Tue, 25 Nov 2014 16:51:05 +0000
From: Lee Jones <lee.jones@linaro.org>
To: "Tan, Raymond" <raymond.tan@intel.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chen, Alvin" <alvin.chen@intel.com>,
        "Shevchenko, Andriy" <andriy.shevchenko@intel.com>
Subject: Re: [PATCH v2 1/1] mfd: intel_quark_i2c_gpio: Add Intel Quark X1000
 I2C-GPIO MFD Driver
Message-ID: <20141125165105.GP4241@x1>
References: <1415713349-16065-1-git-send-email-raymond.tan@intel.com>
 <1415713349-16065-2-git-send-email-raymond.tan@intel.com>
 <20141118172156.GF13959@x1>
 <F0CA9E243F4F424B836EAC30E41BF4CF5C7989F2@PGSMSX104.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <F0CA9E243F4F424B836EAC30E41BF4CF5C7989F2@PGSMSX104.gar.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike,

Something for you down below.

> > > In Quark X1000, there's a single PCI device that provides both an I2C
> > > controller and a GPIO controller. This MFD driver will split the 2
> > > devices for their respective drivers.
> > >
> > > This patch is based on Josef Ahmad's initial work for Quark enabling.
> > >
> > > Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > > Signed-off-by: Weike Chen <alvin.chen@intel.com>
> > > Signed-off-by: Raymond Tan <raymond.tan@intel.com>
> > > ---
> > >  drivers/mfd/Kconfig                |   11 ++
> > >  drivers/mfd/Makefile               |    1 +
> > >  drivers/mfd/intel_quark_i2c_gpio.c |  298
> > > ++++++++++++++++++++++++++++++++++++
> > >  3 files changed, 310 insertions(+)
> > >  create mode 100644 drivers/mfd/intel_quark_i2c_gpio.c

[...]

> > > +	depends on COMMON_CLK
> > 
> > I don't think you should depend on this.  Just use the API and fail if it doesn't
> > find the clock you're after.
> 
> This was added to make sure the clk initialization and other clk related calls will work with the MFD.

[...]

> > > +struct clk *intel_quark_i2c_clk;
> > > +struct clk_lookup *intel_quark_i2c_clk_lookups;
> > 
> > Why do these need to be global?
> 
> I was trying to keep these as runtime allocated variables, and cleaned up with removal of the driver / upon error handling.

They still can be.  But they need to be in a struct somewhere and not
global.

[...]

> > > +static int intel_quark_register_i2c_clk(struct pci_dev *pdev) {
> > > +	intel_quark_i2c_clk_lookups = devm_kcalloc(
> > > +
> > > +		&pdev->dev, INTEL_QUARK_I2C_NCLK,
> > > +		sizeof(*intel_quark_i2c_clk_lookups), GFP_KERNEL);
> > > +
> > > +	if (!intel_quark_i2c_clk_lookups)
> > > +		return -ENOMEM;
> > > +
> > > +	intel_quark_i2c_clk_lookups[0].dev_id =
> > > +INTEL_QUARK_I2C_CONTROLLER_CLK;
> > > +
> > > +	intel_quark_i2c_clk = clk_register_fixed_rate(
> > > +		&pdev->dev, INTEL_QUARK_I2C_CONTROLLER_CLK, NULL,
> > > +		CLK_IS_ROOT, INTEL_QUARK_I2C_CLK_HZ);
> > > +
> > > +	return clk_register_clkdevs(intel_quark_i2c_clk,
> > > +		intel_quark_i2c_clk_lookups, INTEL_QUARK_I2C_NCLK);
> > 
> > We don't normally register clks from MFD.  Normally they are registered in
> > drivers/clk and fetched when a device requires them.
> > Why is this different?
> 
> This is a static clk and on this platform, there's no clk hardware
> to have the clk driver to initialize this and add into the global
> struct for use
> later by i2c controller. The hardware on the platform itself is
> same, and the current driver (i2c_designware_platform) requires the
> clk 
> for its operation. Due to this, I decided to have the clk initialize
> in the MFD before the device being added, which later will trigger
> the probe on the i2c controller driver. 

Mike,

Can I get your input on this please?

[...]

> > > +	pdata = intel_quark_get_i2c_mode(pdev);
> > > +	if (IS_ERR(pdata))
> > > +		return PTR_ERR(pdata);
> > 
> > Bring this functionality into here?
> 
> Were you referring the contents of intel_quark_get_i2c_mode(), and avoid the additional function call instead?

Right.  Please rid intel_quark_get_i2c_mode().

[...]

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
