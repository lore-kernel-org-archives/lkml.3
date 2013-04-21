Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096Ab3DUG7v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 02:59:51 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:46577 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993Ab3DUG7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 02:59:49 -0400
Message-ID: <51738E5B.3030700@linux.vnet.ibm.com>
Date: Sun, 21 Apr 2013 14:59:39 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: gleb@redhat.com, avi.kivity@gmail.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v3 15/15] KVM: MMU: replace kvm_zap_all with kvm_mmu_invalid_all_pages
References: <1366093973-2617-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <1366093973-2617-16-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <20130418000812.GF31059@amt.cnet> <516F70A1.7010007@linux.vnet.ibm.com> <20130420171859.GA15140@amt.cnet>
In-Reply-To: <20130420171859.GA15140@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13042106-8878-0000-0000-000006C9D549
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/21/2013 01:18 AM, Marcelo Tosatti wrote:
> On Thu, Apr 18, 2013 at 12:03:45PM +0800, Xiao Guangrong wrote:
>> On 04/18/2013 08:08 AM, Marcelo Tosatti wrote:
>>> On Tue, Apr 16, 2013 at 02:32:53PM +0800, Xiao Guangrong wrote:
>>>> Use kvm_mmu_invalid_all_pages in kvm_arch_flush_shadow_all and
>>>> rename kvm_zap_all to kvm_free_all which is used to free all
>>>> memmory used by kvm mmu when vm is being destroyed, at this time,
>>>> no vcpu exists and mmu-notify has been unregistered, so we can
>>>> free the shadow pages out of mmu-lock
>>>
>>> Since there is no contention for mmu-lock its also not a problem to 
>>> grab the lock right?
>>
>> This still has contention. Other mmu-notify can happen when we handle
>> ->release(). On the other handle, spin-lock is not preemptable.
> 
> Don't think so:

Hi Marcelo,

The comment of ->release() says:

/*
	 * Called either by mmu_notifier_unregister or when the mm is
	 * being destroyed by exit_mmap, always before all pages are
	 * freed. This can run concurrently with other mmu notifier
	 * methods (the ones invoked outside the mm context)
> 
>         kvm_coalesced_mmio_free(kvm);
> #if defined(CONFIG_MMU_NOTIFIER) && defined(KVM_ARCH_WANT_MMU_NOTIFIER)
>         mmu_notifier_unregister(&kvm->mmu_notifier, kvm->mm);
> #else
>         kvm_arch_flush_shadow_all(kvm);
> #endif
>         kvm_arch_destroy_vm(kvm);

The contention does not exist in the code you listed above. It happens when
vm abnormally exits (for example, VM is killed). Please refer to
commit 3ad3d90 (mm: mmu_notifier: fix freed page still mapped in secondary MMU).
The current mmu-notify code is wrong and i have posted a patch to fix it which
can be found at:
http://marc.info/?l=kvm&m=136609583232031&w=2

Maybe i misunderstand your meaning. This patch tries to use kvm_mmu_invalid_all_pages
in ->release and rename kvm_zap_all to kvm_free_all. Do you mean we can still use
mmu-lock in kvm_free_all()? If yes, I do not have strong opinion on this point and
will keep kvm_free_all under the protection of mmu-lock.

> 
>>> Automated verification of locking/srcu might complain.
>>
>> We hold slot-lock to free shadow page out of mmu-lock, it can avoid
>> the complain. No?
> 
> Not if it realizes srcu is required to access the data structures.

It seems that kvm->srcu is only used to protect kvm->memslots, in kvm_memslots:

static inline struct kvm_memslots *kvm_memslots(struct kvm *kvm)
{
	return rcu_dereference_check(kvm->memslots,
			srcu_read_lock_held(&kvm->srcu)
			|| lockdep_is_held(&kvm->slots_lock));
}

kvm->memslots can be safely accessed when hold kvm->srcu _or_ slots_lock.

Thanks!

