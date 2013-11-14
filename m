Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751446Ab3KNGJq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 01:09:46 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:57449 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751104Ab3KNGJg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 01:09:36 -0500
Message-ID: <52846863.4060001@linux.vnet.ibm.com>
Date: Thu, 14 Nov 2013 11:36:27 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>
CC: Preeti Murthy <preeti.lkml@gmail.com>, mingo@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        mikey@neuling.org, linux-tip-commits@vger.kernel.org
Subject: Re: [PATCH v2] sched: Check sched_domain before computing group power.
References: <tip-db2pe0vxwunv37plc7onnugj@git.kernel.org> <20131112105547.GA27310@linux.vnet.ibm.com> <20131112115736.GO5056@laptop.programming.kicks-ass.net> <20131112164126.GF2559@linux.vnet.ibm.com> <CAM4v1pNMn=5oZDiX3fUp9uPkZTPJgk=vEKEjevzvpwn=PjTzXg@mail.gmail.com> <20131113112329.GC543@linux.vnet.ibm.com>
In-Reply-To: <20131113112329.GC543@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111406-5806-0000-0000-0000236985E5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 11/13/2013 04:53 PM, Srikar Dronamraju wrote:
> * Preeti Murthy <preeti.lkml@gmail.com> [2013-11-13 16:22:37]:
> 
>> Hi Srikar,
>>
>> update_group_power() is called only during load balancing during
>> update_sg_lb_stats().
>> Load balancing begins at the base domain of the CPU,rq(cpu)->sd. This is
>> checked for
>> NULL. So how can update_group_power() be called in a scenario where the
>> base domain
>> of the CPU is not initialized? I say 'initialized' since you check for NULL
>> on rq(cpu)->sd.
>>
> 
> update_group_power() also gets called from init_sched_groups_power().
> And if you see the oops message, we know that the oops happens from that
> path. In build_sched_domains(), we do cpu_attach_domain() what updates
> rq->sd after the call to init_sched_groups_power(). So by the time
> init_sched_groups_power() is called rq->sd is not yet initialized. 
> 
> We only hit oops case, when the sd->flags has SD_OVERLAP set.
> 
> 
> 
>> In the changelog, you say 'updated'. Are you saying that it has a stale
>> value?
> 
> I said, "before the sched_domain for a cpu is updated", so its not yet
> updated or has stale value. As I said earlier in this mail, the
> initialization happens after we do a update_group_power().
> 
>> Please do elaborate on how you observed this.
>>
> 
> Does this clarify?

Yes it clarifies, thank you.

However I was thinking that a better fix would be to reorder the way we call
update_group_power() and cpu_attach_domain(). Why do we need to do
update_group_power() of the groups of the sched domains that would probably
degenerate in cpu_attach_domain()? So it seemed best to move update_group_power()
to after cpu_attach_domain() so that it saves unnecessary iterations over
sched domains which could degenerate, and it fixes the issue that you have brought out
as well. See below for the patch:

-------------------------------------------------------------------------------

sched: Update power of sched groups after sched domains have been attached to CPUs

From: Preeti U Murthy <preeti@linux.vnet.ibm.com>

Avoid iterating unnecessarily over the sched domains which could potentially
degenerate,  while updating sched groups' power. This can be done by moving
the call to init_sched_groups_power() to after cpu_attach_domain(), when the
possibility of degenerating sched domains is examined and appropriately sched
domains are degenerated.

But claim_allocations() which does a NULL on the struct sd_data members for
each sched domain should iterate over all the initally built sched domains.
So move claim_allocations() to a loop where we build sched groups for each domain.
We would not require to reference sd_data after sched domains and sched
groups have been built.

Another use of this re-ordering is with reference to the commit
"sched/fair: Fix group power_orig computation". After this commit,
we end up dereferencing cpu_rq(cpu)->sd in update_group_power(). This would
lead to a NULL pointer since this parameter is updated after call to
update_group_power() in build_sched_domains() during initialization of sched
domains per CPU. The below change prevents this from occuring.

Signed-off-by: Preeti U. Murthy <preeti@linux.vnet.ibm.com>
---
 kernel/sched/core.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index e6a6244..d9703ac 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6211,17 +6211,7 @@ static int build_sched_domains(const struct cpumask *cpu_map,
 				if (build_sched_groups(sd, i))
 					goto error;
 			}
-		}
-	}
-
-	/* Calculate CPU power for physical packages and nodes */
-	for (i = nr_cpumask_bits-1; i >= 0; i--) {
-		if (!cpumask_test_cpu(i, cpu_map))
-			continue;
-
-		for (sd = *per_cpu_ptr(d.sd, i); sd; sd = sd->parent) {
 			claim_allocations(i, sd);
-			init_sched_groups_power(i, sd);
 		}
 	}
 
@@ -6233,6 +6223,16 @@ static int build_sched_domains(const struct cpumask *cpu_map,
 	}
 	rcu_read_unlock();
 
+	/* Calculate CPU power for physical packages and nodes */
+	for (i = nr_cpumask_bits-1; i >= 0; i--) {
+		if (!cpumask_test_cpu(i, cpu_map))
+			continue;
+
+		for (sd = *per_cpu_ptr(d.sd, i); sd; sd = sd->parent)
+			init_sched_groups_power(i, sd);
+	}
+
+
 	ret = 0;
 error:
 	__free_domain_allocs(&d, alloc_state, cpu_map);

> 
Regards
Preeti U. Murthy

