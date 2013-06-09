Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753680Ab3FIKTj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 06:19:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41930 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750853Ab3FIKTh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 06:19:37 -0400
Date: Sun, 9 Jun 2013 13:19:34 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Xiao Guangrong <xiaoguangrong.eric@gmail.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86: fix missed memory synchronization when patch
 hypercall
Message-ID: <20130609101934.GN4725@redhat.com>
References: <51B2A1D9.6060306@gmail.com>
 <20130609084526.GH4725@redhat.com>
 <51B44B01.7050304@gmail.com>
 <20130609093910.GL4725@redhat.com>
 <51B45289.6080704@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51B45289.6080704@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 09, 2013 at 06:01:45PM +0800, Xiao Guangrong wrote:
> On 06/09/2013 05:39 PM, Gleb Natapov wrote:
> > On Sun, Jun 09, 2013 at 05:29:37PM +0800, Xiao Guangrong wrote:
> >> On 06/09/2013 04:45 PM, Gleb Natapov wrote:
> >>
> >>> +static int emulator_fix_hypercall(struct x86_emulate_ctxt *ctxt)
> >>> +{
> >>> +	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
> >>> +	return kvm_exec_with_stopped_vcpu(vcpu->kvm,
> >>> +			emulator_fix_hypercall_cb, ctxt);
> >>> +}
> >>> +
> >>> +
> >>>  /*
> >>>   * Check if userspace requested an interrupt window, and that the
> >>>   * interrupt window is open.
> >>> @@ -5761,6 +5769,10 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
> >>>  			kvm_deliver_pmi(vcpu);
> >>>  		if (kvm_check_request(KVM_REQ_SCAN_IOAPIC, vcpu))
> >>>  			vcpu_scan_ioapic(vcpu);
> >>> +		if (kvm_check_request(KVM_REQ_STOP_VCPU, vcpu)){
> >>> +			mutex_lock(&vcpu->kvm->lock);
> >>> +			mutex_unlock(&vcpu->kvm->lock);
> >>
> >> We should execute a serializing instruction here?
> >>
> >>> --- a/virt/kvm/kvm_main.c
> >>> +++ b/virt/kvm/kvm_main.c
> >>> @@ -222,6 +222,18 @@ void kvm_make_scan_ioapic_request(struct kvm *kvm)
> >>>  	make_all_cpus_request(kvm, KVM_REQ_SCAN_IOAPIC);
> >>>  }
> >>>
> >>> +int kvm_exec_with_stopped_vcpu(struct kvm *kvm, int (*cb)(void *), void *data)
> >>> +{
> >>> +	int r;
> >>> +
> >>> +	mutex_lock(&kvm->lock);
> >>> +	make_all_cpus_request(kvm, KVM_REQ_STOP_VCPU);
> >>> +	r = cb(data);
> >>
> >> And here?
> > Since the serialisation instruction the SDM suggest to use is CPUID I
> > think the point here is to flush CPU pipeline. Since all vcpus are out
> > of a guest mode I think out of order execution of modified instruction
> > is no an issue here.
> 
> I checked the SDM that it did not said VMLAUNCH/VMRESUME are the
> serializing instructions both in VM-Entry description and Instruction
> reference, instead it said the VMX related serializing instructions are:
> INVEPT, INVVPID.
> 
> So, i guess the explicit serializing instruction is needed here.
> 
Again the question is what for? SDM says:

  The Intel 64 and IA-32 architectures define several serializing
  instructions. These instructions force the processor to complete all
  modifications to flags, registers, and memory by previous instructions
  and to drain all buffered writes to memory before the next instruction
  is fetched and executed.

So flags and registers modifications on a host are obviously irrelevant for a guest.
And for memory ordering we have smp_mb() on a guest entry.


--
			Gleb.
