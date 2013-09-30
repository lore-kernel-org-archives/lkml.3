Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925Ab3I3Akf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 20:40:35 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:6225 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753419Ab3I3Akc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 20:40:32 -0400
Message-ID: <1380501626.2174.17.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH] rwsem: reduce spinlock contention in wakeup code path
From: Davidlohr Bueso <davidlohr@hp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>, Waiman Long <Waiman.Long@hp.com>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Alex Shi <alex.shi@intel.com>, Tim Chen <tim.c.chen@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Matthew R Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Date: Sun, 29 Sep 2013 17:40:26 -0700
In-Reply-To: <CA+55aFx1PErQQ8eR6JgQzmM0RZwyUtyc6CFfnvzzKz2RJa2GFw@mail.gmail.com>
References: <1380308424-31011-1-git-send-email-Waiman.Long@hp.com>
	 <CA+55aFxXeQ69B1bfrO+0QtBqm0gt688LOshx=ppNjch10JF8FQ@mail.gmail.com>
	 <20130928074144.GA17773@gmail.com>
	 <CA+55aFyx-Lpqd8i2tHvhXCqL+nJZPq-6SikEkb-cQZEU9ogRjA@mail.gmail.com>
	 <1380495986.2174.10.camel@buesod1.americas.hpqcorp.net>
	 <CA+55aFx1PErQQ8eR6JgQzmM0RZwyUtyc6CFfnvzzKz2RJa2GFw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-09-29 at 16:26 -0700, Linus Torvalds wrote:
> On Sun, Sep 29, 2013 at 4:06 PM, Davidlohr Bueso <davidlohr@hp.com> wrote:
> >>
> >> Btw, I really hate that thing. I think we should turn it back into a
> >> spinlock. None of what it protects needs a mutex or an rwsem.
> >
> > The same should apply to i_mmap_mutex, having a similar responsibility
> > to the anon-vma lock with file backed pages. A few months ago I had
> > suggested changing that lock to rwsem, giving some pretty reasonable
> > performance improvement numbers.
> >
> > http://lwn.net/Articles/556342/
> 
> Ok, that's pretty convincing too.
> 
> Side note: are you sure that the i_mmap_mutex needs to be a sleeping
> lock at all? It's documented to nest outside the anon_vma->rwsem, so
> as long as that is a sleeping lock, the i_mmap_mutex needs to be one
> too, but looking at the actual users, most of them seem to be *very*
> similar to the anon_vma->rwsem users. It is a very close cousin to the
> anon_vma->rwsem, after all (just for file-backed pages rather than
> anonymous ones). No?

Right, I brought that up exactly because it is so similar to the
anon-vma lock. Both should really be the same type, whether it be rwsem
or rwlock. Hopefully the rwlock conversion tests will also benefit just
like Ingo's patch did, I should have numbers early next week.

> 
> I dunno. Maybe the ranges are too big and it really has latency
> issues, the few I looked at looked like fairly trivial interval-tree
> operations, though.
> 
> And your numbers for Ingo's patch:
> 
> > After testing Ingo's anon-vma rwlock_t conversion (v2) on a 8 socket, 80
> > core system with aim7, I am quite surprised about the numbers -
> > considering the lack of queuing in rwlocks. A lot of the tests didn't
> > show hardly any difference, but those that really contend this lock
> > (with high amounts of users) benefited quite nicely:
> >
> > Alltests: +28% throughput after 1000 users and runtime was reduced from
> > 7.2 to 6.6 secs.
> >
> > Custom: +61% throughput after 100 users and runtime was reduced from 7
> > to 4.9 secs.
> >
> > High_systime: +40% throughput after 1000 users and runtime was reduced
> > from 19 to 15.5 secs.
> >
> > Shared: +30.5% throughput after 100 users and runtime was reduced from
> > 6.5 to 5.1 secs.
> >
> > Short: Lots of variance in the numbers, but avg of +29% throughput - no
> > particular performance degradation either.
> 
> Are just overwhelming, in my opinion. The conversion *from* a spinlock
> never had this kind of support behind it.
> 
> Btw, did anybody run Ingo's patch with lockdep and the spinlock sleep
> debugging code to verify that we haven't introduced any problems wrt
> sleeping since the lock was converted into a rw-semaphore?

Hmm, I'm getting the following at bootup:

=============================================
[ INFO: possible recursive locking detected ]
3.12.0-rc2+ #7 Not tainted
---------------------------------------------
qemu-kvm/64239 is trying to acquire lock:
 (&anon_vma->rwlock){+.+...}, at: [<ffffffff8115fba6>] mm_take_all_locks+0x146/0x190

but task is already holding lock:
 (&anon_vma->rwlock){+.+...}, at: [<ffffffff8115fba6>] mm_take_all_locks+0x146/0x190

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&anon_vma->rwlock);
  lock(&anon_vma->rwlock);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

4 locks held by qemu-kvm/64239:
 #0:  (&mm->mmap_sem){++++++}, at: [<ffffffff8117c25c>] do_mmu_notifier_register+0x13c/0x180
 #1:  (mm_all_locks_mutex){+.+...}, at: [<ffffffff8115fa9b>] mm_take_all_locks+0x3b/0x190
 #2:  (&mapping->i_mmap_mutex){+.+...}, at: [<ffffffff8115fb26>] mm_take_all_locks+0xc6/0x190
 #3:  (&anon_vma->rwlock){+.+...}, at: [<ffffffff8115fba6>] mm_take_all_locks+0x146/0x190

stack backtrace:
CPU: 51 PID: 64239 Comm: qemu-kvm Not tainted 3.12.0-rc2+ #7
Hardware name: HP ProLiant DL980 G7, BIOS P66 06/24/2011
 ffff8b9f79294a80 ffff8a9f7c375c08 ffffffff815802dc 0000000000000003
 ffff8b9f79294100 ffff8a9f7c375c38 ffffffff810bda34 ffff8b9f79294100
 ffff8b9f79294a80 ffff8b9f79294100 0000000000000000 ffff8a9f7c375c98
Call Trace:
 [<ffffffff815802dc>] dump_stack+0x49/0x5d
 [<ffffffff810bda34>] print_deadlock_bug+0xf4/0x100
 [<ffffffff810bf864>] validate_chain+0x504/0x7a0
 [<ffffffff810bfe0d>] __lock_acquire+0x30d/0x590
 [<ffffffff8115fba6>] ? mm_take_all_locks+0x146/0x190
 [<ffffffff810c0130>] lock_acquire+0xa0/0x110
 [<ffffffff8115fba6>] ? mm_take_all_locks+0x146/0x190
 [<ffffffff810bebcd>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff81585861>] _raw_write_lock+0x31/0x40
 [<ffffffff8115fba6>] ? mm_take_all_locks+0x146/0x190
 [<ffffffff8115fba6>] mm_take_all_locks+0x146/0x190
 [<ffffffff8117c196>] do_mmu_notifier_register+0x76/0x180
 [<ffffffff8117c2d3>] mmu_notifier_register+0x13/0x20
 [<ffffffffa0365f5c>] kvm_create_vm+0x22c/0x300 [kvm]
 [<ffffffffa03660e8>] kvm_dev_ioctl+0xb8/0x140 [kvm]
 [<ffffffff811a4569>] do_vfs_ioctl+0x89/0x350
 [<ffffffff8158e9b7>] ? sysret_check+0x1b/0x56
 [<ffffffff811a48d1>] SyS_ioctl+0xa1/0xb0

This is probably due to the change in vm_lock_anon_vma():

-               down_write_nest_lock(&anon_vma->root->rwsem, &mm->mmap_sem);
+               write_lock(&anon_vma->root->rwlock);



