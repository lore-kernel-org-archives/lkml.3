Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996AbaJ1LI5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 07:08:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51140 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754910AbaJ1LIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 07:08:54 -0400
Date: Tue, 28 Oct 2014 04:07:57 -0700
From: tip-bot for Wanpeng Li <tipbot@zytor.com>
Message-ID: <tip-f4e9d94a5bf60193d45f92b136e3d166be3ec8d5@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de,
        wanpeng.li@linux.intel.com, mingo@kernel.org, hpa@zytor.com,
        torvalds@linux-foundation.org
Reply-To: torvalds@linux-foundation.org, mingo@kernel.org, hpa@zytor.com,
        tglx@linutronix.de, wanpeng.li@linux.intel.com, peterz@infradead.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1413253360-5318-2-git-send-email-wanpeng.li@linux.intel.com>
References: <1413253360-5318-2-git-send-email-wanpeng.li@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/deadline: Don'
 t balance during wakeup if wakee is pinned
Git-Commit-ID: f4e9d94a5bf60193d45f92b136e3d166be3ec8d5
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

Commit-ID:  f4e9d94a5bf60193d45f92b136e3d166be3ec8d5
Gitweb:     http://git.kernel.org/tip/f4e9d94a5bf60193d45f92b136e3d166be3ec8d5
Author:     Wanpeng Li <wanpeng.li@linux.intel.com>
AuthorDate: Tue, 14 Oct 2014 10:22:40 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 28 Oct 2014 10:48:02 +0100

sched/deadline: Don't balance during wakeup if wakee is pinned

Use nr_cpus_allowed to bail from select_task_rq() when only one cpu
can be used, and saves some cycles for pinned tasks.

Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1413253360-5318-2-git-send-email-wanpeng.li@linux.intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/deadline.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index fab3bf8..2e31a30 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -933,6 +933,9 @@ select_task_rq_dl(struct task_struct *p, int cpu, int sd_flag, int flags)
 	struct task_struct *curr;
 	struct rq *rq;
 
+	if (p->nr_cpus_allowed == 1)
+		goto out;
+
 	if (sd_flag != SD_BALANCE_WAKE)
 		goto out;
 
