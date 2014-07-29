Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753706AbaG2Nuc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 09:50:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35319 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753673AbaG2Nub (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 09:50:31 -0400
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: <xen-devel@lists.xenproject.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Andrew Jones <drjones@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC 3/4] xen/pvhvm: Unmap all PIRQs on startup and shutdown
References: <1405431640-649-1-git-send-email-vkuznets@redhat.com>
	<1405431640-649-4-git-send-email-vkuznets@redhat.com>
	<53D6536E.70104@citrix.com>
Date: Tue, 29 Jul 2014 15:50:19 +0200
In-Reply-To: <53D6536E.70104@citrix.com> (David Vrabel's message of "Mon, 28
	Jul 2014 14:43:10 +0100")
Message-ID: <87d2coe0kk.fsf@vitty.brq.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Vrabel <david.vrabel@citrix.com> writes:

> On 15/07/14 14:40, Vitaly Kuznetsov wrote:
>> When kexec is being run PIRQs from Qemu-emulated devices are still
>> mapped to old event channels and new kernel has no information about
>> that. Trying to map them twice results in the following in Xen's dmesg:
>> 
>>  (XEN) irq.c:2278: dom7: pirq 24 or emuirq 8 already mapped
>>  (XEN) irq.c:2278: dom7: pirq 24 or emuirq 12 already mapped
>>  (XEN) irq.c:2278: dom7: pirq 24 or emuirq 1 already mapped
>>  ...
>> 
>>  and the following in new kernel's dmesg:
>> 
>>  [   92.286796] xen:events: Failed to obtain physical IRQ 4
>> 
>> The result is that the new kernel doesn't recieve IRQs for Qemu-emulated
>> devices. Address the issue by unmapping all mapped PIRQs on kernel shutdown
>> when kexec was requested and on every kernel startup. We need to do this
>> twice to deal with the following issues:
>> - startup-time unmapping is required to make kdump work;
>> - shutdown-time unmapping is required to support kexec-ing non-fixed kernels;
>> - shutdown-time unmapping is required to make Qemu-emulated NICs work after
>>   kexec (event channel is being closed on shutdown but no PHYSDEVOP_unmap_pirq
>>   is being performed).
>
> I think this should be done only in one place -- just prior to exec'ing
> the new kernel (including kdump kernels).
>

Thank you for your comments!

The problem I'm fighting wiht atm is: with FIFO-based event channels we
need to call evtchn_fifo_destroy() so next EVTCHNOP_init_control won't
fail. I was intended to put evtchn_fifo_destroy() in
EVTCHNOP_reset. That introduces a problem: we need to deal with
store/console channels. It is possible to remap those from guest with
EVTCHNOP_bind_interdomain (if we remember where they were mapped before)
but we can't do it after we did evtchn_fifo_destroy() and we can't
rebind them after kexec and performing EVTCHNOP_init_control as
we can't remember where these channels were mapped to after kexec/kdump.

I see the following possible solutions:
1) We put evtchn_fifo_destroy() in EVTCHNOP_init_control so
EVTCHNOP_init_control can be called twice. No EVTCHNOP_reset is required
in that case.

2) Introduce special (e.g. 'EVTCHNOP_fifo_destroy') hypercall to do
evtchn_fifo_destroy() without closing all channels. Alternatively we can
avoid closing all channels in EVTCHNOP_reset when called with DOMID_SELF
(as this mode is not being used atm) -- but that would look unobvious.

3) Keep evtchn_fifo_destroy() in EVTCHNOP_reset but keep console/store
channels -- I saw your concerns it is not safe, some sort of additional
blocking will be required.

4) Do the remapping boot time (query for store/console channels ->
perform EVTCHNOP_reset -> rebind with EVTCHNOP_bind_interdomain).

There is an additional problem: EVTCHNOP_bind_interdomain operation has
local port as OUT parameter so we can't guarantee that remapping
store/console channels will remap them to the same local channel they
were mapped before EVTCHNOP_reset (and we have this information in hvm
info: HVM_PARAM_CONSOLE_EVTCHN/HVM_PARAM_STORE_EVTCHN, ...). Not sure
how to deal with that in case we go with remapping.

Your thoughts would be very appreciated. Thank you again,

>> --- a/arch/x86/xen/smp.c
>> +++ b/arch/x86/xen/smp.c
>> @@ -768,6 +768,7 @@ void xen_kexec_shutdown(void)
>>  #ifdef CONFIG_KEXEC
>>  	if (!kexec_in_progress)
>>  		return;
>> +	xen_unmap_all_pirqs();
>>  #endif
>>  }
>>  
>> diff --git a/drivers/xen/events/events_base.c b/drivers/xen/events/events_base.c
>> index c919d3d..7701c7f 100644
>> --- a/drivers/xen/events/events_base.c
>> +++ b/drivers/xen/events/events_base.c
>> @@ -1643,6 +1643,80 @@ void xen_callback_vector(void) {}
>>  static bool fifo_events = true;
>>  module_param(fifo_events, bool, 0);
>>  
>> +void xen_unmap_all_pirqs(void)
>> +{
>> +	int pirq, rc, gsi, irq, evtchn;
>> +	struct physdev_unmap_pirq unmap_irq;
>> +	struct irq_info *info;
>> +	struct evtchn_close close;
>> +
>> +	mutex_lock(&irq_mapping_update_lock);
>> +
>> +	list_for_each_entry(info, &xen_irq_list_head, list) {
>> +		if (info->type != IRQT_PIRQ)
>> +			continue;
>
> I think you need to do this by querying Xen state rather than relying on
> potentially bad guest state.  Particularly since you may crash while
> holding irq_mapping_update_lock.
>
> EVTCHNOP_status gets you the info you need I think.
>
> David

-- 
  Vitaly
