Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283Ab3I3Ixa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 04:53:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15594 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754154Ab3I3Ix0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 04:53:26 -0400
Date: Mon, 30 Sep 2013 10:52:43 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Waiman Long <Waiman.Long@hp.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Alex Shi <alex.shi@intel.com>, Tim Chen <tim.c.chen@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Matthew R Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        Haggai Eran <haggaie@mellanox.com>, Sagi Grimberg <sagig@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>, Jerome Glisse <jglisse@redhat.com>
Subject: Re: [PATCH] anon_vmas: Convert the rwsem to an rwlock_t
Message-ID: <20130930085243.GA25685@redhat.com>
References: <1380308424-31011-1-git-send-email-Waiman.Long@hp.com>
 <CA+55aFxXeQ69B1bfrO+0QtBqm0gt688LOshx=ppNjch10JF8FQ@mail.gmail.com>
 <20130928074144.GA17773@gmail.com>
 <CA+55aFyx-Lpqd8i2tHvhXCqL+nJZPq-6SikEkb-cQZEU9ogRjA@mail.gmail.com>
 <20130928192123.GA8228@gmail.com>
 <20130928193739.GA8642@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130928193739.GA8642@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

On Sat, Sep 28, 2013 at 09:37:39PM +0200, Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@kernel.org> wrote:
> 
> > If we do that then I suspect the next step will be queued rwlocks :-/ 
> > The current rwlock_t implementation is rather primitive by modern 
> > standards. (We'd probably have killed rwlock_t long ago if not for the 
> > tasklist_lock.)
> > 
> > But yeah, it would work and conceptually a hard spinlock fits something 
> > as lowlevel as the anon-vma lock.
> > 
> > I did a quick review pass and it appears nothing obvious is scheduling 
> > with the anon-vma lock held. If it did in a non-obvious way it's likely 
> > a bug anyway. The hugepage code grew a lot of logic running under the 
> > anon-vma lock, but it all seems atomic.
> > 
> > So a conversion to rwlock_t could be attempted. (It should be relatively 
> > easy patch as well, because the locking operation is now nicely 
> > abstracted out.)
> 
> Here's a totally untested patch to convert the anon vma lock to an 
> rwlock_t.

Sorry having to break the party but the sleepable locks for anon_vma
and i_mmap_mutex are now requirement for the "pageable RDMA" effort
recently achieved upstream by mellanox with the MMU notifier.

And as far as I can tell that's the only single good reason for why
those locks shouldn't be spinlocks (otherwise I would have also
complianed at the time of that conversion, the original regression was
known, ask Andi). After the lock conversion it took a while to fix all
other minor bits to make mmu notifier methods fully sleepable.

The problem with the spinlocks is that in the rmap code (like
try_to_unmap) we need to call mmu_notifier_invalidate_page with an
"mm" as parameter, and the callee assumes the "mm" won't go away under
it. The other second requirement is that the page cannot be freed
until we call the mmu_notifier_invalidate_page (secondary MMU is ok to
still access the page after the linux pte has been dropped and the TLB
flushed).

In the rmap code the only things that keep things afloat is either the
anon_vma lock or the i_mmap_mutex so it is quite tricky to drop that
lock while keeping "mm" and "page" both afloat for the invalidate
post-anon-vma-unlock.

Maybe there are ways to makes that safe? (reference counting,
trylocking the mmap_sem). But there isn't a very strightforward way to
do that.

It isn't just mellanox drivers: originally SGI XPMEM driver also
needed to schedule in those methods (then they figured how to get away
in only scheduling in the mmu_notifier range calls but I suppose they
prefer to be able to schedule in all invalidate methods including
mmu_notifier_invalidate_page).

Nvidia is now also going to use mmu notifier to allow the GPU (acting
as a secondary MMU with pagetables) to access main memory without
requiring RAM pinning and without disabling all VM features on the
graphics memory (and without GART physical). Probably they don't need
to schedule but I CC'ed Jerome just in case they need (as that would
add one more relevant user of the feature).

As far as KVM is concerned, there is no benefit in scheduling in the
methods. The KVM mmu notifier invalidate consists in zeroing out one
or more sptes and sending an IPI to flush the guest TLBs if others
vcpus are running in other cpus. It's a mechanism pretty much
identical to the one used by the primary MMU and it only requires irqs
enabled to avoid deadlocks in case of cross-IPIs.
