Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752290AbaDWXeT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 19:34:19 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:19348 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751461AbaDWXeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 19:34:16 -0400
Date: Wed, 23 Apr 2014 16:36:22 -0700
From: Courtney Cavin <courtney.cavin@sonymobile.com>
To: Josh Cartwright <joshc@codeaurora.org>
CC: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        David Collins <collinsd@codeaurora.org>
Subject: Re: [PATCH 1/2] mfd: pm8x41: add support for Qualcomm 8x41 PMICs
Message-ID: <20140423233621.GM17066@sonymobile.com>
References: <1398213110-28135-1-git-send-email-courtney.cavin@sonymobile.com>
 <20140423214626.GA3215@joshc.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140423214626.GA3215@joshc.qualcomm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 11:46:26PM +0200, Josh Cartwright wrote:
> On Tue, Apr 22, 2014 at 05:31:49PM -0700, Courtney Cavin wrote:
> > From: Josh Cartwright <joshc@codeaurora.org>
> > 
> > The Qualcomm 8941 and 8841 PMICs are components used with the Snapdragon
> > 800 series SoC family.  This driver exists largely as a glue mfd component,
> > it exists to be an owner of an SPMI regmap for children devices
> > described in device tree.
> > 
> > Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
> > Signed-off-by: Courtney Cavin <courtney.cavin@sonymobile.com>
> 
> Hey Courtney-
> 
> Thanks for picking this up!

Well, I've been poking you about it for months now, so I figured I'd
stop being annoying, and start being productive.

> 
> One thing that I had meant to do is rename this thing.  Nothing about
> this is PM8841/PM8941 specific at all.  It should apply equally to all
> Qualcomm's PMICs which implement QPNP.
> 
> Perhaps a better name would be "qcom-pmic-qpnp".

What's a QPNP?  Really.  I've heard you speak about it before as being a
definition of the register layout for interrupts, but I have no
documentation on it.

I would argue here from my understanding that this driver isn't specific
to QPNP either.  With that in mind we could just go with
"qcom-pmic-spmi".  In fact just "spmi-ext" would not be incorrect, as
this driver has little to do with PMICs at all.

My point here is that we can easily make this into something very
generic, but that only causes problems in the future when it's not
"generic enough", and we have to add quirks.  If in the future Qualcomm
releases a pm8A41, and it's qpnp, but not spmi, or spmi, but not 'ext',
then we need to either change this driver dramatically, or write a new
one.  I like keeping this driver name specific to what we know it
supports.  We can rename it in the future if deemed appropriate, but I'd
rather not make it something that which turns out to be wrong at some
later point.

Having said all of this, I have no doubt that your HW engineers will
find a way to break our interpretation of their naming scheme... once
again.

> 
> [..]
> > +++ b/drivers/mfd/pm8x41.c
> > @@ -0,0 +1,63 @@
> > +/* Copyright (c) 2013, The Linux Foundation. All rights reserved.
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 and
> > + * only version 2 as published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + */
> > +#include <linux/kernel.h>
> > +#include <linux/module.h>
> > +#include <linux/spmi.h>
> > +#include <linux/regmap.h>
> > +#include <linux/of_platform.h>
> > +
> > +static const struct regmap_config pm8x41_regmap_config = {
> > +	.reg_bits	= 16,
> > +	.val_bits	= 8,
> > +	.max_register	= 0xFFFF,
> > +};
> 
> This reminds me.  David Collins (CC'd) noticed that there are usecases
> where peripheral drivers will need to be accessing registers from atomic
> context, so we should probably be setting .fast_io in the SPMI
> regmap_bus structures, but we can tackle that when we get there.

Hrm.  Please comment on this David.  I would like to see a solid
use-case before even considering that.

> > +
> > +static int pm8x41_remove_child(struct device *dev, void *unused)
> > +{
> > +	platform_device_unregister(to_platform_device(dev));
> > +	return 0;
> > +}
> > +
> > +static void pm8x41_remove(struct spmi_device *sdev)
> > +{
> > +	device_for_each_child(&sdev->dev, NULL, pm8x41_remove_child);
> > +}
> > +
> > +static int pm8x41_probe(struct spmi_device *sdev)
> > +{
> > +	struct regmap *regmap;
> > +
> > +	regmap = devm_regmap_init_spmi_ext(sdev, &pm8x41_regmap_config);
> > +	if (IS_ERR(regmap)) {
> > +		dev_dbg(&sdev->dev, "regmap creation failed.\n");
> > +		return PTR_ERR(regmap);
> > +	}
> > +
> > +	return of_platform_populate(sdev->dev.of_node, NULL, NULL, &sdev->dev);
> > +}
> > +
> > +static const struct of_device_id pm8x41_id_table[] = {
> > +	{ .compatible = "qcom,pm8841", },
> > +	{ .compatible = "qcom,pm8941", },
> > +	{},
> > +};
> > +MODULE_DEVICE_TABLE(of, pm8x41_id_table);
> 
> I'm thinking we should probably have a generic compatible entry as well,
> "qcom,pmic-qpnp" or similar.  We should still specify in the binding
> that PMIC slaves specify a version-specific string as well as the
> generic string.  That is, a slave should have:
> 
> 	compatible = "qcom,pm8841", "qcom,pmic-qpnp";
> 
> ...in case we would ever need to differentiate in the future.
> 
> (I recall that in a previous version I had done this, but I don't
> remember why I had changed it..)

I gave this some thought but came to the conclusion that there is no
benefit of adding a generic compatible to a new binding.  Please clarify
a use-case where this would be ... useful.

Thanks for the review!

-Courtney
