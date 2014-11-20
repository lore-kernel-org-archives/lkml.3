Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757935AbaKTRab (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 12:30:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36224 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756551AbaKTRa2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 12:30:28 -0500
Date: Thu, 20 Nov 2014 18:29:04 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Peter Feiner <pfeiner@google.com>
Cc: zhanghailiang <zhang.zhanghailiang@huawei.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andres Lagar-Cavilla <andreslc@google.com>,
        Dave Hansen <dave@sr71.net>, Paolo Bonzini <pbonzini@redhat.com>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Andy Lutomirski <luto@amacapital.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sasha.levin@oracle.com>, Hugh Dickins <hughd@google.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Christopher Covington <cov@codeaurora.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Neil Brown <neilb@suse.de>, Mike Hommey <mh@glandium.org>,
        Taras Glek <tglek@mozilla.com>, Jan Kara <jack@suse.cz>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Michel Lespinasse <walken@google.com>,
        Minchan Kim <minchan@kernel.org>, Keith Packard <keithp@keithp.com>,
        "Huangpeng (Peter)" <peter.huangpeng@huawei.com>,
        Isaku Yamahata <yamahata@valinux.co.jp>,
        Anthony Liguori <anthony@codemonkey.ws>,
        Stefan Hajnoczi <stefanha@gmail.com>,
        Wenchao Xia <wenchaoqemu@gmail.com>, Andrew Jones <drjones@redhat.com>,
        Juan Quintela <quintela@redhat.com>
Subject: Re: [PATCH 00/17] RFC: userfault v2
Message-ID: <20141120172904.GF803@redhat.com>
References: <1412356087-16115-1-git-send-email-aarcange@redhat.com>
 <544E1143.1080905@huawei.com>
 <20141029174607.GK19606@redhat.com>
 <545221A4.9030606@huawei.com>
 <20141031022327.GA13275@google.com>
 <5453022D.4040801@huawei.com>
 <20141031193932.GE38315@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141031193932.GE38315@google.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Oct 31, 2014 at 12:39:32PM -0700, Peter Feiner wrote:
> On Fri, Oct 31, 2014 at 11:29:49AM +0800, zhanghailiang wrote:
> > Agreed, but for doing live memory snapshot (VM is running when do snapsphot),
> > we have to do this (block the write action), because we have to save the page before it
> > is dirtied by writing action. This is the difference, compared to pre-copy migration.
> 
> Ah ha, I understand the difference now. I suppose that you have considered
> doing a traditional pre-copy migration (that is, passes over memory saving
> dirty pages, followed by a pause and a final dump of remaining dirty pages) to
> a file. Your approach has the advantage of having the VM pause time bounded by
> the time it takes to handle the userfault and do the write, as opposed to
> pre-copy migration which has a pause time bounded by the time it takes to do
> the final dump of dirty pages, which, in the worst case, is the time it takes
> to dump all of the guest memory!

It sounds really similar issue as live migration, one can implement a
precopy live snapshot, or a precopy+postcopy live snapshot or a pure
postcopy live snapshot.

The decision on the amount of precopy done before engaging postcopy
(zero passes, 1 pass, or more passes) would have similar tradeoffs
too, except instead of having to re-transmit the re-dirtied pages over
the wire, it would need to overwrite them to disk.

The more precopy passes, the longer it takes for the live snapshotting
process to finish and the more I/O there will be (for live migration it'd
be network bandwidth usage instead of amount of I/O), but the shortest
the postcopy runtime will be (and the shorter postcopy runtime is, the
fewer userfaults will end up triggering on writes, in turn reducing
the slowdown and the artificial fault latency introduced to the guest
runtime). But the more precopy passes the more overwriting will happen
during the "longer" precopy stage and the more overall load there will
be for the host (the otherwise idle part of the host).

For the postcopy live snapshot the wrprotect faults are quite
equivalent to the not-present faults of postcopy live migration logic.

> You could use the old fork & dump trick. Given that the guest's memory is
> backed by private VMA (as of a year ago when I last looked, is always the case
> for QEMU), you can have the kernel do the write protection for you.
> Essentially, you fork Qemu and, in the child process, dump the guest memory
> then exit. If the parent (including the guest) writes to guest memory, then it
> will fault and the kernel will copy the page. 
> 
> The fork & dump approach will give you the best performance w.r.t. guest pause
> times (i.e., just pausing for the COW fault handler), but it does have the
> distinct disadvantage of potentially using 2x the guest memory (i.e., if the
> parent process races ahead and writes to all of the pages before you finish the
> dump). To mitigate memory copying, you could madvise MADV_DONTNEED the child
> memory as you copy it.

This is a very good point. fork must be evaluated first because it
literally already provides you a readonly memory snapshot of the guest
memory.

The memory cons mentioned above could lead to both -ENOMEM of too many
guests runs live snapshots at the same time in the same host, unless
overcommit_memory is set to 1 (0 by default). Even then if too many
live snapshots are running in parallel you could hit the OOM killer if
there are just a bit too many faults at the same time, or you could
hit heavy swapping which isn't ideal either.

In fact the -ENOMEM avoidance (with qemu failing) is one of the two
critical reasons why qemu always set the guest memory as
MADV_DONTFORK. But that's not the only reason.

To use the fork() trick you'd need to undo the MADV_DONTFORK first but
that would open another problem: there's a race condition between
fork() O_DIRECT and <4k hardblocksize of virtio-blk. If there's any
read() syscall with O_DIRECT with len=512 while fork() is running
(think if the aio runs in parallel with the live snapshot thread that
forks the child to dump the snapshot) and if the guest writes with the
CPU to any 512 fragment of the same page that is the destination
buffer of the write(len=512) (on two different 512bytes area of the
same guest page) the O_DIRECT write will get lost.

So to use fork we'd need to fix this longstanding race (I tried but in
the end we declared it an userland issue because it's not exploitable
to bypass permissions or corrupt kernel or unrelated memory). Or you'd
need to add locking between the dataplane/aio threads and the live
snapshot thread to ensure no direct-io I/O is ever in-flight while
fork runs.

The O_DIRECT however would only help if it's qemu TCG, if it's KVM
it's not even enough to stop O_DIRECT reads. KVM would use
gup(write=1) from the async-pf all the time... and then the shadow
pagetables would go out of sync (it won't destabilize the host of
course, but the guest memory would be corrupt then and guest would
misbehave). In short all vcpu would need to be halted too in addition
to all direct-I/O. Possibly those gets stopped anyway before starting
the snapshot (they certainly are stopped before starting postcopy
live migration :).

Even if it'd be possible to serialize things in qemu to prevent the
race, unless we first fix fork vs o_direct race in the host kernel, I
wouldn't feel safe in removing MADV_DONTFORK and depend on fork for
the snapshotting. This is also because fork may still be used by qemu
in pci hotplug (to fork+exec but it cannot vfork because it has to
alter the signal handlers first). fork() is something people may do
without thinking it'll automatically trigger memory corruption in the
parent.

(If we'd use fork instead of userfaultfd for this, it'd also be nice
to add a madvise for THP, that will alter the COW faults on THP pages,
to copy only 4k and split the pmd into 512 ptes by default leaving 511
not-cowed pte readonly. The split_huge_page design change that adds a
failure path to split_huge_page would prevent having to split the
trans_huge_pmd on the child too, so it would be more efficient and
strightforward change than it would be if we'd add such a new madvise
right now. Redis would then use that new madvise too instead of
MADV_NOHUGEPAGE, as it uses fork for something similar as the above
live snapshot already and it creates random access cows that with THP
are copying and allocating more memory than with 4k pages. And
hopefully it's already getting the O_DIRECT race right if it happens
uses O_DIRECT + threads too.)

wrprotect userfaults would eliminate the need for fork, and they would
limit the maximal amount of memory allocated by the live snapshot to
the maximal number of asynchronous page faults multiplied by the
number of vcpus multiplied by the page size, and you can increase it
further by creating some buffering but you can still throttle it fine
to keep the buffer limited in size (not like with fork where the
buffer is potentially as large as the entire virtual machine
size). Furthermore you could in theory split the THP and map writable
only the 4k you copy during the wrprotect userfault (COW would always
cow the entire 2m increasing the latency of the fault in the parent).

Problem is, there are no kernel syscalls that allows you to mark all
trans_huge_pmds and ptes wrprotected without altering the vma too, and
we cannot mangle over vmas for doing these things as we could end up
with too many vmas and a -ENOMEM failure (not to tell the inefficiency
of such a load). So at the moment just adding the wrprotect faults to
the userfaultfd protocol isn't going to move the needle until you also
add new commands or syscalls to mangle pte/pmd wrprotect bits.

The real things to decide in API terms if those new operations (that
would likely be implemented in fremap.c) should be exposed to
userland as standalone syscalls that works similar to the
mremap/mprotect but never actually touch any vma and only hold the
mmap_sem for reading. Or if they should be embedded in the userfaultfd
wire protocol as additional commands to write into the ufd.

You'd need one syscall to mark all guest memory readonly. And then the
same syscall could be invoked on the 4k region that triggered
wrprotect-userfault to mark it writable again, just before writing the
same 4k region into the ufd to wakeup and retry the page fault.

The advantage of embedding all pte/pmd mangling inside special ufd
commands is that sometime the ufd write needed to wakeup the page
fault could be skipped (i.e. we could resolve the userfault with 1
syscall instead of 2). The downside is that it forces to change the
userfault protocol every time you want to add a new command. While if
we keep the ufd purely as a page fault event notification/wakeup
mechanism without allowing it to change the pte/pmds (and we leave the
task of mangling the pte/pmds to new syscalls), we could more easily
create a long lived userfault protocol that provides all features now
and we could extend the syscalls to mangle the address space with more
flexibility later.

Also the more commands that are only available through userfaultfd,
the more the MADV_USERFAULT for SIGBUS usage becomes less interesting
as SIGBUS would only provide a reduced set of features that cannot be
available without dealing with an userfaultfd. For example a wrprotect
fault (as result of the task forking) if the userfaultfd is closed
would then need to SIGBUS or not if only MADV_USERFAULT is set?

Until we added the wrprotect faults into the equation,
MADV_USERFAULT+SIGBUS was functionally equivalent (just less efficient
for multithreaded programs and uncapable of dealing with kernel
access). Once we add wrprotect faults I'm uncertain it is worth to
retain MADV_USERFAULT and SIGBUS.

The fast path branch that userfaultfd requires in the page fault does:

		/* Deliver the page fault to userland, check inside PT lock */
		if (vma->vm_flags & VM_USERFAULT) {
			pte_unmap_unlock(page_table, ptl);
			return handle_userfault(vma, address, flags);
		}

It'd be trivial to change it to:

		if (vma->vm_userfault_ctx != NULL_VM_USERFAULTFD_CTX) {
			pte_unmap_unlock(page_table, ptl);
			return handle_userfault(vma, address, flags);
		}

(and the whole block would still be optimized at build time with
CONFIG_USERFAULT=n for embedded without virt needs)

In short we need to decide 1) if to retain the MADV_USERFAULT+SIGBUS
behavior, and 2) if to expose the new commands needed to flip the
wrprotect bits without altering the vmas and to copy the pages
atomically as standalone syscalls or as new commands of the
userfaultfd wire protocol.

About the question if I intend to add wrprotect faults, the answer is
that I certainly do. I think it is good idea regardless of the live
snapshotting usage, because it also allows to more efficiently
implement distributed share memory too (allowing to map the memory
readonly if shared and to make it exclusive again on write access) if
anybody dares.

In theory the userfaultfd could also pre-cow the page and return you
the page through the read() syscall if we add a new protocol later to
accellerate it. But I think the current protocol shouldn't go that far
and we should aim for a protocol that is usable by all even if some
more operation will have to happen in userland than in the
accelerated version specific for live snapshotting (the in-kernel cow
wouldn't necessarily provide a significant speedup anyway).

Supporting only wrprotect faults should be fine by just defining two
bits during registration, one for not-present and one for wrprotect
faults then it's up to you if you set one of the two or both. (at
least one has to be set)

> I absolutely plan on releasing these patches :-) CRIU was the first open-source
> userland I had planned on integrating with. At Google, I'm working with our
> home-grown Qemu replacement. However, I'd be happy to help with an effort to
> get softdirty integrated in Qemu in the future.

Improving precopy by removing the software driven log buffer sounds
like a great to precopy. But I tend to agree with Zhang that it's
orthogonal with the actual postcopy stage that requires to block the
page fault not just track it later (for both live migration and live
snapshot). precopy is not getting obsoleted by postcopy, they just
work in tandem and that applies especially to live migration but I see
no reason why the same applies to live snapshotting like said above.

Comments welcome, thanks!
Andrea
