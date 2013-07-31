Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759195Ab3GaH1d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 03:27:33 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:37404 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759173Ab3GaH1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 03:27:30 -0400
Message-ID: <51F8BBD9.3060909@linux.vnet.ibm.com>
Date: Wed, 31 Jul 2013 15:25:13 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>
CC: gleb@redhat.com, avi.kivity@gmail.com, mtosatti@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 04/12] KVM: MMU: log dirty page after marking spte writable
References: <1375189330-24066-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <1375189330-24066-5-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <51F7BF00.5060703@redhat.com>
In-Reply-To: <51F7BF00.5060703@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13073107-6102-0000-0000-000003F273B2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2013 09:26 PM, Paolo Bonzini wrote:
> Il 30/07/2013 15:02, Xiao Guangrong ha scritto:
>> Make sure we can see the writable spte before the dirt bitmap is visible
>>
>> We do this is for kvm_vm_ioctl_get_dirty_log() write-protects the spte based
>> on the dirty bitmap, we should ensure the writable spte can be found in rmap
>> before the dirty bitmap is visible. Otherwise, we cleared the dirty bitmap and
>> failed to write-protect the page
>>
>> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
>> ---
>>  arch/x86/kvm/mmu.c | 6 +++---
>>  1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
>> index 35d4b50..0fe56ad 100644
>> --- a/arch/x86/kvm/mmu.c
>> +++ b/arch/x86/kvm/mmu.c
>> @@ -2486,12 +2486,12 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
>>  		}
>>  	}
>>  
>> -	if (pte_access & ACC_WRITE_MASK)
>> -		mark_page_dirty(vcpu->kvm, gfn);
>> -
>>  set_pte:
>>  	if (mmu_spte_update(sptep, spte))
>>  		kvm_flush_remote_tlbs(vcpu->kvm);
>> +
>> +	if (pte_access & ACC_WRITE_MASK)
>> +		mark_page_dirty(vcpu->kvm, gfn);
>>  done:
>>  	return ret;
>>  }
>>
> 
> What about this comment above:
> 
>                 /*
>                  * Optimization: for pte sync, if spte was writable the hash
>                  * lookup is unnecessary (and expensive). Write protection
>                  * is responsibility of mmu_get_page / kvm_sync_page.

This comments mean no sync shadow page created if the the spte is still writable
because add a sync page need to writable all spte point to this page. So we can
keep the spte as writable.

I think it is better to checking SPTE_MMU_WRITEABLE bit instead of PT_WRITABLE_MASK
since the latter bit can be cleared by dirty log and it can be a separate patch i
think.

>                  * Same reasoning can be applied to dirty page accounting.

This comment means if the spte is writable the corresponding bit on dirty bitmap
should have been set.

Thanks to your reminder, i think this comment should be dropped, now we need to
mark_page_dirty() whenever the spte update to writable. Otherwise this will happen:

   VCPU 0                         VCPU 1
Clear dirty bit on the bitmap
                               Read the spte, it is writable
write the spte
                               update the spte, keep it as writable
                               and do not call mark_page_dirty().
Flush tlb

Then vcpu 1 can continue to write the page but fail to set the bit on the bitmap.

>                  */
>                 if (!can_unsync && is_writable_pte(*sptep))
>                         goto set_pte;
> 
>                 if (mmu_need_write_protect(vcpu, gfn, can_unsync)) {
> 
> 
> ?
> 
> Should it be changed to
> 
>                 if (!can_unsync && is_writable_pte(*sptep))
>                         pte_access &= ~ACC_WRITE_MASK; /* do not mark dirty */

Yes, this can avoid the issue above.

But there is only a small window between sync the spte and locklessly write-protect
the spte (since the sptep is already writable), i think we'd better keep the spte
writable to speed up the normal case. :)

