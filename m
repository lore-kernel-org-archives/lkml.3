Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757781Ab3IBJmg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 05:42:36 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:38656 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754946Ab3IBJmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 05:42:33 -0400
Message-ID: <52245D81.7060402@linux.vnet.ibm.com>
Date: Mon, 02 Sep 2013 17:42:25 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, glin@suse.de, agraf@suse.de, brogers@suse.de,
        afaerber@suse.de, lnussel@suse.de, edk2-devel@lists.sf.net,
        stable@vger.kernel.org
Subject: Re: [PATCH] KVM: mmu: allow page tables to be in read-only slots
References: <1377866497-3866-1-git-send-email-pbonzini@redhat.com> <20130901091744.GF22899@redhat.com>
In-Reply-To: <20130901091744.GF22899@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13090209-2674-0000-0000-00000A7A0F9F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01/2013 05:17 PM, Gleb Natapov wrote:
> On Fri, Aug 30, 2013 at 02:41:37PM +0200, Paolo Bonzini wrote:
>> Page tables in a read-only memory slot will currently cause a triple
>> fault because the page walker uses gfn_to_hva and it fails on such a slot.
>>
>> OVMF uses such a page table; however, real hardware seems to be fine with
>> that as long as the accessed/dirty bits are set.  Save whether the slot
>> is readonly, and later check it when updating the accessed and dirty bits.
>>
> The fix looks OK to me, but some comment below.
> 
>> Cc: stable@vger.kernel.org
>> Cc: gleb@redhat.com
>> Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>> ---
>> 	CCing to stable@ since the regression was introduced with
>> 	support for readonly memory slots.
>>
>>  arch/x86/kvm/paging_tmpl.h |  7 ++++++-
>>  include/linux/kvm_host.h   |  1 +
>>  virt/kvm/kvm_main.c        | 14 +++++++++-----
>>  3 files changed, 16 insertions(+), 6 deletions(-)
>>
>> diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
>> index 0433301..dadc5c0 100644
>> --- a/arch/x86/kvm/paging_tmpl.h
>> +++ b/arch/x86/kvm/paging_tmpl.h
>> @@ -99,6 +99,7 @@ struct guest_walker {
>>  	pt_element_t prefetch_ptes[PTE_PREFETCH_NUM];
>>  	gpa_t pte_gpa[PT_MAX_FULL_LEVELS];
>>  	pt_element_t __user *ptep_user[PT_MAX_FULL_LEVELS];
>> +	bool pte_writable[PT_MAX_FULL_LEVELS];
>>  	unsigned pt_access;
>>  	unsigned pte_access;
>>  	gfn_t gfn;
>> @@ -235,6 +236,9 @@ static int FNAME(update_accessed_dirty_bits)(struct kvm_vcpu *vcpu,
>>  		if (pte == orig_pte)
>>  			continue;
>>  
>> +		if (unlikely(!walker->pte_writable[level - 1]))
>> +			return -EACCES;
>> +
>>  		ret = FNAME(cmpxchg_gpte)(vcpu, mmu, ptep_user, index, orig_pte, pte);
>>  		if (ret)
>>  			return ret;
>> @@ -309,7 +313,8 @@ retry_walk:
>>  			goto error;
>>  		real_gfn = gpa_to_gfn(real_gfn);
>>  
>> -		host_addr = gfn_to_hva(vcpu->kvm, real_gfn);
>> +		host_addr = gfn_to_hva_read(vcpu->kvm, real_gfn,
>> +					    &walker->pte_writable[walker->level - 1]);
> The use of gfn_to_hva_read is misleading. The code can still write into
> gfn. Lets rename gfn_to_hva_read to gfn_to_hva_prot() and gfn_to_hva()
> to gfn_to_hva_write().

Yes. I agreed.

> 
> This makes me think are there other places where gfn_to_hva() was
> used, but gfn_to_hva_prot() should have been?
>  - kvm_host_page_size() looks incorrect. We never use huge page to map
>    read only memory slots currently.

It only checks whether gfn have been mapped, I think we can use
gfn_to_hva_read() instead, the real permission will be checked when we translate
the gfn to pfn.

>  - kvm_handle_bad_page() also looks incorrect and may cause incorrect
>    address to be reported to userspace.

I have no idea on this point. kvm_handle_bad_page() is called when it failed to
translate the target gfn to pfn, then the emulator can detect the error on target gfn
properly. no? Or i misunderstood your meaning?

>  - kvm_setup_async_pf() also incorrect. Makes all page fault on read
>    only slot to be sync.
>  - kvm_vm_fault() one looks OK since function assumes write only slots,
>    but it is obsolete and should be deleted anyway.


