Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547Ab3LUR0s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Dec 2013 12:26:48 -0500
Received: from merlin.infradead.org ([205.233.59.134]:51832 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692Ab3LUR0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Dec 2013 12:26:47 -0500
Date: Sat, 21 Dec 2013 18:26:18 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: tglx@linutronix.de, mingo@redhat.com, oleg@redhat.com, fweisbec@gmail.com,
        darren@dvhart.com, johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, juri.lelli@gmail.com,
        nicola.manica@disi.unitn.it, luca.abeni@unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com, paulmck@linux.vnet.ibm.com,
        raistlin@linux.it, insop.song@gmail.com, liming.wang@windriver.com,
        jkacur@redhat.com
Subject: Re: [PATCH 09/13] sched: Add bandwidth management for sched_dl
Message-ID: <20131221172618.GM2480@laptop.programming.kicks-ass.net>
References: <20131217122720.950475833@infradead.org>
 <20131217123353.180539582@infradead.org>
 <20131218165508.GB30183@twins.programming.kicks-ass.net>
 <20131220171343.GL2480@laptop.programming.kicks-ass.net>
 <20131220123707.44fb7192@gandalf.local.home>
 <20131220174200.GX16438@laptop.programming.kicks-ass.net>
 <20131220132323.524cf2b1@gandalf.local.home>
 <20131220214413.GF7959@laptop.programming.kicks-ass.net>
 <20131220182946.09ca0f04@gandalf.local.home>
 <20131221100500.GG7959@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131221100500.GG7959@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Like this then? :-)

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5056,10 +5019,25 @@ static int sched_cpu_inactive(struct not
 	switch (action & ~CPU_TASKS_FROZEN) {
 	case CPU_DOWN_PREPARE:
 		set_cpu_active((long)hcpu, false);
+
+		/* explicitly allow suspend */
+		if (!(action & CPU_TASKS_FROZEN)) {
+			struct dl_bw *dl_b = dl_bw_of(cpu);
+			bool overflow;
+			int cpus;
+
+			raw_spin_lock_irqsave(&dl_b->lock, flags);
+			cpus = dl_bw_cpus(cpu);
+			overflow = __dl_overflow(dl_b, cpus, 0, 0);
+			raw_spin_unlock_irqrestore(&dl_b->lock, flags);
+
+			if (overflow)
+				return notifier_from_errno(-EBUSY);
+		}
 		return NOTIFY_OK;
-	default:
-		return NOTIFY_DONE;
 	}
+
+	return NOTIFY_DONE;
 }
 
 static int __init migration_init(void)
