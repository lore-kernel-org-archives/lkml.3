Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848Ab3H2HRO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 03:17:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32844 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751808Ab3H2HRM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 03:17:12 -0400
Date: Thu, 29 Aug 2013 10:16:06 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>, avi.kivity@gmail.com,
        mtosatti@redhat.com, pbonzini@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [RFC PATCH 00/12] KVM: MMU: locklessly wirte-protect
Message-ID: <20130829071606.GY22899@redhat.com>
References: <1375189330-24066-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <20130803140943.3e09bbcda47693789df06315@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130803140943.3e09bbcda47693789df06315@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 03, 2013 at 02:09:43PM +0900, Takuya Yoshikawa wrote:
> On Tue, 30 Jul 2013 21:01:58 +0800
> Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com> wrote:
> 
> > Background
> > ==========
> > Currently, when mark memslot dirty logged or get dirty page, we need to
> > write-protect large guest memory, it is the heavy work, especially, we need to
> > hold mmu-lock which is also required by vcpu to fix its page table fault and
> > mmu-notifier when host page is being changed. In the extreme cpu / memory used
> > guest, it becomes a scalability issue.
> > 
> > This patchset introduces a way to locklessly write-protect guest memory.
> 
> Nice improvements!
> 
> If I read the patch set correctly, this work contains the following changes:
> 
> Cleanups:
>         Patch 1 and patch 12.
> 
Yes, do not see the reason to not apply 1 straightaway. 12 depends on
other patches though.

> Lazy large page dropping for dirty logging:
>         Patch 2-3.
>         Patch 2 is preparatory to patch 3.
> 
>         This does not look like an RFC if you address Marcelo's comment.
>         Any reason to include this in an RFC patch set?
Agree, you can post them separately for faster inclusion.

> 
> Making remote TLBs flushable outside of mmu_lock for dirty logging:
>         Patch 6.
> 
>         This is nice.  I'm locally using a similar patch for my work, but yours
>         is much cleaner and better.  I hope this will get merged soon.
> 
But without other patches this patch itself doesn't do much, no?

> New Pte-list handling:
>         Patch 7-9.
> 
>         Still reading the details.
> 
> RCU-based lockless write protection.
>         Patch 10-11.
> 
>         If I understand RCU correctly, the current implementation has a problem:
>         read-side critical sections can become too long.
> 
>         See the following LWN's article:
>         "Sleepable RCU"
>         https://lwn.net/Articles/202847/
> 
>         Especially, kvm_mmu_slot_remove_write_access() can take hundreds of
>         milliseconds, or even a few seconds for guests using shadow paging.
>         Is it possible to break the read-side critical section after protecting
>         some pages? -- I guess so.
> 
> Anyway, I want to see the following non-RFC quality patches get merged first:
>         - Lazy large page dropping for dirty logging:
>         - Making remote TLBs flushable outside of mmu_lock for dirty logging
> 
> As you are doing in patch 11, the latter can eliminate the TLB flushes before
> cond_resched_lock().  So this alone is an optimization, and since my work is
> based on this TLB flush-less lock breaking, I would appriciate if you make this
> change first in your clean way.
> 
> The remaining patches, pte-list refactoring and lock-less ones, also look
> interesting, but I need to read more to understand them.
> 
> Thanks for the nice work!
Indeed. FWIW I completed the review and am waiting for a new version.

--
			Gleb.
