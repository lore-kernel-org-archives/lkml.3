Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759471Ab3KMPRl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 10:17:41 -0500
Received: from merlin.infradead.org ([205.233.59.134]:60208 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753522Ab3KMPRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 10:17:39 -0500
Date: Wed, 13 Nov 2013 16:17:18 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mikey@neuling.org,
        linux-tip-commits@vger.kernel.org
Subject: Re: [PATCH v2] sched: Check sched_domain before computing group
 power.
Message-ID: <20131113151718.GN21461@twins.programming.kicks-ass.net>
References: <tip-db2pe0vxwunv37plc7onnugj@git.kernel.org>
 <20131112105547.GA27310@linux.vnet.ibm.com>
 <20131112115736.GO5056@laptop.programming.kicks-ass.net>
 <20131112164126.GF2559@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131112164126.GF2559@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 12, 2013 at 10:11:26PM +0530, Srikar Dronamraju wrote:
> After Commit-id 863bffc80898 (sched/fair: Fix group power_orig
> computation), we might end up computing group power before the
> sched_domain for a cpu is updated.
> 
> Update with cpu_power, if rq->sd is not yet updated.
> 
> Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> ---
> Changelog since v1: Fix divide by zero errors that can result because
> power/power_orig was set to 0.

Duh yes!, init_sched_groups_power() is called before we attach the
actual domains, so the above will _always_ fail for the
build_sched_domain() case.

I was a bit puzzled how we could ever have 0 since surely at least the
current cpu should have some !0 contribution, but no!

---
Subject: sched: Check sched_domain before computing group power
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Date: Tue, 12 Nov 2013 22:11:26 +0530

After Commit-id 863bffc80898 (sched/fair: Fix group power_orig
computation), we can dereference rq->sd before its set.

Fix this by falling back to power_of() in this case and add a comment
explaining things.

Cc: mikey@neuling.org
Cc: mingo@kernel.org
Cc: hpa@zytor.com
Cc: tglx@linutronix.de
Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
[peterz: added comment and tweaked patch]
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20131112164126.GF2559@linux.vnet.ibm.com
---
 kernel/sched/fair.c |   27 ++++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5354,10 +5354,31 @@ void update_group_power(struct sched_dom
 		 */
 
 		for_each_cpu(cpu, sched_group_cpus(sdg)) {
-			struct sched_group *sg = cpu_rq(cpu)->sd->groups;
+			struct sched_group_power *sgp;
+			struct rq *rq = cpu_rq(cpu);
 
-			power_orig += sg->sgp->power_orig;
-			power += sg->sgp->power;
+			/*
+			 * build_sched_domains() -> init_sched_groups_power()
+			 * gets here before we've attached the domains to the
+			 * runqueues.
+			 *
+			 * Use power_of(), which is set irrespective of domains
+			 * in update_cpu_power().
+			 *
+			 * This avoids power/power_orig from being 0 and
+			 * causing divide-by-zero issues on boot.
+			 *
+			 * Runtime updates will correct power_orig.
+			 */
+			if (!rq->sd) {
+				power_orig += power_of(cpu);
+				power += power_of(cpu);
+				continue;
+			}
+
+			sgp = rq->sd->groups->sgp;
+			power_orig += sgp->power_orig;
+			power += sgp->power;
 		}
 	} else  {
 		/*
