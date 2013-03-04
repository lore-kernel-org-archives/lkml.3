Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756670Ab3CDJqj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 04:46:39 -0500
Received: from www.linutronix.de ([62.245.132.108]:57487 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755016Ab3CDJqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 04:46:38 -0500
Date: Mon, 4 Mar 2013 10:46:35 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>, akm@linutronix.de,
        Ingo Molnar <mingo@kernel.org>
Subject: [GIT pull] core urgent updates for 3.9-rc1
Message-ID: <alpine.LFD.2.02.1303041045080.22263@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull the latest core-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git core-urgent-for-linus

* Single bugfix for a regression introduced with the conversion of the
  stop machine threads to the generic smpboot thread management
  facility

Thanks,

	tglx

------------------>
Thomas Gleixner (1):
      stop_machine: Mark per cpu stopper enabled early


 include/linux/smpboot.h |    4 ++++
 kernel/smpboot.c        |    2 ++
 kernel/stop_machine.c   |    2 +-
 3 files changed, 7 insertions(+), 1 deletions(-)

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
 
