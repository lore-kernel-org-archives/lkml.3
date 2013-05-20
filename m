Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754385Ab3ETJTl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 05:19:41 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:33078 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752925Ab3ETJTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 05:19:39 -0400
Message-ID: <5199EA9E.3010909@linux.vnet.ibm.com>
Date: Mon, 20 May 2013 17:19:26 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v6 2/7] KVM: MMU: delete shadow page from hash list in
 kvm_mmu_prepare_zap_page
References: <1368738782-18649-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <1368738782-18649-3-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <20130519104713.GE4725@redhat.com>
In-Reply-To: <20130519104713.GE4725@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052009-2000-0000-0000-00000C2DD4F7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19/2013 06:47 PM, Gleb Natapov wrote:
> On Fri, May 17, 2013 at 05:12:57AM +0800, Xiao Guangrong wrote:
>> Move deletion shadow page from the hash list from kvm_mmu_commit_zap_page to
>> kvm_mmu_prepare_zap_page so that we can call kvm_mmu_commit_zap_page
>> once for multiple kvm_mmu_prepare_zap_page that can help us to avoid
>> unnecessary TLB flush
>>
> Don't we call kvm_mmu_commit_zap_page() once for multiple
> kvm_mmu_prepare_zap_page() now when possible? kvm_mmu_commit_zap_page()
> gets a list as a parameter. I am not against the change, but wish to
> understand it better.

The changelong is not clear enough, i mean we can "call
kvm_mmu_commit_zap_page once for multiple kvm_mmu_prepare_zap_page" when
we use lock-break technique. If we do not do this, the page can be found
in hashtable but they are linked on the invalid_list on other thread.

> 
>> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
>> ---
>>  arch/x86/kvm/mmu.c |    8 ++++++--
>>  1 files changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
>> index 40d7b2d..682ecb4 100644
>> --- a/arch/x86/kvm/mmu.c
>> +++ b/arch/x86/kvm/mmu.c
>> @@ -1466,7 +1466,7 @@ static inline void kvm_mod_used_mmu_pages(struct kvm *kvm, int nr)
>>  static void kvm_mmu_free_page(struct kvm_mmu_page *sp)
>>  {
>>  	ASSERT(is_empty_shadow_page(sp->spt));
>> -	hlist_del(&sp->hash_link);
>> +
>>  	list_del(&sp->link);
>>  	free_page((unsigned long)sp->spt);
>>  	if (!sp->role.direct)
>> @@ -1655,7 +1655,8 @@ static void kvm_mmu_commit_zap_page(struct kvm *kvm,
>>  
>>  #define for_each_gfn_indirect_valid_sp(_kvm, _sp, _gfn)			\
>>  	for_each_gfn_sp(_kvm, _sp, _gfn)				\
>> -		if ((_sp)->role.direct || (_sp)->role.invalid) {} else
>> +		if ((_sp)->role.direct ||				\
>> +		      ((_sp)->role.invalid && WARN_ON(1))) {} else
>>  
>>  /* @sp->gfn should be write-protected at the call site */
>>  static int __kvm_sync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
>> @@ -2074,6 +2075,9 @@ static int kvm_mmu_prepare_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp,
>>  		unaccount_shadowed(kvm, sp->gfn);
>>  	if (sp->unsync)
>>  		kvm_unlink_unsync_page(kvm, sp);
>> +
>> +	hlist_del_init(&sp->hash_link);
>> +
> What about moving this inside if() bellow and making it hlist_del()?
> Leave the page on the hash if root_count is non zero.
> 

It's a good idea. will update.


