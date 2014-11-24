Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753014AbaKXI2s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 03:28:48 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:45744 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752951AbaKXI2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 03:28:46 -0500
Message-ID: <5472EBEF.3070108@linaro.org>
Date: Mon, 24 Nov 2014 09:27:27 +0100
From: Eric Auger <eric.auger@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "Wu, Feng" <feng.wu@intel.com>, "eric.auger@st.com" <eric.auger@st.com>,
        "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>,
        "marc.zyngier@arm.com" <marc.zyngier@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "joel.schopp@amd.com" <joel.schopp@amd.com>,
        "kim.phillips@freescale.com" <kim.phillips@freescale.com>,
        "paulus@samba.org" <paulus@samba.org>,
        "gleb@kernel.org" <gleb@kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "agraf@suse.de" <agraf@suse.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        "a.motakis@virtualopensystems.com" <a.motakis@virtualopensystems.com>,
        "a.rigo@virtualopensystems.com" <a.rigo@virtualopensystems.com>,
        "john.liuli@huawei.com" <john.liuli@huawei.com>,
        "ming.lei@canonical.com" <ming.lei@canonical.com>
Subject: Re: [PATCH v3 0/8] KVM-VFIO IRQ forward control
References: <1416767760-14487-1-git-send-email-eric.auger@linaro.org> <E959C4978C3B6342920538CF579893F0022ADA8C@SHSMSX104.ccr.corp.intel.com>
In-Reply-To: <E959C4978C3B6342920538CF579893F0022ADA8C@SHSMSX104.ccr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24/2014 09:14 AM, Wu, Feng wrote:
> 
> 
>> -----Original Message-----
>> From: Eric Auger [mailto:eric.auger@linaro.org]
>> Sent: Monday, November 24, 2014 2:36 AM
>> To: eric.auger@st.com; eric.auger@linaro.org; christoffer.dall@linaro.org;
>> marc.zyngier@arm.com; linux-arm-kernel@lists.infradead.org;
>> kvmarm@lists.cs.columbia.edu; kvm@vger.kernel.org;
>> alex.williamson@redhat.com; joel.schopp@amd.com;
>> kim.phillips@freescale.com; paulus@samba.org; gleb@kernel.org;
>> pbonzini@redhat.com; agraf@suse.de
>> Cc: linux-kernel@vger.kernel.org; patches@linaro.org; will.deacon@arm.com;
>> a.motakis@virtualopensystems.com; a.rigo@virtualopensystems.com;
>> john.liuli@huawei.com; ming.lei@canonical.com; Wu, Feng
>> Subject: [PATCH v3 0/8] KVM-VFIO IRQ forward control
>>
>> This series proposes an integration of "ARM: Forwarding physical
>> interrupts to a guest VM" (http://lwn.net/Articles/603514/) in
>> KVM.
>>
>> It enables to transform a VFIO platform driver IRQ into a forwarded
>> IRQ.
>>
>> When a physical IRQ is forwarded (to a guest), the host does not
>> deactivates this latter. Completion ownership is transferred to the
>> guest. When the guest deactivates the associated virtual IRQ,
>> the interrupt controler automatically completes the physical IRQ.
>> Obviously this requires some dedicated HW support in the interrupt
>> controler.
>>
>> The direct benefit is that, for a level sensitive IRQ, it avoids a
>> VM exit on forwarded IRQ completion.
>>
>> When the IRQ is forwarded, the VFIO platform driver does not need to
>> mask the physical IRQ anymore before signaling the eventfd. Indeed
>> genirq lowers the running priority, enabling other physical IRQ to hit
>> except that one.
>>
>> Besides, the injection still is based on irqfd triggering. The only
>> impact on irqfd process is resamplefd is not called anymore on
>> virtual IRQ completion since this latter becomes "transparent".
>>
>> The current integration is based on an extension of the KVM-VFIO
>> device, previously used by KVM to interact with VFIO groups. The
>> patch series now enables KVM to directly interact with a VFIO
>> platform device. The VFIO external API was extended for that purpose.
>>
>> Th KVM-VFIO device can get/put the vfio platform device, check its
>> integrity and type, get the IRQ number associated to an IRQ index.
>>
>> The IRQ forward programming is architecture specific (virtual interrupt
>> controller programming basically). However the whole infrastructure is
>> kept generic.
>>
>> from a user point of view, the functionality is provided through a
>> new KVM-VFIO group named KVM_DEV_VFIO_DEVICE and 2 associated
>> attributes:
>> - KVM_DEV_VFIO_DEVICE_FORWARD_IRQ,
>> - KVM_DEV_VFIO_DEVICE_UNFORWARD_IRQ.
>>
>> The capability can be checked with KVM_HAS_DEVICE_ATTR.
>>
>> Forwarding must be activated before VFIO signaling mechanism is set
>> using VFIO_DEVICE_SET_IRQS and unset while the signaling is disabled.
>>
>> ---
>>
>> This patch series has the following dependencies:
>> - "ARM: Forwarding physical interrupts to a guest VM"
>>   (http://lwn.net/Articles/603514/)
>> - [PATCH v9 00/19] VFIO support for platform and AMBA devices on ARM
>>   (http://www.spinics.net/lists/kvm-arm/msg11745.html)
>> - [PATCH v2 0/6] vfio: type1: support for ARM SMMUS with
>> VFIO_IOMMU_TYPE1
>>   (http://www.spinics.net/lists/kvm-arm/msg11738.html)
>>
>> Integrated pieces can be found at
>> ssh://git.linaro.org/people/eric.auger/linux.git
>> on branch irqfd_integ_v8
>>
>> This was was tested on Calxeda Midway, assigning the xgmac main IRQ.
>>
> 
> Hi Eric,
> 
> Did you send out the latest QEMU part for this patch set, I notice that v6 of
> The QEMU part is sent out, but seems some structure in this new version
> has been changed, such as, struct kvm_arch_forwarded_irq (subindex is added
> in this version), so a new patchset in QEMU is also needed.

Hi Feng,

v7 is available at:
http://lists.gnu.org/archive/html/qemu-devel/2014-10/msg03804.html. It
already illustrates KVM-VFIO device usage.

v8 which will indeed integrate subindex addition will be delivered this
week.

Best Regards

Eric
> 
> Thanks,
> Feng
> 
> 
>> v2 -> v3:
>> - kvm_fwd_irq_action enum replaced by a bool (KVM_VFIO_IRQ_CLEANUP does
>> not
>>   exist anymore)
>> - a new struct local to vfio.c was introduced to wrap kvm_fw_irq and make it
>>   linkable: kvm_vfio_fwd_irq_node
>> - kvm_fwd_irq now is self-contained (includes struct vfio_device *)
>> - a single list of kvm_vfio_fwd_irq_irq_node is used instead of having
>>   a list of devices and a list of forward irq per device. Having 2 lists
>>   brought extra complexity.
>> - the VFIO device ref counter is incremented each time a new IRQ is forwarded.
>>   It is not attempted anymore to hold a single reference whatever the number
>>   of forwarded IRQs.
>> - subindex added on top of index to be closer to VFIO API
>> - platform device check moved in the arm specific implementation
>> - enable the KVM-VFIO device for arm64
>> - forwarded state change only can happen while the VFIO IRQ handler is not
>>   set; in other words, when the VFIO IRQ signaling is not set.
>>
>> v1 -> v2:
>> - forward control is moved from architecture specific file into generic
>>   vfio.c module.
>>   only kvm_arch_set_fwd_state remains architecture specific
>> - integrate Kim's patch which enables KVM-VFIO for ARM
>> - fix vgic state bypass in vgic_queue_hwirq
>> - struct kvm_arch_forwarded_irq moved from
>> arch/arm/include/uapi/asm/kvm.h
>>   to include/uapi/linux/kvm.h
>>   also irq_index renamed into index and guest_irq renamed into gsi
>> - ASSIGN/DEASSIGN renamed into FORWARD/UNFORWARD
>> - vfio_external_get_base_device renamed into vfio_external_base_device
>> - vfio_external_get_type removed
>> - kvm_vfio_external_get_base_device renamed into
>> kvm_vfio_external_base_device
>> - __KVM_HAVE_ARCH_KVM_VFIO renamed into
>> __KVM_HAVE_ARCH_KVM_VFIO_FORWARD
>>
>>
>> Eric Auger (7):
>>   KVM: arm64: Enable the KVM-VFIO device
>>   VFIO: platform: forwarded state tested when selecting IRQ handler
>>   KVM: kvm-vfio: User API for IRQ forwarding
>>   VFIO: External user API device helpers
>>   KVM: kvm-vfio: wrapper to VFIO external API device helpers
>>   KVM: kvm-vfio: generic forwarding control
>>   KVM: arm: kvm-vfio: forwarding control
>>
>> Kim Phillips (1):
>>   KVM: arm: Enable the KVM-VFIO device
>>
>>  Documentation/virtual/kvm/devices/vfio.txt |  34 +++-
>>  arch/arm/include/asm/kvm_host.h            |   7 +
>>  arch/arm/kvm/Kconfig                       |   1 +
>>  arch/arm/kvm/Makefile                      |   4 +-
>>  arch/arm/kvm/kvm_vfio_arm.c                | 101 ++++++++++
>>  arch/arm64/kvm/Kconfig                     |   1 +
>>  arch/arm64/kvm/Makefile                    |   2 +-
>>  drivers/vfio/platform/vfio_platform_irq.c  |   7 +-
>>  drivers/vfio/vfio.c                        |  24 +++
>>  include/linux/kvm_host.h                   |  28 +++
>>  include/linux/vfio.h                       |   3 +
>>  include/uapi/linux/kvm.h                   |  10 +
>>  virt/kvm/vfio.c                            | 294
>> ++++++++++++++++++++++++++++-
>>  13 files changed, 503 insertions(+), 13 deletions(-)
>>  create mode 100644 arch/arm/kvm/kvm_vfio_arm.c
>>
>> --
>> 1.9.1
> 

