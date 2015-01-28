Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759193AbbA1VTC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 16:19:02 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40980 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762166AbbA1Uu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:50:26 -0500
Date: Wed, 28 Jan 2015 06:33:34 -0800
From: tip-bot for Mike Galbraith <tipbot@zytor.com>
Message-ID: <tip-bb2bc55a694d45cdeda91b6f28ab2adec28125ef@git.kernel.org>
Cc: tglx@linutronix.de, umgwanakikbuti@gmail.com, lizefan@huawei.com,
        peterz@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        hpa@zytor.com, torvalds@linux-foundation.org
Reply-To: umgwanakikbuti@gmail.com, tglx@linutronix.de, mingo@kernel.org,
        peterz@infradead.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, hpa@zytor.com, lizefan@huawei.com
In-Reply-To: <1422417235.5716.5.camel@marge.simpson.net>
References: <1422417235.5716.5.camel@marge.simpson.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Fix crash if cpuset_cpumask_can_shrink(
 ) is passed an empty cpumask
Git-Commit-ID: bb2bc55a694d45cdeda91b6f28ab2adec28125ef
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

Commit-ID:  bb2bc55a694d45cdeda91b6f28ab2adec28125ef
Gitweb:     http://git.kernel.org/tip/bb2bc55a694d45cdeda91b6f28ab2adec28125ef
Author:     Mike Galbraith <umgwanakikbuti@gmail.com>
AuthorDate: Wed, 28 Jan 2015 04:53:55 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 28 Jan 2015 15:28:15 +0100

sched: Fix crash if cpuset_cpumask_can_shrink() is passed an empty cpumask

While creating an exclusive cpuset, we passed cpuset_cpumask_can_shrink()
an empty cpumask (cur), and dl_bw_of(cpumask_any(cur)) made boom with it:

 CPU: 0 PID: 6942 Comm: shield.sh Not tainted 3.19.0-master #19
 Hardware name: MEDIONPC MS-7502/MS-7502, BIOS 6.00 PG 12/26/2007
 task: ffff880224552450 ti: ffff8800caab8000 task.ti: ffff8800caab8000
 RIP: 0010:[<ffffffff81073846>]  [<ffffffff81073846>] cpuset_cpumask_can_shrink+0x56/0xb0
 [...]
 Call Trace:
  [<ffffffff810cb82a>] validate_change+0x18a/0x200
  [<ffffffff810cc877>] cpuset_write_resmask+0x3b7/0x720
  [<ffffffff810c4d58>] cgroup_file_write+0x38/0x100
  [<ffffffff811d953a>] kernfs_fop_write+0x12a/0x180
  [<ffffffff8116e1a3>] vfs_write+0xb3/0x1d0
  [<ffffffff8116ed06>] SyS_write+0x46/0xb0
  [<ffffffff8159ced6>] system_call_fastpath+0x16/0x1b

Signed-off-by: Mike Galbraith <umgwanakikbuti@gmail.com>
Acked-by: Zefan Li <lizefan@huawei.com>
Fixes: f82f80426f7a ("sched/deadline: Ensure that updates to exclusive cpusets don't break AC")
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1422417235.5716.5.camel@marge.simpson.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index c0accc0..5c86687 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4642,6 +4642,9 @@ int cpuset_cpumask_can_shrink(const struct cpumask *cur,
 	struct dl_bw *cur_dl_b;
 	unsigned long flags;
 
+	if (!cpumask_weight(cur))
+		return ret;
+
 	rcu_read_lock_sched();
 	cur_dl_b = dl_bw_of(cpumask_any(cur));
 	trial_cpus = cpumask_weight(trial);
