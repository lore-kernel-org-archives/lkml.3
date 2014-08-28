Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754359AbaH1Sut (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 14:50:49 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:39861 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754329AbaH1Suo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 14:50:44 -0400
Date: Thu, 28 Aug 2014 19:50:46 +0100
From: Will Deacon <will.deacon@arm.com>
To: axboe@kernel.dk, rusty@rustcorp.com.au, tj@kernel.org, hch@lst.de
Cc: linux-kernel@vger.kernel.org
Subject: 3.17-rc2 percpu-ref oops with virtblk remove
Message-ID: <20140828185046.GR22580@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

I've been debugging an issue triggered by virtio-blk and vfio on an
arm64 system running 3.17-rc2. The problem occurs when removing a
virtio-pci block device, which triggers the following warning in the
percpu-ref code:

WARNING: CPU: 0 PID: 1312 at lib/percpu-refcount.c:179 percpu_ref_kill_and_confirm+0x90/0x9c()
percpu_ref_kill() called more than once!
Modules linked in:
CPU: 0 PID: 1312 Comm: vfio-setup.sh Not tainted 3.17.0-rc2+ #5
Call trace:
[<ffffffc0002b68b0>] percpu_ref_kill_and_confirm+0x8c/0x9c
[<ffffffc0002938e8>] blk_mq_freeze_queue+0x34/0xc8
[<ffffffc000294dac>] blk_mq_free_queue+0x1c/0x10c
[<ffffffc00028cc1c>] blk_release_queue+0x68/0xa8
[<ffffffc0002a7208>] kobject_release+0x40/0x84
[<ffffffc0002a7284>] kobject_put+0x38/0x6c
[<ffffffc000288414>] blk_put_queue+0xc/0x18
[<ffffffc0002989b0>] disk_release+0x7c/0xb8
[<ffffffc0003245f0>] device_release+0x30/0x98
[<ffffffc0002a7208>] kobject_release+0x40/0x84
[<ffffffc0002a7284>] kobject_put+0x38/0x6c
[<ffffffc0002980cc>] put_disk+0x10/0x1c
[<ffffffc00033b010>] virtblk_remove+0x74/0xd4

Some more debugging shows that virtblk_remove earlier called
blk_cleanup_queue:

[<ffffffc0002b686c>] percpu_ref_kill_and_confirm+0x48/0x9c
[<ffffffc0002938e8>] blk_mq_freeze_queue+0x34/0xc8
[<ffffffc000288fd4>] blk_cleanup_queue+0x70/0xf4
[<ffffffc00033afe0>] virtblk_remove+0x44/0xd4

which ends up marking the percpu ref as dead and queues some RCU work
to switch over to the atomic_t version using call_rcu_sched. The
virtblk_remove function then continues happily and calls put_disk (first
backtrace above), which ends up trying to get exclusive access to the
queue by killing the usage counter and waiting for the percpu reference
to become zero. Unfortunately, since the reference is already marked as
dead, the call to percpu_ref_kill triggers the warning. Worse still, we
then queue the RCU callback a second time, which dies with something
like:

Unable to handle kernel paging request at virtual address 87f971000
pgd = ffffffc87aca8000
[87f971000] *pgd=0000000000000000, *pud=0000000000000000
Internal error: Oops: 96000005 [#1] PREEMPT SMP
Modules linked in:
CPU: 0 PID: 1312 Comm: systemd-udevd Tainted: G        W      3.17.0-rc2+ #9
task: ffffffc87bb89480 ti: ffffffc87ace0000 task.ti: ffffffc87ace0000
PC is at percpu_ref_kill_rcu+0x50/0x188
LR is at percpu_ref_kill_rcu+0x6c/0x188
pc : [<ffffffc0002b6a34>] lr : [<ffffffc0002b6a50>] pstate: 80000145
sp : ffffffc87ace3840
x29: ffffffc87ace3840 x28: ffffffc000470000 
x27: 0000000000000000 x26: ffffffc87ff74a00 
x25: ffffffc00061f238 x24: ffffffc07f858d68 
x23: ffffffc000657000 x22: ffffffc07f858d88 
x21: ffffffc00064bc68 x20: 0000000000000000 
x19: 0000000000000000 x18: 0000007fc81227e0 
x17: 0000007fb74f1194 x16: ffffffc000161a44 
x15: 0000007fb757b5a0 x14: 0000000000000008 
x13: 0000000000000000 x12: ffffffc000470c70 
x11: 0000000000000005 x10: 0101010101010101 
x9 : ffffffc000470c4b x8 : ffffffc000647318 
x7 : fffffffffffffe40 x6 : 0000000000005b00 
x5 : ffffffc00064bc68 x4 : 0000000000000038 
x3 : 00000000000000ff x2 : 0000000000000000 
x1 : ffffffc000657ee8 x0 : 000000087f971000 

because the percpu_ref has been freed from blk_mq_free_queue.

I'm not really sure how to fix this -- it seems like we shouldn't try to
kill a reference that is already dead, but using __pcpu_ref_alive isn't
the right answer. Simply removing the warning works for me (patch below),
but that also feels like a hack (we skip the confirm callback, for a
start).

Any ideas?

Will

--->8

diff --git a/lib/percpu-refcount.c b/lib/percpu-refcount.c
index fe5a3342e960..c2faa2a97dff 100644
--- a/lib/percpu-refcount.c
+++ b/lib/percpu-refcount.c
@@ -175,8 +175,8 @@ static void percpu_ref_kill_rcu(struct rcu_head *rcu)
 void percpu_ref_kill_and_confirm(struct percpu_ref *ref,
                                 percpu_ref_func_t *confirm_kill)
 {
-       WARN_ONCE(ref->pcpu_count_ptr & PCPU_REF_DEAD,
-                 "percpu_ref_kill() called more than once!\n");
+       if (ref->pcpu_count_ptr & PCPU_REF_DEAD)
+               return;
 
        ref->pcpu_count_ptr |= PCPU_REF_DEAD;
        ref->confirm_kill = confirm_kill;

