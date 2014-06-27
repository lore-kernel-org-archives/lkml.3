Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834AbaF0NSU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 09:18:20 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:35873 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752604AbaF0NSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 09:18:18 -0400
Date: Fri, 27 Jun 2014 14:17:48 +0100
From: Will Deacon <will.deacon@arm.com>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "eric.auger@linaro.org" <eric.auger@linaro.org>,
        Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFC PATCH 4/9] irqchip: GIC: add support for forwarded
 interrupts
Message-ID: <20140627131748.GT26276@arm.com>
References: <1403688530-23273-1-git-send-email-marc.zyngier@arm.com>
 <1403688530-23273-5-git-send-email-marc.zyngier@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403688530-23273-5-git-send-email-marc.zyngier@arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marc,

On Wed, Jun 25, 2014 at 10:28:45AM +0100, Marc Zyngier wrote:
> Now that we've switched to EOImode == 1, prevent a forwarded interrupt
> from being deactivated after its priority has been dropped.
> 
> Also add support for the interrupt state to be saved/restored.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  drivers/irqchip/irq-gic.c | 48 +++++++++++++++++++++++++++++++++++++++++------
>  1 file changed, 42 insertions(+), 6 deletions(-)

[...]

> +static void gic_irq_set_fwd_state(struct irq_data *d, u32 val, u32 mask)
> +{
> +	if (mask & IRQ_FWD_STATE_PENDING)
> +		gic_poke_irq(d, (val & IRQ_FWD_STATE_PENDING) ? GIC_DIST_ENABLE_SET : GIC_DIST_ENABLE_CLEAR);
> +	if (mask & IRQ_FWD_STATE_ACTIVE)
> +		gic_poke_irq(d, (val & IRQ_FWD_STATE_ACTIVE) ? GIC_DIST_ACTIVE_SET : GIC_DIST_ACTIVE_CLEAR);
> +	if (mask & IRQ_FWD_STATE_MASKED)
> +		gic_poke_irq(d, (val & IRQ_FWD_STATE_MASKED) ? GIC_DIST_ENABLE_CLEAR : GIC_DIST_ENABLE_SET);

Given that this isn't atomic and KVM only cares about ACTIVE, why not change
mask to be a single state only? Renumbering the states so that's not bits
would help to enforce this (i.e. make IRQ_FWD_STATE_ACTIVE 0, PENDING 1,
...).

That would also allow you to switch on the state and return early.

> +static u32 gic_irq_get_fwd_state(struct irq_data *d, u32 mask)
> +{
> +	u32 val = 0;
> +
> +	if (mask & IRQ_FWD_STATE_PENDING && gic_peek_irq(d, GIC_DIST_ENABLE_SET))
> +		val |= IRQ_FWD_STATE_PENDING;
> +	if (mask & IRQ_FWD_STATE_ACTIVE && gic_peek_irq(d, GIC_DIST_ACTIVE_SET))
> +		val |= IRQ_FWD_STATE_ACTIVE;
> +	if (mask & IRQ_FWD_STATE_MASKED && !gic_peek_irq(d, GIC_DIST_ENABLE_SET))
> +		val |= IRQ_FWD_STATE_MASKED;

*and* you could peek GIC_DIST_ENABLE_SET in one place here.

Will
