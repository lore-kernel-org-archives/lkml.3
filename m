Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754924AbaEOOQN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 10:16:13 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:44317 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403AbaEOOQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 10:16:11 -0400
Date: Thu, 15 May 2014 16:16:05 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: peterz@infradead.org, tglx@linutronix.de, mingo@kernel.org, tj@kernel.org,
        rusty@rustcorp.com.au, akpm@linux-foundation.org, hch@infradead.org,
        mgorman@suse.de, riel@redhat.com, bp@suse.de, rostedt@goodmis.org,
        mgalbraith@suse.de, ego@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        oleg@redhat.com, rjw@rjwysocki.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] smp: Print more useful debug info upon receiving
 IPI on an offline CPU
Message-ID: <20140515141600.GB11458@localhost.localdomain>
References: <20140511203617.17152.21133.stgit@srivatsabhat.in.ibm.com>
 <20140511203647.17152.45125.stgit@srivatsabhat.in.ibm.com>
 <20140513153845.GD13828@localhost.localdomain>
 <537461C9.9000309@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <537461C9.9000309@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2014 at 12:12:17PM +0530, Srivatsa S. Bhat wrote:
> On 05/13/2014 09:08 PM, Frederic Weisbecker wrote:
> > On Mon, May 12, 2014 at 02:06:49AM +0530, Srivatsa S. Bhat wrote:
> >> Today the smp-call-function code just prints a warning if we get an IPI on
> >> an offline CPU. This info is sufficient to let us know that something went
> >> wrong, but often it is very hard to debug exactly who sent the IPI and why,
> >> from this info alone.
> >>
> >> In most cases, we get the warning about the IPI to an offline CPU, immediately
> >> after the CPU going offline comes out of the stop-machine phase and reenables
> >> interrupts. Since all online CPUs participate in stop-machine, the information
> >> regarding the sender of the IPI is already lost by the time we exit the
> >> stop-machine loop. So even if we dump the stack on each CPU at this point,
> >> we won't find anything useful since all of them will show the stack-trace of
> >> the stopper thread. So we need a better way to figure out who sent the IPI and
> >> why.
> >>
> >> To achieve this, when we detect an IPI targeted to an offline CPU, loop through
> >> the call-single-data linked list and print out the payload (i.e., the name
> >> of the function which was supposed to be executed by the target CPU). This
> >> would give us an insight as to who might have sent the IPI and help us debug
> >> this further.
> >>
> >> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> >> ---
> >>
> >>  kernel/smp.c |   18 ++++++++++++++----
> >>  1 file changed, 14 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/kernel/smp.c b/kernel/smp.c
> >> index 06d574e..f864921 100644
> >> --- a/kernel/smp.c
> >> +++ b/kernel/smp.c
> >> @@ -185,14 +185,24 @@ void generic_smp_call_function_single_interrupt(void)
> >>  {
> >>  	struct llist_node *entry;
> >>  	struct call_single_data *csd, *csd_next;
> >> +	static bool warned;
> >> +
> >> +	entry = llist_del_all(&__get_cpu_var(call_single_queue));
> >> +	entry = llist_reverse_order(entry);
> >>  
> >>  	/*
> >>  	 * Shouldn't receive this interrupt on a cpu that is not yet online.
> >>  	 */
> >> -	WARN_ON_ONCE(!cpu_online(smp_processor_id()));
> >> -
> >> -	entry = llist_del_all(&__get_cpu_var(call_single_queue));
> >> -	entry = llist_reverse_order(entry);
> >> +	if (unlikely(!cpu_online(smp_processor_id()) && !warned)) {
> >> +		warned = true;
> >> +		WARN_ON(1);
> > 
> > More details may be better:
> > 
> > WARN_ONCE(1, "IPI on offline CPU");
> >
> 
> Sure, that sounds better.
>  
> >> +		/*
> >> +		 * We don't have to use the _safe() variant here
> >> +		 * because we are not invoking the IPI handlers yet.
> >> +		 */
> >> +		llist_for_each_entry(csd, entry, llist)
> >> +			pr_warn("SMP IPI Payload: %pS \n", csd->func);
> > 
> > Payload is kind of vague. How about "IPI func %pS sent on offline CPU".
> > 
> 
> Ok, and maybe s/func/function and s/on/to ?

Yeah looks good.

Thanks.

> 
> >> +	}
> >>  
> >>  	llist_for_each_entry_safe(csd, csd_next, entry, llist) {
> >>  		csd->func(csd->info);
> >>
> > 
> 
> Regards,
> Srivatsa S. Bhat
> 
