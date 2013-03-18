Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752487Ab3CROg3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 10:36:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23757 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470Ab3CROg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 10:36:28 -0400
X-Authority-Analysis: v=2.0 cv=BZhaI8R2 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=xnL9SfJxrHEA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=_f5G7fCCuGoA:10 a=a6v82dzNYnejLE2T3JYA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1363617383.25967.152.camel@gandalf.local.home>
Subject: workqueue code needing preemption disabled
From: Steven Rostedt <rostedt@goodmis.org>
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
        Clark Williams <clark@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Mon, 18 Mar 2013 10:36:23 -0400
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

I'm debugging a crash on -rt that has the following:

kernel BUG at kernel/sched/core.c:1731!
invalid opcode: 0000 [#1] PREEMPT SMP 
CPU 5 
Pid: 16637, comm: kworker/5:0 Not tainted 3.6.11-rt30.25.el6rt.x86_64 #1 HP ProLiant DL580 G7
RIP: 0010:[<ffffffff8151ebea>]  [<ffffffff8151ebea>] __schedule+0x89a/0x8c0
RSP: 0018:ffff880fec355c30  EFLAGS: 00010006
RAX: ffff880fff951900 RBX: ffff880fff951900 RCX: ffffffffff48fb8a
RDX: 0000000000000001 RSI: 0000000000000005 RDI: 0000000000000000
RBP: ffff880fec355cc0 R08: 0000000000000001 R09: 0000000000000004
R10: 0000000000000004 R11: 0000000000000002 R12: 0000000000000005
R13: ffff880f61b417a0 R14: ffff883fff051900 R15: ffff880fec355d00
FS:  0000000000000000(0000) GS:ffff880fff940000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000003e0e98bd30 CR3: 0000000fe0348000 CR4: 00000000000007e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process kworker/5:0 (pid: 16637, threadinfo ffff880fec354000, task ffff880fe46d8000)
Stack:
 ffff880fea074d80 ffff880fec354010 ffff880fec354000 ffff880fec354010
 ffff880fec354000 ffff880fec354010 ffff880fec354000 ffff880fec354010
 ffff880fec354000 ffff880fec355fd8 0000000000000286 ffff880fe46d8000
Call Trace:
 [<ffffffff8151ed69>] schedule+0x29/0x70
 [<ffffffff8151f8ed>] rt_spin_lock_slowlock+0x10d/0x310
 [<ffffffff81240500>] ? ioc_destroy_icq+0xe0/0xe0
 [<ffffffff81240500>] ? ioc_destroy_icq+0xe0/0xe0
 [<ffffffff815200e6>] rt_spin_lock+0x26/0x30
 [<ffffffff8106418b>] process_one_work+0x1ab/0x560
 [<ffffffff81065f3b>] worker_thread+0x16b/0x510
 [<ffffffff8151e76b>] ? __schedule+0x41b/0x8c0
 [<ffffffff81065dd0>] ? manage_workers+0x340/0x340
 [<ffffffff8106b246>] kthread+0x96/0xa0
 [<ffffffff81528664>] kernel_thread_helper+0x4/0x10
 [<ffffffff8106b1b0>] ? kthreadd+0x1e0/0x1e0
 [<ffffffff81528660>] ? gs_change+0xb/0xb
Code: c4 01 00 00 00 00 00 40 e9 86 f8 ff ff 83 be 90 02 00 00 00 0f 85
20 f8 ff ff 48 89 f7 e8 df a0 b5 ff e9 13 f8 ff ff 0f 0b eb fe <0f> 0b
0f 1f 40 00 eb fa e8 d9 00 00 00 e9 07 fe ff ff 0f 0b 66 

The bug occurred on this line:

static void try_to_wake_up_local(struct task_struct *p)
{
        struct rq *rq = task_rq(p);

        BUG_ON(rq != this_rq());  <---- bug here
        BUG_ON(p == current);
        lockdep_assert_held(&rq->lock);

        if (!raw_spin_trylock(&p->pi_lock)) {
                raw_spin_unlock(&rq->lock);
                raw_spin_lock(&p->pi_lock);
                raw_spin_lock(&rq->lock);
        }


Now in your code you have the comment:

 * X: During normal operation, modification requires gcwq->lock and
 *    should be done only from local cpu.  Either disabling preemption
 *    on local cpu or grabbing gcwq->lock is enough for read access.
 *    If GCWQ_DISASSOCIATED is set, it's identical to L.

struct worker has flags marked with X.
struct worker_pool has flags and idle_list marked with X.

spin_locks in -rt do not disable preemption, nor do they disable irqs,
but they do disable migration. If there's code that depends on the
spin_lock disabling preemption, we need to either change the code to not
require that, or explicitly disable preemption in the critical paths.
Note, if we explicitly disable preemption, we can not call spin_locks
within those locations as in -rt a spin_lock can block and schedule.

I've tried to figure out the code but I'm not familiar with it enough to
know where the issues are as of yet. I was hoping that you could point
me at the trouble areas that would cause us issues when spin_locks() do
not disable preemption.

Thanks!

-- Steve


