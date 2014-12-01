Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932097AbaLAOru (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 09:47:50 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:61156 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932067AbaLAOrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 09:47:48 -0500
Message-ID: <547C7F3A.2000601@linaro.org>
Date: Mon, 01 Dec 2014 15:46:18 +0100
From: Eric Auger <eric.auger@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Christoffer Dall <christoffer.dall@linaro.org>
CC: eric.auger@st.com, marc.zyngier@arm.com,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, alex.williamson@redhat.com, joel.schopp@amd.com,
        kim.phillips@freescale.com, paulus@samba.org, gleb@kernel.org,
        pbonzini@redhat.com, agraf@suse.de, linux-kernel@vger.kernel.org,
        patches@linaro.org, will.deacon@arm.com,
        a.motakis@virtualopensystems.com, a.rigo@virtualopensystems.com,
        john.liuli@huawei.com, ming.lei@canonical.com, feng.wu@intel.com
Subject: Re: [PATCH v3 4/8] KVM: kvm-vfio: User API for IRQ forwarding
References: <1416767760-14487-1-git-send-email-eric.auger@linaro.org> <1416767760-14487-5-git-send-email-eric.auger@linaro.org> <20141130125314.GE82106@macair>
In-Reply-To: <20141130125314.GE82106@macair>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/30/2014 01:53 PM, Christoffer Dall wrote:
> On Sun, Nov 23, 2014 at 07:35:56PM +0100, Eric Auger wrote:
>> This patch adds and document a new KVM_DEV_VFIO_DEVICE group
> 
> documents
OK
> 
>> and 2 device attributes: KVM_DEV_VFIO_DEVICE_FORWARD_IRQ,
>> KVM_DEV_VFIO_DEVICE_UNFORWARD_IRQ. The purpose is to be able
>> to set a VFIO device IRQ as forwarded or not forwarded.
>> the command takes as argument a handle to a new struct named
>> kvm_arch_forwarded_irq.
>>
>> Signed-off-by: Eric Auger <eric.auger@linaro.org>
>>
>> ---
>>
>> v2 -> v3:
>> - rework vfio kvm device documentation
>> - reword commit message and title
>> - add subindex in kvm_arch_forwarded_irq to be closer to VFIO API
>> - forwarding state can only be changed with VFIO IRQ signaling is off
>>
>> v1 -> v2:
>> - struct kvm_arch_forwarded_irq moved from arch/arm/include/uapi/asm/kvm.h
>>   to include/uapi/linux/kvm.h
>>   also irq_index renamed into index and guest_irq renamed into gsi
>> - ASSIGN/DEASSIGN renamed into FORWARD/UNFORWARD
>> ---
>>  Documentation/virtual/kvm/devices/vfio.txt | 34 ++++++++++++++++++++++++------
>>  include/uapi/linux/kvm.h                   | 10 +++++++++
>>  2 files changed, 38 insertions(+), 6 deletions(-)
>>
>> diff --git a/Documentation/virtual/kvm/devices/vfio.txt b/Documentation/virtual/kvm/devices/vfio.txt
>> index ef51740..f7aff29 100644
>> --- a/Documentation/virtual/kvm/devices/vfio.txt
>> +++ b/Documentation/virtual/kvm/devices/vfio.txt
>> @@ -4,15 +4,24 @@ VFIO virtual device
>>  Device types supported:
>>    KVM_DEV_TYPE_VFIO
>>  
>> -Only one VFIO instance may be created per VM.  The created device
>> -tracks VFIO groups in use by the VM and features of those groups
>> -important to the correctness and acceleration of the VM.  As groups
>> -are enabled and disabled for use by the VM, KVM should be updated
>> -about their presence.  When registered with KVM, a reference to the
>> -VFIO-group is held by KVM.
>> +Only one VFIO instance may be created per VM.
>> +
>> +The created device tracks VFIO groups in use by the VM and features
>> +of those groups important to the correctness and acceleration of
>> +the VM.  As groups are enabled and disabled for use by the VM, KVM
>> +should be updated about their presence.  When registered with KVM,
>> +a reference to the VFIO-group is held by KVM.
>> +
>> +The device also tracks & enable VFIO device forwarded IRQs, if any.
> 
> s/tracks & enable/tracks and enables/
ok
> 
>> +A physical forwarded IRQ is directly completed by the guest. This
>> +requires HW support in the interrupt controller which must be able
>> +to automatically complete the physical IRQ when it detects the guest
>> +has completed the corresponding virtual IRQ. The modality sometimes
>> +is named direct EOI.
> 
> this last sentence is a bit floating out there; perhaps you want to be
> more specific and say what it is on ARM.
Well this is naming some people used at the KVM forum. I thought this
was something known on other archs but I can drop this comment.
> 
>>  
>>  Groups:
>>    KVM_DEV_VFIO_GROUP
>> +  KVM_DEV_VFIO_DEVICE
>>  
>>  KVM_DEV_VFIO_GROUP attributes:
>>    KVM_DEV_VFIO_GROUP_ADD: Add a VFIO group to VFIO-KVM device tracking
>> @@ -20,3 +29,16 @@ KVM_DEV_VFIO_GROUP attributes:
>>  
>>  For each, kvm_device_attr.addr points to an int32_t file descriptor
>>  for the VFIO group.
>> +
>> +KVM_DEV_VFIO_DEVICE attributes:
>> +  KVM_DEV_VFIO_DEVICE_FORWARD_IRQ: set a VFIO device IRQ as forwarded
>> +  KVM_DEV_VFIO_DEVICE_UNFORWARD_IRQ: set a VFIO device IRQ as not forwarded
>> +
>> +For each, kvm_device_attr.addr points to a kvm_arch_forwarded_irq struct.
>> +
>> +The forwarded state can only be changed when the VFIO signaling mechanism
>> +for this physical IRQ is not set. In other words, forwarding must be
>> +activated before VFIO_DEVICE_SET_IRQS has been called to trigger the IRQ
>> +or associate an eventfd to it. Unforwarding can only be called while the
>> +signaling has been disabled with VFIO_DEVICE_SET_IRQS. If this condition is
>> +not satisfied, the command returns an -EBUSY.
> 
> s/command/ioctl/
ok
> 
>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>> index 6076882..a269a42 100644
>> --- a/include/uapi/linux/kvm.h
>> +++ b/include/uapi/linux/kvm.h
>> @@ -946,6 +946,9 @@ struct kvm_device_attr {
>>  #define  KVM_DEV_VFIO_GROUP			1
>>  #define   KVM_DEV_VFIO_GROUP_ADD			1
>>  #define   KVM_DEV_VFIO_GROUP_DEL			2
>> +#define  KVM_DEV_VFIO_DEVICE			2
>> +#define   KVM_DEV_VFIO_DEVICE_FORWARD_IRQ			1
>> +#define   KVM_DEV_VFIO_DEVICE_UNFORWARD_IRQ			2
>>  
>>  enum kvm_device_type {
>>  	KVM_DEV_TYPE_FSL_MPIC_20	= 1,
>> @@ -963,6 +966,13 @@ enum kvm_device_type {
>>  	KVM_DEV_TYPE_MAX,
>>  };
>>  
>> +struct kvm_arch_forwarded_irq {
>> +	__u32 fd; /* file desciptor of the VFIO device */
>> +	__u32 index; /* VFIO device IRQ index */
>> +	__u32 subindex; /* VFIO device IRQ subindex */
>> +	__u32 gsi; /* gsi, ie. virtual IRQ number */
>> +};
>> +
>>  /*
>>   * ioctls for VM fds
>>   */
>> -- 
>> 1.9.1
>>
> 
> otherwise this looks reasonable.
thanks
Eric
> 

