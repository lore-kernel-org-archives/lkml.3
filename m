Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751830AbaBLLiu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 06:38:50 -0500
Received: from www.linutronix.de ([62.245.132.108]:51863 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbaBLLit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 06:38:49 -0500
Date: Wed, 12 Feb 2014 12:38:55 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Kirill Tkhai <ktkhai@parallels.com>
cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] smpboot: Use preempt_enable_no_resched() before
 schedule()
In-Reply-To: <20140212101954.17530.53675.stgit@tkhai>
Message-ID: <alpine.DEB.2.02.1402121226150.21991@ionos.tec.linutronix.de>
References: <20140212101954.17530.53675.stgit@tkhai>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Feb 2014, Kirill Tkhai wrote:

No, preempt_enable_no_resched() should just die. If you want to get
rid of the preempt_enable() / schedule() sequence just use
schedule_preempt_disabled(). See below.

Thanks,

	tglx


--- linux-2.6.orig/kernel/smpboot.c
+++ linux-2.6/kernel/smpboot.c
@@ -106,9 +106,9 @@ static int smpboot_thread_fn(void *data)
 	struct smpboot_thread_data *td = data;
 	struct smp_hotplug_thread *ht = td->ht;
 
+	preempt_disable();
 	while (1) {
 		set_current_state(TASK_INTERRUPTIBLE);
-		preempt_disable();
 		if (kthread_should_stop()) {
 			set_current_state(TASK_RUNNING);
 			preempt_enable();
@@ -128,6 +128,7 @@ static int smpboot_thread_fn(void *data)
 			}
 			kthread_parkme();
 			/* We might have been woken for stop */
+			preempt_disable();
 			continue;
 		}
 
@@ -152,12 +153,12 @@ static int smpboot_thread_fn(void *data)
 		}
 
 		if (!ht->thread_should_run(td->cpu)) {
-			preempt_enable();
-			schedule();
+			schedule_preempt_disabled();
 		} else {
 			set_current_state(TASK_RUNNING);
 			preempt_enable();
 			ht->thread_fn(td->cpu);
+			preempt_disable();
 		}
 	}
 }
