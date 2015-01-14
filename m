Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882AbbANIbh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 03:31:37 -0500
Received: from down.free-electrons.com ([37.187.137.238]:41233 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754357AbbANIbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 03:31:34 -0500
Date: Wed, 14 Jan 2015 09:31:30 +0100
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Jason Cooper <jason@lakedaemon.net>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH v2 1/5] irqchip: add dumb demultiplexer implementation
Message-ID: <20150114093130.3923a89a@bbrezillon>
In-Reply-To: <alpine.DEB.2.11.1501132153210.5526@nanos>
References: <1421174781-4340-1-git-send-email-boris.brezillon@free-electrons.com>
	<1421174781-4340-2-git-send-email-boris.brezillon@free-electrons.com>
	<alpine.DEB.2.11.1501132153210.5526@nanos>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

On Tue, 13 Jan 2015 22:00:55 +0100 (CET)
Thomas Gleixner <tglx@linutronix.de> wrote:

> On Tue, 13 Jan 2015, Boris Brezillon wrote:
> > +	ret = irq_set_handler_data(irq, demux);
> > +	if (ret) {
> > +		pr_err("Failed to assign handler data\n");
> > +		goto err_free_domain;
> > +	}
> > +
> > +	irq_set_chained_handler(irq, irq_dumb_demux_handler);
> > +
> > +	/*
> > +	 * Disable the src irq (automatically enabled by
> > +	 * irq_set_chained_handler) to prevent irqs from happening while
> > +	 * nobody requested any of the demuxed irqs.
> > +	 */
> > +	disable_irq(irq);
> 
> We rather prevent the startup of the irq line right away.

Yep, the comment was here to draw the attention, since I wasn't sure
modifying core code was the best solution.
Anyway I agree that keeping the src_irq disabled when registering the
chained handler is better than doing it afterwards.

> 
> enum {
>      IRQ_CHAINED_NONE,
>      IRQ_CHAINED_STARTUP,
>      IRQ_CHAINED_NOSTARTUP,
> };
> 
> -__irq_set_handler(unsigned int irq, irq_flow_handler_t handle, int is_chained,
> -                  const char *name);
> +__irq_set_handler(unsigned int irq, irq_flow_handler_t handle, int chained_mode,
> +                  const char *name);
> 
> {
> ....
>         if (handle != handle_bad_irq && chained_mode) {
>                 irq_settings_set_noprobe(desc);
>                 irq_settings_set_norequest(desc);
>                 irq_settings_set_nothread(desc);
> -               irq_startup(desc, true);
> +               if (chained_mode == IRQ_CHAINED_STARTUP)
> +                       irq_startup(desc, true);
> 	}
> ....
> }
> 
> Hmm?

I'm fine with this approach, with a static inline helper:

static inline void
irq_set_chained_handler_nostartup(unsigned int irq,
				  irq_flow_handler_t handle)
{
	__irq_set_handler(irq, handle, IRQ_CHAINED_NOSTARTUP, NULL);
}

Anyway, I'll wait a clear decision regarding which approach should be
taken (see my answer to Rob) before sending a new version.

Thanks for your reviews.

Best Regards,

Boris


-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
