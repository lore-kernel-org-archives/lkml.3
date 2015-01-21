Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752276AbbAUIJ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 03:09:59 -0500
Received: from mga09.intel.com ([134.134.136.24]:45336 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750811AbbAUIJv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 03:09:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="443077227"
From: "Zhang, Yang Z" <yang.z.zhang@intel.com>
To: Wincy Van <fanwenyi0529@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>,
        "gleb@kernel.org" <gleb@kernel.org>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Wanpeng Li <wanpeng.li@linux.intel.com>,
        Jan Kiszka <jan.kiszka@web.de>
Subject: RE: [PATCH v2 5/5] KVM: nVMX: Enable nested posted interrupt
 processing.
Thread-Topic: [PATCH v2 5/5] KVM: nVMX: Enable nested posted interrupt
 processing.
Thread-Index: AQHQNI4FmE9Ga9yggEGFMQiaMgUqM5zKLXcQ
Date: Wed, 21 Jan 2015 08:07:36 +0000
Message-ID: <A9667DDFB95DB7438FA9D7D576C3D87E0AC2629C@SHSMSX104.ccr.corp.intel.com>
References: <CACzj_yWxK9d_47a9ZHqtk2HSJBN6+LvtDScQqWd5znfSt8ia0Q@mail.gmail.com>
In-Reply-To: <CACzj_yWxK9d_47a9ZHqtk2HSJBN6+LvtDScQqWd5znfSt8ia0Q@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0L8A288018160

Wincy Van wrote on 2015-01-20:
> If vcpu has a interrupt in vmx non-root mode, we will kick that vcpu
> to inject interrupt timely. With posted interrupt processing, the kick
> intr is not needed, and interrupts are fully taken care of by hardware.
> 
> In nested vmx, this feature avoids much more vmexits than non-nested vmx.
> 
> This patch use L0's POSTED_INTR_NV to avoid unexpected interrupt if
> L1's vector is different with L0's. If vcpu is in hardware's non-root
> mode, we use a physical ipi to deliver posted interrupts, otherwise we
> will deliver that interrupt to L1 and kick that vcpu out of nested non-root mode.
> 
> Signed-off-by: Wincy Van <fanwenyi0529@gmail.com>
> ---
>  arch/x86/kvm/vmx.c |  136
>  ++++++++++++++++++++++++++++++++++++++++++++++++++-- 1 files changed,
>  132 insertions(+), 4 deletions(-)
> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c index
> ea56e9f..cda9133 100644 --- a/arch/x86/kvm/vmx.c +++
> b/arch/x86/kvm/vmx.c @@ -215,6 +215,7 @@ struct __packed vmcs12 {
>         u64 tsc_offset; u64 virtual_apic_page_addr; u64
>         apic_access_addr; +       u64 posted_intr_desc_addr; u64
>         ept_pointer; u64 eoi_exit_bitmap0; u64 eoi_exit_bitmap1; @@
>         -334,6 +335,7 @@ struct __packed vmcs12 { u32
>         vmx_preemption_timer_value; u32 padding32[7]; /* room for future
>         expansion */ u16 virtual_processor_id; +       u16
>         posted_intr_nv; u16 guest_es_selector; u16 guest_cs_selector;
>         u16 guest_ss_selector; @@ -387,6 +389,7 @@ struct nested_vmx {
>         /* The host-usable pointer to the above */ struct page
>         *current_vmcs12_page; struct vmcs12 *current_vmcs12; +      
>         spinlock_t vmcs12_lock; struct vmcs *current_shadow_vmcs; /*
>          * Indicates if the shadow vmcs must be updated with the @@
>          -406,6 +409,8 @@ struct nested_vmx { */
>         struct page *apic_access_page;
>         struct page *virtual_apic_page;
> +       struct page *pi_desc_page;
> +       struct pi_desc *pi_desc;
>         u64 msr_ia32_feature_control;
>         
>         struct hrtimer preemption_timer; @@ -621,6 +626,7 @@ static
> int max_shadow_read_write_fields =
> 
>  static const unsigned short vmcs_field_to_offset_table[] = {
>         FIELD(VIRTUAL_PROCESSOR_ID, virtual_processor_id), +      
>         FIELD(POSTED_INTR_NV, posted_intr_nv), FIELD(GUEST_ES_SELECTOR,
>         guest_es_selector), FIELD(GUEST_CS_SELECTOR, guest_cs_selector),
>         FIELD(GUEST_SS_SELECTOR, guest_ss_selector), @@ -646,6 +652,7 @@
>         static const unsigned short vmcs_field_to_offset_table[] = {
>         FIELD64(TSC_OFFSET, tsc_offset), FIELD64(VIRTUAL_APIC_PAGE_ADDR,
>         virtual_apic_page_addr), FIELD64(APIC_ACCESS_ADDR,
>         apic_access_addr), +       FIELD64(POSTED_INTR_DESC_ADDR,
>         posted_intr_desc_addr), FIELD64(EPT_POINTER, ept_pointer),
>         FIELD64(EOI_EXIT_BITMAP0, eoi_exit_bitmap0),
>         FIELD64(EOI_EXIT_BITMAP1, eoi_exit_bitmap1), @@ -798,6 +805,7
> @@ static void kvm_cpu_vmxon(u64 addr);  static void
> kvm_cpu_vmxoff(void); static bool vmx_mpx_supported(void);  static
> bool vmx_xsaves_supported(void);
> +static int vmx_vm_has_apicv(struct kvm *kvm);
>  static int vmx_set_tss_addr(struct kvm *kvm, unsigned int addr);
> static void vmx_set_segment(struct kvm_vcpu *vcpu,
>                             struct kvm_segment *var, int seg); @@
> -1159,6 +1167,11 @@ static inline bool nested_cpu_has_vid(struct
> vmcs12 *vmcs12)
>         return nested_cpu_has2(vmcs12,
> SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY);
>  }
> +static inline bool nested_cpu_has_posted_intr(struct vmcs12 *vmcs12) {
> +       return vmcs12->pin_based_vm_exec_control &
> +PIN_BASED_POSTED_INTR; }
> +
>  static inline bool is_exception(u32 intr_info)  {
>         return (intr_info & (INTR_INFO_INTR_TYPE_MASK |
> INTR_INFO_VALID_MASK)) @@ -2362,6 +2375,9 @@ static void
> nested_vmx_setup_ctls_msrs(struct vcpu_vmx *vmx)
>         vmx->nested.nested_vmx_pinbased_ctls_high |=
>                 PIN_BASED_ALWAYSON_WITHOUT_TRUE_MSR |
>                 PIN_BASED_VMX_PREEMPTION_TIMER;
> +       if (vmx_vm_has_apicv(vmx->vcpu.kvm))
> +               vmx->nested.nested_vmx_pinbased_ctls_high |=
> +                       PIN_BASED_POSTED_INTR;
> 
>         /* exit controls */ rdmsr(MSR_IA32_VMX_EXIT_CTLS, @@ -4267,6
>         +4283,46 @@ static int vmx_vm_has_apicv(struct kvm *kvm) return
>         enable_apicv && irqchip_in_kernel(kvm);  }
> +static int vmx_deliver_nested_posted_interrupt(struct kvm_vcpu *vcpu,
> +                                               int vector) {
> +       int r = 0;
> +       struct vmcs12 *vmcs12;
> +
> +       /*
> +        * Since posted intr delivery is async,
> +        * we must aquire a spin-lock to avoid
> +        * the race of vmcs12.
> +        */
> +       spin_lock(&to_vmx(vcpu)->nested.vmcs12_lock);
> +       vmcs12 = get_vmcs12(vcpu);
> +       if (!is_guest_mode(vcpu) || !vmcs12) {
> +               r = -1;
> +               goto out;
> +       }
> +       if (vector == vmcs12->posted_intr_nv &&
> +           nested_cpu_has_posted_intr(vmcs12)) {
> +               if (vcpu->mode == IN_GUEST_MODE)
> +                       apic->send_IPI_mask(get_cpu_mask(vcpu->cpu),
> +                               POSTED_INTR_VECTOR);
> +               else {
> +                       r = -1;
> +                       goto out;
> +               }
> +
> +               /*
> +                * if posted intr is done by hardware, the
> +                * corresponding eoi was sent to L0. Thus
> +                * we should send eoi to L1 manually.
> +                */
> +               kvm_apic_set_eoi_accelerated(vcpu,
> +                       vmcs12->posted_intr_nv);

Why this is necessary? As your comments mentioned, it is done by hardware not L1, why L1 should aware of it?

Best regards,
Yang


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
