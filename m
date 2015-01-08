Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756634AbbAHMPv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 07:15:51 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:63090 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579AbbAHMPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 07:15:49 -0500
Message-ID: <54AE74F2.7050700@gmail.com>
Date: Thu, 08 Jan 2015 07:15:46 -0500
From: Andrej Manduch <amanduch@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>, Nicholas Krause <xerofoify@gmail.com>,
        gleb@kernel.org
CC: x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] arch:x86:kvm:Add function for setting pending timer
 on virtual cpu in x86.c
References: <1420167918-2190-1-git-send-email-xerofoify@gmail.com> <54AE709B.2040605@redhat.com>
In-Reply-To: <54AE709B.2040605@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On 01/08/2015 06:57 AM, Paolo Bonzini wrote:
> 
> 
> On 02/01/2015 04:05, Nicholas Krause wrote:
>> Adds the function kvm_vcpu_set_pending_timer for setting a pending timer on a virtual cpu for x86 systems.  This
>> function calls kvm_make_request internally as moved over from lapic.c with the arugments of the virtual cpu passed
>> to the function kvm_vcpu_set_pending_timer and the flag of KVM_REQ_PENDING_TIMER for requesting a pending timer
>> to kvm. In additon we added a function prototype definition as to allow this function to be used by any files that
>> include the header file,x86.h and need to set the pending timer on a virtual cpu supported by kvm.
>> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
>> ---
>>  arch/x86/kvm/lapic.c | 3 +--
>>  arch/x86/kvm/x86.c   | 3 +++
>>  arch/x86/kvm/x86.h   | 1 +
>>  3 files changed, 5 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
>> index 4f0c0b9..6d69b49 100644
>> --- a/arch/x86/kvm/lapic.c
>> +++ b/arch/x86/kvm/lapic.c
>> @@ -1082,8 +1082,7 @@ static void apic_timer_expired(struct kvm_lapic *apic)
>>  		return;
>>  
>>  	atomic_inc(&apic->lapic_timer.pending);
>> -	/* FIXME: this code should not know anything about vcpus */
I don't want to sounds like I'm nitpicking. But I need to ask. Why is
this comment removed?

>> -	kvm_make_request(KVM_REQ_PENDING_TIMER, vcpu);
>> +	kvm_set_pending_timer(vcpu);
>>  
>>  	if (waitqueue_active(q))
>>  		wake_up_interruptible(q);
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index c259814..7f8d048 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -1083,6 +1083,9 @@ static void update_pvclock_gtod(struct timekeeper *tk)
> 
> The patch didn't apply as is because the ",9" should have been ",10".
> 
> Fixed up and applied.
> 
> Paolo
> 
>>  }
>>  #endif
>>  
>> +void kvm_set_pending_timer(struct kvm_vcpu *vcpu)
>> +{
>> +	kvm_make_request(KVM_REQ_PENDING_TIMER, vcpu);
>> +}
>>  
>>  static void kvm_write_wall_clock(struct kvm *kvm, gpa_t wall_clock)
>>  {
>> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
>> index cc1d61a..4b7a819 100644
>> --- a/arch/x86/kvm/x86.h
>> +++ b/arch/x86/kvm/x86.h
>> @@ -147,6 +147,7 @@ static inline void kvm_register_writel(struct kvm_vcpu *vcpu,
>>  
>>  void kvm_before_handle_nmi(struct kvm_vcpu *vcpu);
>>  void kvm_after_handle_nmi(struct kvm_vcpu *vcpu);
>> +void kvm_set_pending_timer(struct kvm_vcpu *vcpu);
>>  int kvm_inject_realmode_interrupt(struct kvm_vcpu *vcpu, int irq, int inc_eip);
>>  
>>  void kvm_write_tsc(struct kvm_vcpu *vcpu, struct msr_data *msr);
>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Kind regards,
b.
