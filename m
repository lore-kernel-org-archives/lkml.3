Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752467Ab3GNNZN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jul 2013 09:25:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3875 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752246Ab3GNNZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jul 2013 09:25:10 -0400
Date: Sun, 14 Jul 2013 16:24:02 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: mingo@redhat.com, jeremy@goop.org, x86@kernel.org, konrad.wilk@oracle.com,
        hpa@zytor.com, pbonzini@redhat.com, linux-doc@vger.kernel.org,
        habanero@linux.vnet.ibm.com, xen-devel@lists.xensource.com,
        peterz@infradead.org, mtosatti@redhat.com,
        stefano.stabellini@eu.citrix.com, andi@firstfloor.org,
        attilio.rao@citrix.com, ouyang@cs.pitt.edu, gregkh@suse.de,
        agraf@suse.de, chegu_vinod@hp.com, torvalds@linux-foundation.org,
        avi.kivity@gmail.com, tglx@linutronix.de, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, stephan.diestelhorst@amd.com,
        riel@redhat.com, drjones@redhat.com,
        virtualization@lists.linux-foundation.org,
        srivatsa.vaddagiri@gmail.com
Subject: Re: [PATCH RFC V10 16/18] kvm hypervisor : Simplify
 kvm_for_each_vcpu with kvm_irq_delivery_to_apic
Message-ID: <20130714132402.GB11772@redhat.com>
References: <20130624124014.27508.8906.sendpatchset@codeblue.in.ibm.com>
 <20130624124353.27508.94224.sendpatchset@codeblue.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130624124353.27508.94224.sendpatchset@codeblue.in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 24, 2013 at 06:13:53PM +0530, Raghavendra K T wrote:
> Simplify kvm_for_each_vcpu with kvm_irq_delivery_to_apic
> 
> From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
> 
> Note that we are using APIC_DM_REMRD which has reserved usage.
> In future if APIC_DM_REMRD usage is standardized, then we should
> find some other way or go back to old method.
> 
> Suggested-by: Gleb Natapov <gleb@redhat.com>
> Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
> ---
>  arch/x86/kvm/lapic.c |    5 ++++-
>  arch/x86/kvm/x86.c   |   25 ++++++-------------------
>  2 files changed, 10 insertions(+), 20 deletions(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index e1adbb4..3f5f82e 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -706,7 +706,10 @@ out:
>  		break;
>  
>  	case APIC_DM_REMRD:
> -		apic_debug("Ignoring delivery mode 3\n");
> +		result = 1;
> +		vcpu->arch.pv.pv_unhalted = 1;
> +		kvm_make_request(KVM_REQ_EVENT, vcpu);
> +		kvm_vcpu_kick(vcpu);
>  		break;
>  
>  	case APIC_DM_SMI:
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 92a9932..b963c86 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5456,27 +5456,14 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
>   */
>  static void kvm_pv_kick_cpu_op(struct kvm *kvm, int apicid)
>  {
> -	struct kvm_vcpu *vcpu = NULL;
> -	int i;
> +	struct kvm_lapic_irq lapic_irq;
>  
> -	kvm_for_each_vcpu(i, vcpu, kvm) {
> -		if (!kvm_apic_present(vcpu))
> -			continue;
> +	lapic_irq.shorthand = 0;
> +	lapic_irq.dest_mode = 0;
> +	lapic_irq.dest_id = apicid;
>  
> -		if (kvm_apic_match_dest(vcpu, 0, 0, apicid, 0))
> -			break;
> -	}
> -	if (vcpu) {
> -		/*
> -		 * Setting unhalt flag here can result in spurious runnable
> -		 * state when unhalt reset does not happen in vcpu_block.
> -		 * But that is harmless since that should soon result in halt.
> -		 */
> -		vcpu->arch.pv.pv_unhalted = true;
> -		/* We need everybody see unhalt before vcpu unblocks */
> -		smp_wmb();
> -		kvm_vcpu_kick(vcpu);
> -	}
> +	lapic_irq.delivery_mode = APIC_DM_REMRD;
Need to make sure that delivery_mode cannot be set to APIC_DM_REMRD
from MSI/IOAPIC/IPI path.

> +	kvm_irq_delivery_to_apic(kvm, 0, &lapic_irq, NULL);
>  }
>  
>  int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)

--
			Gleb.
