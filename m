Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367Ab3GQN24 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 09:28:56 -0400
Received: from smtp.citrix.com ([66.165.176.89]:63741 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753892Ab3GQN2z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 09:28:55 -0400
X-IronPort-AV: E=Sophos;i="4.89,684,1367971200"; 
   d="scan'208";a="37503721"
Date: Wed, 17 Jul 2013 14:28:43 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Julien Grall <julien.grall@linaro.org>, <stefano.stabellini@eu.citrix.com>,
        <ian.campbell@citrix.com>, <patches@linaro.org>,
        <linux-kernel@vger.kernel.org>, <xen-devel@lists.xen.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [Xen-devel] [PATCH] xen/arm: disable cpuidle when linux is
 running as dom0
In-Reply-To: <20130715152532.GC5774@phenom.dumpdata.com>
Message-ID: <alpine.DEB.2.02.1307171426300.8258@kaball.uk.xensource.com>
References: <1373898101-15633-1-git-send-email-julien.grall@linaro.org> <20130715152532.GC5774@phenom.dumpdata.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Jul 2013, Konrad Rzeszutek Wilk wrote:
> On Mon, Jul 15, 2013 at 03:21:41PM +0100, Julien Grall wrote:
> > When linux is running as dom0, Xen doesn't show the physical cpu but a
> > virtual CPU.
> > On some ARM SOC (for instance the exynos 5250), linux registers callbacks
> > for cpuidle. When these callbacks are called, they will modify
> > directly the physical cpu not the virtual one.
> It can impact the whole board
> > instead of dom0.

Certainly this is something that should be fixed at the hypervisor level
too. However I agree that Linux should try to avoid doing that when
running on Xen.



> Should you also call disable_cpufreq() ?

Sounds like a good idea.
Julien, could you add that to this patch?


> > 
> > Signed-off-by: Julien Grall <julien.grall@linaro.org>
> > ---
> >  arch/arm/xen/enlighten.c |    7 +++++++
> >  1 file changed, 7 insertions(+)
> > 
> > diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
> > index 49839d8..a98999f 100644
> > --- a/arch/arm/xen/enlighten.c
> > +++ b/arch/arm/xen/enlighten.c
> > @@ -24,6 +24,8 @@
> >  #include <linux/of.h>
> >  #include <linux/of_irq.h>
> >  #include <linux/of_address.h>
> > +#include <linux/cpuidle.h>
> > +#include <linux/cpufreq.h>
> >  
> >  #include <linux/mm.h>
> >  
> > @@ -292,6 +294,11 @@ static int __init xen_pm_init(void)
> >  {
> >  	pm_power_off = xen_power_off;
> >  	arm_pm_restart = xen_restart;
> > +	/*
> > +	 * Making sure board specific code will not set up ops for
> > +	 * cpu idle.
> > +	 */
> > +	disable_cpuidle();
> >  
> >  	return 0;
> >  }
> > -- 
> > 1.7.10.4
> > 
> > 
> > _______________________________________________
> > Xen-devel mailing list
> > Xen-devel@lists.xen.org
> > http://lists.xen.org/xen-devel
> 
