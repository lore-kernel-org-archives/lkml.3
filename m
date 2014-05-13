Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759899AbaEMJML (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 05:12:11 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:34592 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759884AbaEMJMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:12:08 -0400
From: Vincent Guittot <vincent.guittot@linaro.org>
To: peterz@infradead.org, mingo@kernel.org
Cc: jet.chen@intel.com, fengguang.wu@intel.com, linux-ia64@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: sched: fix: initialization of sched_domain_topology for NUMA
Date: Tue, 13 May 2014 11:11:01 +0200
Message-Id: <1399972261-25693-1-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <20140513082609.GA2485@laptop.programming.kicks-ass.net>
References: <20140513082609.GA2485@laptop.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
link: https://lkml.org/lkml/2014/5/12/130

---

Hi Peter,

Does this commit message contain enough information ?

Regards,
Vincent

 kernel/sched/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 4ea7b3f..205fa17 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6234,7 +6234,7 @@ static void sched_init_numa(void)
 	/* Compute default topology size */
 	for (i = 0; sched_domain_topology[i].mask; i++);
 
-	tl = kzalloc((i + level) *
+	tl = kzalloc((i + level + 1) *
 			sizeof(struct sched_domain_topology_level), GFP_KERNEL);
 	if (!tl)
 		return;
-- 
1.9.1

