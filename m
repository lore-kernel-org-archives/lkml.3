Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751486AbaEFSDy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 14:03:54 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:41126 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154AbaEFSDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 14:03:53 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH 1/2] smp: Print more useful debug info upon receiving IPI on
 an offline CPU
To: peterz@infradead.org, tglx@linutronix.de, mingo@kernel.org, tj@kernel.org,
        rusty@rustcorp.com.au, akpm@linux-foundation.org, fweisbec@gmail.com,
        hch@infradead.org
Cc: mgorman@suse.de, riel@redhat.com, bp@suse.de, rostedt@goodmis.org,
        mgalbraith@suse.de, ego@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        oleg@redhat.com, rjw@rjwysocki.net, linux-kernel@vger.kernel.org,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Date: Tue, 06 May 2014 23:32:51 +0530
Message-ID: <20140506180247.14375.45645.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20140506180213.14375.5904.stgit@srivatsabhat.in.ibm.com>
References: <20140506180213.14375.5904.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14050618-3864-0000-0000-00000E0F4E22
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today the smp-call-function code just prints a warning if we get an IPI on
an offline CPU. This info is sufficient to let us know that something went
wrong, but often it is very hard to debug exactly who sent the IPI and why,
from this info alone.

In most cases, we get the warning about the IPI to an offline CPU, immediately
after the CPU going offline comes out of the stop-machine phase and reenables
interrupts. Since all online CPUs participate in stop-machine, the information
regarding the sender of the IPI is already lost by the time we exit the
stop-machine loop. So even if we dump the stack on each CPU at this point,
we won't find anything useful since all of them will show the stack-trace of
the stopper thread. So we need a better way to figure out who sent the IPI and
why.

To achieve this, when we detect an IPI targeted to an offline CPU, loop through
the call-single-data linked list and print out the payload (i.e., the name
of the function which was supposed to be executed by the target CPU). This
would give us an insight as to who might have sent the IPI and help us debug
this further.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 kernel/smp.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/kernel/smp.c b/kernel/smp.c
index 06d574e..6cb0e2e 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -185,15 +185,28 @@ void generic_smp_call_function_single_interrupt(void)
 {
 	struct llist_node *entry;
 	struct call_single_data *csd, *csd_next;
+	int warn = 0;
 
 	/*
 	 * Shouldn't receive this interrupt on a cpu that is not yet online.
 	 */
-	WARN_ON_ONCE(!cpu_online(smp_processor_id()));
+	if (unlikely(!cpu_online(smp_processor_id()))) {
+		warn = 1;
+		WARN_ON_ONCE(1);
+	}
 
 	entry = llist_del_all(&__get_cpu_var(call_single_queue));
 	entry = llist_reverse_order(entry);
 
+	if (unlikely(warn)) {
+		/*
+		 * We don't have to use the _safe() variant here
+		 * because we are not invoking the IPI handlers yet.
+		 */
+		llist_for_each_entry(csd, entry, llist)
+			pr_warn("SMP IPI Payload: %pS \n", csd->func);
+	}
+
 	llist_for_each_entry_safe(csd, csd_next, entry, llist) {
 		csd->func(csd->info);
 		csd_unlock(csd);

