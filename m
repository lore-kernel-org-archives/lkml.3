Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311Ab3GOFuS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 01:50:18 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:38940 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181Ab3GOFuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 01:50:16 -0400
Message-ID: <51E38E56.7090001@linux.vnet.ibm.com>
Date: Mon, 15 Jul 2013 11:23:26 +0530
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
Subject: Re: [PATCH RFC V10 12/18] kvm hypervisor : Add a hypercall to KVM
 hypervisor to support pv-ticketlocks
References: <20130624124014.27508.8906.sendpatchset@codeblue.in.ibm.com> <20130624124304.27508.5414.sendpatchset@codeblue.in.ibm.com> <20130714134820.GC11772@redhat.com>
In-Reply-To: <20130714134820.GC11772@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071505-9264-0000-0000-0000041FE371
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/2013 07:18 PM, Gleb Natapov wrote:
> On Mon, Jun 24, 2013 at 06:13:04PM +0530, Raghavendra K T wrote:
>> kvm hypervisor : Add a hypercall to KVM hypervisor to support pv-ticketlocks
>>
>> From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
>>
>> kvm_hc_kick_cpu allows the calling vcpu to kick another vcpu out of halt state.
>> the presence of these hypercalls is indicated to guest via
>> kvm_feature_pv_unhalt.
>>
>> Signed-off-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
>> Signed-off-by: Suzuki Poulose <suzuki@in.ibm.com>
>> [Raghu: Apic related changes, folding pvunhalted into vcpu_runnable]
>> Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
>> ---
>>   arch/x86/include/asm/kvm_host.h      |    5 +++++
>>   arch/x86/include/uapi/asm/kvm_para.h |    1 +
>>   arch/x86/kvm/cpuid.c                 |    3 ++-
>>   arch/x86/kvm/x86.c                   |   37 ++++++++++++++++++++++++++++++++++
>>   include/uapi/linux/kvm_para.h        |    1 +
>>   5 files changed, 46 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index 3741c65..95702de 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -503,6 +503,11 @@ struct kvm_vcpu_arch {
>>   	 * instruction.
>>   	 */
>>   	bool write_fault_to_shadow_pgtable;
>> +
>> +	/* pv related host specific info */
>> +	struct {
>> +		bool pv_unhalted;
>> +	} pv;
>>   };
>>
>>   struct kvm_lpage_info {
>> diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
>> index 06fdbd9..94dc8ca 100644
>> --- a/arch/x86/include/uapi/asm/kvm_para.h
>> +++ b/arch/x86/include/uapi/asm/kvm_para.h
>> @@ -23,6 +23,7 @@
>>   #define KVM_FEATURE_ASYNC_PF		4
>>   #define KVM_FEATURE_STEAL_TIME		5
>>   #define KVM_FEATURE_PV_EOI		6
>> +#define KVM_FEATURE_PV_UNHALT		7
>>
>>   /* The last 8 bits are used to indicate how to interpret the flags field
>>    * in pvclock structure. If no bits are set, all flags are ignored.
>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>> index a20ecb5..b110fe6 100644
>> --- a/arch/x86/kvm/cpuid.c
>> +++ b/arch/x86/kvm/cpuid.c
>> @@ -413,7 +413,8 @@ static int do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
>>   			     (1 << KVM_FEATURE_CLOCKSOURCE2) |
>>   			     (1 << KVM_FEATURE_ASYNC_PF) |
>>   			     (1 << KVM_FEATURE_PV_EOI) |
>> -			     (1 << KVM_FEATURE_CLOCKSOURCE_STABLE_BIT);
>> +			     (1 << KVM_FEATURE_CLOCKSOURCE_STABLE_BIT) |
>> +			     (1 << KVM_FEATURE_PV_UNHALT);
>>
>>   		if (sched_info_on())
>>   			entry->eax |= (1 << KVM_FEATURE_STEAL_TIME);
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 094b5d9..f8bea30 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -5449,6 +5449,36 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
>>   	return 1;
>>   }
>>
>> +/*
>> + * kvm_pv_kick_cpu_op:  Kick a vcpu.
>> + *
>> + * @apicid - apicid of vcpu to be kicked.
>> + */
>> +static void kvm_pv_kick_cpu_op(struct kvm *kvm, int apicid)
>> +{
>> +	struct kvm_vcpu *vcpu = NULL;
>> +	int i;
>> +
>> +	kvm_for_each_vcpu(i, vcpu, kvm) {
>> +		if (!kvm_apic_present(vcpu))
>> +			continue;
>> +
>> +		if (kvm_apic_match_dest(vcpu, 0, 0, apicid, 0))
>> +			break;
>> +	}
>> +	if (vcpu) {
>> +		/*
>> +		 * Setting unhalt flag here can result in spurious runnable
>> +		 * state when unhalt reset does not happen in vcpu_block.
>> +		 * But that is harmless since that should soon result in halt.
>> +		 */
>> +		vcpu->arch.pv.pv_unhalted = true;
>> +		/* We need everybody see unhalt before vcpu unblocks */
>> +		smp_wmb();
>> +		kvm_vcpu_kick(vcpu);
>> +	}
>> +}
>> +
>>   int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
>>   {
>>   	unsigned long nr, a0, a1, a2, a3, ret;
>> @@ -5482,6 +5512,10 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
>>   	case KVM_HC_VAPIC_POLL_IRQ:
>>   		ret = 0;
>>   		break;
>> +	case KVM_HC_KICK_CPU:
>> +		kvm_pv_kick_cpu_op(vcpu->kvm, a0);
> Lets make it hypercall with two parameters:
> a0 - flags
> a1 - apic id of a cpu to kick
>
> A0 have to be zero. This will make it more extensible.

Good point. 'll incorporate that.


