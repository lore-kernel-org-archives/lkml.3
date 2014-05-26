Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839AbaEZPkT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 11:40:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12212 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752190AbaEZPkR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 11:40:17 -0400
Date: Mon, 26 May 2014 18:39:09 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, yang.z.zhang@intel.com, mtosatti@redhat.com,
        stable@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: lapic: sync highest ISR to hardware apic on EOI
Message-ID: <20140526153909.GA27903@redhat.com>
References: <1400856713-18628-1-git-send-email-pbonzini@redhat.com>
 <20140526142848.GA27553@redhat.com>
 <53835636.5050801@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53835636.5050801@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 26, 2014 at 04:56:54PM +0200, Paolo Bonzini wrote:
> Il 26/05/2014 16:28, Michael S. Tsirkin ha scritto:
> >> static inline void apic_clear_isr(int vec, struct kvm_lapic *apic)
> >> {
> >>-	if (__apic_test_and_clear_vector(vec, apic->regs + APIC_ISR))
> >>+	struct kvm_vcpu *vcpu;
> >>+	if (!__apic_test_and_clear_vector(vec, apic->regs + APIC_ISR))
> >>+		return;
> >>+
> >>+	vcpu = apic->vcpu;
> >>+
> >>+	/*
> >>+	 * We do get here for APIC virtualization enabled if the guest
> >>+	 * uses the Hyper-V APIC enlightenment.  In this case we may need
> >>+	 * to trigger a new interrupt delivery by writing the SVI field;
> >>+	 * on the other hand isr_count and highest_isr_cache are unused
> >>+	 * and must be left alone.
> >>+	 */
> >>+	if (unlikely(kvm_apic_vid_enabled(vcpu->kvm)))
> >>+		kvm_x86_ops->hwapic_isr_update(vcpu->kvm,
> >>+					       apic_find_highest_isr(apic));
> >
> >I note that an indirect call on data path is mostly unnecessary here:
> >	static int vmx_vm_has_apicv(struct kvm *kvm)
> >	{
> >		return enable_apicv && irqchip_in_kernel(kvm);
> >	}
> >is all it does, and irqchip_in_kernel also has an rmb within it, which
> >is somewhat expensive on x86: and there's no way to reach this code
> >with irqchip disabled, correct?
> 
> smp_rmb is just a compiler barrier, it's not expensive.  The indirect call
> is probably more expensive.
> 
> That said, other places in the paths (kvm_cpu_has_injectable_intr,
> kvm_cpu_get_interrupt) already call kvm_apic_vid_enabled, so this patch
> doesn't introduce something new.
> 
> >How about adding a bool flag in kvm_vcpu_arch, and testing that?
> 
> Yes, that's possible.  It's also possible to test
> kvm_x86_ops->hwapic_isr_update != NULL and zero the field in vmx.c's
> hardware_setup.
> Can you make a patch?
> 
> Paolo

On top of this one? Sure.

-- 
MST
