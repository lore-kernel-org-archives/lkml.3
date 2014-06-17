Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242AbaFQLnH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 07:43:07 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:41230 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756080AbaFQLnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 07:43:05 -0400
Message-ID: <53A029B9.4000204@linaro.org>
Date: Tue, 17 Jun 2014 13:42:49 +0200
From: Eric Auger <eric.auger@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Christoffer Dall <christoffer.dall@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>
CC: "eric.auger@st.com" <eric.auger@st.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "christophe.barnichon@st.com" <christophe.barnichon@st.com>
Subject: Re: [PATCH v2] ARM: KVM: add irqfd and irq routing support
References: <1401694196-30861-1-git-send-email-eric.auger@linaro.org> <87bnub1kor.fsf@approximate.cambridge.arm.com> <20140606121623.GB22341@lvm>
In-Reply-To: <20140606121623.GB22341@lvm>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2014 02:16 PM, Christoffer Dall wrote:
> On Mon, Jun 02, 2014 at 02:54:12PM +0100, Marc Zyngier wrote:
>> Hi Eric,
>>
>> On Mon, Jun 02 2014 at  8:29:56 am BST, Eric Auger <eric.auger@linaro.org> wrote:
>>> This patch enables irqfd and irq routing on ARM.
>>>
>>> It turns on CONFIG_HAVE_KVM_EVENTFD and CONFIG_HAVE_KVM_IRQ_ROUTING
>>>
>>> irqfd framework enables to assign physical IRQs to guests.
>>>
>>> 1) user-side uses KVM_IRQFD VM ioctl to pass KVM a kvm_irqfd struct that
>>> associates a VM, an eventfd, an IRQ number (aka. the GSI). When an actor
>>> signals the eventfd (typically a VFIO platform driver), the irqfd subsystem
>>> injects the specified IRQ into the VM (the "GSI" takes the semantic of a
>>> virtual IRQ for that guest).
>>
>> Just so I can understand how this works: Who EOIs (handles) the physical
>> interrupt? If it is the VFIO driver, then I don't see how you prevent
>> the interrupt from firing again immediately (unless this is an edge
>> interrupt?).
>>
>>> 2) the other use case is user-side does 1) and uses KVM_SET_GSI_ROUTING
>>> VM ioctl to create an association between a VM, a physical IRQ (aka GSI) and
>>> a virtual IRQ (aka irchip.pin).  This creates a so-called GSI routing entry.
>>> When someone triggers the eventfd, irqfd handles it but uses the specified
>>> routing and eventually injects irqchip.pin virtual IRQ into the guest. In that
>>> context the GSI takes the semantic of a physical IRQ while the irqchip.pin
>>> takes the semantic of a virtual IRQ.
>>>
>>> in 1) routing is used by irqfd but an identity routing is created by default
>>> making the gsi = irqchip.pin. Note on ARM there is a single interrupt
>>> controller kind, the GIC.
>>>
>>> GSI routing mostly is implemented in generic irqchip.c.
>>> The tiny ARM specific part is directly implemented in the virtual interrupt
>>> controller (vgic.c) as it is done for powerpc for instance. This option was
>>> prefered compared to implementing other #ifdef in irq_comm.c (x86 and ia64).
>>> Hence irq_comm.c is not used at all.
>>>
>>> Routing currently is not used for anything else than irqfd IRQ injection. Only
>>> SPI can be injected. This means the vgic is not totally hidden behind the
>>> irqchip. There are separate discussions on PPI/SGI routing.
>>>
>>> Only level sensitive IRQs are supported (with a registered resampler). As a
>>> reminder the resampler is a second eventfd called by irqfd framework when the
>>> virtual IRQ is completed by the guest. This eventfd is supposed to be handled
>>> on user-side
>>>
>>> MSI routing is not supported yet.
>>>
>>> This work was tested with Calxeda Midway xgmac main interrupt (with and without
>>> explicit user routing) with qemu-system-arm and QEMU VFIO platform device.
>>>
>>> changes v1 -> v2:
>>> 2 fixes:
>>> - v1 assumed gsi/irqchip.pin was already incremented by VGIC_NR_PRIVATE_IRQS.
>>>   This is now vgic_set_assigned_irq that increments it before injection.
>>> - v2 now handles the case where a pending assigned irq is cleared through
>>>   MMIO access. The irq is properly acked allowing the resamplefd handler
>>>   to possibly unmask the physical IRQ.
>>>
>>> Signed-off-by: Eric Auger <eric.auger@linaro.org>
>>>
>>> Conflicts:
>>>         Documentation/virtual/kvm/api.txt
>>>         arch/arm/kvm/Kconfig
>>>
>>> Conflicts:
>>>         Documentation/virtual/kvm/api.txt
>>> ---
>>>  Documentation/virtual/kvm/api.txt |   4 +-
>>>  arch/arm/include/uapi/asm/kvm.h   |   8 +++
>>>  arch/arm/kvm/Kconfig              |   2 +
>>>  arch/arm/kvm/Makefile             |   1 +
>>>  arch/arm/kvm/irq.h                |  25 +++++++
>>>  virt/kvm/arm/vgic.c               | 141 ++++++++++++++++++++++++++++++++++++--
>>>  6 files changed, 174 insertions(+), 7 deletions(-)
>>>  create mode 100644 arch/arm/kvm/irq.h
>>>
>>> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
>>> index b4f5365..b376334 100644
>>> --- a/Documentation/virtual/kvm/api.txt
>>> +++ b/Documentation/virtual/kvm/api.txt
>>> @@ -1339,7 +1339,7 @@ KVM_ASSIGN_DEV_IRQ. Partial deassignment of host or guest IRQ is allowed.
>>>  4.52 KVM_SET_GSI_ROUTING
>>>
>>>  Capability: KVM_CAP_IRQ_ROUTING
>>> -Architectures: x86 ia64 s390
>>> +Architectures: x86 ia64 s390 arm
>>>  Type: vm ioctl
>>>  Parameters: struct kvm_irq_routing (in)
>>>  Returns: 0 on success, -1 on error
>>> @@ -2126,7 +2126,7 @@ into the hash PTE second double word).
>>>  4.75 KVM_IRQFD
>>>
>>>  Capability: KVM_CAP_IRQFD
>>> -Architectures: x86 s390
>>> +Architectures: x86 s390 arm
>>>  Type: vm ioctl
>>>  Parameters: struct kvm_irqfd (in)
>>>  Returns: 0 on success, -1 on error
>>> diff --git a/arch/arm/include/uapi/asm/kvm.h b/arch/arm/include/uapi/asm/kvm.h
>>> index ef0c878..89b864d 100644
>>> --- a/arch/arm/include/uapi/asm/kvm.h
>>> +++ b/arch/arm/include/uapi/asm/kvm.h
>>> @@ -192,6 +192,14 @@ struct kvm_arch_memory_slot {
>>>  /* Highest supported SPI, from VGIC_NR_IRQS */
>>>  #define KVM_ARM_IRQ_GIC_MAX            127
>>>
>>> +/* needed by IRQ routing */
>>> +
>>> +/* One single KVM irqchip, ie. the VGIC */
>>> +#define KVM_NR_IRQCHIPS          1
>>> +
>>> +/* virtual interrupt controller input pins (max 480 SPI, 32 SGI/PPI) */
>>> +#define KVM_IRQCHIP_NUM_PINS     256
>>
>> Gahhhh... Please don't. We're trying hard to move away from hard-coded
>> definitions such as this, since GICv3 has much higher limits. And the
>> comment you've added perfectly outlines why this is such a bad idea
>> (even on GICv2, we can have up to 960 SPIs).
>>
>> Have a look at what's brewing in my kvm-arm64/vgic-dyn branch.
>>
> Looked at this a bit more, and the generic code does require this
> definition, but it can be arbitrarily high (it is not used to allocate
> tables or anything like that).  Could we not just define it to the
> highest possible number for now, and then deal with it if the number is
> too large for gicv3?

Actually KVM_IRQCHIP_NUM_PINS is used for static allocation  of chip[][]
in kernel routing table struct reminded below.As such it must be
reasonably sized I am afraid.

struct kvm_irq_routing_table {
	int chip[KVM_NR_IRQCHIPS][KVM_IRQCHIP_NUM_PINS];
	struct kvm_kernel_irq_routing_entry *rt_entries;
	u32 nr_rt_entries;
	/*
	 * Array indexed by gsi. Each entry contains list of irq chips
	 * the gsi is connected to.
	 */
	struct hlist_head map[0];
};

As a temporary solution waiting for kvm-arm64/vgic-dyn code, may I use
KVM_ARM_IRQ_GIC_MAX as KVM_IRQCHIP_NUM_PINS value?
> 
> (There may be some more issues related to this and the identity_table
> setup code, but I'll let Eric investigate and comment on this).
What I understand from other architecture implementations like powerpc
or s390 is only a minimalist dummy routing table is created by default
on kernel side. This makes possible to dereference the routing table
pointer. They rely on user side to create the routing table using the
KVM_SET_GSI_ROUTING KVM IOCTL. This is typically done in
hw/intc/openpic_kvm.c, in realize function

    /* set up irq routing */
    kvm_init_irq_routing(kvm_state);
    for (i = 0; i < 256; ++i) {
        kvm_irqchip_add_irq_route(kvm_state, i, 0, i);
    }
    kvm_irqchip_commit_routes(s);

What confuses me is KVM API does not mention specifically that a routing
table must be explicitly built by the user-side before using KVM_IRQFD.
Building the identity table in the kernel enables to avoid such user
action and this is why I did the job in the kernel instead. I asked the
question explicitly on the kvm ML.

Best Regards

Eric

> 
> -Christoffer
> 

