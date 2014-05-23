Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752387AbaEWSVJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 14:21:09 -0400
Received: from service87.mimecast.com ([91.220.42.44]:35990 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303AbaEWSQw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 14:16:52 -0400
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        peterz@infradead.org, mingo@kernel.org
Cc: rjw@rjwysocki.net, vincent.guittot@linaro.org, daniel.lezcano@linaro.org,
        preeti@linux.vnet.ibm.com, dietmar.eggemann@arm.com
Subject: [RFC PATCH 05/16] sched: Add sd energy procfs interface
Date: Fri, 23 May 2014 19:16:32 +0100
Message-Id: <1400869003-27769-6-git-send-email-morten.rasmussen@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400869003-27769-1-git-send-email-morten.rasmussen@arm.com>
References: <1400869003-27769-1-git-send-email-morten.rasmussen@arm.com>
MIME-Version: 1.0
X-OriginalArrivalTime: 23 May 2014 18:16:49.0651 (UTC) FILETIME=[2A371430:01CF76B3]
X-MC-Unique: 114052319165000801
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dietmar Eggemann <dietmar.eggemann@arm.com>

This patch makes the values of the sd energy data structure available via
procfs.  The related files are placed as sub-directory named 'energy'
inside the /proc/sys/kernel/sched_domain/cpuX/domainY/groupZ directory for
those cpu/domain/group tuples which have sd energy information.

The following example depicts the contents of
/proc/sys/kernel/sched_domain/cpu0/domain0/group[01] for a system which
has sd energy information attached to domain level 0.

├── cpu0
│   ├── domain0
│   │   ├── busy_factor
│   │   ├── busy_idx
│   │   ├── cache_nice_tries
│   │   ├── flags
│   │   ├── forkexec_idx
│   │   ├── group0
│   │   │   └── energy
│   │   │       ├── cap_states
│   │   │       ├── idle_power
│   │   │       ├── max_capacity
│   │   │       ├── nr_cap_states
│   │   │       └── wakeup_energy
│   │   ├── group1
│   │   │   └── energy
│   │   │       ├── cap_states
│   │   │       ├── idle_power
│   │   │       ├── max_capacity
│   │   │       ├── nr_cap_states
│   │   │       └── wakeup_energy
│   │   ├── idle_idx
│   │   ├── imbalance_pct
│   │   ├── max_interval
│   │   ├── max_newidle_lb_cost
│   │   ├── min_interval
│   │   ├── name
│   │   ├── newidle_idx
│   │   └── wake_idx
│   └── domain1
│       ├── busy_factor
│       ├── busy_idx
│       ├── cache_nice_tries
│       ├── flags
│       ├── forkexec_idx
│       ├── idle_idx
│       ├── imbalance_pct
│       ├── max_interval
│       ├── max_newidle_lb_cost
│       ├── min_interval
│       ├── name
│       ├── newidle_idx
│       └── wake_idx

The files 'idle_power', 'max_capacity', 'nr_cap_states' and 'wakeup_energy'
contain a scalar value whereas 'cap_states' contains a vector of
(compute capacity, power consumption @ this compute capacity) tuples.

Signed-off-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
---
 kernel/sched/core.c |   73 +++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 71 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 785b61d..096fa55 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4837,10 +4837,66 @@ set_table_entry(struct ctl_table *entry,
 	}
 }
 
+#ifdef CONFIG_SCHED_ENERGY
+static struct ctl_table *
+sd_alloc_ctl_energy_table(struct sched_group_energy *sge)
+{
+	struct ctl_table *table = sd_alloc_ctl_entry(6);
+
+	if (table == NULL)
+		return NULL;
+
+	set_table_entry(&table[0], "max_capacity", &sge->data.max_capacity,
+			sizeof(long), 0644, proc_doulongvec_minmax, false);
+	set_table_entry(&table[1], "idle_power", &sge->data.idle_power,
+			sizeof(int), 0644, proc_dointvec_minmax, false);
+	set_table_entry(&table[2], "wakeup_energy", &sge->data.wakeup_energy,
+			sizeof(int), 0644, proc_dointvec_minmax, false);
+	set_table_entry(&table[3], "nr_cap_states", &sge->data.nr_cap_states,
+			sizeof(int), 0644, proc_dointvec_minmax, false);
+	set_table_entry(&table[4], "cap_states", &sge->data.cap_states[0].cap,
+			sge->data.nr_cap_states*2*sizeof(int), 0644,
+			proc_dointvec_minmax, false);
+
+	return table;
+}
+
+static struct ctl_table *
+sd_alloc_ctl_group_table(struct sched_group *sg)
+{
+	struct ctl_table *table = sd_alloc_ctl_entry(2);
+
+	if (table == NULL)
+		return NULL;
+
+	table->procname = kstrdup("energy", GFP_KERNEL);
+	table->mode = 0555;
+	table->child = sd_alloc_ctl_energy_table(sg->sge);
+
+	return table;
+}
+#endif
+
 static struct ctl_table *
 sd_alloc_ctl_domain_table(struct sched_domain *sd)
 {
-	struct ctl_table *table = sd_alloc_ctl_entry(14);
+	struct ctl_table *table;
+	unsigned int nr_entries = 14;
+
+#ifdef CONFIG_SCHED_ENERGY
+	int i = 0;
+	struct sched_group *sg = sd->groups;
+
+	if (sg->sge) {
+		int nr_sgs = 0;
+
+		do {} while (nr_sgs++, sg = sg->next, sg != sd->groups);
+
+		nr_entries += nr_sgs;
+	}
+#endif
+
+	table = sd_alloc_ctl_entry(nr_entries);
 
 	if (table == NULL)
 		return NULL;
@@ -4873,7 +4929,20 @@ sd_alloc_ctl_domain_table(struct sched_domain *sd)
 		sizeof(long), 0644, proc_doulongvec_minmax, false);
 	set_table_entry(&table[12], "name", sd->name,
 		CORENAME_MAX_SIZE, 0444, proc_dostring, false);
-	/* &table[13] is terminator */
+#ifdef CONFIG_SCHED_ENERGY
+	sg = sd->groups;
+	if (sg->sge) {
+		char buf[32];
+		struct ctl_table *entry = &table[13];
+		do {
+			snprintf(buf, 32, "group%d", i);
+			entry->procname = kstrdup(buf, GFP_KERNEL);
+			entry->mode = 0555;
+			entry->child = sd_alloc_ctl_group_table(sg);
+		} while (entry++, i++, sg = sg->next, sg != sd->groups);
+	}
+#endif
+	/* &table[nr_entries-1] is terminator */
 
 	return table;
 }
-- 
1.7.9.5


