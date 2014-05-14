Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074AbaENOYx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 10:24:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27245 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753883AbaENOYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 10:24:51 -0400
Date: Wed, 14 May 2014 10:24:44 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Viresh Kumar <viresh.kumar@linaro.org>, cpufreq@vger.kernel.org
cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        linux-pm@vger.kernel.org
Subject: [PATCH 1/2] speedstep-smi: enable interrupts when waiting
Message-ID: <alpine.LRH.2.02.1405141012040.11670@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Viresh

Some times ago, I sent these two cpufreq patches to fix frequency 
transition problem on speedstep-smi, but you didn't put them to the 
upstream kernel. I am resending the patches. If you would like a different 
solution to this problem, please explain it.

Mikulas


On Dell Latitude C600 laptop with Pentium 3 850MHz processor, the
speedstep-smi driver sometimes loads and sometimes doesn't load with
"change to state X failed" message.

The hardware sometimes refuses to change frequency and in this case, we 
need to retry later. I found out that we need to enable interrupts while 
waiting for retry. When we enable interrupts, the hardware blockage that 
prevents frequency transition resolves and the transition is possible. 
With disabled interrupts, the blockage doesn't resolve (no matter how long 
do we wait). The exact reasons for this hardware behavior are unknown.

This patch enables interrupts in the function speedstep_set_state that can
be called with disabled interrupts. However, this function is called with
disabled interrupts only from speedstep_get_freqs, so it shouldn't cause
any problem.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com
Cc: stable@vger.kernel.org

---
 drivers/cpufreq/speedstep-lib.c |    3 +++
 drivers/cpufreq/speedstep-smi.c |   12 ++++++++++++
 2 files changed, 15 insertions(+)

Index: linux-3.14-rc1/drivers/cpufreq/speedstep-smi.c
===================================================================
--- linux-3.14-rc1.orig/drivers/cpufreq/speedstep-smi.c	2014-02-03 18:56:44.000000000 +0100
+++ linux-3.14-rc1/drivers/cpufreq/speedstep-smi.c	2014-02-03 19:06:21.000000000 +0100
@@ -156,6 +156,7 @@ static void speedstep_set_state(unsigned
 		return;
 
 	/* Disable IRQs */
+	preempt_disable();
 	local_irq_save(flags);
 
 	command = (smi_sig & 0xffffff00) | (smi_cmd & 0xff);
@@ -166,9 +167,19 @@ static void speedstep_set_state(unsigned
 
 	do {
 		if (retry) {
+			/*
+			 * We need to enable interrupts, otherwise the blockage
+			 * won't resolve.
+			 *
+			 * We disable preemption so that other processes don't
+			 * run. If other processes were running, they could
+			 * submit more DMA requests, making the blockage worse.
+			 */
 			pr_debug("retry %u, previous result %u, waiting...\n",
 					retry, result);
+			local_irq_enable();
 			mdelay(retry * 50);
+			local_irq_disable();
 		}
 		retry++;
 		__asm__ __volatile__(
@@ -185,6 +196,7 @@ static void speedstep_set_state(unsigned
 
 	/* enable IRQs */
 	local_irq_restore(flags);
+	preempt_enable();
 
 	if (new_state == state)
 		pr_debug("change to %u MHz succeeded after %u tries "
Index: linux-3.14-rc1/drivers/cpufreq/speedstep-lib.c
===================================================================
--- linux-3.14-rc1.orig/drivers/cpufreq/speedstep-lib.c	2014-02-03 18:54:39.000000000 +0100
+++ linux-3.14-rc1/drivers/cpufreq/speedstep-lib.c	2014-02-03 19:06:21.000000000 +0100
@@ -400,6 +400,7 @@ unsigned int speedstep_get_freqs(enum sp
 
 	pr_debug("previous speed is %u\n", prev_speed);
 
+	preempt_disable();
 	local_irq_save(flags);
 
 	/* switch to low state */
@@ -464,6 +465,8 @@ unsigned int speedstep_get_freqs(enum sp
 
 out:
 	local_irq_restore(flags);
+	preempt_enable();
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(speedstep_get_freqs);
