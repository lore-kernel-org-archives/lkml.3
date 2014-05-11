Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757843AbaEKUiN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 16:38:13 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:35764 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757711AbaEKUiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 16:38:09 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH v3 2/2] CPU hotplug,
 stop-machine: Plug race-window that leads to "IPI-to-offline-CPU"
To: peterz@infradead.org, tglx@linutronix.de, mingo@kernel.org, tj@kernel.org,
        rusty@rustcorp.com.au, akpm@linux-foundation.org, fweisbec@gmail.com,
        hch@infradead.org
Cc: mgorman@suse.de, riel@redhat.com, bp@suse.de, rostedt@goodmis.org,
        mgalbraith@suse.de, ego@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        oleg@redhat.com, rjw@rjwysocki.net, linux-kernel@vger.kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com
Date: Mon, 12 May 2014 02:07:04 +0530
Message-ID: <20140511203657.17152.79234.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20140511203617.17152.21133.stgit@srivatsabhat.in.ibm.com>
References: <20140511203617.17152.21133.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14051120-9574-0000-0000-00000D86F069
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During CPU offline, stop-machine is used to take control over all the online
CPUs (via the per-cpu stopper thread) and then run take_cpu_down() on the CPU
that is to be taken offline.

But stop-machine itself has several stages: _PREPARE, _DISABLE_IRQ, _RUN etc.
The important thing to note here is that the _DISABLE_IRQ stage comes much
later after starting stop-machine, and hence there is a large window where
other CPUs can send IPIs to the CPU going offline. As a result, we can
encounter a scenario as depicted below, which causes IPIs to be sent to the
CPU going offline, and that CPU notices them *after* it has gone offline,
triggering the "IPI-to-offline-CPU" warning from the smp-call-function code.


              CPU 1                                         CPU 2
          (Online CPU)                               (CPU going offline)

       Enter _PREPARE stage                          Enter _PREPARE stage

                                                     Enter _DISABLE_IRQ stage


                                                   =
       Got a device interrupt,                     | Didn't notice the IPI
       and the interrupt handler                   | since interrupts were
       called smp_call_function()                  | disabled on this CPU.
       and sent an IPI to CPU 2.                   |
                                                   =


       Enter _DISABLE_IRQ stage


       Enter _RUN stage                              Enter _RUN stage

                                  =
       Busy loop with interrupts  |                  Invoke take_cpu_down()
       disabled.                  |                  and take CPU 2 offline
                                  =


       Enter _EXIT stage                             Enter _EXIT stage

       Re-enable interrupts                          Re-enable interrupts

                                                     The pending IPI is noted
                                                     immediately, but alas,
                                                     the CPU is offline at
                                                     this point.



So, as we can observe from this scenario, the IPI was sent when CPU 2 was
still online, and hence it was perfectly legal. But unfortunately it was
noted only after CPU 2 went offline, resulting in the warning from the
IPI handling code. In other words, the fault was not at the sender, but
at the receiver side - and if we look closely, the real bug is in the
stop-machine sequence itself.

The problem here is that the CPU going offline disabled its local interrupts
(by entering _DISABLE_IRQ phase) *before* the other CPUs. And that's the
reason why it was not able to respond to the IPI before going offline.

A simple solution to this problem is to ensure that the CPU going offline
disables its interrupts only *after* the other CPUs do the same thing.
To achieve this, split the _DISABLE_IRQ state into 2 parts:

1st part: MULTI_STOP_DISABLE_IRQ_INACTIVE, where only the non-active CPUs
(i.e., the "other" CPUs) disable their interrupts.

2nd part: MULTI_STOP_DISABLE_IRQ_ACTIVE, where the active CPU (i.e., the
CPU going offline) disables its interrupts.

With this in place, the CPU going offline will always be the last one to
disable interrupts. After this step, no further IPIs can be sent to the
outgoing CPU, since all the other CPUs would be executing the stop-machine
code with interrupts disabled. And by the time stop-machine ends, the CPU
would have gone offline and disappeared from the cpu_online_mask, and hence
future invocations of smp_call_function() and friends will automatically
prune that CPU out. Thus, we can guarantee that no CPU will end up
*inadvertently* sending IPIs to an offline CPU.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 kernel/stop_machine.c |   25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
index 01fbae5..cac8590 100644
--- a/kernel/stop_machine.c
+++ b/kernel/stop_machine.c
@@ -130,8 +130,10 @@ enum multi_stop_state {
 	MULTI_STOP_NONE,
 	/* Awaiting everyone to be scheduled. */
 	MULTI_STOP_PREPARE,
-	/* Disable interrupts. */
-	MULTI_STOP_DISABLE_IRQ,
+	/* Disable interrupts on CPUs not in ->active_cpus mask. */
+	MULTI_STOP_DISABLE_IRQ_INACTIVE,
+	/* Disable interrupts on CPUs in ->active_cpus mask. */
+	MULTI_STOP_DISABLE_IRQ_ACTIVE,
 	/* Run the function */
 	MULTI_STOP_RUN,
 	/* Exit */
@@ -189,10 +191,27 @@ static int multi_cpu_stop(void *data)
 	do {
 		/* Chill out and ensure we re-read multi_stop_state. */
 		cpu_relax();
+
+		/*
+		 * In the case of CPU offline, we don't want the other CPUs to
+		 * send IPIs to the active_cpu (the one going offline) after it
+		 * has disabled interrupts in the _DISABLE_IRQ state (because,
+		 * then it will notice the IPIs only after it goes offline). So
+		 * we split this state into _INACTIVE and _ACTIVE, and thereby
+		 * ensure that the active_cpu disables interrupts only after
+		 * the other CPUs do the same thing.
+		 */
+
 		if (msdata->state != curstate) {
 			curstate = msdata->state;
 			switch (curstate) {
-			case MULTI_STOP_DISABLE_IRQ:
+			case MULTI_STOP_DISABLE_IRQ_INACTIVE:
+				if (is_active)
+					break;
+
+				/* Else, fall-through */
+
+			case MULTI_STOP_DISABLE_IRQ_ACTIVE:
 				local_irq_disable();
 				hard_irq_disable();
 				break;

