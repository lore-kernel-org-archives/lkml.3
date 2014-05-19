Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152AbaESMY0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 08:24:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58727 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752869AbaESMYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 08:24:22 -0400
Date: Mon, 19 May 2014 05:22:31 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-f0d71b3dcb8332f7971b5f2363632573e6d9486a@git.kernel.org>
Cc: mingo@kernel.org, williams@redhat.com, torvalds@linux-foundation.org,
        peterz@infradead.org, jakub@redhat.com, rostedt@goodmis.org,
        bigeasy@linutronix.de, tglx@linutronix.de, laijs@cn.fujitsu.com,
        davidlohr@hp.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        darren@dvhart.com, davej@redhat.com, paulmck@linux.vnet.ibm.com,
        carlos@redhat.com, roland@hack.frob.com, mtk.manpages@gmail.com
Reply-To: mingo@kernel.org, torvalds@linux-foundation.org, williams@redhat.com,
        peterz@infradead.org, jakub@redhat.com, rostedt@goodmis.org,
        bigeasy@linutronix.de, tglx@linutronix.de, davidlohr@hp.com,
        laijs@cn.fujitsu.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        darren@dvhart.com, davej@redhat.com, paulmck@linux.vnet.ibm.com,
        carlos@redhat.com, roland@hack.frob.com, mtk.manpages@gmail.com
In-Reply-To: <20140512201701.194824402@linutronix.de>
References: <20140512201701.194824402@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] futex: Prevent attaching to kernel threads
Git-Commit-ID: f0d71b3dcb8332f7971b5f2363632573e6d9486a
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

Commit-ID:  f0d71b3dcb8332f7971b5f2363632573e6d9486a
Gitweb:     http://git.kernel.org/tip/f0d71b3dcb8332f7971b5f2363632573e6d9486a
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Mon, 12 May 2014 20:45:35 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 19 May 2014 21:18:49 +0900

futex: Prevent attaching to kernel threads

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
---
 kernel/futex.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/futex.c b/kernel/futex.c
index 7c68225..81dbe77 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -814,6 +814,11 @@ lookup_pi_state(u32 uval, struct futex_hash_bucket *hb,
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
