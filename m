Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752354AbaG2RGt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 13:06:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7603 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751282AbaG2RGs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 13:06:48 -0400
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: Andrew Jones <drjones@redhat.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        <linux-kernel@vger.kernel.org>, <xen-devel@lists.xenproject.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: Re: [Xen-devel] [PATCH RFC 3/4] xen/pvhvm: Unmap all PIRQs on startup and shutdown
References: <1405431640-649-1-git-send-email-vkuznets@redhat.com>
	<1405431640-649-4-git-send-email-vkuznets@redhat.com>
	<53D6536E.70104@citrix.com> <87d2coe0kk.fsf@vitty.brq.redhat.com>
	<53D7BD04.4040102@citrix.com>
Date: Tue, 29 Jul 2014 19:06:34 +0200
In-Reply-To: <53D7BD04.4040102@citrix.com> (David Vrabel's message of "Tue, 29
	Jul 2014 16:25:56 +0100")
Message-ID: <878uncdrhh.fsf@vitty.brq.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Vrabel <david.vrabel@citrix.com> writes:

> On 29/07/14 14:50, Vitaly Kuznetsov wrote:
>> David Vrabel <david.vrabel@citrix.com> writes:
>> 
>>> On 15/07/14 14:40, Vitaly Kuznetsov wrote:
>>>> When kexec is being run PIRQs from Qemu-emulated devices are still
>>>> mapped to old event channels and new kernel has no information about
>>>> that. Trying to map them twice results in the following in Xen's dmesg:
>>>>
>>>>  (XEN) irq.c:2278: dom7: pirq 24 or emuirq 8 already mapped
>>>>  (XEN) irq.c:2278: dom7: pirq 24 or emuirq 12 already mapped
>>>>  (XEN) irq.c:2278: dom7: pirq 24 or emuirq 1 already mapped
>>>>  ...
>>>>
>>>>  and the following in new kernel's dmesg:
>>>>
>>>>  [   92.286796] xen:events: Failed to obtain physical IRQ 4
>>>>
>>>> The result is that the new kernel doesn't recieve IRQs for Qemu-emulated
>>>> devices. Address the issue by unmapping all mapped PIRQs on kernel shutdown
>>>> when kexec was requested and on every kernel startup. We need to do this
>>>> twice to deal with the following issues:
>>>> - startup-time unmapping is required to make kdump work;
>>>> - shutdown-time unmapping is required to support kexec-ing non-fixed kernels;
>>>> - shutdown-time unmapping is required to make Qemu-emulated NICs work after
>>>>   kexec (event channel is being closed on shutdown but no PHYSDEVOP_unmap_pirq
>>>>   is being performed).
>>>
>>> I think this should be done only in one place -- just prior to exec'ing
>>> the new kernel (including kdump kernels).
>>>
>> 
>> Thank you for your comments!
>> 
>> The problem I'm fighting wiht atm is: with FIFO-based event channels we
>> need to call evtchn_fifo_destroy() so next EVTCHNOP_init_control won't
>> fail. I was intended to put evtchn_fifo_destroy() in
>> EVTCHNOP_reset. That introduces a problem: we need to deal with
>> store/console channels. It is possible to remap those from guest with
>> EVTCHNOP_bind_interdomain (if we remember where they were mapped before)
>> but we can't do it after we did evtchn_fifo_destroy() and we can't
>> rebind them after kexec and performing EVTCHNOP_init_control as
>> we can't remember where these channels were mapped to after kexec/kdump.
>> 
>> I see the following possible solutions:
>> 1) We put evtchn_fifo_destroy() in EVTCHNOP_init_control so
>> EVTCHNOP_init_control can be called twice. No EVTCHNOP_reset is required
>> in that case.
>
> EVTCHNOP_init_control is called for each VCPU so I can't see how this
> would work.

Right, forgot about that...

>
>> 2) Introduce special (e.g. 'EVTCHNOP_fifo_destroy') hypercall to do
>> evtchn_fifo_destroy() without closing all channels. Alternatively we can
>> avoid closing all channels in EVTCHNOP_reset when called with DOMID_SELF
>> (as this mode is not being used atm) -- but that would look unobvious.
>
> I would try this.  The guest prior to kexec would then:
>
> 1. Use EVTCHNOP_status to query remote end of console and xenstore event
> channels.
>
> 2. Loop for all event channels:
>
> a. unmap pirq (if required)
> b. EVTCHNOP_close
>
> 3. EVTCHNOP_fifo_destroy (the implementation of which must verify that
> no channels are bound).
>
> 4. EVTCHNOP_bind_interdomain to rebind the console and xenstore channels.
>

Yea, that's what I have now when I put evtchn_fifo_destroy() in
EVTCHNOP_reset. The problem here is: we can't do
EVTCHNOP_bind_interdomain after we did evtchn_fifo_destroy(), we need to
call EVTCHNOP_init_control first. And we'll do that only after kexec so
we won't remember what we need to remap.. The second issue is the fact
that EVTCHNOP_bind_interdomain will remap store/storage channels to
*some* local ports, not necessary matching hvm info
(HVM_PARAM_CONSOLE_EVTCHN/HVM_PARAM_STORE_EVTCHN)..

Would it be safe is instead of closing interdomain channels on
EVTCHNOP_fifo_destroy we switch evtchn_port_ops to evtchn_port_ops_2l
(so on EVTCHNOP_init_control after kexec we switch back)? I'll try
prototyping this.

Thank you for your comments,

> David

-- 
  Vitaly
