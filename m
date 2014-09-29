Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519AbaI2OWp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 10:22:45 -0400
Received: from www.linutronix.de ([62.245.132.108]:51937 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543AbaI2OWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 10:22:43 -0400
Date: Mon, 29 Sep 2014 16:23:08 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
cc: marc.zyngier@arm.com, mark.rutland@arm.com, jason@lakedaemon.net,
        will.deacon@arm.com, catalin.marinas@arm.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-doc@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [RFC 4/4] irqchip: gicv2m: Add supports for ARM GICv2m MSI(-X)
In-Reply-To: <54287F17.8000503@amd.com>
Message-ID: <alpine.DEB.2.02.1409291611030.22082@ionos.tec.linutronix.de>
References: <1411937610-22125-1-git-send-email-suravee.suthikulpanit@amd.com> <1411937610-22125-5-git-send-email-suravee.suthikulpanit@amd.com> <54287F17.8000503@amd.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Sep 2014, Suravee Suthikulpanit wrote:

> Jason/Thomas,
> 
> This patch comes from:
>     [V8 2/2] irqchip: gicv2m: Add supports for ARM GICv2m MSI(-X)
>     (https://lkml.org/lkml/2014/9/20/113)
> 
> It has been slightly modified to remove the multi-MSI supports for now
> (I am waiting to discuss with Marc after he returned from vacation.), and will
> be submitted separately.
> 
> Since this patch is independent from the multi-MSI stuff.  Please let me know
> if you would consider taking this separately.

Not without an explicit reviewed/acked from Marc for the GIC part and
a reviewed/acked from the DT folks.

Aside of that the conditional madness is just horrible:
 
> > +static inline
> > +struct gic_chip_data *irq_data_get_gic_chip_data(struct irq_data *d)
> > +{
> > +	struct gic_chip_data *gic_data;
> > +	struct msi_chip *mchip;
> > +	struct v2m_data *v2mdat;
> > +
> > +	/*
> > +	 * For MSI, irq_data.chip_data points to struct msi_chip.
> > +	 * For non-MSI, irq_data.chip_data points to struct gic_chip_data.
> > +	 */
> > +	if (d->msi_desc) {
> > +		mchip = irq_data_get_irq_chip_data(d);
> > +		v2mdat = container_of(mchip, struct v2m_data, msi_chip);
> > +		gic_data = v2mdat->gic;
> > +	} else {
> > +		gic_data = irq_data_get_irq_chip_data(d);
> > +	}
> > +	return gic_data;
> > +}

For heavens sake, why are you insisting on duct-taping that into the
GIC proper instead of coming up with a proper layering?

    https://lkml.org/lkml/2014/8/27/228
    https://lkml.org/lkml/2014/8/26/707

Thanks,

	tglx
    

