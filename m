Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932432Ab3KFNVl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 08:21:41 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49039 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932411Ab3KFNVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 08:21:38 -0500
Date: Wed, 6 Nov 2013 05:20:49 -0800
From: tip-bot for John Stultz <tipbot@zytor.com>
Message-ID: <tip-db751fe3ea6880ff5ac5abe60cb7b80deb5a4140@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        mathieu.desnoyers@efficios.com, peterz@infradead.org,
        davem@davemloft.net, john.stultz@linaro.org, rostedt@goodmis.org,
        tglx@linutronix.de, lizefan@huawei.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mathieu.desnoyers@efficios.com, peterz@infradead.org,
        davem@davemloft.net, john.stultz@linaro.org, rostedt@goodmis.org,
        tglx@linutronix.de, lizefan@huawei.com
In-Reply-To: <1381186321-4906-4-git-send-email-john.stultz@linaro.org>
References: <1381186321-4906-4-git-send-email-john.stultz@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] cpuset: Fix potential deadlock w/
  set_mems_allowed
Git-Commit-ID: db751fe3ea6880ff5ac5abe60cb7b80deb5a4140
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 06 Nov 2013 05:20:55 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  db751fe3ea6880ff5ac5abe60cb7b80deb5a4140
Gitweb:     http://git.kernel.org/tip/db751fe3ea6880ff5ac5abe60cb7b80deb5a4140
Author:     John Stultz <john.stultz@linaro.org>
AuthorDate: Mon, 7 Oct 2013 15:52:00 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 6 Nov 2013 12:40:27 +0100

cpuset: Fix potential deadlock w/ set_mems_allowed

After adding lockdep support to seqlock/seqcount structures,
I started seeing the following warning:

[    1.070907] ======================================================
[    1.072015] [ INFO: SOFTIRQ-safe -> SOFTIRQ-unsafe lock order detected ]
[    1.073181] 3.11.0+ #67 Not tainted
[    1.073801] ------------------------------------------------------
[    1.074882] kworker/u4:2/708 [HC0[0]:SC0[0]:HE0:SE1] is trying to acquire:
[    1.076088]  (&p->mems_allowed_seq){+.+...}, at: [<ffffffff81187d7f>] new_slab+0x5f/0x280
[    1.077572]
[    1.077572] and this task is already holding:
[    1.078593]  (&(&q->__queue_lock)->rlock){..-...}, at: [<ffffffff81339f03>] blk_execute_rq_nowait+0x53/0xf0
[    1.080042] which would create a new lock dependency:
[    1.080042]  (&(&q->__queue_lock)->rlock){..-...} -> (&p->mems_allowed_seq){+.+...}
[    1.080042]
[    1.080042] but this new dependency connects a SOFTIRQ-irq-safe lock:
[    1.080042]  (&(&q->__queue_lock)->rlock){..-...}
[    1.080042] ... which became SOFTIRQ-irq-safe at:
[    1.080042]   [<ffffffff810ec179>] __lock_acquire+0x5b9/0x1db0
[    1.080042]   [<ffffffff810edfe5>] lock_acquire+0x95/0x130
[    1.080042]   [<ffffffff818968a1>] _raw_spin_lock+0x41/0x80
[    1.080042]   [<ffffffff81560c9e>] scsi_device_unbusy+0x7e/0xd0
[    1.080042]   [<ffffffff8155a612>] scsi_finish_command+0x32/0xf0
[    1.080042]   [<ffffffff81560e91>] scsi_softirq_done+0xa1/0x130
[    1.080042]   [<ffffffff8133b0f3>] blk_done_softirq+0x73/0x90
[    1.080042]   [<ffffffff81095dc0>] __do_softirq+0x110/0x2f0
[    1.080042]   [<ffffffff81095fcd>] run_ksoftirqd+0x2d/0x60
[    1.080042]   [<ffffffff810bc506>] smpboot_thread_fn+0x156/0x1e0
[    1.080042]   [<ffffffff810b3916>] kthread+0xd6/0xe0
[    1.080042]   [<ffffffff818980ac>] ret_from_fork+0x7c/0xb0
[    1.080042]
[    1.080042] to a SOFTIRQ-irq-unsafe lock:
[    1.080042]  (&p->mems_allowed_seq){+.+...}
[    1.080042] ... which became SOFTIRQ-irq-unsafe at:
[    1.080042] ...  [<ffffffff810ec1d3>] __lock_acquire+0x613/0x1db0
[    1.080042]   [<ffffffff810edfe5>] lock_acquire+0x95/0x130
[    1.080042]   [<ffffffff810b3df2>] kthreadd+0x82/0x180
[    1.080042]   [<ffffffff818980ac>] ret_from_fork+0x7c/0xb0
[    1.080042]
[    1.080042] other info that might help us debug this:
[    1.080042]
[    1.080042]  Possible interrupt unsafe locking scenario:
[    1.080042]
[    1.080042]        CPU0                    CPU1
[    1.080042]        ----                    ----
[    1.080042]   lock(&p->mems_allowed_seq);
[    1.080042]                                local_irq_disable();
[    1.080042]                                lock(&(&q->__queue_lock)->rlock);
[    1.080042]                                lock(&p->mems_allowed_seq);
[    1.080042]   <Interrupt>
[    1.080042]     lock(&(&q->__queue_lock)->rlock);
[    1.080042]
[    1.080042]  *** DEADLOCK ***

The issue stems from the kthreadd() function calling set_mems_allowed
with irqs enabled. While its possibly unlikely for the actual deadlock
to trigger, a fix is fairly simple: disable irqs before taking the
mems_allowed_seq lock.

Signed-off-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: Li Zefan <lizefan@huawei.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org
Link: http://lkml.kernel.org/r/1381186321-4906-4-git-send-email-john.stultz@linaro.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/cpuset.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
index cc1b01c..3fe661f 100644
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -110,10 +110,14 @@ static inline bool put_mems_allowed(unsigned int seq)
 
 static inline void set_mems_allowed(nodemask_t nodemask)
 {
+	unsigned long flags;
+
 	task_lock(current);
+	local_irq_save(flags);
 	write_seqcount_begin(&current->mems_allowed_seq);
 	current->mems_allowed = nodemask;
 	write_seqcount_end(&current->mems_allowed_seq);
+	local_irq_restore(flags);
 	task_unlock(current);
 }
 
