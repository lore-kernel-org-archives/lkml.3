Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497AbaFGBcu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 21:32:50 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36092 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752640AbaFGBXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 21:23:38 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Roland McGrath" <roland@hack.frob.com>,
        "Lai Jiangshan" <laijs@cn.fujitsu.com>,
        "Jakub Jelinek" <jakub@redhat.com>,
        "Carlos ODonell" <carlos@redhat.com>,
        "Clark Williams" <williams@redhat.com>,
        "Darren Hart" <darren@dvhart.com>,
        "Peter Zijlstra" <peterz@infradead.org>,
        "Michael Kerrisk" <mtk.manpages@gmail.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Steven Rostedt" <rostedt@goodmis.org>,
        "Paul McKenney" <paulmck@linux.vnet.ibm.com>,
        "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Dave Jones" <davej@redhat.com>, "Davidlohr Bueso" <davidlohr@hp.com>
Date: Sat, 07 Jun 2014 02:26:29 +0100
Message-ID: <lsq.1402104389.650369815@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 88/92] futex: Prevent attaching to kernel threads
In-Reply-To: <lsq.1402104388.385007124@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.60-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit f0d71b3dcb8332f7971b5f2363632573e6d9486a upstream.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/futex.c | 5 +++++
 1 file changed, 5 insertions(+)

--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -662,6 +662,11 @@ lookup_pi_state(u32 uval, struct futex_h
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

