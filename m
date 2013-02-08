Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946927Ab3BHSGf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 13:06:35 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:60584 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946893Ab3BHSGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 13:06:10 -0500
From: Vincent Guittot <vincent.guittot@linaro.org>
To: linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        peterz@infradead.org, mingo@kernel.org, fweisbec@gmail.com,
        rostedt@goodmis.org, efault@gmx.de
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Subject: [PATCH v3 1/2] sched: fix init NOHZ_IDLE flag
Date: Fri,  8 Feb 2013 19:05:17 +0100
Message-Id: <1360346718-3313-2-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360346718-3313-1-git-send-email-vincent.guittot@linaro.org>
References: <1360346718-3313-1-git-send-email-vincent.guittot@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On my smp platform which is made of 5 cores in 2 clusters, I have the
nr_busy_cpu field of sched_group_power struct that is not null when the
platform is fully idle. The root cause seems to be:
During the boot sequence, some CPUs reach the idle loop and set their
NOHZ_IDLE flag while waiting for others CPUs to boot. But the nr_busy_cpus
field is initialized later with the assumption that all CPUs are in the busy
state whereas some CPUs have already set their NOHZ_IDLE flag.
We set the NOHZ_IDLE flag when nr_busy_cpus is initialized to 0 in order to
have a coherent configuration.

The patch 2/2 protects this init against an update of NOHZ_IDLE flag because
a NULL sched_domain is attached to the CPU during the build of the new
sched_domain so nohz_kick_needed and set_cpu_sd_state_busy are not called and
can't clear the NOHZ_IDLE flag

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
---
 kernel/sched/core.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 26058d0..c730a4e 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5884,7 +5884,9 @@ static void init_sched_groups_power(int cpu, struct sched_domain *sd)
 		return;
 
 	update_group_power(sd, cpu);
-	atomic_set(&sg->sgp->nr_busy_cpus, sg->group_weight);
+	atomic_set(&sg->sgp->nr_busy_cpus, 0);
+	set_bit(NOHZ_IDLE, nohz_flags(cpu));
+
 }
 
 int __weak arch_sd_sibling_asym_packing(void)
-- 
1.7.9.5

