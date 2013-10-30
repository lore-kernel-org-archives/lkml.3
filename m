Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384Ab3J3DPu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 23:15:50 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:55120 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753121Ab3J3DPt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 23:15:49 -0400
Subject: [PATCH V2 1/2] sched: Fix asymmetric scheduling for POWER7
To: peterz@infradead.org, mikey@neuling.org, svaidy@linux.vnet.ibm.com,
        mingo@kernel.org
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: vincent.guittot@linaro.org, bitbucket@online.de, benh@kernel.crashing.org,
        linux-kernel@vger.kernel.org, anton@samba.org,
        linuxppc-dev@lists.ozlabs.org, Morten.Rasmussen@arm.com,
        pjt@google.com
Date: Wed, 30 Oct 2013 08:42:42 +0530
Message-ID: <20131030031242.23426.13019.stgit@preeti.in.ibm.com>
In-Reply-To: <20131030031145.23426.22930.stgit@preeti.in.ibm.com>
References: <20131030031145.23426.22930.stgit@preeti.in.ibm.com>
User-Agent: StGit/0.16-38-g167d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13103003-0320-0000-0000-0000018F41A6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>

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
Tested-by: Michael Neuling <mikey@neuling.org>
---

 kernel/sched/fair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 813dd61..e9c9549 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6781,7 +6781,7 @@ static inline int nohz_kick_needed(struct rq *rq, int cpu)
 		if (sd->flags & SD_SHARE_PKG_RESOURCES && nr_busy > 1)
 			goto need_kick_unlock;
 
-		if (sd->flags & SD_ASYM_PACKING && nr_busy != sg->group_weight
+		if (sd->flags & SD_ASYM_PACKING
 		    && (cpumask_first_and(nohz.idle_cpus_mask,
 					  sched_domain_span(sd)) < cpu))
 			goto need_kick_unlock;

