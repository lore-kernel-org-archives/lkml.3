Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759947AbaLLDEl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 22:04:41 -0500
Received: from utopia.booyaka.com ([74.50.51.50]:49446 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756007AbaLLDEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 22:04:39 -0500
Date: Fri, 12 Dec 2014 03:04:37 +0000 (UTC)
From: Paul Walmsley <pwalmsley@nvidia.com>
To: Thierry Reding <treding@nvidia.com>
cc: linux-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, Kumar Gala <galak@codeaurora.org>,
        Paul Walmsley <pwalmsley@nvidia.com>,
        Allen Martin <amartin@nvidia.com>, Stephen Warren <swarren@nvidia.com>,
        Alexandre Courbot <gnurou@gmail.com>
Subject: Re: [PATCH] soc: tegra: pmc: restrict compilation of suspend-related
 support to ARM
In-Reply-To: <20141210112322.GE15287@ulmo.nvidia.com>
Message-ID: <alpine.DEB.2.02.1412120257430.29716@utopia.booyaka.com>
References: <alpine.DEB.2.02.1412092224050.31750@utopia.booyaka.com> <20141210112322.GE15287@ulmo.nvidia.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Thierry

On Wed, 10 Dec 2014, Thierry Reding wrote:

> On Tue, Dec 09, 2014 at 10:36:50PM +0000, Paul Walmsley wrote:
> > 
> > Tegra SoCs with 64-bit ARM support don't currently support deep CPU
> > low-power states in mainline Linux.  When this support is added in the
> > future, it will probably look rather different from the existing
> > 32-bit ARM support, since the ARM64 maintainers' strong preference is
> > to use PSCI to implement it.
> > 
> > So, for the time being, prevent the CPU suspend-related code and data
> > in the Tegra PMC driver from compiling on ARM64.
> > 
> > Signed-off-by: Paul Walmsley <paul@pwsan.com>
> > Signed-off-by: Paul Walmsley <pwalmsley@nvidia.com>
> > Cc: Thierry Reding <treding@nvidia.com>
> > Cc: Allen Martin <amartin@nvidia.com>
> > Cc: Stephen Warren <swarren@nvidia.com>
> > Cc: Alexandre Courbot <gnurou@gmail.com>
> > ---
> > Applies on next-20141209.
> > Intended for v3.20.
> > Boot-tested on Tegra124 Jetson TK1 on next-20141209.
> > Also boot-tested on Tegra132 Norrin FFD on next-20141209 + some unrelated 
> > patches.
> > 
> >  drivers/soc/tegra/pmc.c | 7 +++++--
> >  include/soc/tegra/pm.h  | 2 +-
> >  2 files changed, 6 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/soc/tegra/pmc.c b/drivers/soc/tegra/pmc.c
> > index a2c0ceb95f8f..4bdc654bd747 100644
> > --- a/drivers/soc/tegra/pmc.c
> > +++ b/drivers/soc/tegra/pmc.c
> > @@ -739,7 +739,7 @@ static int tegra_pmc_probe(struct platform_device *pdev)
> >  	return 0;
> >  }
> >  
> > -#ifdef CONFIG_PM_SLEEP
> > +#if defined(CONFIG_PM_SLEEP) && defined(CONFIG_ARM)
> 
> I would slightly prefer having this as separate #ifdef lines to make it
> clearer that we're special-casing 32-bit ARM.

That's fine, I'll update that when the patch is reposted against 
v3.19-rc1.

> >  static int tegra_pmc_suspend(struct device *dev)
> >  {
> >  	tegra_pmc_writel(virt_to_phys(tegra_resume), PMC_SCRATCH41);
> > @@ -753,10 +753,11 @@ static int tegra_pmc_resume(struct device *dev)
> >  
> >  	return 0;
> >  }
> > -#endif
> >  
> >  static SIMPLE_DEV_PM_OPS(tegra_pmc_pm_ops, tegra_pmc_suspend, tegra_pmc_resume);
> >  
> > +#endif
> 
> I don't think this is necessary, SIMPLE_DEV_PM_OPS will not use the
> supend or resume hooks if PM_SLEEP is disabled. 

PM_SLEEP is enabled by default for the ARM64 defconfig, and I don't plan 
to patch that out.

> > diff --git a/include/soc/tegra/pm.h b/include/soc/tegra/pm.h
> > index 30fe2078a547..03909101d4e7 100644
> > --- a/include/soc/tegra/pm.h
> > +++ b/include/soc/tegra/pm.h
> > @@ -17,7 +17,7 @@ enum tegra_suspend_mode {
> >  	TEGRA_MAX_SUSPEND_MODE,
> >  };
> >  
> > -#ifdef CONFIG_PM_SLEEP
> > +#if defined(CONFIG_PM_SLEEP) && defined(CONFIG_ARM)
> 
> Similarly to the above, I'd prefer this to be two separate lines. That
> also has the advantage that if we do add code for suspend/resume on 64
> bit ARM later on we don't need to untangle the conditional again.

I'm fine to change it, although it seems rather unlikely that this will be 
a significant issue.


- Paul
