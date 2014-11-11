Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751926AbaKKLWa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:22:30 -0500
Received: from mga02.intel.com ([134.134.136.20]:15518 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751010AbaKKLW0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:22:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,360,1413270000"; 
   d="scan'208";a="634996680"
From: "Wu, Feng" <feng.wu@intel.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: "gleb@kernel.org" <gleb@kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wu, Feng" <feng.wu@intel.com>
Subject: RE: [PATCH 05/13] KVM: Update IRTE according to guest interrupt
 configuration changes
Thread-Topic: RE: [PATCH 05/13] KVM: Update IRTE according to guest
 interrupt configuration changes
Thread-Index: Ac/9oa8NSAy+wocDT+Wz84drSD7GDA==
Date: Tue, 11 Nov 2014 11:22:03 +0000
Message-ID: <E959C4978C3B6342920538CF579893F00226F564@SHSMSX104.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Alex Williamson [mailto:alex.williamson@redhat.com]
> Sent: Tuesday, November 11, 2014 5:58 AM
> To: Wu, Feng
> Cc: gleb@kernel.org; pbonzini@redhat.com; dwmw2@infradead.org;
> joro@8bytes.org; tglx@linutronix.de; mingo@redhat.com; hpa@zytor.com;
> x86@kernel.org; kvm@vger.kernel.org; iommu@lists.linux-foundation.org;
> linux-kernel@vger.kernel.org
> Subject: Re: [PATCH 05/13] KVM: Update IRTE according to guest interrupt
> configuration changes
> 
> On Mon, 2014-11-10 at 14:26 +0800, Feng Wu wrote:
> > When guest changes its interrupt configuration (such as, vector, etc.)
> > for direct-assigned devices, we need to update the associated IRTE
> > with the new guest vector, so external interrupts from the assigned
> > devices can be injected to guests without VM-Exit.
> >
> > The current method of handling guest lowest priority interrtups
> > is to use a counter 'apic_arb_prio' for each VCPU, we choose the
> > VCPU with smallest 'apic_arb_prio' and then increase it by 1.
> > However, for VT-d PI, we cannot re-use this, since we no longer
> > have control to 'apic_arb_prio' with posted interrupt direct
> > delivery by Hardware.
> >
> > Here, we introduce a similiar way with 'apic_arb_prio' to handle
> > guest lowest priority interrtups when VT-d PI is used. Here is the
> > ideas:
> > - Each VCPU has a counter 'round_robin_counter'.
> > - When guests sets an interrupts to lowest priority, we choose
> > the VCPU with smallest 'round_robin_counter' as the destination,
> > then increase it.
> >
> > Signed-off-by: Feng Wu <feng.wu@intel.com>
> > ---
> >  arch/x86/include/asm/irq_remapping.h |    6 ++
> >  arch/x86/include/asm/kvm_host.h      |    2 +
> >  arch/x86/kvm/vmx.c                   |   12 +++
> >  arch/x86/kvm/x86.c                   |   11 +++
> >  drivers/iommu/amd_iommu.c            |    6 ++
> >  drivers/iommu/intel_irq_remapping.c  |   28 +++++++
> >  drivers/iommu/irq_remapping.c        |    9 ++
> >  drivers/iommu/irq_remapping.h        |    3 +
> >  include/linux/dmar.h                 |   26 ++++++
> >  include/linux/kvm_host.h             |   22 +++++
> >  include/uapi/linux/kvm.h             |    1 +
> >  virt/kvm/assigned-dev.c              |  141
> ++++++++++++++++++++++++++++++++++
> >  virt/kvm/irq_comm.c                  |    4 +-
> >  virt/kvm/irqchip.c                   |   11 ---
> >  14 files changed, 269 insertions(+), 13 deletions(-)
> >
> > diff --git a/arch/x86/include/asm/irq_remapping.h
> b/arch/x86/include/asm/irq_remapping.h
> > index a3cc437..32d6cc4 100644
> > --- a/arch/x86/include/asm/irq_remapping.h
> > +++ b/arch/x86/include/asm/irq_remapping.h
> > @@ -51,6 +51,7 @@ extern void compose_remapped_msi_msg(struct
> pci_dev *pdev,
> >  				     unsigned int irq, unsigned int dest,
> >  				     struct msi_msg *msg, u8 hpet_id);
> >  extern int setup_hpet_msi_remapped(unsigned int irq, unsigned int id);
> > +extern int update_pi_irte(unsigned int irq, u64 pi_desc_addr, u32 vector);
> >  extern void panic_if_irq_remap(const char *msg);
> >  extern bool setup_remapped_irq(int irq,
> >  			       struct irq_cfg *cfg,
> > @@ -88,6 +89,11 @@ static inline int setup_hpet_msi_remapped(unsigned
> int irq, unsigned int id)
> >  	return -ENODEV;
> >  }
> >
> > +static inline int update_pi_irte(unsigned int irq, u64 pi_desc_addr, u32
> vector)
> > +{
> > +	return -ENODEV;
> > +}
> > +
> >  static inline void panic_if_irq_remap(const char *msg)
> >  {
> >  }
> > diff --git a/arch/x86/include/asm/kvm_host.h
> b/arch/x86/include/asm/kvm_host.h
> > index 6ed0c30..0630161 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -358,6 +358,7 @@ struct kvm_vcpu_arch {
> >  	struct kvm_lapic *apic;    /* kernel irqchip context */
> >  	unsigned long apic_attention;
> >  	int32_t apic_arb_prio;
> > +	int32_t round_robin_counter;
> >  	int mp_state;
> >  	u64 ia32_misc_enable_msr;
> >  	bool tpr_access_reporting;
> > @@ -771,6 +772,7 @@ struct kvm_x86_ops {
> >  	int (*check_nested_events)(struct kvm_vcpu *vcpu, bool external_intr);
> >
> >  	void (*sched_in)(struct kvm_vcpu *kvm, int cpu);
> > +	u64 (*get_pi_desc_addr)(struct kvm_vcpu *vcpu);
> >  };
> >
> >  struct kvm_arch_async_pf {
> > diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
> > index a4670d3..ae91b72 100644
> > --- a/arch/x86/kvm/vmx.c
> > +++ b/arch/x86/kvm/vmx.c
> > @@ -544,6 +544,11 @@ static inline struct vcpu_vmx *to_vmx(struct
> kvm_vcpu *vcpu)
> >  	return container_of(vcpu, struct vcpu_vmx, vcpu);
> >  }
> >
> > +struct pi_desc *vcpu_to_pi_desc(struct kvm_vcpu *vcpu)
> > +{
> > +	return &(to_vmx(vcpu)->pi_desc);
> > +}
> > +
> >  #define VMCS12_OFFSET(x) offsetof(struct vmcs12, x)
> >  #define FIELD(number, name)	[number] = VMCS12_OFFSET(name)
> >  #define FIELD64(number, name)	[number] = VMCS12_OFFSET(name), \
> > @@ -4280,6 +4285,11 @@ static void vmx_sync_pir_to_irr_dummy(struct
> kvm_vcpu *vcpu)
> >  	return;
> >  }
> >
> > +static u64 vmx_get_pi_desc_addr(struct kvm_vcpu *vcpu)
> > +{
> > +	return __pa((u64)vcpu_to_pi_desc(vcpu));
> > +}
> > +
> >  /*
> >   * Set up the vmcs's constant host-state fields, i.e., host-state fields that
> >   * will not change in the lifetime of the guest.
> > @@ -9232,6 +9242,8 @@ static struct kvm_x86_ops vmx_x86_ops = {
> >  	.check_nested_events = vmx_check_nested_events,
> >
> >  	.sched_in = vmx_sched_in,
> > +
> > +	.get_pi_desc_addr = vmx_get_pi_desc_addr,
> >  };
> >
> >  static int __init vmx_init(void)
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index b447a98..0c19d15 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -7735,6 +7735,17 @@ bool kvm_arch_has_noncoherent_dma(struct
> kvm *kvm)
> >  }
> >  EXPORT_SYMBOL_GPL(kvm_arch_has_noncoherent_dma);
> >
> > +int kvm_update_pi_irte_common(struct kvm *kvm, struct kvm_vcpu *vcpu,
> > +			u32 guest_vector, int host_irq)
> > +{
> > +	u64 pi_desc_addr = kvm_x86_ops->get_pi_desc_addr(vcpu);
> > +
> > +	if (update_pi_irte(host_irq, pi_desc_addr, guest_vector))
> > +		return -1;
> > +
> > +	return 0;
> > +}
> > +
> >  EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_exit);
> >  EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_inj_virq);
> >  EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_page_fault);
> > diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
> > index 505a9ad..a36fdc7 100644
> > --- a/drivers/iommu/amd_iommu.c
> > +++ b/drivers/iommu/amd_iommu.c
> > @@ -4280,6 +4280,11 @@ static int alloc_hpet_msi(unsigned int irq,
> unsigned int id)
> >  	return 0;
> >  }
> >
> > +static int dummy_update_pi_irte(int irq, u64 pi_desc_addr, u32 vector)
> > +{
> > +	return -EINVAL;
> > +}
> > +
> >  struct irq_remap_ops amd_iommu_irq_ops = {
> >  	.supported		= amd_iommu_supported,
> >  	.prepare		= amd_iommu_prepare,
> > @@ -4294,5 +4299,6 @@ struct irq_remap_ops amd_iommu_irq_ops = {
> >  	.msi_alloc_irq		= msi_alloc_irq,
> >  	.msi_setup_irq		= msi_setup_irq,
> >  	.alloc_hpet_msi		= alloc_hpet_msi,
> > +	.update_pi_irte         = dummy_update_pi_irte,
> >  };
> >  #endif
> > diff --git a/drivers/iommu/intel_irq_remapping.c
> b/drivers/iommu/intel_irq_remapping.c
> > index 776da10..87c02fe 100644
> > --- a/drivers/iommu/intel_irq_remapping.c
> > +++ b/drivers/iommu/intel_irq_remapping.c
> > @@ -1172,6 +1172,33 @@ static int intel_alloc_hpet_msi(unsigned int irq,
> unsigned int id)
> >  	return ret;
> >  }
> >
> > +static int intel_update_pi_irte(int irq, u64 pi_desc_addr, u32 vector)
> > +{
> > +	struct irte irte;
> > +
> > +	if (get_irte(irq, &irte))
> > +		return -1;
> > +
> > +	irte.irq_post_low.urg = 0;
> > +	irte.irq_post_low.vector = vector;
> > +	irte.irq_post_low.pda_l = (pi_desc_addr >> (32 - PDA_LOW_BIT)) &
> > +			~(-1UL << PDA_LOW_BIT);
> > +	irte.irq_post_high.pda_h = (pi_desc_addr >> 32) &
> > +			~(-1UL << PDA_HIGH_BIT);
> > +
> > +	irte.irq_post_low.__reserved_1 = 0;
> > +	irte.irq_post_low.__reserved_2 = 0;
> > +	irte.irq_post_low.__reserved_3 = 0;
> > +	irte.irq_post_high.__reserved_4 = 0;
> > +
> > +	irte.irq_post_low.pst = 1;
> > +
> > +	if (modify_irte(irq, &irte))
> > +		return -1;
> > +
> > +	return 0;
> > +}
> > +
> >  struct irq_remap_ops intel_irq_remap_ops = {
> >  	.supported		= intel_irq_remapping_supported,
> >  	.prepare		= dmar_table_init,
> > @@ -1186,4 +1213,5 @@ struct irq_remap_ops intel_irq_remap_ops = {
> >  	.msi_alloc_irq		= intel_msi_alloc_irq,
> >  	.msi_setup_irq		= intel_msi_setup_irq,
> >  	.alloc_hpet_msi		= intel_alloc_hpet_msi,
> > +	.update_pi_irte         = intel_update_pi_irte,
> 
> Extending irq_remap_ops should really be a separate patch from it's use
> by KVM.

Will do.

> 
> >  };
> > diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
> > index 2f8ee00..0e36860 100644
> > --- a/drivers/iommu/irq_remapping.c
> > +++ b/drivers/iommu/irq_remapping.c
> > @@ -362,6 +362,15 @@ int setup_hpet_msi_remapped(unsigned int irq,
> unsigned int id)
> >  	return default_setup_hpet_msi(irq, id);
> >  }
> >
> > +int update_pi_irte(unsigned int irq, u64 pi_desc_addr, u32 vector)
> > +{
> > +	if (!remap_ops || !remap_ops->update_pi_irte)
> > +		return -ENODEV;
> > +
> > +	return remap_ops->update_pi_irte(irq, pi_desc_addr, vector);
> > +}
> > +EXPORT_SYMBOL_GPL(update_pi_irte);
> > +
> >  void panic_if_irq_remap(const char *msg)
> >  {
> >  	if (irq_remapping_enabled)
> > diff --git a/drivers/iommu/irq_remapping.h b/drivers/iommu/irq_remapping.h
> > index 7bb5913..2d8f740 100644
> > --- a/drivers/iommu/irq_remapping.h
> > +++ b/drivers/iommu/irq_remapping.h
> > @@ -84,6 +84,9 @@ struct irq_remap_ops {
> >
> >  	/* Setup interrupt remapping for an HPET MSI */
> >  	int (*alloc_hpet_msi)(unsigned int, unsigned int);
> > +
> > +	/* Update IRTE for posted-interrupt */
> > +	int (*update_pi_irte)(int irq, u64 pi_desc_addr, u32 vector);
> >  };
> >
> >  extern struct irq_remap_ops intel_irq_remap_ops;
> > diff --git a/include/linux/dmar.h b/include/linux/dmar.h
> > index 8be5d42..e1ff4f7 100644
> > --- a/include/linux/dmar.h
> > +++ b/include/linux/dmar.h
> > @@ -160,6 +160,20 @@ struct irte {
> >  				__reserved_2	: 8,
> >  				dest_id		: 32;
> >  		} irq_remap_low;
> > +
> > +		struct {
> > +			__u64   present		: 1,
> > +				fpd		: 1,
> > +				__reserved_1	: 6,
> > +				avail	: 4,
> > +				__reserved_2	: 2,
> > +				urg		: 1,
> > +				pst		: 1,
> > +				vector	: 8,
> > +				__reserved_3	: 14,
> > +				pda_l	: 26;
> > +		} irq_post_low;
> > +
> >  		__u64 low;
> >  	};
> >
> > @@ -170,10 +184,22 @@ struct irte {
> >  				svt		: 2,
> >  				__reserved_3	: 44;
> >  		} irq_remap_high;
> > +
> > +		struct {
> > +			__u64	sid:	16,
> > +				sq:		2,
> > +				svt:	2,
> > +				__reserved_4:	12,
> > +				pda_h:	32;
> > +		} irq_post_high;
> > +
> >  		__u64 high;
> >  	};
> >  };
> >
> > +#define PDA_LOW_BIT    26
> > +#define PDA_HIGH_BIT   32
> > +
> >  enum {
> >  	IRQ_REMAP_XAPIC_MODE,
> >  	IRQ_REMAP_X2APIC_MODE,
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index ea53b04..6bb8287 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -335,6 +335,25 @@ struct kvm_kernel_irq_routing_entry {
> >  	struct hlist_node link;
> >  };
> >
> > +#ifdef CONFIG_HAVE_KVM_IRQ_ROUTING
> > +
> > +struct kvm_irq_routing_table {
> > +	int chip[KVM_NR_IRQCHIPS][KVM_IRQCHIP_NUM_PINS];
> > +	struct kvm_kernel_irq_routing_entry *rt_entries;
> > +	u32 nr_rt_entries;
> > +	/*
> > +	 * Array indexed by gsi. Each entry contains list of irq chips
> > +	 * the gsi is connected to.
> > +	 */
> > +	struct hlist_head map[0];
> > +};
> > +
> > +#else
> > +
> > +struct kvm_irq_routing_table {};
> > +
> > +#endif
> > +
> >  #ifndef KVM_PRIVATE_MEM_SLOTS
> >  #define KVM_PRIVATE_MEM_SLOTS 0
> >  #endif
> > @@ -766,6 +785,9 @@ void kvm_unregister_irq_ack_notifier(struct kvm
> *kvm,
> >  				   struct kvm_irq_ack_notifier *kian);
> >  int kvm_request_irq_source_id(struct kvm *kvm);
> >  void kvm_free_irq_source_id(struct kvm *kvm, int irq_source_id);
> > +void kvm_set_msi_irq(struct kvm_kernel_irq_routing_entry *e,
> > +				   struct kvm_lapic_irq *irq);
> > +bool kvm_is_dm_lowest_prio(struct kvm_lapic_irq *irq);
> >
> >  #ifdef CONFIG_KVM_DEVICE_ASSIGNMENT
> >  int kvm_iommu_map_pages(struct kvm *kvm, struct kvm_memory_slot
> *slot);
> > diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> > index 7593c52..509223a 100644
> > --- a/include/uapi/linux/kvm.h
> > +++ b/include/uapi/linux/kvm.h
> > @@ -1027,6 +1027,7 @@ struct kvm_s390_ucas_mapping {
> >  #define KVM_XEN_HVM_CONFIG        _IOW(KVMIO,  0x7a, struct
> kvm_xen_hvm_config)
> >  #define KVM_SET_CLOCK             _IOW(KVMIO,  0x7b, struct
> kvm_clock_data)
> >  #define KVM_GET_CLOCK             _IOR(KVMIO,  0x7c, struct
> kvm_clock_data)
> > +#define KVM_ASSIGN_DEV_PI_UPDATE  _IOR(KVMIO,  0x7d, __u32)
> >  /* Available with KVM_CAP_PIT_STATE2 */
> >  #define KVM_GET_PIT2              _IOR(KVMIO,  0x9f, struct
> kvm_pit_state2)
> >  #define KVM_SET_PIT2              _IOW(KVMIO,  0xa0, struct
> kvm_pit_state2)
> 
> Needs an accompanying Documentation/virtual/kvm/api.txt update.
> 
> > diff --git a/virt/kvm/assigned-dev.c b/virt/kvm/assigned-dev.c
> > index e05000e..e154009 100644
> > --- a/virt/kvm/assigned-dev.c
> > +++ b/virt/kvm/assigned-dev.c
> 
> 
> Since legacy KVM device assignment is effectively deprecated, have you
> considered how we might do this with VFIO?  Thanks,
> 
> Alex
> 
I haven't thought about how to enable this in VFIO so far. I think I can continue to
implement that if needed after this patch set is finished. What do you think of this?

Thanks,
Feng


> 
> > @@ -326,6 +326,135 @@ void kvm_free_all_assigned_devices(struct kvm
> *kvm)
> >  	}
> >  }
> >
> > +int __weak kvm_update_pi_irte_common(struct kvm *kvm, struct kvm_vcpu
> *vcpu,
> > +					u32 guest_vector, int host_irq)
> > +{
> > +	return 0;
> > +}
> > +
> > +int kvm_compare_rr_counter(struct kvm_vcpu *vcpu1, struct kvm_vcpu
> *vcpu2)
> > +{
> > +	return vcpu1->arch.round_robin_counter -
> > +			vcpu2->arch.round_robin_counter;
> > +}
> > +
> > +bool kvm_pi_find_dest_vcpu(struct kvm *kvm, struct kvm_lapic_irq *irq,
> > +				struct kvm_vcpu **dest_vcpu)
> > +{
> > +	int i, r = 0;
> > +	struct kvm_vcpu *vcpu, *dest = NULL;
> > +
> > +	kvm_for_each_vcpu(i, vcpu, kvm) {
> > +		if (!kvm_apic_present(vcpu))
> > +			continue;
> > +
> > +		if (!kvm_apic_match_dest(vcpu, NULL, irq->shorthand,
> > +					irq->dest_id, irq->dest_mode))
> > +			continue;
> > +
> > +		if (!kvm_is_dm_lowest_prio(irq)) {
> > +			r++;
> > +			*dest_vcpu = vcpu;
> > +		} else if (kvm_lapic_enabled(vcpu)) {
> > +			if (!dest)
> > +				dest = vcpu;
> > +			else if (kvm_compare_rr_counter(vcpu, dest) < 0)
> > +				dest = vcpu;
> > +		}
> > +	}
> > +
> > +	if (dest) {
> > +		dest->arch.round_robin_counter++;
> > +		*dest_vcpu = dest;
> > +		return true;
> > +	} else if (r == 1)
> > +		return true;
> > +
> > +	return false;
> > +}
> > +
> > +static int __kvm_update_pi_irte(struct kvm *kvm, int host_irq, int
> guest_irq)
> > +{
> > +	struct kvm_kernel_irq_routing_entry *e;
> > +	struct kvm_irq_routing_table *irq_rt;
> > +	struct kvm_lapic_irq irq;
> > +	struct kvm_vcpu *vcpu;
> > +	int idx, ret = -EINVAL;
> > +
> > +	idx = srcu_read_lock(&kvm->irq_srcu);
> > +	irq_rt = srcu_dereference(kvm->irq_routing, &kvm->irq_srcu);
> > +	ASSERT(guest_irq < irq_rt->nr_rt_entries);
> > +
> > +	hlist_for_each_entry(e, &irq_rt->map[guest_irq], link) {
> > +		if (e->type != KVM_IRQ_ROUTING_MSI)
> > +			continue;
> > +		/*
> > +		 * VT-d posted-interrupt has the following
> > +		 * limitations:
> > +		 *  - No support for posting multicast/broadcast
> > +		 *    interrupts to a VCPU
> > +		 * Still use interrupt remapping for these
> > +		 * kind of interrupts
> > +		 */
> > +
> > +		kvm_set_msi_irq(e, &irq);
> > +		if (!kvm_pi_find_dest_vcpu(kvm, &irq, &vcpu)) {
> > +			printk(KERN_INFO "%s: can not find the target VCPU\n",
> > +					__func__);
> > +			ret = -EINVAL;
> > +			goto out;
> > +		}
> > +
> > +		if (kvm_update_pi_irte_common(kvm, vcpu, irq.vector,
> > +				host_irq)) {
> > +			printk(KERN_INFO "%s: failed to update PI IRTE\n",
> > +					__func__);
> > +			ret = -EINVAL;
> > +			goto out;
> > +		}
> > +	}
> > +
> > +	ret = 0;
> > +out:
> > +	srcu_read_unlock(&kvm->irq_srcu, idx);
> > +	return ret;
> > +}
> > +
> > +int kvm_update_pi_irte(struct kvm *kvm, u32 dev_id)
> > +{
> > +	int i, rc = -1;
> > +	struct kvm_assigned_dev_kernel *dev;
> > +
> > +	mutex_lock(&kvm->lock);
> > +	dev = kvm_find_assigned_dev(&kvm->arch.assigned_dev_head, dev_id);
> > +	if (!dev) {
> > +		printk(KERN_INFO "%s: cannot find the assigned dev.\n",
> > +				__func__);
> > +		rc = -1;
> > +		goto out;
> > +	}
> > +
> > +	BUG_ON(dev->irq_requested_type == 0);
> > +
> > +	if ((dev->irq_requested_type & KVM_DEV_IRQ_HOST_MSI) &&
> > +		(dev->dev->msi_enabled == 1)) {
> > +			__kvm_update_pi_irte(kvm,
> > +					dev->host_irq, dev->guest_irq);
> > +	} else if ((dev->irq_requested_type & KVM_DEV_IRQ_HOST_MSIX) &&
> > +		(dev->dev->msix_enabled == 1)) {
> > +		for (i = 0; i < dev->entries_nr; i++) {
> > +			__kvm_update_pi_irte(kvm,
> > +					dev->host_msix_entries[i].vector,
> > +					dev->guest_msix_entries[i].vector);
> > +		}
> > +	}
> > +
> > +out:
> > +	rc = 0;
> > +	mutex_unlock(&kvm->lock);
> > +	return rc;
> > +}
> > +
> >  static int assigned_device_enable_host_intx(struct kvm *kvm,
> >  					    struct kvm_assigned_dev_kernel *dev)
> >  {
> > @@ -1017,6 +1146,18 @@ long kvm_vm_ioctl_assigned_device(struct kvm
> *kvm, unsigned ioctl,
> >  		r = kvm_vm_ioctl_set_pci_irq_mask(kvm, &assigned_dev);
> >  		break;
> >  	}
> > +	case KVM_ASSIGN_DEV_PI_UPDATE: {
> > +		u32 dev_id;
> > +
> > +		r = -EFAULT;
> > +		if (copy_from_user(&dev_id, argp, sizeof(dev_id)))
> > +			goto out;
> > +		r = kvm_update_pi_irte(kvm, dev_id);
> > +		if (r)
> > +			goto out;
> > +		break;
> > +
> > +	}
> >  	default:
> >  		r = -ENOTTY;
> >  		break;
> > diff --git a/virt/kvm/irq_comm.c b/virt/kvm/irq_comm.c
> > index 963b899..f51aed3 100644
> > --- a/virt/kvm/irq_comm.c
> > +++ b/virt/kvm/irq_comm.c
> > @@ -55,7 +55,7 @@ static int kvm_set_ioapic_irq(struct
> kvm_kernel_irq_routing_entry *e,
> >  				line_status);
> >  }
> >
> > -inline static bool kvm_is_dm_lowest_prio(struct kvm_lapic_irq *irq)
> > +bool kvm_is_dm_lowest_prio(struct kvm_lapic_irq *irq)
> >  {
> >  #ifdef CONFIG_IA64
> >  	return irq->delivery_mode ==
> > @@ -106,7 +106,7 @@ int kvm_irq_delivery_to_apic(struct kvm *kvm,
> struct kvm_lapic *src,
> >  	return r;
> >  }
> >
> > -static inline void kvm_set_msi_irq(struct kvm_kernel_irq_routing_entry *e,
> > +void kvm_set_msi_irq(struct kvm_kernel_irq_routing_entry *e,
> >  				   struct kvm_lapic_irq *irq)
> >  {
> >  	trace_kvm_msi_set_irq(e->msi.address_lo, e->msi.data);
> > diff --git a/virt/kvm/irqchip.c b/virt/kvm/irqchip.c
> > index 7f256f3..cdf29a6 100644
> > --- a/virt/kvm/irqchip.c
> > +++ b/virt/kvm/irqchip.c
> > @@ -31,17 +31,6 @@
> >  #include <trace/events/kvm.h>
> >  #include "irq.h"
> >
> > -struct kvm_irq_routing_table {
> > -	int chip[KVM_NR_IRQCHIPS][KVM_IRQCHIP_NUM_PINS];
> > -	struct kvm_kernel_irq_routing_entry *rt_entries;
> > -	u32 nr_rt_entries;
> > -	/*
> > -	 * Array indexed by gsi. Each entry contains list of irq chips
> > -	 * the gsi is connected to.
> > -	 */
> > -	struct hlist_head map[0];
> > -};
> > -
> >  int kvm_irq_map_gsi(struct kvm *kvm,
> >  		    struct kvm_kernel_irq_routing_entry *entries, int gsi)
> >  {
> 
> 

