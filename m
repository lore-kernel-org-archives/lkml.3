Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891AbaIBSs5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 14:48:57 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:14952 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750954AbaIBSsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 14:48:55 -0400
Date: Tue, 2 Sep 2014 11:48:54 -0700
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: Jeffrey Hugo <jhugo@codeaurora.org>
CC: Ohad Ben-Cohen <ohad@wizery.com>, Kumar Gala <galak@codeaurora.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Grant Likely <grant.likely@linaro.org>, Suman Anna <s-anna@ti.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Eric Holmberg <eholmber@codeaurora.org>,
        "Cavin, Courtney" <Courtney.Cavin@sonymobile.com>
Subject: Re: [PATCH v2] hwspinlock/msm: Add support for Qualcomm MSM HW Mutex
 block
Message-ID: <20140902184853.GQ12494@sonymobile.com>
References: <1409354063-20289-1-git-send-email-bjorn.andersson@sonymobile.com>
 <5405FE42.90809@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <5405FE42.90809@codeaurora.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 02 Sep 10:28 PDT 2014, Jeffrey Hugo wrote:

> > diff --git a/drivers/hwspinlock/msm_hwspinlock.c b/drivers/hwspinlock/msm_hwspinlock.c
[..]
> > + * Copyright (c) 2013, The Linux Foundation. All rights reserved.
> 
> Should the copyright range be updated to include your changes which I 
> presume were authored in 2014?
> 

That would be expected by people on my side, will update.

[..]
> > +
> > +#include <linux/err.h>
> > +#include <linux/kernel.h>
> > +#include <linux/slab.h>
> > +#include <linux/device.h>
> > +#include <linux/module.h>
> > +#include <linux/platform_device.h>
> > +#include <linux/pm_runtime.h>
> > +#include <linux/of.h>
> > +#include <linux/of_address.h>
> > +#include <linux/of_device.h>
> > +#include <linux/hwspinlock.h>
> > +#include <linux/io.h>
> 
> Could these be put in alphabetical order?  I vaguely recall a few 
> maintainers expressing this preference to avoid merge issues.
> 

I think we can clean some of them out at least, will have a look.

[..]
> > +static int msm_hwspinlock_probe(struct platform_device *pdev)
> > +{
[..]
> > +	match = of_match_device(msm_hwspinlock_of_match, &pdev->dev);
> > +	if (!match)
> > +		return -EINVAL;
> 
> This seems redundant.  It is my understanding that probe will only be 
> called for a matching device.  What are we attempting to accomplish here?
> 

Yeah, if anything it would catch static bugs.

And with the modification below I'll just drop it.

[..]
> > +	stride = (int)match->data;
> > +	for (i = 0, hwlock = &bank->lock[0]; i < num_locks; i++, hwlock++)
> > +		hwlock->priv = iobase + i * stride;
> 
> I am not a fan of this method for determining the stride.  We already 
> have 0x4 and 0x80 in this driver, and will soon need 0x1000 for some of 
> the current chips (still listed as TCSR too).  The stride is completely 
> up to our hardware designers, and it seems like encoding stride in this 
> manner will require constant updates and maintenance.  I prefer 
> calculating stride by dividing the reg size by num_locks since that will 
> automatically adjust for whatever the hardware designers decide to use 
> next month.  If you wanted to, with the reg size calculation, you could 
> remove the "qcom,sfpb-mutex" since there is no functional difference 
> other than stride.  What are your thoughts?
> 

I was thinking about this before and with your addition of tcsr having
different strides on different platforms we could either make the compatibles
more specifc (e.g. include platform name) or encode the stride in some other
way.

As you say there's no real technical difference in how we interact with the
current sfpb and tcsr mutex registers, so I would say making the compatibles
more specifc doesn't add any value.

I'll update this and follow your recommendation.



When we started hacking on this we found it very confusing that the caf driver
for tcsr is called sfpb, so I will keep both compatibles for clarity...

Thanks for your input!

Regards,
Bjorn
