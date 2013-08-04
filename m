Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752955Ab3HDOPf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Aug 2013 10:15:35 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44999 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752585Ab3HDOPd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Aug 2013 10:15:33 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Subject: Re: [RFC PATCH 00/12] KVM: MMU: locklessly wirte-protect
From: Xiao Guangrong <xiaoguangrong.eric@gmail.com>
In-Reply-To: <20130803140943.3e09bbcda47693789df06315@gmail.com>
Date: Sun, 4 Aug 2013 22:15:05 +0800
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        "gleb@redhat.com Natapov" <gleb@redhat.com>, avi.kivity@gmail.com,
        mtosatti@redhat.com,
        "pbonzini@redhat.com Bonzini" <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <C5B92ED2-6055-40A7-88FD-7425AFC1A626@gmail.com>
References: <1375189330-24066-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <20130803140943.3e09bbcda47693789df06315@gmail.com>
To: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
X-Mailer: Apple Mail (2.1508)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 3, 2013, at 1:09 PM, Takuya Yoshikawa <takuya.yoshikawa@gmail.com> wrote:

> On Tue, 30 Jul 2013 21:01:58 +0800
> Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com> wrote:
> 
>> Background
>> ==========
>> Currently, when mark memslot dirty logged or get dirty page, we need to
>> write-protect large guest memory, it is the heavy work, especially, we need to
>> hold mmu-lock which is also required by vcpu to fix its page table fault and
>> mmu-notifier when host page is being changed. In the extreme cpu / memory used
>> guest, it becomes a scalability issue.
>> 
>> This patchset introduces a way to locklessly write-protect guest memory.
> 
> Nice improvements!

Thank you!

> 
> If I read the patch set correctly, this work contains the following changes:
> 
> Cleanups:
>        Patch 1 and patch 12.
> 
> Lazy large page dropping for dirty logging:
>        Patch 2-3.
>        Patch 2 is preparatory to patch 3.
> 
>        This does not look like an RFC if you address Marcelo's comment.
>        Any reason to include this in an RFC patch set?

Right, these two patches are not really RFC since you guys have reviewed the
idea.

The reason i put these into this patchset is that they are also the preparing work
for implementing lockless writ-protection since after that we do not need to
remove a spte from the rmap any more. (only need to write-protect a spte.)

> 
> Making remote TLBs flushable outside of mmu_lock for dirty logging:
>        Patch 6.
> 
>        This is nice.  I'm locally using a similar patch for my work, but yours
>        is much cleaner and better.  I hope this will get merged soon.

Thanks!

> 
> New Pte-list handling:
>        Patch 7-9.
> 
>        Still reading the details.
> 
> RCU-based lockless write protection.
>        Patch 10-11.
> 
>        If I understand RCU correctly, the current implementation has a problem:
>        read-side critical sections can become too long.
> 
>        See the following LWN's article:
>        "Sleepable RCU"
>        https://lwn.net/Articles/202847/
> 
>        Especially, kvm_mmu_slot_remove_write_access() can take hundreds of
>        milliseconds, or even a few seconds for guests using shadow paging.
>        Is it possible to break the read-side critical section after protecting
>        some pages? -- I guess so.

Yes. we can use the break-tech in the code if it is needed, like this:

if (need_resched()) {
	kvm_use_rcu_free_page_end();
	kvm_use_rcu_free_page_begin();
}

> 
> Anyway, I want to see the following non-RFC quality patches get merged first:
>        - Lazy large page dropping for dirty logging:
>        - Making remote TLBs flushable outside of mmu_lock for dirty logging
> 
> As you are doing in patch 11, the latter can eliminate the TLB flushes before
> cond_resched_lock().  So this alone is an optimization, and since my work is
> based on this TLB flush-less lock breaking, I would appriciate if you make this
> change first in your clean way.

Okay, i will move these patches to the front then the maintainers can merge
them easily.

> 
> The remaining patches, pte-list refactoring and lock-less ones, also look
> interesting, but I need to read more to understand them.
> 
> Thanks for the nice work!

Thanks for your review and the comments! :)

