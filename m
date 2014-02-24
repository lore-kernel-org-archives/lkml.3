Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746AbaBXOeB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 09:34:01 -0500
Received: from smtp.citrix.com ([66.165.176.89]:55686 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752452AbaBXOeA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 09:34:00 -0500
X-IronPort-AV: E=Sophos;i="4.97,535,1389744000"; 
   d="scan'208";a="105198717"
Message-ID: <530B5856.7080900@citrix.com>
Date: Mon, 24 Feb 2014 14:33:58 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Xen <xen-devel@lists.xenproject.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [Xen-devel] [patch 21/26] xen: Get rid of the last irq_desc abuse
References: <20140223212703.511977310@linutronix.de> <20140223212738.579581220@linutronix.de>
In-Reply-To: <20140223212738.579581220@linutronix.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/02/14 21:40, Thomas Gleixner wrote:
> I'd prefer to drop that completely but there seems to be some mystic
> value to the error printout and the allocation check.

    Warn if any PIRQ cannot be bound to an event channel.  Remove an
    unnecessary test for !desc in xen_destroy_irq() since the only caller
    will only do so if the irq was previously allocated.

> --- tip.orig/drivers/xen/events/events_base.c
> +++ tip/drivers/xen/events/events_base.c
[...]
> @@ -535,7 +528,7 @@ static unsigned int __startup_pirq(unsig
>  					BIND_PIRQ__WILL_SHARE : 0;
>  	rc = HYPERVISOR_event_channel_op(EVTCHNOP_bind_pirq, &bind_pirq);
>  	if (rc != 0) {
> -		if (!probing_irq(irq))
> +		if (!data || irqd_irq_has_action(data))
>  			pr_info("Failed to obtain physical IRQ %d\n", irq);

Remove this if and change the pr_info() to a pr_warn().

This hypercall never fails in practice, but it's still useful to have the
message in case on some systems it does.

>  		return 0;
>  	}
> @@ -769,15 +762,13 @@ error_irq:
>  
>  int xen_destroy_irq(int irq)
>  {
> -	struct irq_desc *desc;
>  	struct physdev_unmap_pirq unmap_irq;
>  	struct irq_info *info = info_for_irq(irq);
>  	int rc = -ENOENT;
>  
>  	mutex_lock(&irq_mapping_update_lock);
>  
> -	desc = irq_to_desc(irq);
> -	if (!desc)
> +	if (!irq_is_allocated(irq))
>  		goto out;

Remove this test.  The only caller of xen_destroy_irq() will only do
so if the irq was previously fully setup.

I think this means you don't need to introduce the irqd_irq_has_action()
and irq_is_allocated() helpers.

David
