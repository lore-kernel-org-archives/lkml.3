Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751570AbaESXSJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 19:18:09 -0400
Received: from www.linutronix.de ([62.245.132.108]:52752 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868AbaESXSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 19:18:08 -0400
Date: Tue, 20 May 2014 08:18:16 +0900 (JST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
cc: LKML <linux-kernel@vger.kernel.org>, linux@openrisc.net,
        jonas@southpole.se, Jason Cooper <jason@lakedaemon.net>
Subject: Re: [PATCH v2] openrisc: irq: use irqchip framework
In-Reply-To: <1400530303-29182-1-git-send-email-stefan.kristiansson@saunalahti.fi>
Message-ID: <alpine.DEB.2.02.1405200809260.5204@ionos.tec.linutronix.de>
References: <1400530303-29182-1-git-send-email-stefan.kristiansson@saunalahti.fi>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 May 2014, Stefan Kristiansson wrote:
> +static void or1k_pic_ack(struct irq_data *data)
> +{
> +	/* EDGE-triggered interrupts need to be ack'ed in order to clear
> +	 * the latch.
> +	 * LEVEL-triggered interrupts do not need to be ack'ed; however,
> +	 * ack'ing the interrupt has no ill-effect and is quicker than
> +	 * trying to figure out what type it is...
> +	 */

The right thing to do here is to have two interrupt chips. One for
level and one for ack. So you do not need a runtime check and you
avoid the ack for the level type.

> +	/* The OpenRISC 1000 spec says to write a 1 to the bit to ack the
> +	 * interrupt, but the OR1200 does this backwards and requires a 0
> +	 * to be written...
> +	 */
> +
> +#ifdef CONFIG_OR1K_1200
> +	/* There are two oddities with the OR1200 PIC implementation:
> +	 * i)  LEVEL-triggered interrupts are latched and need to be cleared
> +	 * ii) the interrupt latch is cleared by writing a 0 to the bit,
> +	 *     as opposed to a 1 as mandated by the spec
> +	 */
> +
> +	mtspr(SPR_PICSR, mfspr(SPR_PICSR) & ~(1UL << data->hwirq));
> +#else
> +	mtspr(SPR_PICSR, (1UL << data->hwirq));
> +#endif

Again, you could set the write 1/0 variant at runtime.

> +static int or1k_map(struct irq_domain *d, unsigned int irq, irq_hw_number_t hw)
> +{
> +	irq_set_chip_and_handler_name(irq, &or1k_dev,
> +				      handle_level_irq, "level");

It's wrong to use the level flow handler for edge type interrupts as
you might lose edges.

Thanks,

	tglx
