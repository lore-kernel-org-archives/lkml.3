Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758106AbaGAPOr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 11:14:47 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:10817 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754356AbaGAPOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 11:14:46 -0400
Date: Tue, 1 Jul 2014 11:14:44 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <williams@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, stable-rt@vger.kernel.org
Subject: [PATCH RT] sched: Do not clear PF_NO_SETAFFINITY flag in
 select_fallback_rq()
Message-ID: <20140701111444.0cfebaa1@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


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
---
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index ce80b93..352239e 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1393,12 +1393,6 @@ out:
 		}
 	}
 
-	/*
-	 * Clear PF_NO_SETAFFINITY, otherwise we wreckage
-	 * migrate_disable/enable. See optimization for
-	 * PF_NO_SETAFFINITY tasks there.
-	 */
-	p->flags &= ~PF_NO_SETAFFINITY;
 	return dest_cpu;
 }
 
