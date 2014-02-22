Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612AbaBVSC3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 13:02:29 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41285 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837AbaBVSC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 13:02:26 -0500
Date: Sat, 22 Feb 2014 10:01:54 -0800
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-77177856e3bf39d435b3ae4bfd164ca3c8cd4577@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, bigeasy@linutronix.de, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, bigeasy@linutronix.de
In-Reply-To: <1391803122-4425-2-git-send-email-bigeasy@linutronix.de>
References: <1391803122-4425-2-git-send-email-bigeasy@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Init idle->on_rq in init_idle()
Git-Commit-ID: 77177856e3bf39d435b3ae4bfd164ca3c8cd4577
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

Commit-ID:  77177856e3bf39d435b3ae4bfd164ca3c8cd4577
Gitweb:     http://git.kernel.org/tip/77177856e3bf39d435b3ae4bfd164ca3c8cd4577
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Fri, 7 Feb 2014 20:58:37 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sat, 22 Feb 2014 18:07:36 +0100

sched: Init idle->on_rq in init_idle()

We stumbled in RT over a SMP bringup issue on ARM where the
idle->on_rq == 0 was causing try_to_wakeup() on the other cpu to run
into nada land.

After adding that idle->on_rq = 1; I was able to find the root cause
of the lockup: the idle task on the newly woken up cpu was fiddling
with a sleeping spinlock, which is a nono.

I kept the init of idle->on_rq to keep the state consistent and to
avoid another long lasting debug session.

As a side note, the whole debug mess could have been avoided if
might_sleep() would have yelled when called from the idle task. That's
fixed with patch 2/6 - and that one actually has a changelog :)

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1391803122-4425-2-git-send-email-bigeasy@linutronix.de
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 49db434..06da865 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4443,6 +4443,7 @@ void init_idle(struct task_struct *idle, int cpu)
 	rcu_read_unlock();
 
 	rq->curr = rq->idle = idle;
+	idle->on_rq = 1;
 #if defined(CONFIG_SMP)
 	idle->on_cpu = 1;
 #endif
