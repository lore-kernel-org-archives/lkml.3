Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718AbaFEWJ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 18:09:58 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:16244 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306AbaFEWJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 18:09:53 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 05 Jun 2014 15:01:49 -0700
Date: Fri, 6 Jun 2014 01:09:46 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Russell King <linux@arm.linux.org.uk>,
        Thierry Reding <thierry.reding@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Linus Walleij" <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v7 3/5] misc: fuse: Add efuse driver for Tegra
Message-ID: <20140605220946.GP5961@tbergstrom-lnx.Nvidia.com>
References: <1401973754-19701-1-git-send-email-pdeschrijver@nvidia.com>
 <1401973754-19701-4-git-send-email-pdeschrijver@nvidia.com>
 <5390B8E6.1050600@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <5390B8E6.1050600@wwwdotorg.org>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 05, 2014 at 08:37:26PM +0200, Stephen Warren wrote:
> On 06/05/2014 07:09 AM, Peter De Schrijver wrote:
> > Implement fuse driver for Tegra20, Tegra30, Tegra114 and Tegra124.
> > 
> > Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
> > ---
> >  Documentation/ABI/testing/sysfs-driver-tegra-fuse |   11 +
> >  drivers/misc/fuse/Makefile                        |    1 +
> >  drivers/misc/fuse/tegra/Makefile                  |    7 +
> >  drivers/misc/fuse/tegra/fuse-tegra.c              |  250 +++++++++++++++++
> 
> I wonder if we shouldn't put this into drivers/soc/tegra?
> 
> > diff --git a/drivers/misc/fuse/tegra/fuse-tegra.c b/drivers/misc/fuse/tegra/fuse-tegra.c
> 
> > +void __init tegra_init_fuse(void)
> > +{
> > +	struct device_node *np;
> > +	u32 id;
> > +	void __iomem *car_base;
> > +
> > +	np = of_find_matching_node(NULL, apbmisc_match);
> > +	apbmisc_base = of_iomap(np, 0);
> > +	if (!apbmisc_base) {
> > +		pr_warn("ioremap tegra apbmisc failed. using %08x instead\n",
> > +			APBMISC_BASE);
> > +		apbmisc_base = ioremap(APBMISC_BASE, APBMISC_SIZE);
> > +	}
> > +
> > +	id = tegra_read_chipid();
> > +	tegra_chip_id = (id >> 8) & 0xff;
> 
> So there's a fallback using APBMIS_BASE above if the node is missing, so
> those last 2 lines always happen. However, if any of the following fail:
> 
> > +	strapping_base = of_iomap(np, 0);
> ...
> > +	np = of_find_matching_node(NULL, tegra_fuse_match);
> ...
> > +	np = of_find_matching_node(NULL, car_match);
> 
> Then this doesn't get executed:
> 
> > +	tegra_get_revision(id);
> 
> Isn't that important?
> 

No. It's only used to populate /sys/devices/soc0/revision. I don't think
that's particularly important.

> I guess that can't run if the lookup for tegra_fuse_match isn't
> successful, since that tegra_get_revision may call
> tegra20_spare_fuse_early() which uses fuse_base which is set up in
> response to succesfully calling on of those node lookups. Isn't a
> fallback needed there too?
> 

tegra20_spare_fuse_early() will not be called if fuse_base is NULL.

> I'm also a bit concerned that the driver probes, rather than the early
> function tegra_init_fuse(), are doing things like setting up the speedo
> data initialization, randomness addition, etc. For one, those won't
> happen any more unless the DT nodes are present, and secondly,
> triggering all those from driver probe rather than a function that's
> called from the machine descriptor makes guaranteeing the timing
> problematic.
> 

Today there are no users of the speedo ID in upstream. Looking at chromeos
the users of the speedo ID are: CPU dvfs, GPU dvfs and sdhci. The last 2 also
need regulators and therefor will need to support deferred probing anyway.
CPU dvfs isn't critical at all, we don't care when it gets initialized. So
deferred probe is fine.
sdhci needs this for faster modes I guess which will also need extra DT
properties looking at the chromeos driver. The others definitely will need
an updated DT. For randomness I haven't seen any appreciable difference in when
the 'random: nonblocking pool is initialized' message appears between having
the randomness addition or not. Most likely the bulk of the randomness comes
from serial interrupts rather than the fuse data. So I don't think the move to
a driver probe will cause any problem. Nor do I think the lack of an updated
DT will cause problems.

Cheers,

Peter.
