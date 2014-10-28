Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408AbaJ1LEK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 07:04:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50938 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755335AbaJ1LEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 07:04:05 -0400
Date: Tue, 28 Oct 2014 04:02:57 -0700
From: tip-bot for Kirill Tkhai <tipbot@zytor.com>
Message-ID: <tip-6419265899d9bd27e5ff9f8b43db3715407fc2ba@git.kernel.org>
Cc: tglx@linutronix.de, rientjes@google.com, ktkhai@parallels.com,
        keescook@chromium.org, axboe@fb.com, peterz@infradead.org,
        linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com,
        torvalds@linux-foundation.org, raistlin@linux.it, mingo@kernel.org,
        akpm@linux-foundation.org, hpa@zytor.com, riel@redhat.com,
        atomlin@redhat.com
Reply-To: linux-kernel@vger.kernel.org, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, torvalds@linux-foundation.org,
        raistlin@linux.it, mingo@kernel.org, akpm@linux-foundation.org,
        hpa@zytor.com, riel@redhat.com, atomlin@redhat.com, tglx@linutronix.de,
        rientjes@google.com, ktkhai@parallels.com, keescook@chromium.org,
        axboe@fb.com
In-Reply-To: <1413455977.24793.78.camel@tkhai>
References: <1413455977.24793.78.camel@tkhai>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/fair:
  Fix division by zero sysctl_numa_balancing_scan_size
Git-Commit-ID: 6419265899d9bd27e5ff9f8b43db3715407fc2ba
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6419265899d9bd27e5ff9f8b43db3715407fc2ba
Gitweb:     http://git.kernel.org/tip/6419265899d9bd27e5ff9f8b43db3715407fc2ba
Author:     Kirill Tkhai <ktkhai@parallels.com>
AuthorDate: Thu, 16 Oct 2014 14:39:37 +0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 28 Oct 2014 10:46:04 +0100

sched/fair: Fix division by zero sysctl_numa_balancing_scan_size

File /proc/sys/kernel/numa_balancing_scan_size_mb allows writing of zero.

This bash command reproduces problem:

$ while :; do echo 0 > /proc/sys/kernel/numa_balancing_scan_size_mb; \
	   echo 256 > /proc/sys/kernel/numa_balancing_scan_size_mb; done

	divide error: 0000 [#1] SMP
	Modules linked in:
	CPU: 0 PID: 24112 Comm: bash Not tainted 3.17.0+ #8
	Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
	task: ffff88013c852600 ti: ffff880037a68000 task.ti: ffff880037a68000
	RIP: 0010:[<ffffffff81074191>]  [<ffffffff81074191>] task_scan_min+0x21/0x50
	RSP: 0000:ffff880037a6bce0  EFLAGS: 00010246
	RAX: 0000000000000a00 RBX: 00000000000003e8 RCX: 0000000000000000
	RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88013c852600
	RBP: ffff880037a6bcf0 R08: 0000000000000001 R09: 0000000000015c90
	R10: ffff880239bf6c00 R11: 0000000000000016 R12: 0000000000003fff
	R13: ffff88013c852600 R14: ffffea0008d1b000 R15: 0000000000000003
	FS:  00007f12bb048700(0000) GS:ffff88007da00000(0000) knlGS:0000000000000000
	CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
	CR2: 0000000001505678 CR3: 0000000234770000 CR4: 00000000000006f0
	Stack:
	 ffff88013c852600 0000000000003fff ffff880037a6bd18 ffffffff810741d1
	 ffff88013c852600 0000000000003fff 000000000002bfff ffff880037a6bda8
	 ffffffff81077ef7 ffffea0008a56d40 0000000000000001 0000000000000001
	Call Trace:
	 [<ffffffff810741d1>] task_scan_max+0x11/0x40
	 [<ffffffff81077ef7>] task_numa_fault+0x1f7/0xae0
	 [<ffffffff8115a896>] ? migrate_misplaced_page+0x276/0x300
	 [<ffffffff81134a4d>] handle_mm_fault+0x62d/0xba0
	 [<ffffffff8103e2f1>] __do_page_fault+0x191/0x510
	 [<ffffffff81030122>] ? native_smp_send_reschedule+0x42/0x60
	 [<ffffffff8106dc00>] ? check_preempt_curr+0x80/0xa0
	 [<ffffffff8107092c>] ? wake_up_new_task+0x11c/0x1a0
	 [<ffffffff8104887d>] ? do_fork+0x14d/0x340
	 [<ffffffff811799bb>] ? get_unused_fd_flags+0x2b/0x30
	 [<ffffffff811799df>] ? __fd_install+0x1f/0x60
	 [<ffffffff8103e67c>] do_page_fault+0xc/0x10
	 [<ffffffff8150d322>] page_fault+0x22/0x30
	RIP  [<ffffffff81074191>] task_scan_min+0x21/0x50
	RSP <ffff880037a6bce0>
	---[ end trace 9a826d16936c04de ]---

Also fix race in task_scan_min (it depends on compiler behaviour).

Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Aaron Tomlin <atomlin@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Dario Faggioli <raistlin@linux.it>
Cc: David Rientjes <rientjes@google.com>
Cc: Jens Axboe <axboe@fb.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Rik van Riel <riel@redhat.com>
Link: http://lkml.kernel.org/r/1413455977.24793.78.camel@tkhai
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 5 +++--
 kernel/sysctl.c     | 3 ++-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index e9abd4e..34baa60 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -828,11 +828,12 @@ static unsigned int task_nr_scan_windows(struct task_struct *p)
 
 static unsigned int task_scan_min(struct task_struct *p)
 {
+	unsigned int scan_size = ACCESS_ONCE(sysctl_numa_balancing_scan_size);
 	unsigned int scan, floor;
 	unsigned int windows = 1;
 
-	if (sysctl_numa_balancing_scan_size < MAX_SCAN_WINDOW)
-		windows = MAX_SCAN_WINDOW / sysctl_numa_balancing_scan_size;
+	if (scan_size < MAX_SCAN_WINDOW)
+		windows = MAX_SCAN_WINDOW / scan_size;
 	floor = 1000 / windows;
 
 	scan = sysctl_numa_balancing_scan_period_min / task_nr_scan_windows(p);
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 4aada6d..15f2511 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -387,7 +387,8 @@ static struct ctl_table kern_table[] = {
 		.data		= &sysctl_numa_balancing_scan_size,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &one,
 	},
 	{
 		.procname	= "numa_balancing",
