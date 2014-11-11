Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751690AbaKKROy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 12:14:54 -0500
Received: from mga03.intel.com ([134.134.136.65]:45888 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751152AbaKKROw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 12:14:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,362,1413270000"; 
   d="scan'208";a="606039463"
Date: Tue, 11 Nov 2014 09:11:00 -0800
From: "David E. Box" <david.e.box@linux.intel.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: jdelvare@suse.de, arnd@arndb.de, maxime.ripard@free-electrons.com,
        dianders@chromium.org, u.kleine-koenig@pengutronix.de,
        laurent.pinchart+renesas@ideasonboard.com,
        boris.brezillon@free-electrons.com, maxime.coquelin@st.com,
        andrew@lunn.ch, sjg@chromium.org, markus.mayer@linaro.org,
        ch.naveen@samsung.com, jacob.jun.pan@linux.intel.com,
        max.schwarz@online.de, mika.westerberg@linux.intel.com,
        skuribay@pobox.com, Romain.Baeriswyl@abilis.com, wenkai.du@intel.com,
        chiau.ee.chew@intel.com, christian.ruppert@abilis.com,
        alan@linux.intel.com, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH V2] i2c-designware: Add Intel Baytrail PMIC I2C bus
 support
Message-ID: <20141111171100.GA6955@pathfinder>
References: <1410543367-6565-1-git-send-email-david.e.box@linux.intel.com>
 <1411497626-7984-1-git-send-email-david.e.box@linux.intel.com>
 <20141111113255.GC3794@katana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141111113255.GC3794@katana>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2014 at 12:32:56PM +0100, Wolfram Sang wrote:
> On Tue, Sep 23, 2014 at 11:40:26AM -0700, David E. Box wrote:
> > This patch implements an I2C bus sharing mechanism between the host and platform
> > hardware on select Intel BayTrail SoC platforms using the X-Powers AXP288 PMIC.
> > 
> > On these platforms access to the PMIC must be shared with platform hardware. The
> > hardware unit assumes full control of the I2C bus and the host must request
> > access through a special semaphore. Hardware control of the bus also makes it
> > necessary to disable runtime pm to avoid interfering with hardware transactions.
> 
> Can we foresee that other platforms will have similar mechanisms in the
> future?
>

Maybe one other platform. Unlikely there'll be any others. Okay on your
comments below.

Dave

> > +config I2C_BAYTRAIL_SEM
> 
> I2C_DESIGNWARE_BAYTRAIL_SEM
> 
> > +	tristate "Intel Baytrail I2C semaphore support"
> > +	depends on I2C_DESIGNWARE_PLATFORM
> > +	select I2C_DESIGNWARE_CORE
> 
> This select is already covered by I2C_DESIGNWARE_PLATFORM.
> 
> > +	select IOSF_MBI
> > +	help
> > +	  This driver enables host access to the PMIC I2C bus on select Intel
> > +	  BayTrail platforms using the X-Powers AXP288 PMIC. This driver is
> > +	  required for host access to the PMIC on these platforms. You should
> > +	  probably say Y if you have a BayTrail system, unless you know it uses
> > +	  a different PMIC. Otherwises critical PMIC functions, like charging,
> > +	  may not operate.
> > +
> > +	  This driver should be built as a m if I2C_DESIGNWARE_PLATFORM=m,
> > +	  and as y if I2C_DESIGNWARE_PLATFORM=y.
> 
> That shouldn't be the user's task to ensure. Please enforce this in the
> makefile. Check Documentation/kbuid/makefiles.txt, Section 3.3.
> 
> > --- /dev/null
> > +++ b/drivers/i2c/busses/i2c-baytrail-sem.c
> > @@ -0,0 +1,157 @@
> > +/*
> > + * Intel BayTrail PMIC I2C bus semaphore implementaion
> > + * Copyright (c) 2014, Intel Corporation.
> 
> Mika, can you have a look at the ACPI part here?
> 
> > diff --git a/drivers/i2c/busses/i2c-designware-core.h b/drivers/i2c/busses/i2c-designware-core.h
> > index d66b6cb..13e0809 100644
> > --- a/drivers/i2c/busses/i2c-designware-core.h
> > +++ b/drivers/i2c/busses/i2c-designware-core.h
> > @@ -65,6 +65,8 @@
> >   * @ss_lcnt: standard speed LCNT value
> >   * @fs_hcnt: fast speed HCNT value
> >   * @fs_lcnt: fast speed LCNT value
> > + * has_hw_lock: true if bus access requires hardware lock
> > + * pm_runtime_disabled: true if pm runtime is disabled
> 
> Look closely. There is a difference to the entries above.
> 
> > @@ -123,3 +127,18 @@ extern void i2c_dw_disable(struct dw_i2c_dev *dev);
> >  extern void i2c_dw_clear_int(struct dw_i2c_dev *dev);
> >  extern void i2c_dw_disable_int(struct dw_i2c_dev *dev);
> >  extern u32 i2c_dw_read_comp_param(struct dw_i2c_dev *dev);
> > +
> > +#if IS_ENABLED(CONFIG_I2C_BAYTRAIL_SEM)
> > +extern int baytrail_i2c_acquire(struct dw_i2c_dev *dev);
> > +extern void baytrail_i2c_release(struct dw_i2c_dev *dev);
> > +extern void baytrail_evaluate_sem(struct dw_i2c_dev *dev);
> > +#define i2c_dw_acquire_ownership(dev) baytrail_i2c_acquire(dev)
> > +#define i2c_dw_release_ownership(dev) baytrail_i2c_release(dev)
> > +#define i2c_dw_eval_lock(dev) baytrail_evaluate_sem(dev)
> i2c_dw_test_ownership_support()?
> 
> That doesn't scale in case other platformts will need this. I could
> imagine a struct i2c_dw_ownership_ops() (or whatever name) which gets
> populated according to the matched device.
> 
> Thanks,
> 
>    Wolfram
> 


