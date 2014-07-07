Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752118AbaGGKns (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 06:43:48 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:11328 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752001AbaGGKno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 06:43:44 -0400
From: Marc Zyngier <marc.zyngier@arm.com>
To: Will Deacon <will.deacon@arm.com>
Cc: "kvmarm\@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "eric.auger\@linaro.org" <eric.auger@linaro.org>,
        Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFC PATCH 4/9] irqchip: GIC: add support for forwarded interrupts
In-Reply-To: <20140627131748.GT26276@arm.com> (Will Deacon's message of "Fri,
	27 Jun 2014 14:17:48 +0100")
Organization: ARM Ltd
References: <1403688530-23273-1-git-send-email-marc.zyngier@arm.com>
	<1403688530-23273-5-git-send-email-marc.zyngier@arm.com>
	<20140627131748.GT26276@arm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
Date: Mon, 07 Jul 2014 11:43:30 +0100
Message-ID: <87egxxa1pp.fsf@why.wild-wind.fr.eu.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27 2014 at  2:17:48 pm BST, Will Deacon <will.deacon@arm.com> wrote:
> Hi Marc,
>
> On Wed, Jun 25, 2014 at 10:28:45AM +0100, Marc Zyngier wrote:
>> Now that we've switched to EOImode == 1, prevent a forwarded interrupt
>> from being deactivated after its priority has been dropped.
>> 
>> Also add support for the interrupt state to be saved/restored.
>> 
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  drivers/irqchip/irq-gic.c | 48
>> +++++++++++++++++++++++++++++++++++++++++------
>>  1 file changed, 42 insertions(+), 6 deletions(-)
>
> [...]
>
>> +static void gic_irq_set_fwd_state(struct irq_data *d, u32 val, u32 mask)
>> +{
>> +	if (mask & IRQ_FWD_STATE_PENDING)
>> + gic_poke_irq(d, (val & IRQ_FWD_STATE_PENDING) ?
>> GIC_DIST_ENABLE_SET : GIC_DIST_ENABLE_CLEAR);
>> +	if (mask & IRQ_FWD_STATE_ACTIVE)
>> + gic_poke_irq(d, (val & IRQ_FWD_STATE_ACTIVE) ? GIC_DIST_ACTIVE_SET
>> : GIC_DIST_ACTIVE_CLEAR);
>> +	if (mask & IRQ_FWD_STATE_MASKED)
>> + gic_poke_irq(d, (val & IRQ_FWD_STATE_MASKED) ?
>> GIC_DIST_ENABLE_CLEAR : GIC_DIST_ENABLE_SET);
>
> Given that this isn't atomic and KVM only cares about ACTIVE, why not change
> mask to be a single state only? Renumbering the states so that's not bits
> would help to enforce this (i.e. make IRQ_FWD_STATE_ACTIVE 0, PENDING 1,
> ...).
>
> That would also allow you to switch on the state and return early.

Well, this is atomic from the point of view of the interrupt (we hold
the descriptor spinlock). Now, given my answer to your remark about the
locking earlier in this thread and given the KVM use case, we could
indeed relax this and loose the atomicity. But we need to agree on what
is the model we want to expose.

>> +static u32 gic_irq_get_fwd_state(struct irq_data *d, u32 mask)
>> +{
>> +	u32 val = 0;
>> +
>> + if (mask & IRQ_FWD_STATE_PENDING && gic_peek_irq(d,
>> GIC_DIST_ENABLE_SET))
>> +		val |= IRQ_FWD_STATE_PENDING;
>> +	if (mask & IRQ_FWD_STATE_ACTIVE && gic_peek_irq(d, GIC_DIST_ACTIVE_SET))
>> +		val |= IRQ_FWD_STATE_ACTIVE;
>> + if (mask & IRQ_FWD_STATE_MASKED && !gic_peek_irq(d,
>> GIC_DIST_ENABLE_SET))
>> +		val |= IRQ_FWD_STATE_MASKED;
>
> *and* you could peek GIC_DIST_ENABLE_SET in one place here.

Ah yes, this is a GIC specificity (MASKED = !ENABLED). Good point.

Thanks,

	M.
-- 
Without deviation from the norm, progress is not possible.
