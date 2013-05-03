Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761968Ab3ECWii (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 18:38:38 -0400
Received: from www.linutronix.de ([62.245.132.108]:47364 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034Ab3ECWih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 18:38:37 -0400
Date: Sat, 4 May 2013 00:38:34 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: LKML <linux-kernel@vger.kernel.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Arnd Bergmann <arnd@arndb.de>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Jean-Francois Moine <moinejf@free.fr>,
        Gerlando Falauto <gerlando.falauto@keymile.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC patch 7/8] genirq: generic chip: Add linear irq domain
 support
In-Reply-To: <20130503222300.GF18614@n2100.arm.linux.org.uk>
Message-ID: <alpine.LFD.2.02.1305040033000.2990@ionos>
References: <alpine.LFD.2.02.1305031514230.2886@ionos> <20130503212258.385818955@linutronix.de> <20130503214629.810207749@linutronix.de> <20130503222300.GF18614@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 May 2013, Russell King - ARM Linux wrote:

> On Fri, May 03, 2013 at 09:50:53PM -0000, Thomas Gleixner wrote:
> > +	/* Init mask cache ? */
> > +	if (dgc->gc_flags & IRQ_GC_INIT_MASK_CACHE) {
> > +		raw_spin_lock_irqsave(&gc->lock, flags);
> > +		gc->mask_cache = irq_reg_readl(gc->reg_base + ct->regs.mask);
> > +		raw_spin_unlock_irqrestore(&gc->lock, flags);
> > +	}
> 
> This looks a little weird to me - it seems that it'll re-read this
> each time any irq is mapped in the domain, which is probably not
> wanted.

Yes, it's sloppy in two aspects.

1) It does not respect the per irq type mask cache, which got
   introduced in the same series

2) It rereads the mask cache for each mapping, but thats harmless
   because it's proper serialized. We can avoid that by clearing the
   IRQ_GC_INIT_MASK_CACHE bit when the first irq of that chip is
   mapped.

Congrats, you found a bug and as I said:

	  WARNING: It's compile tested only. So if you find bugs you can keep
	  them and fix them yourself :)

Thanks,

	tglx
