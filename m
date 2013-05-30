Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928Ab3E3MNZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 08:13:25 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:7763 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753753Ab3E3MNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 08:13:15 -0400
X-Forefront-Antispam-Report: CIP:193.138.13.20;KIP:(null);UIP:(null);IPV:NLI;H:oce-exbhcs03b.oce.net;RD:smtp02.oce.com;EFVD:NLI
X-SpamScore: 7
X-BigFish: VS7(zzzz1f42h1ee6h1ce5h1fdah201ch1202h1fd0h1e76h1d1ah1cabh1d2ah1fc6hzz8275bhz2ei87h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h15a8h162dh1631h1758h17eeh1898h18e1h1946h19b5h1b0ah1c0dh1d0ch1d2eh1d3fh1dc1h1dfeh1dffhff4m129fi1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
From: Ivo Sieben <meltedpianoman@gmail.com>
To: RT <linux-rt-users@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
CC: LKML <linux-kernel@vger.kernel.org>, Ivo Sieben <meltedpianoman@gmail.com>
Subject: [PATCH] RFC: Set irq thread to RT priority on creation
Date: Thu, 30 May 2013 14:12:55 +0200
Message-ID: <1369915975-28797-1-git-send-email-meltedpianoman@gmail.com>
X-Mailer: git-send-email 1.7.9.5
X-OriginalArrivalTime: 30 May 2013 12:13:09.0716 (UTC) FILETIME=[0CA2B940:01CE5D2F]
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: oce.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a threaded irq handler is installed the irq thread is initially created
on normal scheduling priority. Only after the the irq thread is woken up it
sets its priority to RT_FIFO MAX_USER_RT_PRIO/2.

This means that interrupts that occur directly after the irq handler is
installed will be handled on a normal scheduling priority instead of the
realtime priority that you would expect. Fixed this by setting the RT
priority on creation of the irq_thread.

Signed-off-by: Ivo Sieben <meltedpianoman@gmail.com>
---

RFC:
Whas there a specific reason for the irq_thread to be created on normal
scheduling and only set to RT priority when woken up?
This patch solves an issue for me where a device driver is expected to handle an
interrupt immediatly after irq handlers are installed and interrupts enabled.

(If this does make sense: I guess the sched_setscheduler() call in the irq_thread
function can be removed?)

 kernel/irq/manage.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index fa17855..0ffe37b 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -950,6 +950,9 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 	 */
 	if (new->thread_fn && !nested) {
 		struct task_struct *t;
+		static const struct sched_param param = {
+			.sched_priority = MAX_USER_RT_PRIO/2,
+		};
 
 		t = kthread_create(irq_thread, new, "irq/%d-%s", irq,
 				   new->name);
@@ -957,6 +960,9 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 			ret = PTR_ERR(t);
 			goto out_mput;
 		}
+
+		sched_setscheduler(t, SCHED_FIFO, &param);
+
 		/*
 		 * We keep the reference to the task struct even if
 		 * the thread dies to avoid that the interrupt code
-- 
1.7.9.5


