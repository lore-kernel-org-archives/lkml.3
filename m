Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932506Ab3GOPct (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 11:32:49 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:60965 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757887Ab3GOPcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 11:32:47 -0400
Message-ID: <51E416ED.3090604@linux.vnet.ibm.com>
Date: Mon, 15 Jul 2013 21:06:13 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: mingo@redhat.com, jeremy@goop.org, x86@kernel.org, konrad.wilk@oracle.com,
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
Subject: Re: [PATCH RFC V10 16/18] kvm hypervisor : Simplify kvm_for_each_vcpu
 with kvm_irq_delivery_to_apic
References: <20130624124014.27508.8906.sendpatchset@codeblue.in.ibm.com> <20130624124353.27508.94224.sendpatchset@codeblue.in.ibm.com> <20130714132402.GB11772@redhat.com>
In-Reply-To: <20130714132402.GB11772@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071515-4790-0000-0000-000009464417
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/2013 06:54 PM, Gleb Natapov wrote:
> On Mon, Jun 24, 2013 at 06:13:53PM +0530, Raghavendra K T wrote:
>> Simplify kvm_for_each_vcpu with kvm_irq_delivery_to_apic
>>
>> From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
>>
>> Note that we are using APIC_DM_REMRD which has reserved usage.
>> In future if APIC_DM_REMRD usage is standardized, then we should
>> find some other way or go back to old method.
>>
>> Suggested-by: Gleb Natapov <gleb@redhat.com>
>> Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
>> ---
>>   arch/x86/kvm/lapic.c |    5 ++++-
>>   arch/x86/kvm/x86.c   |   25 ++++++-------------------
>>   2 files changed, 10 insertions(+), 20 deletions(-)
>>
>> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
>> index e1adbb4..3f5f82e 100644
>> --- a/arch/x86/kvm/lapic.c
>> +++ b/arch/x86/kvm/lapic.c
>> @@ -706,7 +706,10 @@ out:
>>   		break;
>>
>>   	case APIC_DM_REMRD:
>> -		apic_debug("Ignoring delivery mode 3\n");
>> +		result = 1;
>> +		vcpu->arch.pv.pv_unhalted = 1;
>> +		kvm_make_request(KVM_REQ_EVENT, vcpu);
>> +		kvm_vcpu_kick(vcpu);
>>   		break;
>>
>>   	case APIC_DM_SMI:
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 92a9932..b963c86 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -5456,27 +5456,14 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
>>    */
>>   static void kvm_pv_kick_cpu_op(struct kvm *kvm, int apicid)
>>   {
>> -	struct kvm_vcpu *vcpu = NULL;
>> -	int i;
>> +	struct kvm_lapic_irq lapic_irq;
>>
>> -	kvm_for_each_vcpu(i, vcpu, kvm) {
>> -		if (!kvm_apic_present(vcpu))
>> -			continue;
>> +	lapic_irq.shorthand = 0;
>> +	lapic_irq.dest_mode = 0;
>> +	lapic_irq.dest_id = apicid;
>>
>> -		if (kvm_apic_match_dest(vcpu, 0, 0, apicid, 0))
>> -			break;
>> -	}
>> -	if (vcpu) {
>> -		/*
>> -		 * Setting unhalt flag here can result in spurious runnable
>> -		 * state when unhalt reset does not happen in vcpu_block.
>> -		 * But that is harmless since that should soon result in halt.
>> -		 */
>> -		vcpu->arch.pv.pv_unhalted = true;
>> -		/* We need everybody see unhalt before vcpu unblocks */
>> -		smp_wmb();
>> -		kvm_vcpu_kick(vcpu);
>> -	}
>> +	lapic_irq.delivery_mode = APIC_DM_REMRD;
> Need to make sure that delivery_mode cannot be set to APIC_DM_REMRD
> from MSI/IOAPIC/IPI path.

I Gleb,
I need your help here since I do not know much about apic.

so are you saying explicitly checking that, kvm_set_msi_irq, 
apic_send_ipi, native_setup_ioapic_entry, does not have APIC_DM_REMRD as 
delivery_mode set?



