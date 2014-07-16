Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934642AbaGPQet (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 12:34:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38981 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752706AbaGPQeq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 12:34:46 -0400
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: xen-devel@lists.xenproject.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Andrew Jones <drjones@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 3/4] xen/pvhvm: Unmap all PIRQs on startup and shutdown
References: <1405431640-649-1-git-send-email-vkuznets@redhat.com>
	<1405431640-649-4-git-send-email-vkuznets@redhat.com>
	<20140715152309.GQ3403@laptop.dumpdata.com>
	<87wqbdk5kp.fsf@vitty.brq.redhat.com>
	<20140716134501.GI19585@laptop.dumpdata.com>
Date: Wed, 16 Jul 2014 18:34:34 +0200
In-Reply-To: <20140716134501.GI19585@laptop.dumpdata.com> (Konrad Rzeszutek
	Wilk's message of "Wed, 16 Jul 2014 09:45:01 -0400")
Message-ID: <87lhrtjm91.fsf@vitty.brq.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> writes:

> On Wed, Jul 16, 2014 at 11:37:10AM +0200, Vitaly Kuznetsov wrote:
>> Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> writes:
>> 
>> > On Tue, Jul 15, 2014 at 03:40:39PM +0200, Vitaly Kuznetsov wrote:
>> >> When kexec is being run PIRQs from Qemu-emulated devices are still
>> >> mapped to old event channels and new kernel has no information about
>> >> that. Trying to map them twice results in the following in Xen's dmesg:
>> >> 
>> >>  (XEN) irq.c:2278: dom7: pirq 24 or emuirq 8 already mapped
>> >>  (XEN) irq.c:2278: dom7: pirq 24 or emuirq 12 already mapped
>> >>  (XEN) irq.c:2278: dom7: pirq 24 or emuirq 1 already mapped
>> >>  ...
>> >> 
>> >>  and the following in new kernel's dmesg:
>> >> 
>> >>  [   92.286796] xen:events: Failed to obtain physical IRQ 4
>> >> 
>> >> The result is that the new kernel doesn't recieve IRQs for Qemu-emulated
>> >> devices. Address the issue by unmapping all mapped PIRQs on kernel shutdown
>> >> when kexec was requested and on every kernel startup. We need to do this
>> >> twice to deal with the following issues:
>> >> - startup-time unmapping is required to make kdump work;
>> >> - shutdown-time unmapping is required to support kexec-ing non-fixed kernels;
>> >> - shutdown-time unmapping is required to make Qemu-emulated NICs work after
>> >>   kexec (event channel is being closed on shutdown but no PHYSDEVOP_unmap_pirq
>> >>   is being performed).
>> >
>> > How does this work when you boot the guest under Xen 4.4 where the FIFO events
>> > are used? Does it still work correctly?
>> 
>> Thanks for pointing that out! I've checked and it doesn't. However
>> patches make no difference - guest kernel gets stuck on boot with and
>> without them. Will try to investigate...
>
> I think for FIFO events we can't do much right now - it would need some
> new hypercalls to de-allocate or such.
>

Yeah, you're probably right. I tried wrapping evtchn_fifo_destroy() into
'EVTCHNOP_fifo_destroy' hypercall but it seems some other actions are
required as well..

> But I was thinking that your code logic could just return out when
> it detects that it is running with FIFO events (with a TODO comment)
> - and also spit out some information to this effect?

Sure, having TODO here is a good idea.

>
> Say: "Use xen.fifo=0 in your launching kernel"

s,xen.fifo,xen.fifo_events,

>
> (don't know the right name for the kernel in which you do 'kexec -e' in ?
> Is that launching? Original? Bootstrap kernel?)

Yes, if under Xen-4.4 I boot original kernel with "xen.fifo_events=0"
I'm able to do kexec with "xen.fifo_events=0" and even without it (but
only once :-). Once kernel is booted with FIFO-based event channels
enabled no kexec is possible, new kernel gets stuck (I guess vcpuop
timer doesn't work..). My patch series brings no difference here..

Thanks,

>
>> 
>> >
>> > Thanks.
>> >> 
>> >> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> >> ---
>> >>  arch/x86/xen/smp.c               |  1 +
>> >>  drivers/xen/events/events_base.c | 76 ++++++++++++++++++++++++++++++++++++++++
>> >>  include/xen/events.h             |  3 ++
>> >>  3 files changed, 80 insertions(+)
>> >> 
>> >> diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
>> >> index 35dcf39..e2b4deb 100644
>> >> --- a/arch/x86/xen/smp.c
>> >> +++ b/arch/x86/xen/smp.c
>> >> @@ -768,6 +768,7 @@ void xen_kexec_shutdown(void)
>> >>  #ifdef CONFIG_KEXEC
>> >>  	if (!kexec_in_progress)
>> >>  		return;
>> >> +	xen_unmap_all_pirqs();
>> >>  #endif
>> >>  }
>> >>  
>> >> diff --git a/drivers/xen/events/events_base.c b/drivers/xen/events/events_base.c
>> >> index c919d3d..7701c7f 100644
>> >> --- a/drivers/xen/events/events_base.c
>> >> +++ b/drivers/xen/events/events_base.c
>> >> @@ -1643,6 +1643,80 @@ void xen_callback_vector(void) {}
>> >>  static bool fifo_events = true;
>> >>  module_param(fifo_events, bool, 0);
>> >>  
>> >> +void xen_unmap_all_pirqs(void)
>> >> +{
>> >> +	int pirq, rc, gsi, irq, evtchn;
>> >> +	struct physdev_unmap_pirq unmap_irq;
>> >> +	struct irq_info *info;
>> >> +	struct evtchn_close close;
>> >> +
>> >> +	mutex_lock(&irq_mapping_update_lock);
>> >> +
>> >> +	list_for_each_entry(info, &xen_irq_list_head, list) {
>> >> +		if (info->type != IRQT_PIRQ)
>> >> +			continue;
>> >> +
>> >> +		pirq = info->u.pirq.pirq;
>> >> +		gsi = info->u.pirq.gsi;
>> >> +		evtchn = info->evtchn;
>> >> +		irq = info->irq;
>> >> +
>> >> +		pr_debug("unmapping pirq gsi=%d pirq=%d irq=%d evtchn=%d\n",
>> >> +			gsi, pirq, irq, evtchn);
>> >> +
>> >> +		if (evtchn > 0) {
>> >> +			close.port = evtchn;
>> >> +			if (HYPERVISOR_event_channel_op(EVTCHNOP_close,
>> >> +							&close) != 0)
>> >> +				pr_warn("close evtchn %d failed\n", evtchn);
>> >> +		}
>> >> +
>> >> +		unmap_irq.pirq = pirq;
>> >> +		unmap_irq.domid = DOMID_SELF;
>> >> +
>> >> +		rc = HYPERVISOR_physdev_op(PHYSDEVOP_unmap_pirq, &unmap_irq);
>> >> +		if (rc)
>> >> +			pr_warn("unmap pirq failed gsi=%d pirq=%d irq=%d rc=%d\n",
>> >> +				gsi, pirq, irq, rc);
>> >> +	}
>> >> +
>> >> +	mutex_unlock(&irq_mapping_update_lock);
>> >> +}
>> >> +EXPORT_SYMBOL_GPL(xen_unmap_all_pirqs);
>> >
>> > Why the EXPORT? Is this used by modules?
>> >> +
>> >> +static void xen_startup_unmap_pirqs(void)
>> >> +{
>> >> +	struct evtchn_status status;
>> >> +	int port, rc = -ENOENT;
>> >> +	struct physdev_unmap_pirq unmap_irq;
>> >> +	struct evtchn_close close;
>> >> +
>> >> +	memset(&status, 0, sizeof(status));
>> >> +	for (port = 0; port < xen_evtchn_max_channels(); port++) {
>> >> +		status.dom = DOMID_SELF;
>> >> +		status.port = port;
>> >> +		rc = HYPERVISOR_event_channel_op(EVTCHNOP_status, &status);
>> >> +		if (rc < 0)
>> >> +			continue;
>> >> +		if (status.status == EVTCHNSTAT_pirq) {
>> >> +			close.port = port;
>> >> +			if (HYPERVISOR_event_channel_op(EVTCHNOP_close,
>> >> +							&close) != 0)
>> >> +				pr_warn("xen: failed to close evtchn %d\n",
>> >> +					port);
>> >> +			unmap_irq.pirq = status.u.pirq;
>> >> +			unmap_irq.domid = DOMID_SELF;
>> >> +			pr_warn("xen: unmapping previously mapped pirq %d\n",
>> >> +				unmap_irq.pirq);
>> >> +			if (HYPERVISOR_physdev_op(PHYSDEVOP_unmap_pirq,
>> >> +						  &unmap_irq) != 0)
>> >> +				pr_warn("xen: failed to unmap pirq %d\n",
>> >> +					unmap_irq.pirq);
>> >> +		}
>> >> +	}
>> >> +}
>> >> +
>> >> +
>> >>  void __init xen_init_IRQ(void)
>> >>  {
>> >>  	int ret = -EINVAL;
>> >> @@ -1671,6 +1745,8 @@ void __init xen_init_IRQ(void)
>> >>  		xen_callback_vector();
>> >>  
>> >>  	if (xen_hvm_domain()) {
>> >> +		xen_startup_unmap_pirqs();
>> >> +
>> >>  		native_init_IRQ();
>> >>  		/* pci_xen_hvm_init must be called after native_init_IRQ so that
>> >>  		 * __acpi_register_gsi can point at the right function */
>> >> diff --git a/include/xen/events.h b/include/xen/events.h
>> >> index 8bee7a7..3f9f428 100644
>> >> --- a/include/xen/events.h
>> >> +++ b/include/xen/events.h
>> >> @@ -122,6 +122,9 @@ int xen_irq_from_gsi(unsigned gsi);
>> >>  /* Determine whether to ignore this IRQ if it is passed to a guest. */
>> >>  int xen_test_irq_shared(int irq);
>> >>  
>> >> +/* Unmap all PIRQs and close event channels */
>> >> +void xen_unmap_all_pirqs(void);
>> >> +
>> >>  /* initialize Xen IRQ subsystem */
>> >>  void xen_init_IRQ(void);
>> >>  #endif	/* _XEN_EVENTS_H */
>> >> -- 
>> >> 1.9.3
>> >> 
>> 
>> -- 
>>   Vitaly

-- 
  Vitaly
