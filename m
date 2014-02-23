Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751314AbaBWHxg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 02:53:36 -0500
Received: from mail-la0-f43.google.com ([209.85.215.43]:64805 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbaBWHxe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 02:53:34 -0500
MIME-Version: 1.0
In-Reply-To: <20140221200725.GA19733@phenom.dumpdata.com>
References: <20140219071605.GA25092@falcon.amazon.com>
	<20140219174153.GH11365@phenom.dumpdata.com>
	<CAKbGBLjYWggnVeggj-d3-jTUqgFFwWyiih4VNM5yyuakd6yamg@mail.gmail.com>
	<CAKbGBLhm2krqjn98p1QGGPq=oNMpKNXUOKYZ9D9GRYLfEHCm-A@mail.gmail.com>
	<20140221200725.GA19733@phenom.dumpdata.com>
Date: Sat, 22 Feb 2014 23:53:31 -0800
Message-ID: <CAKbGBLjYQmty-YY+exiQ0wb-5==gMBY6qAz4a6tTvxSirJYEpQ@mail.gmail.com>
Subject: Re: [BISECTED] Xen HVM guest hangs since 3.12-rc5
From: Steven Noonan <steven@uplinklabs.net>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 21, 2014 at 12:07 PM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
> On Thu, Feb 20, 2014 at 12:44:15PM -0800, Steven Noonan wrote:
>> On Wed, Feb 19, 2014 at 1:01 PM, Steven Noonan <steven@uplinklabs.net> wrote:
>> > On Wed, Feb 19, 2014 at 9:41 AM, Konrad Rzeszutek Wilk
>> > <konrad.wilk@oracle.com> wrote:
>> >> On Tue, Feb 18, 2014 at 11:16:05PM -0800, Steven Noonan wrote:
>> >>> I've been running into problems on an Xen HVM domU. I've got a guest with NUMA
>> >>> enabled, 60GB of RAM, and 3 disks attached (including root volume). 2 of the
>> >>> disks are in an MD RAID0 in the guest, with an ext4 filesystem on top of that.
>> >>> I was running the fio 'iometer-file-access-server.fio' example config against
>> >>> that fs. During this workload, it would eventually cause a soft lockup, like
>> >>> the below:
>> >>
>> >> I presume since you mention NUMA and Mel is CC-ed that if you boot without
>> >> NUMA enabled (either via the toolstack or via Linux command line) - the issue
>> >> is not present?
>> >
>> > I mentioned NUMA because the bisected commit is sched/numa, and the
>> > guest is NUMA-enabled. I hadn't attempted booting with NUMA off. I
>> > just tried with numa=off, and the workload has run in a loop for 20
>> > minutes so far with no issues (normally the issue would repro in less
>> > than 5).
>>
>> The subject line is actually incorrect -- I did a 'git describe' on
>> the result of the bisection when writing the subject line, but the
>> '3.12-rc5' tag was just the base on which the code was originally
>> developed. As far as what tags actually contain the commit:
>>
>> $ git tag --contains b795854b1fa70f6aee923ae5df74ff7afeaddcaa
>> v3.13
>> v3.13-rc1
>> v3.13-rc2
>> v3.13-rc3
>> v3.13-rc4
>> v3.13-rc5
>> v3.13-rc6
>> v3.13-rc7
>> v3.13-rc8
>> v3.13.1
>> v3.13.2
>> v3.13.3
>> v3.14-rc1
>> v3.14-rc2
>>
>> So it's more accurate to say it was introduced in the v3.13 merge window.
>>
>> In any case, does anyone have any ideas?
>
> There is nothing in that git commit that gives that 'AHA' feeling.
>
> If you revert that patch on top of the latest Linux kernel does the problem
> go away? This is more of a double-check to see if the commit
> is really the fault or if it exposed some latent issue.

I just tried out 3.13.5 and the problem went away. Looking through the
commit logs, it appears this commit (added as part of 3.13.4) resolved
the issue:

commit 27b4328e523b3de854229e6b505f94aa9708dde6
Author: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date:   Thu Feb 6 12:04:24 2014 -0800

    mm: __set_page_dirty_nobuffers() uses spin_lock_irqsave() instead
of spin_lock_irq()

    commit a85d9df1ea1d23682a0ed1e100e6965006595d06 upstream.

    During aio stress test, we observed the following lockdep warning.  This
    mean AIO+numa_balancing is currently deadlockable.

    The problem is, aio_migratepage disable interrupt, but
    __set_page_dirty_nobuffers unintentionally enable it again.

    Generally, all helper function should use spin_lock_irqsave() instead of
    spin_lock_irq() because they don't know caller at all.

       other info that might help us debug this:
        Possible unsafe locking scenario:

              CPU0
              ----
         lock(&(&ctx->completion_lock)->rlock);
         <Interrupt>
           lock(&(&ctx->completion_lock)->rlock);

        *** DEADLOCK ***

          dump_stack+0x19/0x1b
          print_usage_bug+0x1f7/0x208
          mark_lock+0x21d/0x2a0
          mark_held_locks+0xb9/0x140
          trace_hardirqs_on_caller+0x105/0x1d0
          trace_hardirqs_on+0xd/0x10
          _raw_spin_unlock_irq+0x2c/0x50
          __set_page_dirty_nobuffers+0x8c/0xf0
          migrate_page_copy+0x434/0x540
          aio_migratepage+0xb1/0x140
          move_to_new_page+0x7d/0x230
          migrate_pages+0x5e5/0x700
          migrate_misplaced_page+0xbc/0xf0
          do_numa_page+0x102/0x190
          handle_pte_fault+0x241/0x970
          handle_mm_fault+0x265/0x370
          __do_page_fault+0x172/0x5a0
          do_page_fault+0x1a/0x70
          page_fault+0x28/0x30

    Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
    Cc: Larry Woodman <lwoodman@redhat.com>
    Cc: Rik van Riel <riel@redhat.com>
    Cc: Johannes Weiner <jweiner@redhat.com>
    Acked-by: David Rientjes <rientjes@google.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

>>
>> >>>
>> >>> [ 2536.250054] BUG: soft lockup - CPU#0 stuck for 23s! [kworker/u257:0:7]
>> >>> [ 2536.250054] Modules linked in: isofs crct10dif_pclmul crct10dif_common crc32_pclmul crc32c_intel ghash_clmulni_intel aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd raid0 md_mod acpi_cpufreq psmouse i2c_piix4 intel_agp intel_gtt i2c_core processor serio_raw evdev microcode ext4 crc16 mbcache jbd2 ata_generic pata_acpi ata_piix libata scsi_mod floppy ixgbevf xen_privcmd xen_netfront xen_kbdfront syscopyarea sysfillrect sysimgblt fb_sys_fops xen_blkfront virtio_pci virtio_net virtio_blk virtio_ring virtio ipmi_poweroff ipmi_msghandler button
>> >>> [ 2536.250054] CPU: 0 PID: 7 Comm: kworker/u257:0 Tainted: G        W    3.12.0-rc4-bisect-00073-g6fe6b2d #26
>> >>> [ 2536.250054] Hardware name: Xen HVM domU, BIOS 4.2.amazon 01/14/2014
>> >>> [ 2536.250054] Workqueue: writeback bdi_writeback_workfn (flush-202:0)
>> >>> [ 2536.250054] task: ffff880766533400 ti: ffff88076652e000 task.ti: ffff88076652e000
>> >>> [ 2536.250054] RIP: 0010:[<ffffffff810cc518>]  [<ffffffff810cc518>] smp_call_function_many+0x258/0x2b0
>> >>> [ 2536.250054] RSP: 0018:ffff88076652f878  EFLAGS: 00000202
>> >>> [ 2536.250054] RAX: 000000000000000f RBX: ffff88076652f808 RCX: ffff880ef0ef74a8
>> >>> [ 2536.250054] RDX: 000000000000000f RSI: 0000000000000080 RDI: 0000000000000000
>> >>> [ 2536.250054] RBP: ffff88076652f8c0 R08: ffff880771046c00 R09: ffff880770c008e0
>> >>> [ 2536.250054] R10: 000000000000003e R11: 0000000000000210 R12: ffff88076652f7f0
>> >>> [ 2536.250054] R13: ffffffff810b859e R14: ffff88076652f7e0 R15: ffffffff810b50e7
>> >>> [ 2536.250054] FS:  0000000000000000(0000) GS:ffff880771600000(0000) knlGS:0000000000000000
>> >>> [ 2536.250054] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> >>> [ 2536.250054] CR2: 00007f8752bea000 CR3: 0000000001a0d000 CR4: 00000000001406f0
>> >>> [ 2536.250054] Stack:
>> >>> [ 2536.250054]  0000000181275231 0000000000014d00 ffff88076652f8d0 ffffffff810564e0
>> >>> [ 2536.250054]  ffff88076530b180 00007f0c8826a000 ffff880ed4d57700 ffff88076530b180
>> >>> [ 2536.250054]  ffff880ed4cc6350 ffff88076652f8e8 ffffffff81056637 ffff88076530b180
>> >>> [ 2536.250054] Call Trace:
>> >>> [ 2536.250054]  [<ffffffff810564e0>] ? leave_mm+0x70/0x70
>> >>> [ 2536.250054]  [<ffffffff81056637>] native_flush_tlb_others+0x37/0x40
>> >>> [ 2536.250054]  [<ffffffff81056988>] flush_tlb_page+0x88/0x90
>> >>> [ 2536.250054]  [<ffffffff8117bb94>] ptep_clear_flush+0x34/0x40
>> >>> [ 2536.250054]  [<ffffffff81175b1e>] page_mkclean+0x12e/0x1d0
>> >>> [ 2536.250054]  [<ffffffff8114aeeb>] clear_page_dirty_for_io+0x3b/0xe0
>> >>> [ 2536.250054]  [<ffffffffa016fd52>] mpage_submit_page+0x52/0x80 [ext4]
>> >>> [ 2536.250054]  [<ffffffffa016fe89>] mpage_process_page_bufs+0x109/0x140 [ext4]
>> >>> [ 2536.250054]  [<ffffffffa01700d7>] mpage_prepare_extent_to_map+0x217/0x2d0 [ext4]
>> >>> [ 2536.250054]  [<ffffffffa0174929>] ext4_writepages+0x469/0xca0 [ext4]
>> >>> [ 2536.250054]  [<ffffffff8114cd3e>] do_writepages+0x1e/0x50
>> >>> [ 2536.250054]  [<ffffffff811d7716>] __writeback_single_inode+0x76/0x240
>> >>> [ 2536.250054]  [<ffffffff811d7c12>] writeback_sb_inodes+0x282/0x420
>> >>> [ 2536.250054]  [<ffffffff811d7e2f>] __writeback_inodes_wb+0x7f/0xd0
>> >>> [ 2536.250054]  [<ffffffff811d884b>] wb_writeback+0x15b/0x2a0
>> >>> [ 2536.250054]  [<ffffffff811d8fa7>] bdi_writeback_workfn+0x1d7/0x450
>> >>> [ 2536.250054]  [<ffffffff8107be4d>] process_one_work+0x25d/0x460
>> >>> [ 2536.250054]  [<ffffffff8107d196>] worker_thread+0x266/0x480
>> >>> [ 2536.250054]  [<ffffffff8107cf30>] ? manage_workers.isra.18+0x3f0/0x3f0
>> >>> [ 2536.250054]  [<ffffffff81083bcb>] kthread+0xbb/0xd0
>> >>> [ 2536.250054]  [<ffffffff81083b10>] ? kthread_stop+0xf0/0xf0
>> >>> [ 2536.250054]  [<ffffffff814d4dbc>] ret_from_fork+0x7c/0xb0
>> >>> [ 2536.250054]  [<ffffffff81083b10>] ? kthread_stop+0xf0/0xf0
>> >>> [ 2536.250054] Code: 00 74 70 48 63 35 d1 1f a1 00 ba ff ff ff ff eb 29 66 90 48 98 48 8b 0b 48 03 0c c5 00 27 ad 81 f6 41 20 01 74 14 0f 1f 44 00 00 <f3> 90 f6 41 20 01 75 f8 48 63 35 a1 1f a1 00 48 8b 7b 08 83 c2
>> >>> [ 2544.900055] BUG: soft lockup - CPU#31 stuck for 24s! [systemd-journal:304]
>> >>> [ 2544.900055] Modules linked in: isofs crct10dif_pclmul crct10dif_common crc32_pclmul crc32c_intel ghash_clmulni_intel aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd raid0 md_mod acpi_cpufreq psmouse i2c_piix4 intel_agp intel_gtt i2c_core processor serio_raw evdev microcode ext4 crc16 mbcache jbd2 ata_generic pata_acpi ata_piix libata scsi_mod floppy ixgbevf xen_privcmd xen_netfront xen_kbdfront syscopyarea sysfillrect sysimgblt fb_sys_fops xen_blkfront virtio_pci virtio_net virtio_blk virtio_ring virtio ipmi_poweroff ipmi_msghandler button
>> >>> [ 2544.900055] CPU: 31 PID: 304 Comm: systemd-journal Tainted: G        W    3.12.0-rc4-bisect-00073-g6fe6b2d #26
>> >>> [ 2544.900055] Hardware name: Xen HVM domU, BIOS 4.2.amazon 01/14/2014
>> >>> [ 2544.900055] task: ffff880764bcb400 ti: ffff8807653f6000 task.ti: ffff8807653f6000
>> >>> [ 2544.900055] RIP: 0010:[<ffffffff810cc040>]  [<ffffffff810cc040>] generic_exec_single+0x80/0xa0
>> >>> [ 2544.900055] RSP: 0018:ffff8807653f7c80  EFLAGS: 00000202
>> >>> [ 2544.900055] RAX: 0000000000000080 RBX: ffffffff813207fd RCX: 0000000000000080
>> >>> [ 2544.900055] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 0000000000000080
>> >>> [ 2544.900055] RBP: ffff8807653f7cb0 R08: ffffffff8160d148 R09: ffff880770c006a8
>> >>> [ 2544.900055] R10: 0000000000000020 R11: ffffea003b490700 R12: ffffffff810b859e
>> >>> [ 2544.900055] R13: ffff8807653f7bf8 R14: ffffffff810b50e7 R15: ffff8807653f7be8
>> >>> [ 2544.900055] FS:  00007f0c934cd780(0000) GS:ffff880ef0fe0000(0000) knlGS:0000000000000000
>> >>> [ 2544.900055] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> >>> [ 2544.900055] CR2: 00007f0c934db000 CR3: 0000000764b0f000 CR4: 00000000001406e0
>> >>> [ 2544.900055] Stack:
>> >>> [ 2544.900055]  0000000106038000 000000000000000f 000000000000001f ffffffff81adcfe0
>> >>> [ 2544.900055]  ffffffff810564e0 000000000000001f ffff8807653f7d20 ffffffff810cc195
>> >>> [ 2544.900055]  00007f0c934db000 ffff8807653f7cd8 ffff880ef0ef74a8 ffff880ef0ef4d00
>> >>> [ 2544.900055] Call Trace:
>> >>> [ 2544.900055]  [<ffffffff810564e0>] ? leave_mm+0x70/0x70
>> >>> [ 2544.900055]  [<ffffffff810cc195>] smp_call_function_single+0x135/0x170
>> >>> [ 2544.900055]  [<ffffffff810564e0>] ? leave_mm+0x70/0x70
>> >>> [ 2544.900055]  [<ffffffff810cc3c5>] smp_call_function_many+0x105/0x2b0
>> >>> [ 2544.900055]  [<ffffffff810564e0>] ? leave_mm+0x70/0x70
>> >>> [ 2544.900055]  [<ffffffff81056637>] native_flush_tlb_others+0x37/0x40
>> >>> [ 2544.900055]  [<ffffffff810568ae>] flush_tlb_mm_range+0x1fe/0x250
>> >>> [ 2544.900055]  [<ffffffff81167917>] tlb_flush_mmu+0x37/0xa0
>> >>> [ 2544.900055]  [<ffffffff81167994>] tlb_finish_mmu+0x14/0x50
>> >>> [ 2544.900055]  [<ffffffff8116fdc5>] unmap_region+0x105/0x120
>> >>> [ 2544.900055]  [<ffffffff811cd01e>] ? mntput_no_expire+0x3e/0x140
>> >>> [ 2544.900055]  [<ffffffff81170349>] ? vma_rb_erase+0x1c9/0x210
>> >>> [ 2544.900055]  [<ffffffff81171f10>] do_munmap+0x280/0x370
>> >>> [ 2544.900055]  [<ffffffff81172041>] vm_munmap+0x41/0x60
>> >>> [ 2544.900055]  [<ffffffff81172f42>] SyS_munmap+0x22/0x30
>> >>> [ 2544.900055]  [<ffffffff814d4e6d>] system_call_fastpath+0x1a/0x1f
>> >>> [ 2544.900055] Code: 48 89 4b 08 48 89 19 e8 4f 05 40 00 4d 39 fc 8b 55 d4 75 0f 44 89 f7 ff 15 5e 8d 95 00 8b 55 d4 0f 1f 00 85 d2 75 06 eb 0a 66 90 <f3> 90 f6 43 20 01 75 f8 48 83 c4 08 5b 41 5c 41 5d 41 5e 41 5f
>> >>>
>> >>> At this point, the MD array will not accept any I/O, and any requests will just
>> >>> result in additional soft lockup messages.
>> >>>
>> >>> I originally noticed this issue on Linux 3.13.3, and wasn't able to reproduce
>> >>> it on 3.10.30. I eventually narrowed it down to a regression introduced between
>> >>> 3.12 and 3.13. A bisection blames this commit:
>> >>>
>> >>> commit b795854b1fa70f6aee923ae5df74ff7afeaddcaa
>> >>> Author: Mel Gorman <mgorman@suse.de>
>> >>> Date:   Mon Oct 7 11:29:07 2013 +0100
>> >>>
>> >>>     sched/numa: Set preferred NUMA node based on number of private faults
>> >>>
>> >>>     Ideally it would be possible to distinguish between NUMA hinting faults that
>> >>>     are private to a task and those that are shared. If treated identically
>> >>>     there is a risk that shared pages bounce between nodes depending on
>> >>>     the order they are referenced by tasks. Ultimately what is desirable is
>> >>>     that task private pages remain local to the task while shared pages are
>> >>>     interleaved between sharing tasks running on different nodes to give good
>> >>>     average performance. This is further complicated by THP as even
>> >>>     applications that partition their data may not be partitioning on a huge
>> >>>     page boundary.
>> >>>
>> >>>     To start with, this patch assumes that multi-threaded or multi-process
>> >>>     applications partition their data and that in general the private accesses
>> >>>     are more important for cpu->memory locality in the general case. Also,
>> >>>     no new infrastructure is required to treat private pages properly but
>> >>>     interleaving for shared pages requires additional infrastructure.
>> >>>
>> >>>     To detect private accesses the pid of the last accessing task is required
>> >>>     but the storage requirements are a high. This patch borrows heavily from
>> >>>     Ingo Molnar's patch "numa, mm, sched: Implement last-CPU+PID hash tracking"
>> >>>     to encode some bits from the last accessing task in the page flags as
>> >>>     well as the node information. Collisions will occur but it is better than
>> >>>     just depending on the node information. Node information is then used to
>> >>>     determine if a page needs to migrate. The PID information is used to detect
>> >>>     private/shared accesses. The preferred NUMA node is selected based on where
>> >>>     the maximum number of approximately private faults were measured. Shared
>> >>>     faults are not taken into consideration for a few reasons.
>> >>>
>> >>>     First, if there are many tasks sharing the page then they'll all move
>> >>>     towards the same node. The node will be compute overloaded and then
>> >>>     scheduled away later only to bounce back again. Alternatively the shared
>> >>>     tasks would just bounce around nodes because the fault information is
>> >>>     effectively noise. Either way accounting for shared faults the same as
>> >>>     private faults can result in lower performance overall.
>> >>>
>> >>>     The second reason is based on a hypothetical workload that has a small
>> >>>     number of very important, heavily accessed private pages but a large shared
>> >>>     array. The shared array would dominate the number of faults and be selected
>> >>>     as a preferred node even though it's the wrong decision.
>> >>>
>> >>>     The third reason is that multiple threads in a process will race each
>> >>>     other to fault the shared page making the fault information unreliable.
>> >>>
>> >>>     Signed-off-by: Mel Gorman <mgorman@suse.de>
>> >>>     [ Fix complication error when !NUMA_BALANCING. ]
>> >>>     Reviewed-by: Rik van Riel <riel@redhat.com>
>> >>>     Cc: Andrea Arcangeli <aarcange@redhat.com>
>> >>>     Cc: Johannes Weiner <hannes@cmpxchg.org>
>> >>>     Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
>> >>>     Signed-off-by: Peter Zijlstra <peterz@infradead.org>
>> >>>     Link: http://lkml.kernel.org/r/1381141781-10992-30-git-send-email-mgorman@suse.de
>> >>>     Signed-off-by: Ingo Molnar <mingo@kernel.org>
>> >>>
>> >>> Here's the bisection log:
>> >>>
>> >>>  # bad:  [d8ec26d7] Linux 3.13
>> >>>  # good: [5e01dc7b] Linux 3.12
>> >>>  # bad:  [42a2d923] Merge git://git.kernel.org/pub/scm/linux/kernel/gi
>> >>>  # bad:  [4b4d2b46] Merge tag 'h8300-for-linus' of git://git.kernel.or
>> >>>  # skip: [c224b76b] Merge tag 'nfs-for-3.13-1' of git://git.linux-nfs.
>> >>>  # good: [ae1dd9bc] Staging: xillybus: quoted strings split across lin
>> >>>  # good: [beb5bfe4] Merge tag 'fixes-nc-for-linus' of git://git.kernel
>> >>>  # good: [f9efbce6] Merge tag 'dt-for-linus' of git://git.kernel.org/p
>> >>>  # good: [ad5d6989] Merge branch 'perf-core-for-linus' of git://git.ke
>> >>>  # bad:  [39cf275a] Merge branch 'sched-core-for-linus' of git://git.k
>> >>>  # good: [e6628d5b] sched/numa: Reschedule task on preferred NUMA node
>> >>>  # bad:  [04bb2f94] sched/numa: Adjust scan rate in task_numa_placemen
>> >>>  # bad:  [e1dda8a7] sched/numa: Fix placement of workloads spread acro
>> >>>  # bad:  [58d081b5] sched/numa: Avoid overloading CPUs on a preferred
>> >>>  # good: [073b5bee] sched/numa: Remove check that skips small VMAs
>> >>>  # bad:  [6fe6b2d6] sched/numa: Do not migrate memory immediately afte
>> >>>  # bad:  [b795854b] sched/numa: Set preferred NUMA node based on numbe
>> >>>
>> >>> Anyone have any ideas why this change broke things? Is there any additional
>> >>> information I can provide to help pin this down?
>> >>>
>> >>> - Steven
