Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751197AbaJIRFv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 13:05:51 -0400
Received: from mail.skyhub.de ([78.46.96.112]:52915 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750896AbaJIRFn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 13:05:43 -0400
Date: Thu, 9 Oct 2014 19:05:34 +0200
From: Borislav Petkov <bp@alien8.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Arjan van de Veen <arjan@infradead.org>, Paul Turner <pjt@google.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Richard Weinberger <richard@nod.at>,
        =?utf-8?B?SsO2cmcgUsO2ZGVs?= <joro@8bytes.org>
Subject: Re: [patch 05/40] cpu: Restructure cpu_down code
Message-ID: <20141009170533.GB15050@pd.tnic>
References: <20130131120348.372374706@linutronix.de>
 <20130131120741.823640323@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130131120741.823640323@linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2013 at 12:11:15PM -0000, Thomas Gleixner wrote:
> Split out into separate functions, so we can convert it to a state machine.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Refreshed:

>From linux-kernel-owner@vger.kernel.org Thu Jan 31 13:11:32 2013
Message-Id: <20130131120741.823640323@linutronix.de>
User-Agent: quilt/0.48-1
Date:	Thu, 31 Jan 2013 12:11:15 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Rusty Russell <rusty@rustcorp.com.au>, Paul McKenney
 <paulmck@linux.vnet.ibm.com>, "Srivatsa S. Bhat"
 <srivatsa.bhat@linux.vnet.ibm.com>, Arjan van de Veen <arjan@infradead.org>,
 Paul Turner <pjt@google.com>, Richard Weinberger <rw@linutronix.de>, Magnus
 Damm <magnus.damm@gmail.com>
Subject: [patch 05/40] cpu: Restructure cpu_down code
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=utf-8
Status: RO

Split out into separate functions, so we can convert it to a state machine.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/cpu.c |   69 ++++++++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 47 insertions(+), 22 deletions(-)

Index: linux/kernel/cpu.c
===================================================================
--- linux.orig/kernel/cpu.c	2014-10-09 18:54:47.251793646 +0200
+++ linux/kernel/cpu.c	2014-10-09 19:00:46.743791277 +0200
@@ -214,6 +214,43 @@ static int cpu_notify(unsigned long val,
 	return __cpu_notify(val, cpu, -1, NULL);
 }
 
+/* Notifier wrappers for transitioning to state machine */
+static int notify_prepare(unsigned int cpu)
+{
+	int nr_calls = 0;
+	int ret;
+
+	ret = __cpu_notify(CPU_UP_PREPARE, cpu, -1, &nr_calls);
+	if (ret) {
+		nr_calls--;
+		printk(KERN_WARNING "%s: attempt to bring up CPU %u failed\n",
+				__func__, cpu);
+		__cpu_notify(CPU_UP_CANCELED, cpu, nr_calls, NULL);
+	}
+	return ret;
+}
+
+static int notify_online(unsigned int cpu)
+{
+	cpu_notify(CPU_ONLINE, cpu);
+	return 0;
+}
+
+static int bringup_cpu(unsigned int cpu)
+{
+	struct task_struct *idle = idle_thread_get(cpu);
+	int ret;
+
+	/* Arch-specific enabling code. */
+	ret = __cpu_up(cpu, idle);
+	if (ret) {
+		cpu_notify(CPU_UP_CANCELED, cpu);
+		return ret;
+	}
+	BUG_ON(!cpu_online(cpu));
+	return 0;
+}
+
 #ifdef CONFIG_HOTPLUG_CPU
 
 static void cpu_notify_nofail(unsigned long val, unsigned int cpu)
@@ -421,7 +458,7 @@ EXPORT_SYMBOL(cpu_down);
 static int _cpu_up(unsigned int cpu, int tasks_frozen)
 {
 	struct task_struct *idle;
-	int ret, nr_calls = 0;
+	int ret;
 
 	cpu_hotplug_begin();
 
@@ -436,35 +473,24 @@ static int _cpu_up(unsigned int cpu, int
 		goto out;
 	}
 
+	cpuhp_tasks_frozen = tasks_frozen;
+
 	ret = smpboot_create_threads(cpu);
 	if (ret)
 		goto out;
 
-	cpuhp_tasks_frozen = tasks_frozen;
-
-	ret = __cpu_notify(CPU_UP_PREPARE, cpu, -1, &nr_calls);
-	if (ret) {
-		nr_calls--;
-		pr_warn("%s: attempt to bring up CPU %u failed\n",
-			__func__, cpu);
-		goto out_notify;
-	}
+	ret = notify_prepare(cpu);
+	if (ret)
+		goto out;
 
-	/* Arch-specific enabling code. */
-	ret = __cpu_up(cpu, idle);
-	if (ret != 0)
-		goto out_notify;
-	BUG_ON(!cpu_online(cpu));
+	ret = bringup_cpu(cpu);
+	if (ret)
+		goto out;
 
 	/* Wake the per cpu threads */
 	smpboot_unpark_threads(cpu);
 
-	/* Now call notifier in preparation. */
-	cpu_notify(CPU_ONLINE, cpu);
-
-out_notify:
-	if (ret != 0)
-		__cpu_notify(CPU_UP_CANCELED, cpu, nr_calls, NULL);
+	notify_online(cpu);
 out:
 	cpu_hotplug_done();
 

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
