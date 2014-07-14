Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757276AbaGNUF5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 16:05:57 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:10540 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757265AbaGNUFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 16:05:47 -0400
Message-Id: <20140714200545.576509660@goodmis.org>
User-Agent: quilt/0.63-1
Date: Mon, 14 Jul 2014 16:05:36 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Kacur <jkacur@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        stable-rt@vger.kernel.org, Clark Williams <williams@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH RT 1/4] sched: Do not clear PF_NO_SETAFFINITY flag in select_fallback_rq()
References: <20140714200535.671192970@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0001-sched-Do-not-clear-PF_NO_SETAFFINITY-flag-in-select_.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4.97-rt121-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <rostedt@goodmis.org>

I talked with Peter Zijlstra about this, and he told me that the clearing
of the PF_NO_SETAFFINITY flag was to deal with the optimization of
migrate_disable/enable() that ignores tasks that have that flag set. But
that optimization was removed when I did a rework of the cpu hotplug code.

I found that ignoring tasks that had that flag set would cause those tasks
to not sync with the hotplug code and cause the kernel to crash. Thus it
needed to not treat them special and those tasks had to go though the same
work as tasks without that flag set.

Now that those tasks are not treated special, there's no reason to clear the
flag.

May still need to be tested as the migrate_me() code does not ignore those
flags.

Cc: stable-rt@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Clark Williams <williams@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20140701111444.0cfebaa1@gandalf.local.home
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/sched/core.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 1199054adb2e..2b2863972dd1 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1325,12 +1325,6 @@ out:
 		}
 	}
 
-	/*
-	 * Clear PF_THREAD_BOUND, otherwise we wreckage
-	 * migrate_disable/enable. See optimization for
-	 * PF_THREAD_BOUND tasks there.
-	 */
-	p->flags &= ~PF_THREAD_BOUND;
 	return dest_cpu;
 }
 
-- 
2.0.0


