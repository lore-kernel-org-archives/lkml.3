Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127AbbAMVB3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 16:01:29 -0500
Received: from www.linutronix.de ([62.245.132.108]:47272 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752780AbbAMVB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 16:01:28 -0500
Date: Tue, 13 Jan 2015 22:00:55 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
cc: Jason Cooper <jason@lakedaemon.net>,
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
In-Reply-To: <1421174781-4340-2-git-send-email-boris.brezillon@free-electrons.com>
Message-ID: <alpine.DEB.2.11.1501132153210.5526@nanos>
References: <1421174781-4340-1-git-send-email-boris.brezillon@free-electrons.com> <1421174781-4340-2-git-send-email-boris.brezillon@free-electrons.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Jan 2015, Boris Brezillon wrote:
> +	ret = irq_set_handler_data(irq, demux);
> +	if (ret) {
> +		pr_err("Failed to assign handler data\n");
> +		goto err_free_domain;
> +	}
> +
> +	irq_set_chained_handler(irq, irq_dumb_demux_handler);
> +
> +	/*
> +	 * Disable the src irq (automatically enabled by
> +	 * irq_set_chained_handler) to prevent irqs from happening while
> +	 * nobody requested any of the demuxed irqs.
> +	 */
> +	disable_irq(irq);

We rather prevent the startup of the irq line right away.

enum {
     IRQ_CHAINED_NONE,
     IRQ_CHAINED_STARTUP,
     IRQ_CHAINED_NOSTARTUP,
};

-__irq_set_handler(unsigned int irq, irq_flow_handler_t handle, int is_chained,
-                  const char *name);
+__irq_set_handler(unsigned int irq, irq_flow_handler_t handle, int chained_mode,
+                  const char *name);

{
....
        if (handle != handle_bad_irq && chained_mode) {
                irq_settings_set_noprobe(desc);
                irq_settings_set_norequest(desc);
                irq_settings_set_nothread(desc);
-               irq_startup(desc, true);
+               if (chained_mode == IRQ_CHAINED_STARTUP)
+                       irq_startup(desc, true);
	}
....
}

Hmm?

	tglx
