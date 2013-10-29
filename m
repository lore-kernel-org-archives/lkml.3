Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519Ab3J2NHK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 09:07:10 -0400
Received: from www.linutronix.de ([62.245.132.108]:55977 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237Ab3J2NHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 09:07:08 -0400
Date: Tue, 29 Oct 2013 14:07:00 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Huacai Chen <chenhc@lemote.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] genirq: Avoid NULL OOPS in irq handling
In-Reply-To: <1380334284-12690-1-git-send-email-chenhc@lemote.com>
Message-ID: <alpine.DEB.2.02.1310291402490.8257@ionos.tec.linutronix.de>
References: <1380334284-12690-1-git-send-email-chenhc@lemote.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Sep 2013, Huacai Chen wrote:

> Some devices (e.g. serial port) setup irq handler at dev open and free
> it at dev close. So, sometimes there is no irqaction for a specific
> irq. But some buggy devices may send irqs at any time. This patch avoid
> the NULL OOPS when irqaction isn't registered.

All callers except the real per cpu interrupts are checking whether
there is a valid action before calling. And serial ports are not
routed to real per cpu interrupts. Can you provide more detailed
information about the problem you are trying to solve please?

Thanks,

	tglx

> Signed-off-by: Huacai Chen <chenhc@lemote.com>
> ---
>  kernel/irq/handle.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
> index 131ca17..1c78e69 100644
> --- a/kernel/irq/handle.c
> +++ b/kernel/irq/handle.c
> @@ -135,6 +135,9 @@ handle_irq_event_percpu(struct irq_desc *desc, struct irqaction *action)
>  	irqreturn_t retval = IRQ_NONE;
>  	unsigned int flags = 0, irq = desc->irq_data.irq;
>  
> +	if (!action)
> +		goto out;
> +
>  	do {
>  		irqreturn_t res;
>  
> @@ -174,6 +177,7 @@ handle_irq_event_percpu(struct irq_desc *desc, struct irqaction *action)
>  
>  	add_interrupt_randomness(irq, flags);
>  
> +out:
>  	if (!noirqdebug)
>  		note_interrupt(irq, desc, retval);
>  	return retval;
> -- 
> 1.7.7.3
> 
> 
