Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508Ab3JULpG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 07:45:06 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:44876 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753471Ab3JULpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 07:45:04 -0400
Subject: [PATCH 2/3] sched: Fix asymmetric scheduling for POWER7
To: Peter Zijlstra <peterz@infradead.org>,
        Mike Galbraith <bitbucket@online.de>, Paul Turner <pjt@google.com>,
        Ingo Molnar <mingo@kernel.org>
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Cc: Michael Neuling <mikey@neuling.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, Anton Blanchard <anton@samba.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        linuxppc-dev@lists.ozlabs.org
Date: Mon, 21 Oct 2013 17:14:52 +0530
Message-ID: <20131021114452.13291.19947.stgit@drishya>
In-Reply-To: <20131021114002.13291.31478.stgit@drishya>
References: <20131021114002.13291.31478.stgit@drishya>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13102111-9264-0000-0000-000004C3B4DD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Asymmetric scheduling within a core is a scheduler loadbalancing
feature that is triggered when SD_ASYM_PACKING flag is set.  The goal
for the load balancer is to move tasks to lower order idle SMT threads
within a core on a POWER7 system.

In nohz_kick_needed(), we intend to check if our sched domain (core)
is completely busy or we have idle cpu.

The following check for SD_ASYM_PACKING:

    (cpumask_first_and(nohz.idle_cpus_mask, sched_domain_span(sd)) < cpu)

already covers the case of checking if the domain has an idle cpu,
because cpumask_first_and() will not yield any set bits if this domain
has no idle cpu.

Hence, nr_busy check against group weight can be removed.

Reported-by: Michael Neuling <michael.neuling@au1.ibm.com>
Signed-off-by: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
---
 kernel/sched/fair.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 12f0eab..828ed97 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5821,8 +5821,8 @@ static inline int nohz_kick_needed(struct rq *rq, int cpu)
 				goto need_kick_unlock;
 		}
 
-		if (sd->flags & SD_ASYM_PACKING && nr_busy != sg->group_weight
-		    && (cpumask_first_and(nohz.idle_cpus_mask,
+		if (sd->flags & SD_ASYM_PACKING &&
+			(cpumask_first_and(nohz.idle_cpus_mask,
 					  sched_domain_span(sd)) < cpu))
 			goto need_kick_unlock;
 

