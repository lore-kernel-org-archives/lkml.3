Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506AbaEOTwl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 15:52:41 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:36107 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755377AbaEOTwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 15:52:39 -0400
Message-ID: <53751ABF.4000307@linux.vnet.ibm.com>
Date: Fri, 16 May 2014 01:21:27 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: peterz@infradead.org, tglx@linutronix.de, mingo@kernel.org, tj@kernel.org,
        rusty@rustcorp.com.au, akpm@linux-foundation.org, fweisbec@gmail.com,
        hch@infradead.org, mgorman@suse.de, riel@redhat.com, bp@suse.de,
        rostedt@goodmis.org, mgalbraith@suse.de, ego@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, oleg@redhat.com, rjw@rjwysocki.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5 UPDATED 1/3] smp: Print more useful debug info upon receiving
 IPI on an offline CPU
References: <20140515191218.19811.25887.stgit@srivatsabhat.in.ibm.com> <20140515191259.19811.81032.stgit@srivatsabhat.in.ibm.com> <1400181576.5058.19.camel@joe-AO725> <537516DA.9010407@linux.vnet.ibm.com> <1400183029.5058.21.camel@joe-AO725>
In-Reply-To: <1400183029.5058.21.camel@joe-AO725>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14051519-2674-0000-0000-00000E4C41E1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2014 01:13 AM, Joe Perches wrote:
[...]
> Ah, good.
> 
> I was misled a bit by the WARN_ONCE that is in the
> same block.  Perhaps because there is a guard flag
> above the block, maybe the WARN_ONCE should just be
> WARN.
> 

Ah, right, just WARN is sufficient there. Thanks!

-------------------------------------------------------

From: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
[PATCH v5 UPDATED 1/3] smp: Print more useful debug info upon receiving IPI on an offline CPU

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

 kernel/smp.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/kernel/smp.c b/kernel/smp.c
index 06d574e..306f818 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -185,14 +185,26 @@ void generic_smp_call_function_single_interrupt(void)
 {
 	struct llist_node *entry;
 	struct call_single_data *csd, *csd_next;
+	static bool warned;
+
+	entry = llist_del_all(&__get_cpu_var(call_single_queue));
+	entry = llist_reverse_order(entry);
 
 	/*
 	 * Shouldn't receive this interrupt on a cpu that is not yet online.
 	 */
-	WARN_ON_ONCE(!cpu_online(smp_processor_id()));
+	if (unlikely(!cpu_online(smp_processor_id()) && !warned)) {
+		warned = true;
+		WARN(1, "IPI on offline CPU %d\n", smp_processor_id());
 
-	entry = llist_del_all(&__get_cpu_var(call_single_queue));
-	entry = llist_reverse_order(entry);
+		/*
+		 * We don't have to use the _safe() variant here
+		 * because we are not invoking the IPI handlers yet.
+		 */
+		llist_for_each_entry(csd, entry, llist)
+			pr_warn("IPI callback %pS sent to offline CPU\n",
+				csd->func);
+	}
 
 	llist_for_each_entry_safe(csd, csd_next, entry, llist) {
 		csd->func(csd->info);


