Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933160Ab3CVCQO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 22:16:14 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:50822 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601Ab3CVCQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 22:16:13 -0400
Message-ID: <514BBEE1.5040204@linux.vnet.ibm.com>
Date: Fri, 22 Mar 2013 10:16:01 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: mtosatti@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 4/7] KVM: MMU: delete shadow page from hash list in
 kvm_mmu_prepare_zap_page
References: <1363768227-4782-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <1363768227-4782-5-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <20130321131409.GT3889@redhat.com>
In-Reply-To: <20130321131409.GT3889@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13032202-2674-0000-0000-0000084F870A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2013 09:14 PM, Gleb Natapov wrote:
> On Wed, Mar 20, 2013 at 04:30:24PM +0800, Xiao Guangrong wrote:
>> Move deletion shadow page from the hash list from kvm_mmu_commit_zap_page to
>> kvm_mmu_prepare_zap_page, we that we can free the shadow page out of mmu-lock.
>>
>> Also, delete the invalid shadow page from the hash list since this page can
>> not be reused anymore. This makes reset mmu-cache more easier - we do not need
>> to care all hash entries after reset mmu-cache
>>
>> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
>> ---
>>  arch/x86/kvm/mmu.c |    8 ++++++--
>>  1 files changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
>> index dc37512..5578c91 100644
>> --- a/arch/x86/kvm/mmu.c
>> +++ b/arch/x86/kvm/mmu.c
>> @@ -1472,7 +1472,7 @@ static inline void kvm_mod_used_mmu_pages(struct kvm *kvm, int nr)
>>  static void kvm_mmu_free_page(struct kvm_mmu_page *sp)
>>  {
>>  	ASSERT(is_empty_shadow_page(sp->spt));
>> -	hlist_del(&sp->hash_link);
>> +
>>  	list_del(&sp->link);
>>  	free_page((unsigned long)sp->spt);
>>  	if (!sp->role.direct)
>> @@ -1660,7 +1660,8 @@ static void kvm_mmu_commit_zap_page(struct kvm *kvm,
>>  
>>  #define for_each_gfn_indirect_valid_sp(_kvm, _sp, _gfn)			\
>>  	for_each_gfn_sp(_kvm, _sp, _gfn)				\
>> -		if ((_sp)->role.direct || (_sp)->role.invalid) {} else
>> +		if ((_sp)->role.direct ||				\
>> +		      ((_sp)->role.invalid && WARN_ON(1))) {} else
>>  
>>  /* @sp->gfn should be write-protected at the call site */
>>  static int __kvm_sync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
>> @@ -2079,6 +2080,9 @@ static int kvm_mmu_prepare_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp,
>>  		unaccount_shadowed(kvm, sp->gfn);
>>  	if (sp->unsync)
>>  		kvm_unlink_unsync_page(kvm, sp);
>> +
>> +	hlist_del_init(&sp->hash_link);
>> +
> Now we delete roots from hash, but leave it on active_mmu_pages list. Is
> this OK?

It is okay i think. Hash-lish is only used to find gfn's shadow page. Invalid shadow page
does not contain any useful guest content and will be freed soon after vcpu reload.

IIRC, we did it when we used rcu to free shadow pages.

