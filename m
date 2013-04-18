Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966974Ab3DRMKf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 08:10:35 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:45190 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756107Ab3DRMKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 08:10:34 -0400
Message-ID: <516FE2B0.4050300@linux.vnet.ibm.com>
Date: Thu, 18 Apr 2013 20:10:24 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: mtosatti@redhat.com, avi.kivity@gmail.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v3 08/15] KVM: MMU: allow unmap invalid rmap out of mmu-lock
References: <1366093973-2617-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <1366093973-2617-9-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <20130418110036.GS8997@redhat.com> <516FD76F.6090306@linux.vnet.ibm.com> <20130418113837.GU8997@redhat.com>
In-Reply-To: <20130418113837.GU8997@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041812-2674-0000-0000-000008A5C786
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/18/2013 07:38 PM, Gleb Natapov wrote:
> On Thu, Apr 18, 2013 at 07:22:23PM +0800, Xiao Guangrong wrote:
>> On 04/18/2013 07:00 PM, Gleb Natapov wrote:
>>> On Tue, Apr 16, 2013 at 02:32:46PM +0800, Xiao Guangrong wrote:
>>>> pte_list_clear_concurrently allows us to reset pte-desc entry
>>>> out of mmu-lock. We can reset spte out of mmu-lock if we can protect the
>>>> lifecycle of sp, we use this way to achieve the goal:
>>>>
>>>> unmap_memslot_rmap_nolock():
>>>> for-each-rmap-in-slot:
>>>>       preempt_disable
>>>>       kvm->arch.being_unmapped_rmap = rmapp
>>>>       clear spte and reset rmap entry
>>>>       kvm->arch.being_unmapped_rmap = NULL
>>>>       preempt_enable
>>>>
>>>> Other patch like zap-sp and mmu-notify which are protected
>>>> by mmu-lock:
>>>>       clear spte and reset rmap entry
>>>> retry:
>>>>       if (kvm->arch.being_unmapped_rmap == rmap)
>>>> 		goto retry
>>>> (the wait is very rare and clear one rmap is very fast, it
>>>> is not bad even if wait is needed)
>>>>
>>> I do not understand what how this achieve the goal. Suppose that rmap
>>> == X and kvm->arch.being_unmapped_rmap == NULL so "goto retry" is skipped,
>>> but moment later unmap_memslot_rmap_nolock() does
>>> vm->arch.being_unmapped_rmap = X.
>>
>> Access rmap is always safe since rmap and its entries are valid until
>> memslot is destroyed.
>>
>> This algorithm protects spte since it can be freed in the protection of mmu-lock.
>>
>> In your scenario:
>>
>> ======
>>    CPU 1                                      CPU 2
>>
>> vcpu / mmu-notify access the RMAP         unmap rmap out of mmu-lock which is under
>> which is under mmu-lock                   slot-lock
>>
>> zap spte1
>> clear RMAP entry
>>
>> kvm->arch.being_unmapped_rmap = NULL,
>> do not wait
>>
>> free spte1
>>
>>                                         set kvm->arch.being_unmapped_rmap = RMAP
>>                                         walking RMAP and do not see spet1 on RMAP
>>                                         (the entry of spte 1 has been reset by CPU 1)
> and what prevents this from happening concurrently with "clear RMAP
> entry"? Is it safe?

All the possible changes on the RMAP entry is from valid-spte to PTE_LIST_SPTE_SKIP.
(no valid-spte to valid-spte / no spte to new-spte)

There are three possible cases:
case 1): both two paths can see the valid-spte.
         the worst case is, the host page can be double A/D tracked
         (multi calling of kvm_set_pfn_accessed/kvm_set_pfn_dirty), it is safe.

case 2): only the path under protection of mmu-lock see the valid-spte
         this is safe since RMAP and spte are always valid under mmu-lock

case 3): only the path out of mmu-lock see the valid-spte
         then the path under mmu-lock will being wait until the no-lock path has
         finished. The spte is valid and no-lock path is safe to call
         kvm_set_pfn_accessed/kvm_set_pfn_dirty.

Do you get any potential issue?


