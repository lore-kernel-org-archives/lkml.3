Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896AbaHKLd5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 07:33:57 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:43120 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871AbaHKLd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 07:33:56 -0400
Subject: [RFC PATCH V2 03/19] sched/idle: Enumerate idle states in scheduler
 topology
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
To: alex.shi@intel.com, vincent.guittot@linaro.org, peterz@infradead.org,
        pjt@google.com, efault@gmx.de, rjw@rjwysocki.net,
        morten.rasmussen@arm.com, svaidy@linux.vnet.ibm.com,
        arjan@linux.intel.com, mingo@kernel.org
Cc: nicolas.pitre@linaro.org, len.brown@intel.com, yuyang.du@intel.com,
        linaro-kernel@lists.linaro.org, daniel.lezcano@linaro.org,
        corbet@lwn.net, catalin.marinas@arm.com, markgross@thegnar.org,
        sundar.iyer@intel.com, linux-kernel@vger.kernel.org,
        dietmar.eggemann@arm.com, Lorenzo.Pieralisi@arm.com,
        mike.turquette@linaro.org, akpm@linux-foundation.org,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de
Date: Mon, 11 Aug 2014 17:03:35 +0530
Message-ID: <20140811113322.31956.58019.stgit@preeti.in.ibm.com>
In-Reply-To: <20140811113000.31956.52857.stgit@preeti.in.ibm.com>
References: <20140811113000.31956.52857.stgit@preeti.in.ibm.com>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14081111-7164-0000-0000-000003BAA32A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The goal of the power aware scheduler design is to integrate
all cpu power management in the scheduler. As a first step
the idle state selection was moved into the scheduler. Doing
this helps better decide which idle state to enter into using
metrics known by the scheduler. However the cost of entering
and exiting an idle state can help the scheduler do load balancing
better.It would be even better if the idle states can let the
scheduler know about the impact on the cache contents when
the cpu enters that state. The scheduler can make use of this data
while waking up tasks or scheduling new tasks. To make way for such
information to be propogated to the scheduler, enumerate idle states
in the scheduler topology levels.

Doing so will also let the scheduler know the idle states
that a *sched_group* can enter into at a given level of scheduling
domain. This means the scheduler is implicitly made aware of the
fact that idle state is not necessarily a per-cpu state, it can be a
per-core state or a state shared by a group of cpus that is specified
by the sched_group. The knowledge of this higher level cpuidle information
is missing today too.

The low level platform cpuidle drivers must expose to the scheduler
the idle states at the different topology levels. This patch takes
up the powernv cpuidle driver to illustrate this. The scheduling
topology is left to the arch to decide.
Commit 143e1e28cb40bed836 introduced this. The platform idle
drivers are thus in a better position to fill up the topology
levels with appropriate cpuidle state information while they discover
it themselves.

Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
---

 drivers/cpuidle/cpuidle-powernv.c |    8 ++++++++
 include/linux/sched.h             |    3 +++
 2 files changed, 11 insertions(+)

diff --git a/drivers/cpuidle/cpuidle-powernv.c b/drivers/cpuidle/cpuidle-powernv.c
index 95ef533..4232fbc 100644
--- a/drivers/cpuidle/cpuidle-powernv.c
+++ b/drivers/cpuidle/cpuidle-powernv.c
@@ -184,6 +184,11 @@ static int powernv_add_idle_states(void)
 
 	dt_idle_states = len_flags / sizeof(u32);
 
+#ifdef CONFIG_SCHED_POWER
+	/* Snooze is a thread level idle state; the rest are core level idle states */
+	sched_domain_topology[0].states[0] = powernv_states[0];
+#endif
+
 	for (i = 0; i < dt_idle_states; i++) {
 
 		flags = be32_to_cpu(idle_state_flags[i]);
@@ -209,6 +214,9 @@ static int powernv_add_idle_states(void)
 			powernv_states[nr_idle_states].enter = &fastsleep_loop;
 			nr_idle_states++;
 		}
+#ifdef CONFIG_SCHED_POWER
+		sched_domain_topology[1].states[i] = powernv_states[nr_idle_states];
+#endif
 	}
 
 	return nr_idle_states;
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 5dd99b5..009da6a 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1027,6 +1027,9 @@ struct sched_domain_topology_level {
 #ifdef CONFIG_SCHED_DEBUG
 	char                *name;
 #endif
+#ifdef CONFIG_SCHED_POWER
+	struct cpuidle_state states[CPUIDLE_STATE_MAX];
+#endif
 };
 
 extern struct sched_domain_topology_level *sched_domain_topology;

