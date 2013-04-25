Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755601Ab3DYJX1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 05:23:27 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:50587 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448Ab3DYJXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 05:23:25 -0400
Message-ID: <5178F602.9040100@linux.vnet.ibm.com>
Date: Thu, 25 Apr 2013 17:23:14 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: mtosatti@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 6/6] KVM: MMU: init kvm generation close to mmio wrap-around
 value
References: <1364810209-25954-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <1364810209-25954-7-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <20130424125911.GQ12401@redhat.com>
In-Reply-To: <20130424125911.GQ12401@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13042509-5490-0000-0000-00000358950B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2013 08:59 PM, Gleb Natapov wrote:
> On Mon, Apr 01, 2013 at 05:56:49PM +0800, Xiao Guangrong wrote:
>> Then it has chance to trigger mmio generation number wrap-around
>>
>> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
>> ---
>>  arch/x86/include/asm/kvm_host.h |    1 +
>>  arch/x86/kvm/mmu.c              |    8 ++++++++
>>  virt/kvm/kvm_main.c             |    6 ++++++
>>  3 files changed, 15 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index 6c1e642..4e1f7cb 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -767,6 +767,7 @@ void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,
>>  				     struct kvm_memory_slot *slot,
>>  				     gfn_t gfn_offset, unsigned long mask);
>>  void kvm_mmu_zap_all(struct kvm *kvm);
>> +void kvm_arch_init_generation(struct kvm *kvm);
>>  void kvm_mmu_invalid_mmio_sptes(struct kvm *kvm);
>>  unsigned int kvm_mmu_calculate_mmu_pages(struct kvm *kvm);
>>  void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned int kvm_nr_mmu_pages);
>> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
>> index d314e21..dcc059c 100644
>> --- a/arch/x86/kvm/mmu.c
>> +++ b/arch/x86/kvm/mmu.c
>> @@ -4279,6 +4279,14 @@ restart:
>>  	spin_unlock(&kvm->mmu_lock);
>>  }
>>  
>> +void kvm_arch_init_generation(struct kvm *kvm)
>> +{
>> +	mutex_lock(&kvm->slots_lock);
>> +	/* It is easier to trigger mmio generation-number wrap-around. */
>> +	kvm_memslots(kvm)->generation = MMIO_MAX_GEN - 13;
> kvm_memslots(kvm)->generation should never overflow since
> (read|write)_cached mechanism does not handle it. Initialising it to
> anything but 0 makes overflow more likely.
> 
> You can hide mmio overflow trick in kvm_current_mmio_generation():
> 
> static unsigned int kvm_current_mmio_generation(struct kvm *kvm)
> {
> 	return (kvm_memslots(kvm)->generation + MMIO_MAX_GEN - 13) & MMIO_GEN_MASK;
> }

Very smart idea. Thanks you, Gleb!



