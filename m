Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935078AbaH0PT1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 11:19:27 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:45500 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934523AbaH0PTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 11:19:25 -0400
Message-ID: <53FDF6E4.7090203@linaro.org>
Date: Wed, 27 Aug 2014 17:19:00 +0200
From: Eric Auger <eric.auger@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>
CC: eric.auger@st.com, christoffer.dall@linaro.org, marc.zyngier@arm.com,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, joel.schopp@amd.com, kim.phillips@freescale.com,
        linux-kernel@vger.kernel.org, patches@linaro.org, will.deacon@arm.com,
        a.motakis@virtualopensystems.com, a.rigo@virtualopensystems.com,
        john.liuli@huawei.com
Subject: Re: [RFC 4/9] KVM: KVM-VFIO: update user API to program forwarded
 IRQ
References: <1408973264-30384-1-git-send-email-eric.auger@linaro.org>	 <1408973264-30384-5-git-send-email-eric.auger@linaro.org> <1409079715.2906.127.camel@ul30vt.home>
In-Reply-To: <1409079715.2906.127.camel@ul30vt.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/2014 09:01 PM, Alex Williamson wrote:
> On Mon, 2014-08-25 at 15:27 +0200, Eric Auger wrote:
>> add new device group commands:
>> - KVM_DEV_VFIO_DEVICE_ASSIGN_IRQ and
>>   KVM_DEV_VFIO_DEVICE_DEASSIGN_IRQ
>>
>> which enable to turn forwarded IRQ mode on/off.
>>
>> Signed-off-by: Eric Auger <eric.auger@linaro.org>
>> ---
>>  Documentation/virtual/kvm/devices/vfio.txt | 25 +++++++++++++++++++++++++
>>  arch/arm/include/uapi/asm/kvm.h            |  6 ++++++
>>  include/uapi/linux/kvm.h                   |  3 +++
>>  3 files changed, 34 insertions(+)
>>
>> diff --git a/Documentation/virtual/kvm/devices/vfio.txt b/Documentation/virtual/kvm/devices/vfio.txt
>> index ef51740..c8b3fa1 100644
>> --- a/Documentation/virtual/kvm/devices/vfio.txt
>> +++ b/Documentation/virtual/kvm/devices/vfio.txt
>> @@ -13,6 +13,7 @@ VFIO-group is held by KVM.
>>  
>>  Groups:
>>    KVM_DEV_VFIO_GROUP
>> +  KVM_DEV_VFIO_DEVICE
>>  
>>  KVM_DEV_VFIO_GROUP attributes:
>>    KVM_DEV_VFIO_GROUP_ADD: Add a VFIO group to VFIO-KVM device tracking
>> @@ -20,3 +21,27 @@ KVM_DEV_VFIO_GROUP attributes:
>>  
>>  For each, kvm_device_attr.addr points to an int32_t file descriptor
>>  for the VFIO group.
>> +
>> +KVM_DEV_VFIO_DEVICE attributes:
>> +  KVM_DEV_VFIO_DEVICE_ASSIGN_IRQ
>> +  KVM_DEV_VFIO_DEVICE_DEASSIGN_IRQ
>> +
>> +For each, kvm_device_attr.addr points to an kvm_arch_forwarded_irq.
>> +This user API makes possible to create a special IRQ handling mode,
>> +currently supported only on ARM, where KVM and a VFIO platform driver
>> +collaborate to improve IRQ handling performance.
>> +fd represents the file descriptor of a valid VFIO device whose physical
>> +IRQ, referenced by its irq_index is injected to the VM guest_irq.
>> +
>> +On ASSIGN_IRQ, KVM-VFIO device programs:
>> +- the host, to not complete the physical IRQ itself.
>> +- the GIC, to automatically complete the physical IRQ when the guest
>> +  completes the virtual IRQ
>> +This avoid trapping the end-of-interrupt for level sensitive IRQ.
>> +
>> +On DEASSIGN_IRQ, one come back to the mode where the host completes the
>> +physical IRQ and the guest only completes the virtual IRQ.
>> +
>> +It is up to the caller of this API to get the assurance the IRQ is not
>> +outstanding when the ASSIGN/DEASSIGN is called. This could lead to some
>> +inconsistency on who is going to complete the IRQ.
> 
> Why not call these FORWARD/UNFORWARD or something since the operation
> isn't really doing anything with assignment of the IRQ.  The IRQ is
> already "assigned", we're modifying the behavior.

Sure I will change the name.

> 
>> diff --git a/arch/arm/include/uapi/asm/kvm.h b/arch/arm/include/uapi/asm/kvm.h
>> index 3034c66..1920b33 100644
>> --- a/arch/arm/include/uapi/asm/kvm.h
>> +++ b/arch/arm/include/uapi/asm/kvm.h
>> @@ -109,6 +109,12 @@ struct kvm_sync_regs {
>>  struct kvm_arch_memory_slot {
>>  };
>>  
>> +struct kvm_arch_forwarded_irq {
>> +	__u32 fd; /* file desciptor of the VFIO device */
>> +	__u32 irq_index; /* platform device index of the IRQ */
> 
> The vfio-platform device IRQ index?  ARM is the only implementation we
> have of this, but to keep it generic maybe the comment should read "vfio
> device IRQ index".

I will replace by vfio device IRQ index.

> 
>> +	__u32 guest_irq; /* virtual IRQ number */
> 
> This would be a GSI or similar concept if we were on x86.

ok for GSI now this naming seems better understood by the ARM community
too;-)

  I'm a little
> confused that were using an arch structure here rather than trying to
> keep the kvm-vfio device interface neutral.

I will move much more things on the generic side then then assuming that
someone in the future may use such functionality. Actually the only ARM
specific implementation is the GIC interrupt controller programming. As
far as I see the rest is generic, in terms of API.

Thanks

Eric

  Maybe it makes sense, I'm
> not sure.  Thanks,
> 
> Alex
> 
>> +};
>> +
>>  /* If you need to interpret the index values, here is the key: */
>>  #define KVM_REG_ARM_COPROC_MASK		0x000000000FFF0000
>>  #define KVM_REG_ARM_COPROC_SHIFT	16
>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>> index cf3a2ff..b149ba8 100644
>> --- a/include/uapi/linux/kvm.h
>> +++ b/include/uapi/linux/kvm.h
>> @@ -954,6 +954,9 @@ struct kvm_device_attr {
>>  #define  KVM_DEV_VFIO_GROUP			1
>>  #define   KVM_DEV_VFIO_GROUP_ADD			1
>>  #define   KVM_DEV_VFIO_GROUP_DEL			2
>> +#define  KVM_DEV_VFIO_DEVICE			2
>> +#define   KVM_DEV_VFIO_DEVICE_ASSIGN_IRQ			1
>> +#define   KVM_DEV_VFIO_DEVICE_DEASSIGN_IRQ			2
>>  #define KVM_DEV_TYPE_ARM_VGIC_V2	5
>>  #define KVM_DEV_TYPE_FLIC		6
>>  
> 
> 
> 

