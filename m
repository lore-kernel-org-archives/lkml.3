Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754316AbaFNUos (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 16:44:48 -0400
Received: from 1wt.eu ([62.212.114.60]:42906 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754242AbaFNUoq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 16:44:46 -0400
Message-Id: <20140614191250.253462412@1wt.eu>
User-Agent: quilt/0.48-1
Date: Sat, 14 Jun 2014 21:12:53 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Darren Hart <darren@dvhart.com>,
        Davidlohr Bueso <davidlohr@hp.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Clark Williams <williams@redhat.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Roland McGrath <roland@hack.frob.com>,
        Carlos ODonell <carlos@redhat.com>, Jakub Jelinek <jakub@redhat.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 3/9] futex: Prevent attaching to kernel threads
In-Reply-To: <57d1129d02f4fc14423dd66474950cb7@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

We happily allow userspace to declare a random kernel thread to be the
owner of a user space PI futex.

Found while analysing the fallout of Dave Jones syscall fuzzer.

We also should validate the thread group for private futexes and find
some fast way to validate whether the "alleged" owner has RW access on
the file which backs the SHM, but that's a separate issue.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Dave Jones <davej@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Darren Hart <darren@dvhart.com>
Cc: Davidlohr Bueso <davidlohr@hp.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Clark Williams <williams@redhat.com>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Roland McGrath <roland@hack.frob.com>
Cc: Carlos ODonell <carlos@redhat.com>
Cc: Jakub Jelinek <jakub@redhat.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Link: http://lkml.kernel.org/r/20140512201701.194824402@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
(cherry picked from commit f0d71b3dcb8332f7971b5f2363632573e6d9486a)
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 kernel/futex.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/futex.c b/kernel/futex.c
index 731b271..c00b6e4 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -610,6 +610,11 @@ lookup_pi_state(u32 uval, struct futex_hash_bucket *hb,
 	if (!p)
 		return -ESRCH;
 
+	if (!p->mm) {
+		put_task_struct(p);
+		return -EPERM;
+	}
+
 	/*
 	 * We need to look at the task state flags to figure out,
 	 * whether the task is exiting. To protect against the do_exit
-- 
1.7.12.2.21.g234cd45.dirty



