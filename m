Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753231Ab3FIJ3p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 05:29:45 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:62105 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931Ab3FIJ3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 05:29:43 -0400
Message-ID: <51B44B01.7050304@gmail.com>
Date: Sun, 09 Jun 2013 17:29:37 +0800
From: Xiao Guangrong <xiaoguangrong.eric@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86: fix missed memory synchronization when patch
 hypercall
References: <51B2A1D9.6060306@gmail.com> <20130609084526.GH4725@redhat.com>
In-Reply-To: <20130609084526.GH4725@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/09/2013 04:45 PM, Gleb Natapov wrote:

> +static int emulator_fix_hypercall(struct x86_emulate_ctxt *ctxt)
> +{
> +	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
> +	return kvm_exec_with_stopped_vcpu(vcpu->kvm,
> +			emulator_fix_hypercall_cb, ctxt);
> +}
> +
> +
>  /*
>   * Check if userspace requested an interrupt window, and that the
>   * interrupt window is open.
> @@ -5761,6 +5769,10 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  			kvm_deliver_pmi(vcpu);
>  		if (kvm_check_request(KVM_REQ_SCAN_IOAPIC, vcpu))
>  			vcpu_scan_ioapic(vcpu);
> +		if (kvm_check_request(KVM_REQ_STOP_VCPU, vcpu)){
> +			mutex_lock(&vcpu->kvm->lock);
> +			mutex_unlock(&vcpu->kvm->lock);

We should execute a serializing instruction here?

> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -222,6 +222,18 @@ void kvm_make_scan_ioapic_request(struct kvm *kvm)
>  	make_all_cpus_request(kvm, KVM_REQ_SCAN_IOAPIC);
>  }
> 
> +int kvm_exec_with_stopped_vcpu(struct kvm *kvm, int (*cb)(void *), void *data)
> +{
> +	int r;
> +
> +	mutex_lock(&kvm->lock);
> +	make_all_cpus_request(kvm, KVM_REQ_STOP_VCPU);
> +	r = cb(data);

And here?

