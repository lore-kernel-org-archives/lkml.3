Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751645AbaJYU1n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2014 16:27:43 -0400
Received: from www.linutronix.de ([62.245.132.108]:51112 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbaJYU1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2014 16:27:42 -0400
Date: Sat, 25 Oct 2014 22:27:37 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Marc Zyngier <marc.zyngier@arm.com>
cc: Jason Cooper <jason@lakedaemon.net>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/3] genirq: Add support for priority-drop/deactivate
 interrupt controllers
In-Reply-To: <1414235215-10468-2-git-send-email-marc.zyngier@arm.com>
Message-ID: <alpine.DEB.2.11.1410252144170.5308@nanos>
References: <1414235215-10468-1-git-send-email-marc.zyngier@arm.com> <1414235215-10468-2-git-send-email-marc.zyngier@arm.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 Oct 2014, Marc Zyngier wrote:

@@ -330,6 +330,7 @@ struct irq_chip {
        void            (*irq_mask)(struct irq_data *data);
        void            (*irq_mask_ack)(struct irq_data *data);
        void            (*irq_unmask)(struct irq_data *data);
+       void            (*irq_priority_drop)(struct irq_data *data);

Lacks the docbook comment.

> +static void mask_threaded_irq(struct irq_desc *desc)

There is only one caller for this, i.e handle_fasteoi_irq, right? So
this should go to the other eoi handler specific helpers and have eoi
in its name.

> +{
> +	struct irq_chip *chip = desc->irq_data.chip;
> +
> +	/* If we can do priority drop, then masking comes for free */
> +	if (chip->irq_priority_drop)
> +		irq_state_set_masked(desc);
> +	else
> +		mask_irq(desc);
> +}

>  void unmask_irq(struct irq_desc *desc)
>  {
> -	if (desc->irq_data.chip->irq_unmask) {
> -		desc->irq_data.chip->irq_unmask(&desc->irq_data);
> +	struct irq_chip *chip = desc->irq_data.chip;
> +
> +	if (chip->irq_unmask && !chip->irq_priority_drop)
> +		chip->irq_unmask(&desc->irq_data);

I have a hard time to understand that logic. Assume the interrupt
being masked at the hardware level after boot. Now at request_irq()
time what is going to unmask that very interrupt? Ditto for masking
after disable_irq(). Probably not what you really want.

> +static void eoi_irq(struct irq_desc *desc, struct irq_chip *chip)
> +{
> +	if (chip->irq_priority_drop)
> +		chip->irq_priority_drop(&desc->irq_data);
> +	if (chip->irq_eoi)
> +		chip->irq_eoi(&desc->irq_data);
> +}

So if you are using that priority drop stuff, you need both calls even
for the non threaded case?

>  static void cond_unmask_eoi_irq(struct irq_desc *desc, struct irq_chip *chip)
>  {
>  	if (!(desc->istate & IRQS_ONESHOT)) {
> -		chip->irq_eoi(&desc->irq_data);
> +		eoi_irq(desc, chip);
>  		return;
>  	}
> +
> +	if (chip->irq_priority_drop)
> +		chip->irq_priority_drop(&desc->irq_data);
> +
>  	/*
>  	 * We need to unmask in the following cases:
>  	 * - Oneshot irq which did not wake the thread (caused by a
> @@ -485,7 +507,8 @@ static void cond_unmask_eoi_irq(struct irq_desc *desc, struct irq_chip *chip)
>  	if (!irqd_irq_disabled(&desc->irq_data) &&
>  	    irqd_irq_masked(&desc->irq_data) && !desc->threads_oneshot) {
>  		chip->irq_eoi(&desc->irq_data);
> -		unmask_irq(desc);
> +		if (!chip->irq_priority_drop)
> +			unmask_irq(desc);

This is really completely obfuscated: Brain starts melting and
spiraling towards some unidentified universe.

Seriously, I don't think it's a good idea to bandaid this
functionality into the existing handle_fasteoi_irq() mechanism. It's
complex enough already.

So what you really want is a separate handler for this. But aside of
adding the drop prio callback you probably want to handle the other
existing callbacks completely differently than for the regular mode of
that irq controller.

Can you please explain detailed how this "priority drop" mode
works? 

Thanks,

	tglx
