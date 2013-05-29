Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759337Ab3E2CW4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 22:22:56 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:61603 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758274Ab3E2CWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 22:22:54 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [patch 7/8] genirq: generic chip: Add linear irq domain support
To: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
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
In-Reply-To: <20130506142539.450634298@linutronix.de>
References: <20130503212258.385818955@linutronix.de> <20130506142348.321859745@linutronix.de> <20130506142539.450634298@linutronix.de>
Date: Wed, 29 May 2013 03:22:49 +0100
Message-Id: <20130529022249.DE5ED3E14F1@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 06 May 2013 14:30:27 -0000, Thomas Gleixner <tglx@linutronix.de> wrote:
> Provide infrastructure for irq chip implementations which work on
> linear irq domains.
> 
> - Interface to allocate multiple generic chips which are associated to
>   the irq domain.
> 
> - Interface to get the generic chip pointer for a particular hardware
>   interrupt in the domain.
> 
> - irq domain mapping function to install the chip for a particular
>   interrupt.
> 
> Note: This lacks a removal function for now, but this is a draft patch
> the ARM folks to work on.
> 
> [ Sebastian Hesselbarth: Mask cache and pointer math fixups ]
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Hi Thomas,

Acked-by: Grant Likely <grant.likely@linaro.org>

But I have some comments below...

> ---
>  include/linux/irq.h       |   30 +++++++
>  include/linux/irqdomain.h |   12 ++
>  kernel/irq/generic-chip.c |  187 ++++++++++++++++++++++++++++++++++++++++++++--
>  kernel/irq/irqdomain.c    |    6 -
>  4 files changed, 223 insertions(+), 12 deletions(-)
> 
> Index: linux-2.6/include/linux/irq.h
> ===================================================================
> --- linux-2.6.orig/include/linux/irq.h
> +++ linux-2.6/include/linux/irq.h
> @@ -678,6 +678,8 @@ struct irq_chip_type {
>   * @wake_active:	Interrupt is marked as an wakeup from suspend source
>   * @num_ct:		Number of available irq_chip_type instances (usually 1)
>   * @private:		Private data for non generic chip callbacks
> + * @installed:		bitfield to denote installed interrupts
> + * @domain:		irq domain pointer
>   * @list:		List head for keeping track of instances
>   * @chip_types:		Array of interrupt irq_chip_types
>   *
> @@ -699,6 +701,8 @@ struct irq_chip_generic {
>  	u32			wake_active;
>  	unsigned int		num_ct;
>  	void			*private;
> +	unsigned long		installed;

This is probably something that the irqdomain should be keeping track of
internally, but that's an issue for a separate patch series.

[...]
> +struct irq_domain_ops irq_generic_chip_ops = {
> +	.map = irq_map_generic_chip,
> +	.xlate = irq_domain_xlate_onecell,

As discussed on IRC, should use onetwocell here for greater
compatibility with existing bindings.

Cheers,
g.
