Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755924Ab3H2JZY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 05:25:24 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:43778 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753356Ab3H2JZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 05:25:22 -0400
Message-ID: <521F137A.7090208@linux.vnet.ibm.com>
Date: Thu, 29 Aug 2013 17:25:14 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 10/12] KVM: MMU: allow locklessly access shadow page table
 out of vcpu thread
References: <1375189330-24066-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <1375189330-24066-11-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <20130829091020.GB22899@redhat.com>
In-Reply-To: <20130829091020.GB22899@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082909-1396-0000-0000-00000378DDAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29/2013 05:10 PM, Gleb Natapov wrote:
> On Tue, Jul 30, 2013 at 09:02:08PM +0800, Xiao Guangrong wrote:
>> It is easy if the handler is in the vcpu context, in that case we can use
>> walk_shadow_page_lockless_begin() and walk_shadow_page_lockless_end() that
>> disable interrupt to stop shadow page be freed. But we are on the ioctl context
>> and the paths we are optimizing for have heavy workload, disabling interrupt is
>> not good for the system performance
>>
>> We add a indicator into kvm struct (kvm->arch.rcu_free_shadow_page), then use
>> call_rcu() to free the shadow page if that indicator is set. Set/Clear the
>> indicator are protected by slot-lock, so it need not be atomic and does not
>> hurt the performance and the scalability
>>
>> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
>> ---
>>  arch/x86/include/asm/kvm_host.h |  6 +++++-
>>  arch/x86/kvm/mmu.c              | 23 +++++++++++++++++++++++
>>  arch/x86/kvm/mmu.h              | 22 ++++++++++++++++++++++
>>  3 files changed, 50 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index 531f47c..dc842b6 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -226,7 +226,10 @@ struct kvm_mmu_page {
>>  	/* The page is obsolete if mmu_valid_gen != kvm->arch.mmu_valid_gen.  */
>>  	unsigned long mmu_valid_gen;
>>  
>> -	DECLARE_BITMAP(unsync_child_bitmap, 512);
>> +	union {
>> +		DECLARE_BITMAP(unsync_child_bitmap, 512);
>> +		struct rcu_head rcu;
>> +	};
>>  
>>  #ifdef CONFIG_X86_32
>>  	/*
>> @@ -545,6 +548,7 @@ struct kvm_arch {
>>  	 */
>>  	struct list_head active_mmu_pages;
>>  	struct list_head zapped_obsolete_pages;
>> +	bool rcu_free_shadow_page;
>>  
>>  	struct list_head assigned_dev_head;
>>  	struct iommu_domain *iommu_domain;
>> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
>> index f8fc0cc..7f3391f 100644
>> --- a/arch/x86/kvm/mmu.c
>> +++ b/arch/x86/kvm/mmu.c
>> @@ -2322,6 +2322,22 @@ static int kvm_mmu_prepare_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp,
>>  	return ret;
>>  }
>>  
>> +static void free_pages_rcu(struct rcu_head *head)
>> +{
>> +	struct kvm_mmu_page *next, *sp;
>> +
>> +	sp = container_of(head, struct kvm_mmu_page, rcu);
>> +	while (sp) {
>> +		if (!list_empty(&sp->link))
>> +			next = list_first_entry(&sp->link,
>> +					      struct kvm_mmu_page, link);
>> +		else
>> +			next = NULL;
>> +		kvm_mmu_free_page(sp);
> So here we are calling kvm_mmu_free_page() without holding mmu lock, why
> is it safe?

Oops. :(

I should move "hlist_del(&sp->hash_link);" from this function to
kvm_mmu_prepare_zap_page(), after that kvm_mmu_free_page() will not
touch global resource anymore.


