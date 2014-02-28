Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751859AbaB1MjR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 07:39:17 -0500
Received: from merlin.infradead.org ([205.233.59.134]:54898 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447AbaB1MjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 07:39:16 -0500
Date: Fri, 28 Feb 2014 13:39:05 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>,
        Robert Richter <rric@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        David Daney <david.daney@cavium.com>, linux-kernel@vger.kernel.org,
        Prarit Bhargava <prarit@redhat.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>
Subject: Re: smp_call_function_single with wait=0 considered harmful
Message-ID: <20140228123905.GK3104@twins.programming.kicks-ass.net>
References: <20131204164627.GA27677@infradead.org>
 <20140228122624.GF9987@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140228122624.GF9987@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 28, 2014 at 01:26:24PM +0100, Peter Zijlstra wrote:
> On Wed, Dec 04, 2013 at 08:46:27AM -0800, Christoph Hellwig wrote:
> >   kernel/stop_machine.c:stop_two_cpus()
> 
> That site should work with .wait=1 just fine, but given the above, the
> .wait=0 doesn't appear problematic at all.

Scratch that; its broken, but not because of smp_call_function_single().

---
Subject: stop_machine: Fix^2 race between stop_two_cpus() and stop_cpus()

We must use smp_call_function_single(.wait=1) for the
irq_cpu_stop_queue_work() to ensure the queueing is actually done under
stop_cpus_lock. Without this we could have dropped the lock by the time
we do the queueing and get the race we tried to fix.

Fixes: 7053ea1a34fa ("stop_machine: Fix race between stop_two_cpus() and stop_cpus()")
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 kernel/stop_machine.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
index 84571e09c907..01fbae5b97b7 100644
--- a/kernel/stop_machine.c
+++ b/kernel/stop_machine.c
@@ -293,7 +293,7 @@ int stop_two_cpus(unsigned int cpu1, unsigned int cpu2, cpu_stop_fn_t fn, void *
 	 */
 	smp_call_function_single(min(cpu1, cpu2),
 				 &irq_cpu_stop_queue_work,
-				 &call_args, 0);
+				 &call_args, 1);
 	lg_local_unlock(&stop_cpus_lock);
 	preempt_enable();
 
