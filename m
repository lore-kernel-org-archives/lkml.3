Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498Ab3BZVjl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 16:39:41 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46822 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503Ab3BZVjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 16:39:40 -0500
Date: Tue, 26 Feb 2013 13:38:06 -0800
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-46c498c2cdee5efe44f617bcd4f388179be36115@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        konrad.wilk@oracle.com, rusty@rustcorp.com.au,
        srivatsa.bhat@linux.vnet.ibm.com, tglx@linutronix.de,
        linux@eikelenboom.it
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, rusty@rustcorp.com.au,
        srivatsa.bhat@linux.vnet.ibm.com, tglx@linutronix.de,
        linux@eikelenboom.it
In-Reply-To: <alpine.LFD.2.02.1302261843240.22263@ionos>
References: <alpine.LFD.2.02.1302261843240.22263@ionos>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] stop_machine:
  Mark per cpu stopper enabled early
Git-Commit-ID: 46c498c2cdee5efe44f617bcd4f388179be36115
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 26 Feb 2013 13:38:14 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  46c498c2cdee5efe44f617bcd4f388179be36115
Gitweb:     http://git.kernel.org/tip/46c498c2cdee5efe44f617bcd4f388179be36115
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Tue, 26 Feb 2013 18:44:33 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 26 Feb 2013 22:25:17 +0100

stop_machine: Mark per cpu stopper enabled early

commit 14e568e78 (stop_machine: Use smpboot threads) introduced the
following regression:

Before this commit the stopper enabled bit was set in the online
notifier.

CPU0				CPU1
cpu_up
				cpu online
hotplug_notifier(ONLINE)
  stopper(CPU1)->enabled = true;
...
stop_machine()

The conversion to smpboot threads moved the enablement to the wakeup
path of the parked thread. The majority of users seem to have the
following working order:

CPU0				CPU1
cpu_up
				cpu online
unpark_threads()
  wakeup(stopper[CPU1])
....
				stopper thread runs
				  stopper(CPU1)->enabled = true;
stop_machine()

But Konrad and Sander have observed:

CPU0				CPU1
cpu_up
				cpu online
unpark_threads()
  wakeup(stopper[CPU1])
....
stop_machine()
				stopper thread runs
				  stopper(CPU1)->enabled = true;

Now the stop machinery kicks CPU0 into the stop loop, where it gets
stuck forever because the queue code saw stopper(CPU1)->enabled ==
false, so CPU0 waits for CPU1 to enter stomp_machine, but the CPU1
stopper work got discarded due to enabled == false.

Add a pre_unpark function to the smpboot thread descriptor and call it
before waking the thread.

This fixes the problem at hand, but the stop_machine code should be
more robust. The stopper->enabled flag smells fishy at best.

Thanks to Konrad for going through a loop of debug patches and
providing the information to decode this issue.

Reported-and-tested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Reported-and-tested-by: Sander Eikelenboom <linux@eikelenboom.it>
Cc: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Link: http://lkml.kernel.org/r/alpine.LFD.2.02.1302261843240.22263@ionos
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/smpboot.h | 4 ++++
 kernel/smpboot.c        | 2 ++
 kernel/stop_machine.c   | 2 +-
 3 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/linux/smpboot.h b/include/linux/smpboot.h
index c65dee0..13e9296 100644
--- a/include/linux/smpboot.h
+++ b/include/linux/smpboot.h
@@ -24,6 +24,9 @@ struct smpboot_thread_data;
  *			parked (cpu offline)
  * @unpark:		Optional unpark function, called when the thread is
  *			unparked (cpu online)
+ * @pre_unpark:		Optional unpark function, called before the thread is
+ *			unparked (cpu online). This is not guaranteed to be
+ *			called on the target cpu of the thread. Careful!
  * @selfparking:	Thread is not parked by the park function.
  * @thread_comm:	The base name of the thread
  */
@@ -37,6 +40,7 @@ struct smp_hotplug_thread {
 	void				(*cleanup)(unsigned int cpu, bool online);
 	void				(*park)(unsigned int cpu);
 	void				(*unpark)(unsigned int cpu);
+	void				(*pre_unpark)(unsigned int cpu);
 	bool				selfparking;
 	const char			*thread_comm;
 };
diff --git a/kernel/smpboot.c b/kernel/smpboot.c
index d4abac2..8eaed9a 100644
--- a/kernel/smpboot.c
+++ b/kernel/smpboot.c
@@ -209,6 +209,8 @@ static void smpboot_unpark_thread(struct smp_hotplug_thread *ht, unsigned int cp
 {
 	struct task_struct *tsk = *per_cpu_ptr(ht->store, cpu);
 
+	if (ht->pre_unpark)
+		ht->pre_unpark(cpu);
 	kthread_unpark(tsk);
 }
 
diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
index 95d178c..c09f295 100644
--- a/kernel/stop_machine.c
+++ b/kernel/stop_machine.c
@@ -336,7 +336,7 @@ static struct smp_hotplug_thread cpu_stop_threads = {
 	.create			= cpu_stop_create,
 	.setup			= cpu_stop_unpark,
 	.park			= cpu_stop_park,
-	.unpark			= cpu_stop_unpark,
+	.pre_unpark		= cpu_stop_unpark,
 	.selfparking		= true,
 };
 
