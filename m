Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753172Ab3GIP5a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 11:57:30 -0400
Received: from service87.mimecast.com ([91.220.42.44]:45974 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419Ab3GIPzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 11:55:36 -0400
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: mingo@kernel.org, peterz@infradead.org
Cc: arjan@linux.intel.com, vincent.guittot@linaro.org,
        preeti@linux.vnet.ibm.com, alex.shi@intel.com, efault@gmx.de,
        pjt@google.com, len.brown@intel.com, corbet@lwn.net,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        tglx@linutronix.de, catalin.marinas@arm.com,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        morten.rasmussen@arm.com
Subject: [RFC][PATCH 4/9] sched: Make periodic load-balance disregard cpus with a cpu_power of 1
Date: Tue,  9 Jul 2013 16:55:33 +0100
Message-Id: <1373385338-12983-5-git-send-email-morten.rasmussen@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1373385338-12983-1-git-send-email-morten.rasmussen@arm.com>
References: <1373385338-12983-1-git-send-email-morten.rasmussen@arm.com>
X-OriginalArrivalTime: 09 Jul 2013 15:55:33.0419 (UTC) FILETIME=[BEA037B0:01CE7CBC]
X-MC-Unique: 113070916553406601
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r69FvjiY011649

Some of the load_balance() helper functions will put tasks on cpus with
cpu_power=1 when they are completely idle. This patch changes this behaviour.

The patch is a quick fix. The load_balance() helper functions should be
revisited to implement proper handling of cpus with cpu_power=1.

Signed-off-by: Morten Rasmussen <morten.rasmussen@arm.com>
CC: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Catalin Marinas <catalin.marinas@arm.com>
---
 kernel/sched/fair.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index f637ea5..4610463 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3952,6 +3952,13 @@ int can_migrate_task(struct task_struct *p, struct lb_env *env)
 	}
 
 	/*
+	 * Vacate cpus disabled by the power scheduler even if the cache is
+	 * hot
+	 */
+	if (!power_cpu_balance(env->src_cpu))
+		return 1;
+
+	/*
 	 * Aggressive migration if:
 	 * 1) task is cache cold, or
 	 * 2) too many balance attempts have failed.
@@ -4500,6 +4507,11 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 			update_group_power(env->sd, env->dst_cpu);
 		} else if (time_after_eq(jiffies, group->sgp->next_update))
 			update_group_power(env->sd, env->dst_cpu);
+
+		if (!power_cpu_balance(env->dst_cpu)) {
+			*balance = 0;
+			return;
+		}
 	}
 
 	/* Adjust by relative CPU power of the group */
-- 
1.7.9.5


