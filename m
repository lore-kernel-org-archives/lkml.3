Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936613AbaFIJfX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 05:35:23 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59137 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933562AbaFIJ0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 05:26:52 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Dave Jones <davej@redhat.com>,
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
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 012/146] futex: Prevent attaching to kernel threads
Date: Mon,  9 Jun 2014 10:49:07 +0200
Message-Id: <5a9e6a04f7b5ecccf9b7a5fe0ce4f54072c59475.1402303820.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
References: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
In-Reply-To: <cover.1402303820.git.jslaby@suse.cz>
References: <cover.1402303820.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 kernel/futex.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/futex.c b/kernel/futex.c
index 470729dfe192..6c7975b3f291 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -668,6 +668,11 @@ lookup_pi_state(u32 uval, struct futex_hash_bucket *hb,
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
1.9.3

