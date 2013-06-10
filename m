Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763Ab3FJIqA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 04:46:00 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:54324 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600Ab3FJIp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 04:45:59 -0400
Message-ID: <51B5923F.9050801@gmail.com>
Date: Mon, 10 Jun 2013 16:45:51 +0800
From: Xiao Guangrong <xiaoguangrong.eric@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>, avi.kivity@gmail.com,
        mtosatti@redhat.com, pbonzini@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v3 3/6] KVM: MMU: make return value of mmio page fault
 handler more readable
References: <1370595088-3315-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <1370595088-3315-4-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <20130610075750.GZ4725@redhat.com>
In-Reply-To: <20130610075750.GZ4725@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2013 03:57 PM, Gleb Natapov wrote:
> On Fri, Jun 07, 2013 at 04:51:25PM +0800, Xiao Guangrong wrote:
>> Define some meaningful names instead of raw code
>>
>> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
>> ---
>>  arch/x86/kvm/mmu.c | 15 +++++----------
>>  arch/x86/kvm/mmu.h | 14 ++++++++++++++
>>  arch/x86/kvm/vmx.c |  4 ++--
>>  3 files changed, 21 insertions(+), 12 deletions(-)
>>
>> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
>> index eca91bd..044d8c0 100644
>> --- a/arch/x86/kvm/mmu.c
>> +++ b/arch/x86/kvm/mmu.c
>> @@ -3222,17 +3222,12 @@ static u64 walk_shadow_page_get_mmio_spte(struct kvm_vcpu *vcpu, u64 addr)
>>  	return spte;
>>  }
>>  
>> -/*
>> - * If it is a real mmio page fault, return 1 and emulat the instruction
>> - * directly, return 0 to let CPU fault again on the address, -1 is
>> - * returned if bug is detected.
>> - */
>>  int handle_mmio_page_fault_common(struct kvm_vcpu *vcpu, u64 addr, bool direct)
>>  {
>>  	u64 spte;
>>  
>>  	if (quickly_check_mmio_pf(vcpu, addr, direct))
>> -		return 1;
>> +		return RET_MMIO_PF_EMULATE;
>>  
>>  	spte = walk_shadow_page_get_mmio_spte(vcpu, addr);
>>  
>> @@ -3245,7 +3240,7 @@ int handle_mmio_page_fault_common(struct kvm_vcpu *vcpu, u64 addr, bool direct)
>>  
>>  		trace_handle_mmio_page_fault(addr, gfn, access);
>>  		vcpu_cache_mmio_info(vcpu, addr, gfn, access);
>> -		return 1;
>> +		return RET_MMIO_PF_EMULATE;
>>  	}
>>  
>>  	/*
>> @@ -3253,13 +3248,13 @@ int handle_mmio_page_fault_common(struct kvm_vcpu *vcpu, u64 addr, bool direct)
>>  	 * it's a BUG if the gfn is not a mmio page.
>>  	 */
>>  	if (direct && !check_direct_spte_mmio_pf(spte))
>> -		return -1;
>> +		return RET_MMIO_PF_BUG;
>>  
>>  	/*
>>  	 * If the page table is zapped by other cpus, let CPU fault again on
>>  	 * the address.
>>  	 */
>> -	return 0;
>> +	return RET_MMIO_PF_RETRY;
>>  }
>>  EXPORT_SYMBOL_GPL(handle_mmio_page_fault_common);
>>  
>> @@ -3269,7 +3264,7 @@ static int handle_mmio_page_fault(struct kvm_vcpu *vcpu, u64 addr,
>>  	int ret;
>>  
>>  	ret = handle_mmio_page_fault_common(vcpu, addr, direct);
>> -	WARN_ON(ret < 0);
>> +	WARN_ON(ret == RET_MMIO_PF_BUG);
>>  	return ret;
>>  }
>>  
>> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
>> index 922bfae..ba6a19c 100644
>> --- a/arch/x86/kvm/mmu.h
>> +++ b/arch/x86/kvm/mmu.h
>> @@ -52,6 +52,20 @@
>>  
>>  int kvm_mmu_get_spte_hierarchy(struct kvm_vcpu *vcpu, u64 addr, u64 sptes[4]);
>>  void kvm_mmu_set_mmio_spte_mask(u64 mmio_mask);
>> +
>> +/*
>> + * Return values of handle_mmio_page_fault_common:
>> + * RET_MMIO_PF_EMULATE: it is a real mmio page fault, emulate the instruction
>> + *			 directly.
>> + * RET_MMIO_PF_RETRY: let CPU fault again on the address.
>> + * RET_MMIO_PF_BUG: bug is detected.
>> + */
>> +enum {
>> +	RET_MMIO_PF_EMULATE = 1,
>> +	RET_MMIO_PF_RETRY = 0,
>> +	RET_MMIO_PF_BUG = -1
>> +};
> I would order them from -1 to 1 and rename RET_MMIO_PF_BUG to
> RET_MMIO_PF_ERROR, but no need to resend just for that.

Fine to me. Will make a separate patch to update it later. Thanks for your review!
