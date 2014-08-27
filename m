Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757430AbaH0LJH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 07:09:07 -0400
Received: from mail1.bemta14.messagelabs.com ([193.109.254.117]:38862 "EHLO
	mail1.bemta14.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756900AbaH0LJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 07:09:04 -0400
X-Env-Sender: Andreas.Werner@men.de
X-Msg-Ref: server-14.tower-194.messagelabs.com!1409137738!16723692!1
X-Originating-IP: [80.255.6.145]
X-StarScan-Received: 
X-StarScan-Version: 6.11.3; banners=-,-,-
X-VirusChecked: Checked
X-PGP-Universal: processed;
	by keys.men.de on Wed, 27 Aug 2014 13:08:59 +0200
Date: Wed, 27 Aug 2014 14:00:55 +0200
From: Andreas Werner <andreas.werner@men.de>
To: Lee Jones <lee.jones@linaro.org>
CC: Andreas Werner <andreas.werner@men.de>, <linux-kernel@vger.kernel.org>,
        <sameo@linux.intel.com>, <wim@iguana.be>,
        <linux-watchdog@vger.kernel.org>, <cooloney@gmail.com>,
        <rpurdie@rpsys.net>, <linux-leds@vger.kernel.org>, <jdelvare@suse.de>,
        <linux@roeck-us.net>, <lm-sensors@lm-sensors.org>,
        <johannes.thumshirn@men.de>
Subject: Re: [PATCH v5 1/4] drivers/mfd/menf21bmc: introduce MEN 14F021P00
 BMC MFD Core driver
Message-ID: <20140827120054.GA27232@awelinux>
References: <cover.1409074255.git.andreas.werner@men.de>
 <67faa70de03924edc768002df17b02e47256260c.1409074255.git.andreas.werner@men.de>
 <20140827072633.GY26707@lee--X1>
 <20140827105204.GA2083@awelinux>
 <20140827110142.GA6364@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140827110142.GA6364@lee--X1>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [192.1.1.171]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2014 at 12:01:42PM +0100, Lee Jones wrote:
> On Wed, 27 Aug 2014, Andreas Werner wrote:
> > On Wed, Aug 27, 2014 at 08:26:33AM +0100, Lee Jones wrote:
> > > On Tue, 26 Aug 2014, Andreas Werner wrote:
> > > > The MEN 14F021P00 Board Management Controller provides an
> > > > I2C interface to the host to access the feature implemented in the BMC.
> > > > The BMC is a PIC Microntroller assembled on CPCI Card from MEN Mikroelektronik
> > > > and on a few Box/Display Computer.
> > > > 
> > > > Added MFD Core driver, supporting the I2C communication to the device.
> > > > 
> > > > The MFD driver currently supports the following features:
> > > >  	- Watchdog
> > > >  	- LEDs
> > > > 	- Hwmon (voltage monitoring)
> > > > 
> > > > Signed-off-by: Andreas Werner <andreas.werner@men.de>
> > > > Acked-by: Lee Jones <lee.jones@linaro.org>
> > > > ---
> > > >  drivers/mfd/Kconfig     |  12 +++++
> > > >  drivers/mfd/Makefile    |   1 +
> > > >  drivers/mfd/menf21bmc.c | 132 ++++++++++++++++++++++++++++++++++++++++++++++++
> > > >  3 files changed, 145 insertions(+)
> > > >  create mode 100644 drivers/mfd/menf21bmc.c
> > > > 
> > > > diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> > > > index b8d9ca0..6a9f101 100644
> > > > --- a/drivers/mfd/Kconfig
> > > > +++ b/drivers/mfd/Kconfig
> > > > @@ -453,6 +453,18 @@ config MFD_MAX8998
> > > >  	  additional drivers must be enabled in order to use the functionality
> > > >  	  of the device.
> > > >  
> > > > +config MFD_MENF21BMC
> > > > +	tristate "MEN 14F021P00 Board Management Controller Support"
> > > > +	depends on I2C
> > > > +	select MFD_CORE
> > > > +	help
> > > > +	  Say yes here to add support for the MEN 14F021P00 BMC
> > > > +	  which is a Board Management Controller connected to the I2C bus.
> > > > +	  The device supports multiple sub-devices like LED, HWMON  and WDT.
> > > 
> > > Nit: Whitespace error.
> > > 
> > 
> > I run checkpatch but did not find any whitespace error.
> > Where is it?
> 
> After 'HWMON'.
>

Ah ok.
 
> > > > +MODULE_DEVICE_TABLE(i2c, menf21bmc_id_table);
> > > > +
> > > > +static struct i2c_driver menf21bmc_driver = {
> > > > +	.driver.name	= "menf21bmc",
> > > > +	.id_table	= menf21bmc_id_table,
> > > > +	.probe		= menf21bmc_probe,
> > > > +	.remove		= menf21bmc_remove,
> > > > +};
> > > 
> > > No DT support?
> > > 
> > 
> > No not at the moment because it is used only on x86 system.
> 
> Ah okay.  Shouldn't the Kconfig depend on X86 then?  What about ACPI?

Yes and no. Could be also instantiated manually withouth DT. (e.g. i2c sysfs)
So for me it is better to not depend on x86 to have the possibility to use
the driver without DT on another arch.
ACPI is no option because there are a lot boards out without
the BMC in ACPI Table.

I think i will implement DT support if we have on board which is not x86.

> 
> > > > +module_i2c_driver(menf21bmc_driver);
> > > > +
> > > > +MODULE_DESCRIPTION("MEN 14F021P00 BMC mfd core driver");
> > > 
> > > s/mfd/MFD
> > > 
> > > > +MODULE_AUTHOR("Andreas Werner <andreas.werner@men.de>");
> > > > +MODULE_LICENSE("GPL v2");
> > > 
> 
> -- 
> Lee Jones
> Linaro STMicroelectronics Landing Team Lead
> Linaro.org │ Open source software for ARM SoCs
> Follow Linaro: Facebook | Twitter | Blog
