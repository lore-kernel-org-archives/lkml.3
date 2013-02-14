Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761505Ab3BNRtU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 12:49:20 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54703 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759344Ab3BNRtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 12:49:19 -0500
Date: Thu, 14 Feb 2013 09:46:50 -0800
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-7d7e499f7333f68b7e7f67d14b9c1480913b4afb@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rusty@rustcorp.com.au, pjt@google.com, peterz@infradead.org,
        srivatsa.bhat@linux.vnet.ibm.com, rw@linutronix.de,
        paulmck@linux.vnet.ibm.com, arjan@infradead.org, tglx@linutronix.de,
        magnus.damm@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au, peterz@infradead.org, pjt@google.com,
        srivatsa.bhat@linux.vnet.ibm.com, rw@linutronix.de,
        arjan@infradead.org, paulmck@linux.vnet.ibm.com, tglx@linutronix.de,
        magnus.damm@gmail.com
In-Reply-To: <20130131120741.553993267@linutronix.de>
References: <20130131120741.553993267@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] smpboot: Allow selfparking per cpu threads
Git-Commit-ID: 7d7e499f7333f68b7e7f67d14b9c1480913b4afb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 14 Feb 2013 09:46:56 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7d7e499f7333f68b7e7f67d14b9c1480913b4afb
Gitweb:     http://git.kernel.org/tip/7d7e499f7333f68b7e7f67d14b9c1480913b4afb
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 31 Jan 2013 12:11:12 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 14 Feb 2013 15:29:37 +0100

smpboot: Allow selfparking per cpu threads

The stop machine threads are still killed when a cpu goes offline. The
reason is that the thread is used to bring the cpu down, so it can't
be parked along with the other per cpu threads.

Allow a per cpu thread to be excluded from automatic parking, so it
can park itself once it's done

Add a create callback function as well.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Arjan van de Veen <arjan@infradead.org>
Cc: Paul Turner <pjt@google.com>
Cc: Richard Weinberger <rw@linutronix.de>
Cc: Magnus Damm <magnus.damm@gmail.com>
Link: http://lkml.kernel.org/r/20130131120741.553993267@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/smpboot.h | 5 +++++
 kernel/smpboot.c        | 5 +++--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/include/linux/smpboot.h b/include/linux/smpboot.h
index e0106d8..c65dee0 100644
--- a/include/linux/smpboot.h
+++ b/include/linux/smpboot.h
@@ -14,6 +14,8 @@ struct smpboot_thread_data;
  * @thread_should_run:	Check whether the thread should run or not. Called with
  *			preemption disabled.
  * @thread_fn:		The associated thread function
+ * @create:		Optional setup function, called when the thread gets
+ *			created (Not called from the thread context)
  * @setup:		Optional setup function, called when the thread gets
  *			operational the first time
  * @cleanup:		Optional cleanup function, called when the thread
@@ -22,6 +24,7 @@ struct smpboot_thread_data;
  *			parked (cpu offline)
  * @unpark:		Optional unpark function, called when the thread is
  *			unparked (cpu online)
+ * @selfparking:	Thread is not parked by the park function.
  * @thread_comm:	The base name of the thread
  */
 struct smp_hotplug_thread {
@@ -29,10 +32,12 @@ struct smp_hotplug_thread {
 	struct list_head		list;
 	int				(*thread_should_run)(unsigned int cpu);
 	void				(*thread_fn)(unsigned int cpu);
+	void				(*create)(unsigned int cpu);
 	void				(*setup)(unsigned int cpu);
 	void				(*cleanup)(unsigned int cpu, bool online);
 	void				(*park)(unsigned int cpu);
 	void				(*unpark)(unsigned int cpu);
+	bool				selfparking;
 	const char			*thread_comm;
 };
 
diff --git a/kernel/smpboot.c b/kernel/smpboot.c
index d6c5fc0..d4abac2 100644
--- a/kernel/smpboot.c
+++ b/kernel/smpboot.c
@@ -183,9 +183,10 @@ __smpboot_create_thread(struct smp_hotplug_thread *ht, unsigned int cpu)
 		kfree(td);
 		return PTR_ERR(tsk);
 	}
-
 	get_task_struct(tsk);
 	*per_cpu_ptr(ht->store, cpu) = tsk;
+	if (ht->create)
+		ht->create(cpu);
 	return 0;
 }
 
@@ -225,7 +226,7 @@ static void smpboot_park_thread(struct smp_hotplug_thread *ht, unsigned int cpu)
 {
 	struct task_struct *tsk = *per_cpu_ptr(ht->store, cpu);
 
-	if (tsk)
+	if (tsk && !ht->selfparking)
 		kthread_park(tsk);
 }
 
