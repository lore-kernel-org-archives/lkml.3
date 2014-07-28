Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709AbaG1NnO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 09:43:14 -0400
Received: from smtp.citrix.com ([66.165.176.89]:57732 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751674AbaG1NnN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 09:43:13 -0400
X-IronPort-AV: E=Sophos;i="5.01,749,1400025600"; 
   d="scan'208";a="156369741"
Message-ID: <53D6536E.70104@citrix.com>
Date: Mon, 28 Jul 2014 14:43:10 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Vitaly Kuznetsov <vkuznets@redhat.com>, <xen-devel@lists.xenproject.org>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Andrew Jones <drjones@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC 3/4] xen/pvhvm: Unmap all PIRQs on startup and shutdown
References: <1405431640-649-1-git-send-email-vkuznets@redhat.com> <1405431640-649-4-git-send-email-vkuznets@redhat.com>
In-Reply-To: <1405431640-649-4-git-send-email-vkuznets@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/07/14 14:40, Vitaly Kuznetsov wrote:
> When kexec is being run PIRQs from Qemu-emulated devices are still
> mapped to old event channels and new kernel has no information about
> that. Trying to map them twice results in the following in Xen's dmesg:
> 
>  (XEN) irq.c:2278: dom7: pirq 24 or emuirq 8 already mapped
>  (XEN) irq.c:2278: dom7: pirq 24 or emuirq 12 already mapped
>  (XEN) irq.c:2278: dom7: pirq 24 or emuirq 1 already mapped
>  ...
> 
>  and the following in new kernel's dmesg:
> 
>  [   92.286796] xen:events: Failed to obtain physical IRQ 4
> 
> The result is that the new kernel doesn't recieve IRQs for Qemu-emulated
> devices. Address the issue by unmapping all mapped PIRQs on kernel shutdown
> when kexec was requested and on every kernel startup. We need to do this
> twice to deal with the following issues:
> - startup-time unmapping is required to make kdump work;
> - shutdown-time unmapping is required to support kexec-ing non-fixed kernels;
> - shutdown-time unmapping is required to make Qemu-emulated NICs work after
>   kexec (event channel is being closed on shutdown but no PHYSDEVOP_unmap_pirq
>   is being performed).

I think this should be done only in one place -- just prior to exec'ing
the new kernel (including kdump kernels).

> --- a/arch/x86/xen/smp.c
> +++ b/arch/x86/xen/smp.c
> @@ -768,6 +768,7 @@ void xen_kexec_shutdown(void)
>  #ifdef CONFIG_KEXEC
>  	if (!kexec_in_progress)
>  		return;
> +	xen_unmap_all_pirqs();
>  #endif
>  }
>  
> diff --git a/drivers/xen/events/events_base.c b/drivers/xen/events/events_base.c
> index c919d3d..7701c7f 100644
> --- a/drivers/xen/events/events_base.c
> +++ b/drivers/xen/events/events_base.c
> @@ -1643,6 +1643,80 @@ void xen_callback_vector(void) {}
>  static bool fifo_events = true;
>  module_param(fifo_events, bool, 0);
>  
> +void xen_unmap_all_pirqs(void)
> +{
> +	int pirq, rc, gsi, irq, evtchn;
> +	struct physdev_unmap_pirq unmap_irq;
> +	struct irq_info *info;
> +	struct evtchn_close close;
> +
> +	mutex_lock(&irq_mapping_update_lock);
> +
> +	list_for_each_entry(info, &xen_irq_list_head, list) {
> +		if (info->type != IRQT_PIRQ)
> +			continue;

I think you need to do this by querying Xen state rather than relying on
potentially bad guest state.  Particularly since you may crash while
holding irq_mapping_update_lock.

EVTCHNOP_status gets you the info you need I think.

David
