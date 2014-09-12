Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755082AbaILNsX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 09:48:23 -0400
Received: from mail-qg0-f43.google.com ([209.85.192.43]:49200 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753972AbaILNsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 09:48:21 -0400
Message-ID: <5412F99A.30608@redhat.com>
Date: Fri, 12 Sep 2014 15:48:10 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: guohliu <liuguohui@gmail.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: Refactor making request to makes it meaningful
References: <1410500599-12114-1-git-send-email-liuguohui@gmail.com>
In-Reply-To: <1410500599-12114-1-git-send-email-liuguohui@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 12/09/2014 07:43, guohliu ha scritto:
> This patch replace the set_bit method by kvm_make_request
> to makes it more readable and consistency.
> 
> Signed-off-by: Guo Hui Liu <liuguohui@gmail.com>
> ---
>  arch/x86/kvm/x86.c | 15 +++++++--------
>  1 file changed, 7 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 916e895..5fed2de 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1518,7 +1518,7 @@ static void kvm_gen_update_masterclock(struct kvm *kvm)
>  	pvclock_update_vm_gtod_copy(kvm);
>  
>  	kvm_for_each_vcpu(i, vcpu, kvm)
> -		set_bit(KVM_REQ_CLOCK_UPDATE, &vcpu->requests);
> +		kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
>  
>  	/* guest entries allowed */
>  	kvm_for_each_vcpu(i, vcpu, kvm)
> @@ -1661,7 +1661,7 @@ static void kvmclock_update_fn(struct work_struct *work)
>  	struct kvm_vcpu *vcpu;
>  
>  	kvm_for_each_vcpu(i, vcpu, kvm) {
> -		set_bit(KVM_REQ_CLOCK_UPDATE, &vcpu->requests);
> +		kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
>  		kvm_vcpu_kick(vcpu);
>  	}
>  }
> @@ -1670,7 +1670,7 @@ static void kvm_gen_kvmclock_update(struct kvm_vcpu *v)
>  {
>  	struct kvm *kvm = v->kvm;
>  
> -	set_bit(KVM_REQ_CLOCK_UPDATE, &v->requests);
> +	kvm_make_request(KVM_REQ_CLOCK_UPDATE, v);
>  	schedule_delayed_work(&kvm->arch.kvmclock_update_work,
>  					KVMCLOCK_UPDATE_DELAY);
>  }
> @@ -2846,7 +2846,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>  	if (unlikely(vcpu->arch.tsc_offset_adjustment)) {
>  		adjust_tsc_offset_host(vcpu, vcpu->arch.tsc_offset_adjustment);
>  		vcpu->arch.tsc_offset_adjustment = 0;
> -		set_bit(KVM_REQ_CLOCK_UPDATE, &vcpu->requests);
> +		kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
>  	}
>  
>  	if (unlikely(vcpu->cpu != cpu) || check_tsc_unstable()) {
> @@ -5600,7 +5600,7 @@ static void pvclock_gtod_update_fn(struct work_struct *work)
>  	spin_lock(&kvm_lock);
>  	list_for_each_entry(kvm, &vm_list, vm_list)
>  		kvm_for_each_vcpu(i, vcpu, kvm)
> -			set_bit(KVM_REQ_MASTERCLOCK_UPDATE, &vcpu->requests);
> +			kvm_make_request(KVM_REQ_MASTERCLOCK_UPDATE, vcpu);
>  	atomic_set(&kvm_guest_has_master_clock, 0);
>  	spin_unlock(&kvm_lock);
>  }
> @@ -6978,7 +6978,7 @@ int kvm_arch_hardware_enable(void)
>  	list_for_each_entry(kvm, &vm_list, vm_list) {
>  		kvm_for_each_vcpu(i, vcpu, kvm) {
>  			if (!stable && vcpu->cpu == smp_processor_id())
> -				set_bit(KVM_REQ_CLOCK_UPDATE, &vcpu->requests);
> +				kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
>  			if (stable && vcpu->arch.last_host_tsc > local_tsc) {
>  				backwards_tsc = true;
>  				if (vcpu->arch.last_host_tsc > max_tsc)
> @@ -7032,8 +7032,7 @@ int kvm_arch_hardware_enable(void)
>  			kvm_for_each_vcpu(i, vcpu, kvm) {
>  				vcpu->arch.tsc_offset_adjustment += delta_cyc;
>  				vcpu->arch.last_host_tsc = local_tsc;
> -				set_bit(KVM_REQ_MASTERCLOCK_UPDATE,
> -					&vcpu->requests);
> +				kvm_make_request(KVM_REQ_MASTERCLOCK_UPDATE, vcpu);
>  			}
>  
>  			/*
> 

Thanks, applied to kvm/queue.

Paolo
