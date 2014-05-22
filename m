Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485AbaEVM2O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 08:28:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51267 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755090AbaEVM2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 08:28:12 -0400
Date: Thu, 22 May 2014 05:27:24 -0700
From: tip-bot for Vincent Guittot <tipbot@zytor.com>
Message-ID: <tip-c515db8cd311ef77b2dc7cbd6b695022655bb0f3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jet.chen@intel.com, peterz@infradead.org, vincent.guittot@linaro.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jet.chen@intel.com, peterz@infradead.org, vincent.guittot@linaro.org,
        tglx@linutronix.de
In-Reply-To: <1399972261-25693-1-git-send-email-vincent.guittot@linaro.org>
References: <1399972261-25693-1-git-send-email-vincent.guittot@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/numa:
  Fix initialization of sched_domain_topology for NUMA
Git-Commit-ID: c515db8cd311ef77b2dc7cbd6b695022655bb0f3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c515db8cd311ef77b2dc7cbd6b695022655bb0f3
Gitweb:     http://git.kernel.org/tip/c515db8cd311ef77b2dc7cbd6b695022655bb0f3
Author:     Vincent Guittot <vincent.guittot@linaro.org>
AuthorDate: Tue, 13 May 2014 11:11:01 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 22 May 2014 11:16:29 +0200

sched/numa: Fix initialization of sched_domain_topology for NUMA

Jet Chen has reported a kernel panics when booting qemu-system-x86_64 with
kvm64 cpu. A panic occured while building the sched_domain.

In sched_init_numa, we create a new topology table in which both default
levels and numa levels are copied. The last row of the table must have a null
pointer in the mask field.

The current implementation doesn't add this last row in the computation of the
table size. So we add 1 row in the allocation size that will be used as the
last row of the table. The kzalloc will ensure that the mask field is NULL.

Reported-by: Jet Chen <jet.chen@intel.com>
Tested-by: Jet Chen <jet.chen@intel.com>
Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: fengguang.wu@intel.com
Link: http://lkml.kernel.org/r/1399972261-25693-1-git-send-email-vincent.guittot@linaro.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index a78c5b6..45d077e 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6231,7 +6231,7 @@ static void sched_init_numa(void)
 	/* Compute default topology size */
 	for (i = 0; sched_domain_topology[i].mask; i++);
 
-	tl = kzalloc((i + level) *
+	tl = kzalloc((i + level + 1) *
 			sizeof(struct sched_domain_topology_level), GFP_KERNEL);
 	if (!tl)
 		return;
