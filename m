Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019Ab3JCGqM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 02:46:12 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:44693 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005Ab3JCGqK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 02:46:10 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: [PATCH v2 05/15] KVM: MMU: flush tlb out of mmu lock when write-protect the sptes
From: Xiao Guangrong <xiaoguangrong.eric@gmail.com>
In-Reply-To: <20130930230524.GB31805@amt.cnet>
Date: Thu, 3 Oct 2013 14:46:03 +0800
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>, gleb@redhat.com,
        avi.kivity@gmail.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <D15C0FFF-A437-46A9-AF3E-1E31BD938B8B@gmail.com>
References: <1378376958-27252-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <1378376958-27252-6-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <20130930230524.GB31805@amt.cnet>
To: Marcelo Tosatti <mtosatti@redhat.com>
X-Mailer: Apple Mail (2.1510)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 1, 2013, at 7:05 AM, Marcelo Tosatti <mtosatti@redhat.com> wrote:

> On Thu, Sep 05, 2013 at 06:29:08PM +0800, Xiao Guangrong wrote:
>> Now we can flush all the TLBs out of the mmu lock without TLB corruption when
>> write-proect the sptes, it is because:
>> - we have marked large sptes readonly instead of dropping them that means we
>>  just change the spte from writable to readonly so that we only need to care
>>  the case of changing spte from present to present (changing the spte from
>>  present to nonpresent will flush all the TLBs immediately), in other words,
>>  the only case we need to care is mmu_spte_update()
>> 
>> - in mmu_spte_update(), we have checked
>>  SPTE_HOST_WRITEABLE | PTE_MMU_WRITEABLE instead of PT_WRITABLE_MASK, that
>>  means it does not depend on PT_WRITABLE_MASK anymore
>> 
>> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
>> ---
>> arch/x86/kvm/mmu.c | 18 ++++++++++++++----
>> arch/x86/kvm/x86.c |  9 +++++++--
>> 2 files changed, 21 insertions(+), 6 deletions(-)
>> 
>> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
>> index 7488229..a983570 100644
>> --- a/arch/x86/kvm/mmu.c
>> +++ b/arch/x86/kvm/mmu.c
>> @@ -4320,15 +4320,25 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm, int slot)
>> 			if (*rmapp)
>> 				__rmap_write_protect(kvm, rmapp, false);
>> 
>> -			if (need_resched() || spin_needbreak(&kvm->mmu_lock)) {
>> -				kvm_flush_remote_tlbs(kvm);
>> +			if (need_resched() || spin_needbreak(&kvm->mmu_lock))
>> 				cond_resched_lock(&kvm->mmu_lock);
>> -			}
>> 		}
>> 	}
>> 
>> -	kvm_flush_remote_tlbs(kvm);
>> 	spin_unlock(&kvm->mmu_lock);
>> +
>> +	/*
>> +	 * We can flush all the TLBs out of the mmu lock without TLB
>> +	 * corruption since we just change the spte from writable to
>> +	 * readonly so that we only need to care the case of changing
>> +	 * spte from present to present (changing the spte from present
>> +	 * to nonpresent will flush all the TLBs immediately), in other
>> +	 * words, the only case we care is mmu_spte_update() where we
>> +	 * haved checked SPTE_HOST_WRITEABLE | SPTE_MMU_WRITEABLE
>> +	 * instead of PT_WRITABLE_MASK, that means it does not depend
>> +	 * on PT_WRITABLE_MASK anymore.
>> +	 */
>> +	kvm_flush_remote_tlbs(kvm);
>> }
> 
> What about need_remote_flush? 

It is safe because before calling need_remote_flush mmu_pte_write_new_pte is called to
update the spte which will finally call set_spte() where the tlb flush has been properly checked.


