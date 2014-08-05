Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720AbaHEMnA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 08:43:00 -0400
Received: from mga01.intel.com ([192.55.52.88]:14688 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752536AbaHEMm6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 08:42:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="368160968"
Date: Tue, 5 Aug 2014 20:44:20 +0800
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Felipe Reyes <freyes@suse.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jan Kiszka <jan.kiszka@siemens.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Bandan Das <bsd@redhat.com>, Zhang Yang <yang.z.zhang@intel.com>,
        Davidlohr Bueso <davidlohr@hp.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] KVM: nVMX: fix acknowledge interrupt on exit when
 APICv is in use
Message-ID: <20140805124420.GA19457@kernel>
Reply-To: Wanpeng Li <wanpeng.li@linux.intel.com>
References: <1407213744-24794-1-git-send-email-wanpeng.li@linux.intel.com>
 <1407213744-24794-2-git-send-email-wanpeng.li@linux.intel.com>
 <53E0BA31.1000708@redhat.com>
 <53E0D069.3010202@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53E0D069.3010202@suse.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2014 at 02:39:05PM +0200, Felipe Reyes wrote:
>Hi,
>
>On 08/05/2014 01:04 PM, Paolo Bonzini wrote:
>>Il 05/08/2014 06:42, Wanpeng Li ha scritto:
>>>After commit 77b0f5d (KVM: nVMX: Ack and write vector info to intr_info
>>>if L1 asks us to), "Acknowledge interrupt on exit" behavior can be
>>>emulated. To do so, KVM will ask the APIC for the interrupt vector if
>>>during a nested vmexit if VM_EXIT_ACK_INTR_ON_EXIT is set.  With APICv,
>>>kvm_get_apic_interrupt would return -1 and give the following WARNING:
>>>
>>>Call Trace:
>>>  [<ffffffff81493563>] dump_stack+0x49/0x5e
>>>  [<ffffffff8103f0eb>] warn_slowpath_common+0x7c/0x96
>>>  [<ffffffffa059709a>] ? nested_vmx_vmexit+0xa4/0x233 [kvm_intel]
>>>  [<ffffffff8103f11a>] warn_slowpath_null+0x15/0x17
>>>  [<ffffffffa059709a>] nested_vmx_vmexit+0xa4/0x233 [kvm_intel]
>>>  [<ffffffffa0594295>] ? nested_vmx_exit_handled+0x6a/0x39e [kvm_intel]
>>>  [<ffffffffa0537931>] ? kvm_apic_has_interrupt+0x80/0xd5 [kvm]
>>>  [<ffffffffa05972ec>] vmx_check_nested_events+0xc3/0xd3 [kvm_intel]
>>>  [<ffffffffa051ebe9>] inject_pending_event+0xd0/0x16e [kvm]
>>>  [<ffffffffa051efa0>] vcpu_enter_guest+0x319/0x704 [kvm]
>>>
>>>If enabling APIC-v, all interrupts to L1 are delivered through APIC-v.
>>>But when L2 is running, external interrupt will casue L1 vmexit with
>>>reason external interrupt. Then L1 will pick up the interrupt through
>>>vmcs12. when L1 ack the interrupt, since the APIC-v is enabled when
>>>L1 is running, so APIC-v hardware still will do vEOI updating. The problem
>>>is that the interrupt is delivered not through APIC-v hardware, this means
>>>SVI/RVI/vPPR are not setting, but hardware required them when doing vEOI
>>>updating. The solution is that, when L1 tried to pick up the interrupt
>>>from vmcs12, then hypervisor will help to update the SVI/RVI/vPPR to make
>>>sure the following vEOI updating and vPPR updating corrently.
>>>
>>>Also, since interrupt is delivered through vmcs12, so APIC-v hardware will
>>>not cleare vIRR and hypervisor need to clear it before L1 running.
>>>
>>>Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
>>>Suggested-by: "Zhang, Yang Z" <yang.z.zhang@intel.com>
>>>Tested-by: Liu, RongrongX <rongrongx.liu@intel.com>
>>>Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
>>>---
>>>v1 -> v2:
>>>  * reusing kvm_get_apic_interrupt here (by modifying kvm_cpu_get_interrupt,
>>>    apic_set_isr and apic_clear_irr)
>>>
>>>  arch/x86/kvm/irq.c   |  2 +-
>>>  arch/x86/kvm/lapic.c | 52 +++++++++++++++++++++++++++++++++++++++-------------
>>>  2 files changed, 40 insertions(+), 14 deletions(-)
>>>
>>>diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c
>>>index bd0da43..a1ec6a5 100644
>>>--- a/arch/x86/kvm/irq.c
>>>+++ b/arch/x86/kvm/irq.c
>>>@@ -108,7 +108,7 @@ int kvm_cpu_get_interrupt(struct kvm_vcpu *v)
>>>
>>>  	vector = kvm_cpu_get_extint(v);
>>>
>>>-	if (kvm_apic_vid_enabled(v->kvm) || vector != -1)
>>>+	if (vector != -1)
>>>  		return vector;			/* PIC */
>>>
>>>  	return kvm_get_apic_interrupt(v);	/* APIC */
>>>diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
>>>index 3855103..08e8a89 100644
>>>--- a/arch/x86/kvm/lapic.c
>>>+++ b/arch/x86/kvm/lapic.c
>>>@@ -352,25 +352,46 @@ static inline int apic_find_highest_irr(struct kvm_lapic *apic)
>>>
>>>  static inline void apic_clear_irr(int vec, struct kvm_lapic *apic)
>>>  {
>>>-	apic->irr_pending = false;
>>>+	struct kvm_vcpu *vcpu;
>>>+
>>>+	vcpu = apic->vcpu;
>>>+
>>>  	apic_clear_vector(vec, apic->regs + APIC_IRR);
>>>-	if (apic_search_irr(apic) != -1)
>>>-		apic->irr_pending = true;
>>>+	if (unlikely(kvm_apic_vid_enabled(vcpu->kvm)))
>>>+		/* try to update RVI */
>>>+		kvm_make_request(KVM_REQ_EVENT, vcpu);
>>>+	else {
>>>+		vec = apic_search_irr(apic);
>>>+		apic->irr_pending = (vec != -1);
>>>+	}
>>>  }
>>>
>>>  static inline void apic_set_isr(int vec, struct kvm_lapic *apic)
>>>  {
>>>-	/* Note that we never get here with APIC virtualization enabled.  */
>>>+	struct kvm_vcpu *vcpu;
>>>+
>>>+	if (__apic_test_and_set_vector(vec, apic->regs + APIC_ISR))
>>>+		return;
>>>+
>>>+	vcpu = apic->vcpu;
>>>
>>>-	if (!__apic_test_and_set_vector(vec, apic->regs + APIC_ISR))
>>>-		++apic->isr_count;
>>>-	BUG_ON(apic->isr_count > MAX_APIC_VECTOR);
>>>  	/*
>>>-	 * ISR (in service register) bit is set when injecting an interrupt.
>>>-	 * The highest vector is injected. Thus the latest bit set matches
>>>-	 * the highest bit in ISR.
>>>+	 * With APIC virtualization enabled, all caching is disabled
>>>+	 * because the processor can modify ISR under the hood.  Instead
>>>+	 * just set SVI.
>>>  	 */
>>>-	apic->highest_isr_cache = vec;
>>>+	if (unlikely(kvm_apic_vid_enabled(vcpu->kvm)))
>>>+		kvm_x86_ops->hwapic_isr_update(vcpu->kvm, vec);
>>>+	else {
>>>+		++apic->isr_count;
>>>+		BUG_ON(apic->isr_count > MAX_APIC_VECTOR);
>>>+		/*
>>>+		 * ISR (in service register) bit is set when injecting an interrupt.
>>>+		 * The highest vector is injected. Thus the latest bit set matches
>>>+		 * the highest bit in ISR.
>>>+		 */
>>>+		apic->highest_isr_cache = vec;
>>>+	}
>>>  }
>>>
>>>  static inline int apic_find_highest_isr(struct kvm_lapic *apic)
>>>@@ -1627,11 +1648,16 @@ int kvm_get_apic_interrupt(struct kvm_vcpu *vcpu)
>>>  	int vector = kvm_apic_has_interrupt(vcpu);
>>>  	struct kvm_lapic *apic = vcpu->arch.apic;
>>>
>>>-	/* Note that we never get here with APIC virtualization enabled.  */
>>>-
>>>  	if (vector == -1)
>>>  		return -1;
>>>
>>>+	/*
>>>+	 * We get here even with APIC virtualization enabled, if doing
>>>+	 * nested virtualization and L1 runs with the "acknowledge interrupt
>>>+	 * on exit" mode.  Then we cannot inject the interrupt via RVI,
>>>+	 * because the process would deliver it through the IDT.
>>>+	 */
>>>+
>>>  	apic_set_isr(vector, apic);
>>>  	apic_update_ppr(apic);
>>>  	apic_clear_irr(vector, apic);
>>>
>>
>>Thanks, this looks good.  Felipe, can you test this patch together with
>>http://article.gmane.org/gmane.linux.kernel/1762356/raw please?
>>
>>Paolo
>>
>
>I checked that the bug was still there using the latest version of
>linus' kernel (8e099d1) and it is, then I applied the patches you
>indicated and the problem went away. So those 2 patches fix the
>problem for me.
>

Thanks for your verify. 

Regards,
Wanpeng Li 

>Best,
>--
>To unsubscribe from this list: send the line "unsubscribe kvm" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
