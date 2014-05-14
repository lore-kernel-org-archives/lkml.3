Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754269AbaENOZa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 10:25:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33307 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752042AbaENOZ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 10:25:28 -0400
Date: Wed, 14 May 2014 10:25:25 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Viresh Kumar <viresh.kumar@linaro.org>, cpufreq@vger.kernel.org
cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        linux-pm@vger.kernel.org
Subject: [PATCH 2/2] speedstep: clean up interrupt disabling
In-Reply-To: <alpine.LRH.2.02.1405141012040.11670@file01.intranet.prod.int.rdu2.redhat.com>
Message-ID: <alpine.LRH.2.02.1405141024520.11670@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1405141012040.11670@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch cleans up interrupt disabling in speedstep-smi and
speedstep-lib. It doesn't fix any bug.

speedstep_get_freqs in speedstep-lib may be called from speedstep-smi or
speedstep-ich. When it is called from speedstep-ich, it needs to calculate
transition latency. When it is called from speedstep-smi, transition
latency doesn't have to be calculated.

The function speedstep_set_state in speedstep-smi needs to enable
interrupts. Previously it enabled interrupts even if it was called with
disabled interrupts, but it is dirty.

This patch changes speedstep_get_freqs so that it disables interrupts only
when it is called from speedstep-ich and when it is measuring the
transition latency. This avoids much of the code dirtiness.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/cpufreq/speedstep-lib.c |   13 ++++++-------
 drivers/cpufreq/speedstep-smi.c |   11 ++++-------
 2 files changed, 10 insertions(+), 14 deletions(-)

Index: linux-3.14-rc1/drivers/cpufreq/speedstep-lib.c
===================================================================
--- linux-3.14-rc1.orig/drivers/cpufreq/speedstep-lib.c	2014-02-03 19:06:21.000000000 +0100
+++ linux-3.14-rc1/drivers/cpufreq/speedstep-lib.c	2014-02-03 19:06:26.000000000 +0100
@@ -400,9 +400,6 @@ unsigned int speedstep_get_freqs(enum sp
 
 	pr_debug("previous speed is %u\n", prev_speed);
 
-	preempt_disable();
-	local_irq_save(flags);
-
 	/* switch to low state */
 	set_state(SPEEDSTEP_LOW);
 	*low_speed = speedstep_get_frequency(processor);
@@ -414,15 +411,19 @@ unsigned int speedstep_get_freqs(enum sp
 	pr_debug("low speed is %u\n", *low_speed);
 
 	/* start latency measurement */
-	if (transition_latency)
+	if (transition_latency) {
+		local_irq_save(flags);
 		do_gettimeofday(&tv1);
+	}
 
 	/* switch to high state */
 	set_state(SPEEDSTEP_HIGH);
 
 	/* end latency measurement */
-	if (transition_latency)
+	if (transition_latency) {
 		do_gettimeofday(&tv2);
+		local_irq_restore(flags);
+	}
 
 	*high_speed = speedstep_get_frequency(processor);
 	if (!*high_speed) {
@@ -464,8 +465,6 @@ unsigned int speedstep_get_freqs(enum sp
 	}
 
 out:
-	local_irq_restore(flags);
-	preempt_enable();
 
 	return ret;
 }
Index: linux-3.14-rc1/drivers/cpufreq/speedstep-smi.c
===================================================================
--- linux-3.14-rc1.orig/drivers/cpufreq/speedstep-smi.c	2014-02-03 19:06:21.000000000 +0100
+++ linux-3.14-rc1/drivers/cpufreq/speedstep-smi.c	2014-02-03 19:06:26.000000000 +0100
@@ -148,16 +148,16 @@ static int speedstep_smi_get_freqs(unsig
 static void speedstep_set_state(unsigned int state)
 {
 	unsigned int result = 0, command, new_state, dummy;
-	unsigned long flags;
 	unsigned int function = SET_SPEEDSTEP_STATE;
 	unsigned int retry = 0;
 
 	if (state > 0x1)
 		return;
 
-	/* Disable IRQs */
+	WARN_ON_ONCE(irqs_disabled());
+
+	/* Disable preemption so that other processes don't run */
 	preempt_disable();
-	local_irq_save(flags);
 
 	command = (smi_sig & 0xffffff00) | (smi_cmd & 0xff);
 
@@ -177,9 +177,7 @@ static void speedstep_set_state(unsigned
 			 */
 			pr_debug("retry %u, previous result %u, waiting...\n",
 					retry, result);
-			local_irq_enable();
 			mdelay(retry * 50);
-			local_irq_disable();
 		}
 		retry++;
 		__asm__ __volatile__(
@@ -194,8 +192,7 @@ static void speedstep_set_state(unsigned
 			);
 	} while ((new_state != state) && (retry <= SMI_TRIES));
 
-	/* enable IRQs */
-	local_irq_restore(flags);
+	/* enable preemption */
 	preempt_enable();
 
 	if (new_state == state)

