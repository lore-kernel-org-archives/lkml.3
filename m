Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753165Ab3GJISV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 04:18:21 -0400
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:57626 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659Ab3GJISR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 04:18:17 -0400
Message-ID: <51DD18BD.9090201@de.ibm.com>
Date: Wed, 10 Jul 2013 10:18:05 +0200
From: Christian Borntraeger <borntraeger@de.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Dominik Dingel <dingel@linux.vnet.ibm.com>
CC: Gleb Natapov <gleb@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Cornelia Huck <cornelia.huck@de.ibm.com>,
        Xiantao Zhang <xiantao.zhang@intel.com>,
        Alexander Graf <agraf@suse.de>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Ralf Baechle <ralf@linux-mips.org>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] PF: Async page fault support on s390
References: <1373378207-10451-1-git-send-email-dingel@linux.vnet.ibm.com> <1373378207-10451-5-git-send-email-dingel@linux.vnet.ibm.com>
In-Reply-To: <1373378207-10451-5-git-send-email-dingel@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071008-8372-0000-0000-0000068925E6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/07/13 15:56, Dominik Dingel wrote:
> This patch enables async page faults for s390 kvm guests.
> It provides the userspace API to enable, disable or get the status of this
> feature. Also it includes the diagnose code, called by the guest to enable
> async page faults.
> 
> The async page faults will use an already existing guest interface for this
> purpose, as described in "CP Programming Services (SC24-6084)".
> 
> Signed-off-by: Dominik Dingel <dingel@linux.vnet.ibm.com>

Re-reading this patch again, found some thing that you should take 
care of (nothing major, just small details). Sorry for not seeing them
earlier.

[...]
> +	case 1: /* CANCEL */
> +		if (vcpu->run->s.regs.gprs[rx] & 7)
> +			return kvm_s390_inject_program_int(vcpu, PGM_ADDRESSING);
> +
> +		vcpu->run->s.regs.gprs[ry] = 0;
> +
> +		if (vcpu->arch.pfault_token == KVM_S390_PFAULT_TOKEN_INVALID)
> +			vcpu->run->s.regs.gprs[ry] = 1;
> +
> +		vcpu->arch.pfault_token = KVM_S390_PFAULT_TOKEN_INVALID;
> +		rc = 0;
> +		break;

Dont we need a kvm_clear_async_pf_completion_queue(vcpu) or similar here as well?
The cancel function is supposed to purge all outstanding requests (those were no 
completion signal was made pending yet)

[...]
> @@ -264,6 +292,7 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
>  {
>  	VCPU_EVENT(vcpu, 3, "%s", "free cpu");
>  	trace_kvm_s390_destroy_vcpu(vcpu->vcpu_id);
> +	kvm_clear_async_pf_completion_queue(vcpu);
>  	if (!kvm_is_ucontrol(vcpu->kvm)) {
>  		clear_bit(63 - vcpu->vcpu_id,
>  			  (unsigned long *) &vcpu->kvm->arch.sca->mcn);
> @@ -313,6 +342,9 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
>  /* Section: vcpu related */
>  int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
>  {
> +	vcpu->arch.pfault_token = KVM_S390_PFAULT_TOKEN_INVALID;
> +	kvm_clear_async_pf_completion_queue(vcpu);
> +	kvm_async_pf_wakeup_all(vcpu);
>  	if (kvm_is_ucontrol(vcpu->kvm)) {
>  		vcpu->arch.gmap = gmap_alloc(current->mm);
>  		if (!vcpu->arch.gmap)

We should also reset pfault handling for CPU reset, no?

> @@ -691,10 +723,75 @@ static void kvm_arch_fault_in_sync(struct kvm_vcpu *vcpu)
>  	up_read(&mm->mmap_sem);
>  }
> 
> +static void __kvm_inject_pfault_token(struct kvm_vcpu *vcpu, bool start_token,
> +				      unsigned long token)
> +{
> +	struct kvm_s390_interrupt inti;
> +	inti.type = start_token ? KVM_S390_INT_PFAULT_INIT :
> +				  KVM_S390_INT_PFAULT_DONE;
> +	inti.parm64 = token;
> +	if (kvm_s390_inject_vcpu(vcpu, &inti))
> +		WARN(1, "pfault interrupt injection failed");
> +}

The PFAULT_DONE is architectured as a floating interrupt (can happen
on other CPUs).

[...]
> --- a/arch/s390/kvm/sigp.c
> +++ b/arch/s390/kvm/sigp.c
> @@ -187,6 +187,8 @@ static int __sigp_set_arch(struct kvm_vcpu *vcpu, u32 parameter)
>  {
>  	int rc;
> 
> +	vcpu->arch.pfault_token = KVM_S390_PFAULT_TOKEN_INVALID;
> +

sigp set architecture affects all cpus, so we must reset pfault via
kvm_for_each_vcpu, I guess.

Otherwise patch looks good. I guess only one more iteration
Christian



