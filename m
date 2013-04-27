Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330Ab3D0HuT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Apr 2013 03:50:19 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:60288 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677Ab3D0HuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Apr 2013 03:50:17 -0400
Date: Sat, 27 Apr 2013 09:50:11 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@us.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [GIT PULL] perf fix
Message-ID: <20130427075011.GA16589@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-urgent-for-linus

   HEAD: c79aa0d96548aee50570209eb2d45c8f4ac49230 events: Protect access via task_subsys_state_check()

This fix adds missing RCU read protection.

 Thanks,

	Ingo

------------------>
Paul E. McKenney (1):
      events: Protect access via task_subsys_state_check()


 kernel/events/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 4d3124b..9fcb094 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4596,6 +4596,7 @@ void perf_event_comm(struct task_struct *task)
 	struct perf_event_context *ctx;
 	int ctxn;
 
+	rcu_read_lock();
 	for_each_task_context_nr(ctxn) {
 		ctx = task->perf_event_ctxp[ctxn];
 		if (!ctx)
@@ -4603,6 +4604,7 @@ void perf_event_comm(struct task_struct *task)
 
 		perf_event_enable_on_exec(ctx);
 	}
+	rcu_read_unlock();
 
 	if (!atomic_read(&nr_comm_events))
 		return;
