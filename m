Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755883AbaCLRUL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 13:20:11 -0400
Received: from mail-ea0-f182.google.com ([209.85.215.182]:52797 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754442AbaCLRUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 13:20:06 -0400
Message-ID: <53209741.3060204@redhat.com>
Date: Wed, 12 Mar 2014 18:20:01 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, gleb@kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] KVM: SVM: fix cr8 intercept window
References: <1394561478-8815-1-git-send-email-rkrcmar@redhat.com> <20140312010513.GA8131@amt.cnet> <20140312104047.GA7488@potion.brq.redhat.com>
In-Reply-To: <20140312104047.GA7488@potion.brq.redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 12/03/2014 11:40, Radim Krčmář ha scritto:
> 2014-03-11 22:05-0300, Marcelo Tosatti:
>> On Tue, Mar 11, 2014 at 07:11:18PM +0100, Radim Krčmář wrote:
>>> We always disable cr8 intercept in its handler, but only re-enable it
>>> if handling KVM_REQ_EVENT, so there can be a window where we do not
>>> intercept cr8 writes, which allows an interrupt to disrupt a higher
>>> priority task.
>>>
>>> Fix this by disabling intercepts in the same function that re-enables
>>> them when needed. This fixes BSOD in Windows 2008.
>>>
>>> Cc: <stable@vger.kernel.org>
>>> Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
>>> ---
>>>  arch/x86/kvm/svm.c | 6 +++---
>>>  1 file changed, 3 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
>>> index 64d9bb9..f676c18 100644
>>> --- a/arch/x86/kvm/svm.c
>>> +++ b/arch/x86/kvm/svm.c
>>> @@ -3003,10 +3003,8 @@ static int cr8_write_interception(struct vcpu_svm *svm)
>>>  	u8 cr8_prev = kvm_get_cr8(&svm->vcpu);
>>>  	/* instruction emulation calls kvm_set_cr8() */
>>>  	r = cr_interception(svm);
>>> -	if (irqchip_in_kernel(svm->vcpu.kvm)) {
>>> -		clr_cr_intercept(svm, INTERCEPT_CR8_WRITE);
>>> +	if (irqchip_in_kernel(svm->vcpu.kvm))
>>>  		return r;
>>> -	}

I think that the old code here makes little sense, and for two reasons:

1) There are other ways to change the TPR, and the condition for 
setting/clearing the CR8 intercept should be the same for all of them. 
Now CR8 is the really optimized one, but there is no reason to treat 
them differently and it just complicates understanding the code.

So it is a good thing that your patch moves the clearing of the CR8 
write intercept in a generic place (the setting of the intercept is 
already generic).  Doesn't say much about the correctness of the patch; 
it would be just an optimization.  But at least the old code is the 
"smelly" one.


2) Unconditionally disabling the CR8 intercept is definitely wrong. 
What matters is the change in the PPR; if the processor priority is the 
same as before, or higher, absolutely nothing has changed from the point 
of view of interrupt delivery; if we had an interrupt in the IRR, 
waiting to be delivered, we still have it, and we should keep the CR8 
intercept enabled.

Your patch does the right thing by virtue of apic_update_ppr setting 
KVM_REQ_EVENT (which ultimately calls update_cr8_intercept) exactly if 
the PPR has been lowered.  The call chain is 
kvm_set_cr8->kvm_lapic_set_tpr->apic_set_tpr->apic_update_ppr.

At the end of this email I'll show an example of why this actually is 
relatively common on Windows guests.


So, IMO there is no doubt that the change is semantically correct.  The 
next question then is whether it undoes the V_TPR optimization.  You can 
prove it by a sort of induction; consider a sequences of events that 
start and end with the same IRR, assume CR8 is not intercepted at the 
beginning, and prove that CR8 is still not intercepted afterwards.

We can assume that all changes to the TPR are balanced and properly 
nested (except you can go low->med->high->low).


The simple sequences are:

1) changes in TPR with no interrupts in the middle; remember that 
Windows doesn't really ever disable/enable preemption or interrupt flags 
like Linux does.  It only modifies the TPR ("raise/lower the IRQL", they 
call it).  We're assuming that the CR8 intercept is initially disabled, 
so a raised-IRQL section of the code that doesn't cause other vmexits 
will obviously run at full speed.  Not much to see here.

2) delivery of an unmasked interrupt (with priority P) and subsequent 
EOI.  Changes to TPR don't really matter until EOI, because they are 
always to priority >= P and they are balanced.  So we ignore them.

To summarize: an interrupt with priority P is going to be delivered, the 
VCPU is running at TPR <= P, interrupts are allowed, and the CR8 
intercept is disabled.

The interrupt is injected via apic_set_irr/kvm_make_request, and this 
causes a call to update_cr8_intercept.  If TPR < P, the intercept will 
remain disabled.  When the EOI is sent, we get another event and another 
call to update_cr8_intercept; again, the intercept stays cleared because 
IRR == -1.

If TPR == P, the intercept is set while the interrupt handler runs, but 
it is still disabled at the end of the interrupt.  Looks like another 
bugfix; before your patch, it would remain enabled, which is useless. 
The TPR == P case is actually interesting for Windows, more below.


The complicated sequences are:

3) a change in the TPR, where an interrupt is masked while the 
high-priority task runs.  The interrupt is what will cause the intercept 
to be set.  As soon as the TPR is restored, the interrupt will be 
delivered and the intercept cleared (TPR < IRR).  We fall back to case 2 
above.

4) interrupts that are received while interrupts are not allowed.  Here 
KVM does not inject the interrupt; it requests the interrupt window and 
clears the intercept.  Clearing the intercept is okay, because no 
interrupt can be delivered anyway and TPR changes are moot until the 
interrupt window opens.  Once it opens, sync_cr8_to_lapic will call 
kvm_set_cr8 and interrupt_window_interception will set KVM_REQ_EVENT. 
Any intervening change to the TPR is handled fine: if it got high again, 
update_cr8_intercept will set the CR8 intercept and the "loop" restarts; 
if it is still low, inject_pending_event will queue the interrupt as in 
case 3.


With all these covered, is the base case true?  That is, will the CR8 
intercept _ever_ be disabled?  Yes :) because kvm_vcpu_reset sets 
KVM_REQ_EVENT and this calls update_cr8_intercept.

Do you agree with the above analysis?  If so, let's look how it can be 
used to reply to Marcelo's question.

>> Shouldnt IRR be injected if TPR < IRR ? (via KVM_REQ_EVENT).

This is "the complicated case" above.  Say initially TPR = 15.

>> 1) IRR has interrupt 10.

Interrupt 10 is received and the CR8 intercept is set.  Because PPR = 
15, the interrupt is not yet in the ISR, only in the IRR.

>> 2) TPR now 9 due to CR8 write.

When the TPR becomes 9, the PPR is lowered to 9 too, thus 
apic_update_ppr sets KVM_REQ_EVENT.

>> 3) 10 should be injected.

Event processing calls inject_pending_event, which either queues the 
interrupt or requests the interrupt window.  In my writing above, this 
corresponds to cases 3 and 4 respectively.

As usual, correct me if I'm wrong.

>> Also not clearing the intercept can cause continuous CR8 writes to
>> exit until KVM_REQ_EVENT ?
>
> It is intended, I suppose this is because we run with V_INTR_MASKING, so
> writes to CR8 only affect V_TPR register; guest then raises it once more
> and APIC incorrectly gives us low priority interrupt.

Yes, but the extra exits should not be a problem.

Let's see what could happen with Windows.  Windows uses "deferred 
procedure calls" (also known as DPCs; basically they're non-preemptible 
"bottom halves") extensively.  Almost all ISRs will do the bulk of the 
work in a DPC, including the timer interrupt.  DPC processing is 
requested with a priority-2 IPI, hence Windows raises the TPR to 2 in 
order to disable preemption.

This is the gory detail of why, as mentioned above, Windows writes to 
CR8 in order to disable preemption.  Since spinlocks are not 
preemptible, taking a spinlock does the same.  In both cases the old CR8 
value is saved and then restored (when exiting the non-preemptible 
section, or when releasing the spinlock).

So, if you have N nested spinlocks and a timer interrupt fires, you will 
have up to 2N-1 CR8 write exits.  Example with 2 nested spinlocks:

                                      IRR    TPR   PPR    intercept
initial                              {}     0     0      disabled
take spinlock #1                     {}     2     2      disabled
 >>> timer interrupt injected         {13}   2     13     disabled
 >>> timer ISR schedules DPCs         {2,13} 2     13     disabled
 >>> timer interrupt EOI              {2}    2     2      enabled
take spinlock #2 (vmexit!)           {2}    2     2      enabled
release spinlock #2 (vmexit!)        {2}    2     2      enabled
release spinlock #1 (vmexit!)        {2}    0     0      enabled
 >>> DPC interrupt injected           {2}    0     2      disabled
 >>> set CR8 = 2                      {2}    2     2      enabled
 >>> DPC interrupt EOI                {}     2     2      disabled
 >>> DPC queue processed              {}     2     2      disabled
 >>> set CR8 = 0                      {}     0     0      disabled

Here N=2 so you have 3 extra vmexits.  Note that:

* line "take spinlock #2" writes 2 to CR8, but is really a no-op.  But 
without this patch, the CR8 intercept would have been disabled!

* line "release spinlock #1" writes 0 to CR8.  Without this patch, the 
PPR would not have been updated.  The DPC interrupt would have been delayed.

* line "DPC interrupt EOI" is the other bugfix/optimization I mentioned 
above for TPR==P.  Without this patch, the CR8 interrupt would have 
stayed enabled, and KVM would have taken an exit when setting CR8 to 0.

So in this scenario with N nested spinlocks there will be indeed 2N-2 
more exits than before.

Windows has an extra pair of lock/unlock primitives that do not touch 
CR8, that you can use when you know you'r already at TPR=2, so we can 
expect the common case to be N=1.  And N=1 adds up to 0 extra vmexits.


I'm applying the patch to kvm/next.

As a follow up, I would consider the following changes:

1) stop calling update_cr8_intercept directly.  There is a call in 
kvm_vcpu_ioctl_set_lapic, which is useless because 
kvm_apic_post_state_restore sets KVM_REQ_EVENT.  Another in 
kvm_arch_vcpu_ioctl_set_sregs, which is how userspace modifies CR8. 
Also useless, because the function calls kvm_set_cr8 and ultimately 
apic_update_ppr.

2) stop setting the CR8_WRITE intercept in init_vmcb (called by 
svm_vcpu_reset, called by kvm_vcpu_reset), since it's always undone 
immediately afterwards by the processing of KVM_REQ_EVENT.

Paolo
