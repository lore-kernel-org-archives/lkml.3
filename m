Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932674Ab3FRPWd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 11:22:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32729 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755961Ab3FRPWb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 11:22:31 -0400
Date: Tue, 18 Jun 2013 18:22:29 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86: fix missed memory synchronization when patch
 hypercall
Message-ID: <20130618152229.GB21032@redhat.com>
References: <20130609093910.GL4725@redhat.com>
 <51B45289.6080704@gmail.com>
 <20130609101934.GN4725@redhat.com>
 <51B4661D.8080807@gmail.com>
 <20130609113624.GQ4725@redhat.com>
 <51B46A83.4010008@gmail.com>
 <20130609115652.GR4725@redhat.com>
 <51B4724F.4000706@gmail.com>
 <20130609122727.GS4725@redhat.com>
 <51C06AEE.6050708@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51C06AEE.6050708@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 04:13:02PM +0200, Paolo Bonzini wrote:
> Il 09/06/2013 14:27, Gleb Natapov ha scritto:
> > On Sun, Jun 09, 2013 at 08:17:19PM +0800, Xiao Guangrong wrote:
> >> On 06/09/2013 07:56 PM, Gleb Natapov wrote:
> >>> On Sun, Jun 09, 2013 at 07:44:03PM +0800, Xiao Guangrong wrote:
> >>>> On 06/09/2013 07:36 PM, Gleb Natapov wrote:
> >>>>> On Sun, Jun 09, 2013 at 07:25:17PM +0800, Xiao Guangrong wrote:
> >>>>>> On 06/09/2013 06:19 PM, Gleb Natapov wrote:
> >>>>>>> On Sun, Jun 09, 2013 at 06:01:45PM +0800, Xiao Guangrong wrote:
> >>>>>>>> On 06/09/2013 05:39 PM, Gleb Natapov wrote:
> >>>>>>>>> On Sun, Jun 09, 2013 at 05:29:37PM +0800, Xiao Guangrong wrote:
> >>>>>>>>>> On 06/09/2013 04:45 PM, Gleb Natapov wrote:
> >>>>>>>>>>
> >>>>>>>>>>> +static int emulator_fix_hypercall(struct x86_emulate_ctxt *ctxt)
> >>>>>>>>>>> +{
> >>>>>>>>>>> +	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
> >>>>>>>>>>> +	return kvm_exec_with_stopped_vcpu(vcpu->kvm,
> >>>>>>>>>>> +			emulator_fix_hypercall_cb, ctxt);
> >>>>>>>>>>> +}
> >>>>>>>>>>> +
> >>>>>>>>>>> +
> >>>>>>>>>>>  /*
> >>>>>>>>>>>   * Check if userspace requested an interrupt window, and that the
> >>>>>>>>>>>   * interrupt window is open.
> >>>>>>>>>>> @@ -5761,6 +5769,10 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
> >>>>>>>>>>>  			kvm_deliver_pmi(vcpu);
> >>>>>>>>>>>  		if (kvm_check_request(KVM_REQ_SCAN_IOAPIC, vcpu))
> >>>>>>>>>>>  			vcpu_scan_ioapic(vcpu);
> >>>>>>>>>>> +		if (kvm_check_request(KVM_REQ_STOP_VCPU, vcpu)){
> >>>>>>>>>>> +			mutex_lock(&vcpu->kvm->lock);
> >>>>>>>>>>> +			mutex_unlock(&vcpu->kvm->lock);
> >>>>>>>>>>
> >>>>>>>>>> We should execute a serializing instruction here?
> >>>>>>>>>>
> >>>>>>>>>>> --- a/virt/kvm/kvm_main.c
> >>>>>>>>>>> +++ b/virt/kvm/kvm_main.c
> >>>>>>>>>>> @@ -222,6 +222,18 @@ void kvm_make_scan_ioapic_request(struct kvm *kvm)
> >>>>>>>>>>>  	make_all_cpus_request(kvm, KVM_REQ_SCAN_IOAPIC);
> >>>>>>>>>>>  }
> >>>>>>>>>>>
> >>>>>>>>>>> +int kvm_exec_with_stopped_vcpu(struct kvm *kvm, int (*cb)(void *), void *data)
> >>>>>>>>>>> +{
> >>>>>>>>>>> +	int r;
> >>>>>>>>>>> +
> >>>>>>>>>>> +	mutex_lock(&kvm->lock);
> >>>>>>>>>>> +	make_all_cpus_request(kvm, KVM_REQ_STOP_VCPU);
> >>>>>>>>>>> +	r = cb(data);
> >>>>>>>>>>
> >>>>>>>>>> And here?
> >>>>>>>>> Since the serialisation instruction the SDM suggest to use is CPUID I
> >>>>>>>>> think the point here is to flush CPU pipeline. Since all vcpus are out
> >>>>>>>>> of a guest mode I think out of order execution of modified instruction
> >>>>>>>>> is no an issue here.
> >>>>>>>>
> >>>>>>>> I checked the SDM that it did not said VMLAUNCH/VMRESUME are the
> >>>>>>>> serializing instructions both in VM-Entry description and Instruction
> >>>>>>>> reference, instead it said the VMX related serializing instructions are:
> >>>>>>>> INVEPT, INVVPID.
> >>>>>>>>
> >>>>>>>> So, i guess the explicit serializing instruction is needed here.
> >>>>>>>>
> >>>>>>> Again the question is what for? SDM says:
> >>>>>>>
> >>>>>>>   The Intel 64 and IA-32 architectures define several serializing
> >>>>>>>   instructions. These instructions force the processor to complete all
> >>>>>>>   modifications to flags, registers, and memory by previous instructions
> >>>>>>>   and to drain all buffered writes to memory before the next instruction
> >>>>>>>   is fetched and executed.
> >>>>>>>
> >>>>>>> So flags and registers modifications on a host are obviously irrelevant for a guest.
> >>>>>>
> >>>>>> Okay. Hmm... but what can guarantee that "drain all buffered writes to memory"?
> >>>>> Memory barrier should guaranty that as I said bellow.
> >>>>>
> >>>>>>
> >>>>>>> And for memory ordering we have smp_mb() on a guest entry.
> >>>>>>
> >>>>>> If i understand the SDM correctly, memory-ordering instructions can not drain
> >>>>>> instruction buffer, it only drains "data memory subsystem":
> >>>>> What is "instruction buffer"?
> >>>>
> >>>> I mean "Instruction Cache" (icache). Can memory ordering drain icache?
> >>>> The "data memory subsystem" confused me, does it mean dcache?
> >>>>
> >>> I think it means all caches.
> >>> 11.6 says:
> >>>
> >>>   A write to a memory location in a code segment that is currently
> >>>   cached in the processor causes the associated cache line (or lines)
> >>>   to be invalidated. This check is based on the physical address of
> >>>   the instruction. In addition, the P6 family and Pentium processors
> >>>   check whether a write to a code segment may modify an instruction that
> >>>   has been prefetched for execution. If the write affects a prefetched
> >>>   instruction, the prefetch queue is invalidated. This latter check is
> >>>   based on the linear address of the instruction. For the Pentium 4 and
> >>>   Intel Xeon processors, a write or a snoop of an instruction in a code
> >>>   segment, where the target instruction is already decoded and resident in
> >>>   the trace cache, invalidates the entire trace cache. The latter behavior
> >>>   means that programs that self-modify code can cause severe degradation
> >>>   of performance when run on the Pentium 4 and Intel Xeon processors.
> >>>
> >>> So icache line is invalidate based on physical address so we are OK.
> >>
> >> Yes.
> >>
> >>> Prefetched instruction is invalidated based on linear address, but if
> >>> all vcpus are in a host guest instruction cannot be prefetched.
> >>
> >> But what happen if the instruction has been prefetched before vcpu exits
> >> to host? Then, after returns to guest, it executes the old instruction.
> >>
> >> Can it happen?
> > I do not thing so, prefetched instructions is not a cache, but I'll ask
> > Intel.
> 
> Any news?
> 
Not yet.

> Anyway, if this were the case (which seems strange, but you never know),
> CPUID would not help.  The hypothetical guest prefetch queue would not
> be flushed, and you'd need INVEPT/INVVPID as Xiao mentioned upthread.
Do not see why INVEPT/INVVPID is relevant. There is no issue with TLB
here.

--
			Gleb.
