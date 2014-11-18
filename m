Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119AbaKRJzG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 04:55:06 -0500
Received: from www.linutronix.de ([62.245.132.108]:37809 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbaKRJzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 04:55:03 -0500
Date: Tue, 18 Nov 2014 10:54:56 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Yun Wu (Abel)" <wuyun.wu@huawei.com>
cc: LKML <linux-kernel@vger.kernel.org>, Jiang Liu <jiang.liu@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Yijing Wang <wangyijing@huawei.com>
Subject: Re: [patch 01/16] irqdomain: Introduce new interfaces to support
 hierarchy irqdomains
In-Reply-To: <546B1067.2020403@huawei.com>
Message-ID: <alpine.DEB.2.11.1411181048110.3909@nanos>
References: <20141112133941.647950773@linutronix.de> <20141112134119.881823615@linutronix.de> <546B1067.2020403@huawei.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Nov 2014, Yun Wu (Abel) wrote:
> Hi Thomas, Jiang,
> On 2014/11/12 21:42, Thomas Gleixner wrote:
> 
> > From: Jiang Liu <jiang.liu@linux.intel.com>
> > Index: tip/kernel/irq/chip.c
> > ===================================================================
> > --- tip.orig/kernel/irq/chip.c
> > +++ tip/kernel/irq/chip.c
> > @@ -15,6 +15,7 @@
> >  #include <linux/module.h>
> >  #include <linux/interrupt.h>
> >  #include <linux/kernel_stat.h>
> > +#include <linux/irqdomain.h>
> >  
> >  #include <trace/events/irq.h>
> >  
> > @@ -178,6 +179,7 @@ int irq_startup(struct irq_desc *desc, b
> >  	irq_state_clr_disabled(desc);
> >  	desc->depth = 0;
> >  
> > +	irq_domain_activate_irq(&desc->irq_data);
> 
> I'm not sure why this is needed, please help me out.. :)

Because it makes the whole error handling in stacked allocations way
simpler.

We allocate and reserve resources, but do not program the hardware up
to the point where request_irq and therefor irq_startup() is invoked.

So when in the allocation/reservation phase any of the stack level
fails we just have to undo the allocations/reservations and not any
hardware settings.

That also solves the issue that depending on the stacking we might not
be able to program the hardware during the allocation because all
stack levels need to be allocated/reserved before we can figure out
which hardware configuration we need for the various levels.

So we decided to postpone the actual hardware programming to the point
where the interrupt actually gets used.

Thanks,

	tglx

