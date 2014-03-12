Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861AbaCLI4I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 04:56:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1894 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751804AbaCLI4D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 04:56:03 -0400
Message-ID: <53202118.1060201@redhat.com>
Date: Wed, 12 Mar 2014 09:55:52 +0100
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org, Carlo Caione <carlo.caione@gmail.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-sunxi <linux-sunxi@googlegroups.com>
Subject: Re: [PATCH] irq: Add a new IRQF_ACK_BEFORE_UNMASK irq flag
References: <1394579583-29316-1-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1394579583-29316-1-git-send-email-hdegoede@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

So after sleeping a night on this I'm not so sure anymore this patch
is such such a good idea. So self-nack.

Still I welcome feedback on this issue...

On 03/12/2014 12:13 AM, Hans de Goede wrote:
> In some cases we want to do an ack right before the unmask of an irq.
> 
> A typical example of such a case is having an i2c device which uses a level
> interrupt. Such devices usually have an interrupt status register with
> write to clear status bits. This means that the interrupt handler needs to
> sleep to do i2c transfers to read / write the interrupt status register.
> 
> This means using a threaded interrupt handler and IRQF_ONESHOT so that the
> interrupt does not re-trigger while the interrupt handler is waiting for the
> i2c transfer.
> 
> Without ack-before-unmask the sequence of a single interrupt in this setup
> looks like this:
> 
> i2c-device raises interrupt line
> interrupt gets triggered
> interrupt gets masked
> interrupt gets acked
> interrupt handling thread starts running
> interrupt handling thread does its stuff, write-clears irq-status register
>  in i2c-device
> i2c-device lowers interrupt line (note this happens after the ack!)
> interrupt handling thread is done
> interrupt gets unmasked
> interrupt immediately retriggers again, because the line has been high
>  after the ack

So this is the crux, it seems that for interrupt 0 (called an External NMI
by the datasheet, even though it can be masked just fine). When configured
for level interrupts the external interrupt line needs to become low (inactive)
before the ack. Otherwise the interrupt handler will be called a second time.

Comparing this to how normal level interrupts works, this seems a special
case for the ENMI on sun4i, AFAIK a normal level interrupt goes like this:

device raises interrupt line
interrupt gets triggered
interrupt gets masked
interrupt gets acked
interrupt handler runs, clears interrupt source
device lowers interrupt line
interrupt gets unmasked

And thats it, so normal level interrupts only get sensitive to an active
interrupt line after the unmask, but this ENMI stays sensitive the whole
time, and we need to do the ack after clearing the source, to avoid
a spurious second interrupt.

> interrupt gets masked
> interrupt gets acked
> interrupt handling thread starts running
> interrupt handling thread reads irq-status register, has nothing todo
> interrupt handling thread is done
> interrupt gets unmasked
> 
> So in essence we get and handle 2 interrupts for what is 1 interrupt from
> the i2c-device pov. By doing an ack before the unmask, the second interrupt
> is avoided since at the point of the unmask the irq-thread has done its
> job and cleared the interrupt source.
> 
> Note that things work fine without this patch, the purpose of this patch is
> soley to avoid the second unneeded interrupt.
> 
> This patch uses an interrupt flag for this and not an irqchip flag because
> the need for ack before unmask is based on the device and not on the irqchip.

So this is also wrong, this is an irqchip property, not a device property, and
more-over its an irqchip property only happening for one special interrupt, so
we cannot do this with an irqchip flag either. We will need to add some special
handling for this one interrupt inside the irq-sun4i.c driver.

I'll be working on my $dayjob for most of today, so I'm not sure if I'll have'
time for this today, but if I've some time this evening I'll try to whip up
a patch, give it a test-run and then send it out.

Regards,

Hans


> 
> Cc: Carlo Caione <carlo.caione@gmail.com>
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---
>  include/linux/interrupt.h | 2 ++
>  kernel/irq/chip.c         | 4 ++++
>  kernel/irq/internals.h    | 2 ++
>  kernel/irq/manage.c       | 5 ++++-
>  4 files changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
> index a2678d3..c252344 100644
> --- a/include/linux/interrupt.h
> +++ b/include/linux/interrupt.h
> @@ -57,6 +57,7 @@
>   * IRQF_NO_THREAD - Interrupt cannot be threaded
>   * IRQF_EARLY_RESUME - Resume IRQ early during syscore instead of at device
>   *                resume time.
> + * IRQF_ACK_BEFORE_UNMASK - IRQ must be acked before an unmask
>   */
>  #define IRQF_DISABLED		0x00000020
>  #define IRQF_SHARED		0x00000080
> @@ -70,6 +71,7 @@
>  #define IRQF_FORCE_RESUME	0x00008000
>  #define IRQF_NO_THREAD		0x00010000
>  #define IRQF_EARLY_RESUME	0x00020000
> +#define IRQF_ACK_BEFORE_UNMASK	0x00040000
>  
>  #define IRQF_TIMER		(__IRQF_TIMER | IRQF_NO_SUSPEND | IRQF_NO_THREAD)
>  
> diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
> index dc04c16..b6ed2fb 100644
> --- a/kernel/irq/chip.c
> +++ b/kernel/irq/chip.c
> @@ -275,6 +275,10 @@ void mask_irq(struct irq_desc *desc)
>  
>  void unmask_irq(struct irq_desc *desc)
>  {
> +	if ((desc->istate & IRQS_ACK_BEFORE_UNMASK) &&
> +	                desc->irq_data.chip->irq_ack)
> +		desc->irq_data.chip->irq_ack(&desc->irq_data);
> +
>  	if (desc->irq_data.chip->irq_unmask) {
>  		desc->irq_data.chip->irq_unmask(&desc->irq_data);
>  		irq_state_clr_masked(desc);
> diff --git a/kernel/irq/internals.h b/kernel/irq/internals.h
> index 001fa5b..cd68190 100644
> --- a/kernel/irq/internals.h
> +++ b/kernel/irq/internals.h
> @@ -43,6 +43,7 @@ enum {
>   * IRQS_WAITING			- irq is waiting
>   * IRQS_PENDING			- irq is pending and replayed later
>   * IRQS_SUSPENDED		- irq is suspended
> + * IRQS_ACK_BEFORE_UNMASK	- irq must be acked before an unmask
>   */
>  enum {
>  	IRQS_AUTODETECT		= 0x00000001,
> @@ -53,6 +54,7 @@ enum {
>  	IRQS_WAITING		= 0x00000080,
>  	IRQS_PENDING		= 0x00000200,
>  	IRQS_SUSPENDED		= 0x00000800,
> +	IRQS_ACK_BEFORE_UNMASK	= 0x00001000,
>  };
>  
>  #include "debug.h"
> diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
> index 481a13c..fd105ce 100644
> --- a/kernel/irq/manage.c
> +++ b/kernel/irq/manage.c
> @@ -1104,7 +1104,7 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
>  		}
>  
>  		desc->istate &= ~(IRQS_AUTODETECT | IRQS_SPURIOUS_DISABLED | \
> -				  IRQS_ONESHOT | IRQS_WAITING);
> +			IRQS_ONESHOT | IRQS_WAITING | IRQS_ACK_BEFORE_UNMASK);
>  		irqd_clear(&desc->irq_data, IRQD_IRQ_INPROGRESS);
>  
>  		if (new->flags & IRQF_PERCPU) {
> @@ -1140,6 +1140,9 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
>  				   irq, nmsk, omsk);
>  	}
>  
> +	if (new->flags & IRQF_ACK_BEFORE_UNMASK)
> +		desc->istate |= IRQS_ACK_BEFORE_UNMASK;
> +
>  	new->irq = irq;
>  	*old_ptr = new;
>  
> 
