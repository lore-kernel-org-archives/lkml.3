Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147Ab3EPNbd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 09:31:33 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:41070 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754061Ab3EPNbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 09:31:31 -0400
Message-ID: <5194DFAC.8010707@linux.vnet.ibm.com>
Date: Thu, 16 May 2013 21:31:24 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>
CC: gleb@redhat.com, avi.kivity@gmail.com, mtosatti@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v5 8/8] KVM: MMU: zap pages in batch
References: <1368706673-8530-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <1368706673-8530-9-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <5194D507.5080005@redhat.com>
In-Reply-To: <5194D507.5080005@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13051700-3568-0000-0000-000003A0D6C8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2013 08:45 PM, Paolo Bonzini wrote:
> Il 16/05/2013 14:17, Xiao Guangrong ha scritto:
>> Zap at lease 10 pages before releasing mmu-lock to reduce the overload
>> caused by requiring lock
>>
>> [ It improves kernel building 0.6% ~ 1% ]
>>
>> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
>> ---
>>  arch/x86/kvm/mmu.c |   11 ++++++++---
>>  1 files changed, 8 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
>> index e12f431..9c27fda 100644
>> --- a/arch/x86/kvm/mmu.c
>> +++ b/arch/x86/kvm/mmu.c
>> @@ -4216,10 +4216,12 @@ restart:
>>  	spin_unlock(&kvm->mmu_lock);
>>  }
>>  
>> +#define BATCH_ZAP_PAGES	10
>>  static void zap_invalid_pages(struct kvm *kvm)
>>  {
>>  	struct kvm_mmu_page *sp, *node;
>>  	LIST_HEAD(invalid_list);
>> +	int batch = 0;
>>  
>>  restart:
>>  	list_for_each_entry_safe(sp, node, &kvm->arch.active_mmu_pages, link) {
>> @@ -4256,11 +4258,14 @@ restart:
>>  		 * Need not flush tlb since we only zap the sp with invalid
>>  		 * generation number.
>>  		 */
>> -		if (cond_resched_lock(&kvm->mmu_lock))
>> +		if ((batch >= BATCH_ZAP_PAGES) &&
>> +		      cond_resched_lock(&kvm->mmu_lock)) {
>> +			batch = 0;
>>  			goto restart;
>> +		}
>>  
>> -		if (kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list))
>> -			goto restart;
>> +		batch += kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list);
>> +		goto restart;
> 
> Would this look again and again at the same page if
> kvm_mmu_prepare_zap_page returns 0?

We skip the invalid page (sp->role.invalid) before call
kvm_mmu_prepare_zap_page so that kvm_mmu_prepare_zap_page can not
meet the same page. ;)



