Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705AbaEFUev (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 16:34:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40588 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753968AbaEFUeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 16:34:50 -0400
Date: Tue, 6 May 2014 13:34:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: peterz@infradead.org, tglx@linutronix.de, mingo@kernel.org, tj@kernel.org,
        rusty@rustcorp.com.au, fweisbec@gmail.com, hch@infradead.org,
        mgorman@suse.de, riel@redhat.com, bp@suse.de, rostedt@goodmis.org,
        mgalbraith@suse.de, ego@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        oleg@redhat.com, rjw@rjwysocki.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] smp: Print more useful debug info upon receiving
 IPI on an offline CPU
Message-Id: <20140506133448.23f9baa4bf4fc1a09e03fd75@linux-foundation.org>
In-Reply-To: <20140506180247.14375.45645.stgit@srivatsabhat.in.ibm.com>
References: <20140506180213.14375.5904.stgit@srivatsabhat.in.ibm.com>
	<20140506180247.14375.45645.stgit@srivatsabhat.in.ibm.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 06 May 2014 23:32:51 +0530 "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com> wrote:

> Today the smp-call-function code just prints a warning if we get an IPI on
> an offline CPU. This info is sufficient to let us know that something went
> wrong, but often it is very hard to debug exactly who sent the IPI and why,
> from this info alone.
> 
> In most cases, we get the warning about the IPI to an offline CPU, immediately
> after the CPU going offline comes out of the stop-machine phase and reenables
> interrupts. Since all online CPUs participate in stop-machine, the information
> regarding the sender of the IPI is already lost by the time we exit the
> stop-machine loop. So even if we dump the stack on each CPU at this point,
> we won't find anything useful since all of them will show the stack-trace of
> the stopper thread. So we need a better way to figure out who sent the IPI and
> why.
> 
> To achieve this, when we detect an IPI targeted to an offline CPU, loop through
> the call-single-data linked list and print out the payload (i.e., the name
> of the function which was supposed to be executed by the target CPU). This
> would give us an insight as to who might have sent the IPI and help us debug
> this further.
> 
> ...
>
> --- a/kernel/smp.c
> +++ b/kernel/smp.c
> @@ -185,15 +185,28 @@ void generic_smp_call_function_single_interrupt(void)
>  {
>  	struct llist_node *entry;
>  	struct call_single_data *csd, *csd_next;
> +	int warn = 0;
>  
>  	/*
>  	 * Shouldn't receive this interrupt on a cpu that is not yet online.
>  	 */
> -	WARN_ON_ONCE(!cpu_online(smp_processor_id()));
> +	if (unlikely(!cpu_online(smp_processor_id()))) {
> +		warn = 1;
> +		WARN_ON_ONCE(1);
> +	}
>  
>  	entry = llist_del_all(&__get_cpu_var(call_single_queue));
>  	entry = llist_reverse_order(entry);
>  
> +	if (unlikely(warn)) {
> +		/*
> +		 * We don't have to use the _safe() variant here
> +		 * because we are not invoking the IPI handlers yet.
> +		 */
> +		llist_for_each_entry(csd, entry, llist)
> +			pr_warn("SMP IPI Payload: %pS \n", csd->func);
> +	}
> +

This will emit the WARN_ON a single time, but will emit the "IPI
Payload" list every time the cpu is found to be offline.  So on the
second and successive occurrences some output will still occur.

Unfortunately WARN_ON_ONCE() returns the value of `condition', not
`__warned', so we have to hand-code things.  Like this?

void generic_smp_call_function_single_interrupt(void)
{
	struct llist_node *entry;
	struct call_single_data *csd, *csd_next;
	static bool warned;

	entry = llist_del_all(&__get_cpu_var(call_single_queue));
	entry = llist_reverse_order(entry);

	/*
	 * Shouldn't receive this interrupt on a cpu that is not yet online.
	 */
	if (unlikely(!cpu_online(smp_processor_id()) && !warned)) {
		warned = true;
		WARN_ON(1);
		/*
		 * We don't have to use the _safe() variant here
		 * because we are not invoking the IPI handlers yet.
		 */
		llist_for_each_entry(csd, entry, llist)
			pr_warn("SMP IPI Payload: %pS \n", csd->func);
	}

	llist_for_each_entry_safe(csd, csd_next, entry, llist) {
		csd->func(csd->info);
		csd_unlock(csd);
	}
}


--- a/kernel/smp.c~smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu-fix
+++ a/kernel/smp.c
@@ -185,20 +185,17 @@ void generic_smp_call_function_single_in
 {
 	struct llist_node *entry;
 	struct call_single_data *csd, *csd_next;
-	int warn = 0;
-
-	/*
-	 * Shouldn't receive this interrupt on a cpu that is not yet online.
-	 */
-	if (unlikely(!cpu_online(smp_processor_id()))) {
-		warn = 1;
-		WARN_ON_ONCE(1);
-	}
+	static bool warned;
 
 	entry = llist_del_all(&__get_cpu_var(call_single_queue));
 	entry = llist_reverse_order(entry);
 
-	if (unlikely(warn)) {
+	/*
+	 * Shouldn't receive this interrupt on a cpu that is not yet online.
+	 */
+	if (unlikely(!cpu_online(smp_processor_id()) && !warned)) {
+		warned = true;
+		WARN_ON(1);
 		/*
 		 * We don't have to use the _safe() variant here
 		 * because we are not invoking the IPI handlers yet.
_

