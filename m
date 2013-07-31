Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759236Ab3GaIoU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 04:44:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47708 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754269Ab3GaIoP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 04:44:15 -0400
Date: Wed, 31 Jul 2013 09:44:11 +0100
From: Mel Gorman <mgorman@suse.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched, numa: migrates_degrades_locality()
Message-ID: <20130731084411.GG2296@suse.de>
References: <1373901620-2021-1-git-send-email-mgorman@suse.de>
 <1373901620-2021-8-git-send-email-mgorman@suse.de>
 <20130725104009.GO27075@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20130725104009.GO27075@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 12:40:09PM +0200, Peter Zijlstra wrote:
> 
> Subject: sched, numa: migrates_degrades_locality()
> From: Peter Zijlstra <peterz@infradead.org>
> Date: Mon Jul 22 14:02:54 CEST 2013
> 
> It just makes heaps of sense; so add it and make both it and
> migrate_improve_locality() a sched_feat().
> 

Ok. I'll be splitting this patch and merging part of it into "sched:
Favour moving tasks towards the preferred node" and keeping the
degrades_locality as a separate patch. I'm also not a fan of the
tunables names NUMA_FAULTS_UP and NUMA_FAULTS_DOWN because it is hard to
guess what they mean. NUMA_FAVOUR_HIGHER, NUMA_RESIST_LOWER?

Change to just the parent patch looks is as follows. task_faults() is
not introduced yet in the series which is why it is still missing.

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 78bfbea..5ea3afe 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3978,8 +3978,10 @@ static bool migrate_improves_locality(struct task_struct *p, struct lb_env *env)
 {
 	int src_nid, dst_nid;
 
-	if (!p->numa_faults || !(env->sd->flags & SD_NUMA))
+	if (!sched_feat(NUMA_FAVOUR_HIGHER || !p->numa_faults ||
+	    !(env->sd->flags & SD_NUMA))) {
 		return false;
+	}
 
 	src_nid = cpu_to_node(env->src_cpu);
 	dst_nid = cpu_to_node(env->dst_cpu);
@@ -3988,7 +3990,7 @@ static bool migrate_improves_locality(struct task_struct *p, struct lb_env *env)
 	    p->numa_migrate_seq >= sysctl_numa_balancing_settle_count)
 		return false;
 
-	if (p->numa_preferred_nid == dst_nid)
+	if (p->numa_faults[dst_nid] > p->numa_faults[src_nid])
 		return true;
 
 	return false;
diff --git a/kernel/sched/features.h b/kernel/sched/features.h
index 99399f8..97a1136 100644
--- a/kernel/sched/features.h
+++ b/kernel/sched/features.h
@@ -69,4 +69,11 @@ SCHED_FEAT(LB_MIN, false)
 #ifdef CONFIG_NUMA_BALANCING
 SCHED_FEAT(NUMA,	false)
 SCHED_FEAT(NUMA_FORCE,	false)
+
+/*
+ * NUMA_FAVOUR_HIGHER will favor moving tasks towards nodes where a
+ * higher number of hinting faults are recorded during active load
+ * balancing.
+ */
+SCHED_FEAT(NUMA_FAVOUR_HIGHER, true)
 #endif

-- 
Mel Gorman
SUSE Labs
