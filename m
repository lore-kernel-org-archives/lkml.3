Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932407Ab3KFNVV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 08:21:21 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48990 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932346Ab3KFNUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 08:20:50 -0500
Date: Wed, 6 Nov 2013 05:20:09 -0800
From: tip-bot for Vaidyanathan Srinivasan <tipbot@zytor.com>
Message-ID: <tip-2042abe7977222ef606306faa2dce8fd51e98e65@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, michael.neuling@au1.ibm.com,
        preeti@linux.vnet.ibm.com, tglx@linutronix.de,
        svaidy@linux.vnet.ibm.com, mikey@neuling.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, michael.neuling@au1.ibm.com,
        preeti@linux.vnet.ibm.com, tglx@linutronix.de, mikey@neuling.org,
        svaidy@linux.vnet.ibm.com
In-Reply-To: <20131030031242.23426.13019.stgit@preeti.in.ibm.com>
References: <20131030031242.23426.13019.stgit@preeti.in.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Fix asymmetric scheduling for POWER7
Git-Commit-ID: 2042abe7977222ef606306faa2dce8fd51e98e65
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 06 Nov 2013 05:20:17 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2042abe7977222ef606306faa2dce8fd51e98e65
Gitweb:     http://git.kernel.org/tip/2042abe7977222ef606306faa2dce8fd51e98e65
Author:     Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
AuthorDate: Wed, 30 Oct 2013 08:42:42 +0530
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 6 Nov 2013 12:37:54 +0100

sched: Fix asymmetric scheduling for POWER7

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
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: vincent.guittot@linaro.org
Cc: bitbucket@online.de
Cc: benh@kernel.crashing.org
Cc: anton@samba.org
Cc: Morten.Rasmussen@arm.com
Cc: pjt@google.com
Link: http://lkml.kernel.org/r/20131030031242.23426.13019.stgit@preeti.in.ibm.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 41c02b6..074551a 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6800,7 +6800,7 @@ static inline int nohz_kick_needed(struct rq *rq, int cpu)
 		if (sd->flags & SD_SHARE_PKG_RESOURCES && nr_busy > 1)
 			goto need_kick_unlock;
 
-		if (sd->flags & SD_ASYM_PACKING && nr_busy != sg->group_weight
+		if (sd->flags & SD_ASYM_PACKING
 		    && (cpumask_first_and(nohz.idle_cpus_mask,
 					  sched_domain_span(sd)) < cpu))
 			goto need_kick_unlock;
