Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162AbaDOLKt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 07:10:49 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:55775 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbaDOLKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 07:10:47 -0400
Message-ID: <534D13DC.7040400@linux.vnet.ibm.com>
Date: Tue, 15 Apr 2014 19:11:24 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: gleb@kernel.org, avi.kivity@gmail.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 5/5] KVM: MMU: flush tlb out of mmu lock when write-protect
 the sptes
References: <1394460109-3150-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <1394460109-3150-6-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <20140409145137.GA23449@amt.cnet>
In-Reply-To: <20140409145137.GA23449@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14041511-5816-0000-0000-00000D84FB77
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Marcelo,

Thanks your time to review it.

On 04/09/2014 10:51 PM, Marcelo Tosatti wrote:

>> +/*
>> + * Please note PT_WRITABLE_MASK is not stable since
>> + * 1) fast_page_fault() sets spte from readonly to writable out of mmu-lock or
>> + * 2) kvm_mmu_slot_remove_write_access() and kvm_vm_ioctl_get_dirty_log()
>> + *    can write protect sptes but flush tlb out mmu-lock that means we may use
>> + *    the corrupt tlb entries which depend on this bit.
>> + *
>> + * Both cases do not modify the status of  spte_is_locklessly_modifiable() so
>> + * if you want to check whether the spte is writable on MMU you can check
>> + * SPTE_MMU_WRITEABLE instead. If you want to update spte without losing
>> + * A/D bits and tlb flush, you can check spte_is_locklessly_modifiable()
>> + * instead. See the comments in spte_has_volatile_bits() and
>> + * mmu_spte_update().
>> + */
>>  static inline int is_writable_pte(unsigned long pte)
>>  {
> 
> Xiao,
> 
> Can't get the SPTE_MMU_WRITEABLE part.
> 
> So assume you are writing code to perform some action after guest memory
> has been write protected. You would
> 
> spin_lock(mmu_lock);
> 
> if (writeable spte bit is set)
>     remove writeable spte bit from spte
> remote TLB flush            (*)
> action
> 
> spin_unlock(mmu_lock);
> 
> (*) is necessary because reading the writeable spte bit as zero
> does not guarantee remote TLBs have been flushed.
> 
> Now what SPTE_MMU_WRITEABLE has to do with it ?

It is contained in "remove writeable spte bit from spte" which
is done by mmu_spte_update():

	if (spte_is_locklessly_modifiable(old_spte) &&
	      !is_writable_pte(new_spte))
		ret = true;
> 
> Perhaps a recipe like that (or just the rules) would be useful.

Okay, i am considering to improve this comments, how about like
this:

Currently, we have two sorts of write-protection, a) the first
one write-protects guest page to sync the guest modification,
b) another one is used to sync dirty bitmap when we do
KVM_GET_DIRTY_LOG. The differences between these two sorts are:
1) the first case clears SPTE_MMU_WRITEABLE bit.
2) the first case requires flushing tlb immediately avoiding
   corrupting shadow page table between all vcpus so it should
   be in the protection of mmu-lock. And the another case does
   not need to flush tlb until returning the dirty bitmap to
   userspace since it only write-protects the page logged in
   the bitmap, that means the page in the dirty bitmap is not
   missed, so it can flush tlb out of mmu-lock.

So, there is the problem: the first case can meet the corrupted
tlb caused by another case which write-protects pages but without
flush tlb immediately. In order to making the first case be aware
this problem we let it flush tlb if we try to write-protect
a spte whose SPTE_MMU_WRITEABLE bit is set, it works since another
case never touches SPTE_MMU_WRITEABLE bit.

Anyway, whenever a spte is updated (only permission and status bits
are changed) we need to check whether the spte with SPTE_MMU_WRITEABLE
becomes readonly, if that happens, we need to flush tlb. Fortunately,
mmu_spte_update() has already handled it perfectly.

The rules to use SPTE_MMU_WRITEABLE and PT_WRITABLE_MASK:
- if we want to see if it has writable tlb entry or if the spte can
  be writable on the mmu mapping, check SPTE_MMU_WRITEABLE, this is
  the most case, otherwise
- if we fix page fault on the spte or do write-protection by dirty logging,
  check PT_WRITABLE_MASK.

TODO: introduce APIs to split these two cases.

> 
> The remaining patches look good.

Thank you.


