Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759481AbaGCQca (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 12:32:30 -0400
Received: from service87.mimecast.com ([91.220.42.44]:45062 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759147AbaGCQ0L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 12:26:11 -0400
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        peterz@infradead.org, mingo@kernel.org
Cc: rjw@rjwysocki.net, vincent.guittot@linaro.org, daniel.lezcano@linaro.org,
        preeti@linux.vnet.ibm.com, Dietmar.Eggemann@arm.com, pjt@google.com
Subject: [RFCv2 PATCH 05/23] sched: Add energy procfs interface
Date: Thu,  3 Jul 2014 17:25:52 +0100
Message-Id: <1404404770-323-6-git-send-email-morten.rasmussen@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1404404770-323-1-git-send-email-morten.rasmussen@arm.com>
References: <1404404770-323-1-git-send-email-morten.rasmussen@arm.com>
MIME-Version: 1.0
X-OriginalArrivalTime: 03 Jul 2014 16:26:09.0834 (UTC) FILETIME=[7F8328A0:01CF96DB]
X-MC-Unique: 114070317260911701
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dietmar Eggemann <dietmar.eggemann@arm.com>

This patch makes the energy data available via procfs. The related files
are placed as sub-directory named 'energy' inside the
/proc/sys/kernel/sched_domain/cpuX/domainY/groupZ directory for those
cpu/domain/group tuples which have energy information.

The following example depicts the contents of
/proc/sys/kernel/sched_domain/cpu0/domain0/group[01] for a system which
has energy information attached to domain level 0.

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
│   │   │       ├── idle_states
│   │   │       ├── nr_cap_states
│   │   │       └── nr_idle_states
│   │   ├── group1
│   │   │   └── energy
│   │   │       ├── cap_states
│   │   │       ├── idle_states
│   │   │       ├── nr_cap_states
│   │   │       └── nr_idle_states
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

The files 'nr_idle_states' and 'nr_cap_states' contain a scalar value
whereas 'idle_states' and 'cap_states' contain a vector of (power
consumption, wakeup energy for run->sleep->run cycle for this idle
state) respectively (compute capacity, power consumption at this compute
capacity) tuples.

Signed-off-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
---
 kernel/sched/core.c |   67 +++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 65 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index ecece17..7fecc63 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4931,9 +4931,60 @@ set_table_entry(struct ctl_table *entry,
 }
 
 static struct ctl_table *
+sd_alloc_ctl_energy_table(struct sched_group_energy *sge)
+{
+	struct ctl_table *table = sd_alloc_ctl_entry(5);
+
+	if (table == NULL)
+		return NULL;
+
+	set_table_entry(&table[0], "nr_idle_states", &sge->nr_idle_states,
+			sizeof(int), 0644, proc_dointvec_minmax, false);
+	set_table_entry(&table[1], "idle_states", &sge->idle_states[0].power,
+			sge->nr_idle_states*sizeof(struct idle_state), 0644,
+			proc_doulongvec_minmax, false);
+	set_table_entry(&table[2], "nr_cap_states", &sge->nr_cap_states,
+			sizeof(int), 0644, proc_dointvec_minmax, false);
+	set_table_entry(&table[3], "cap_states", &sge->cap_states[0].cap,
+			sge->nr_cap_states*sizeof(struct capacity_state), 0644,
+			proc_doulongvec_minmax, false);
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
+
+static struct ctl_table *
 sd_alloc_ctl_domain_table(struct sched_domain *sd)
 {
-	struct ctl_table *table = sd_alloc_ctl_entry(14);
+	struct ctl_table *table;
+	unsigned int nr_entries = 14;
+
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
+
+	table = sd_alloc_ctl_entry(nr_entries);
 
 	if (table == NULL)
 		return NULL;
@@ -4966,7 +5017,19 @@ sd_alloc_ctl_domain_table(struct sched_domain *sd)
 		sizeof(long), 0644, proc_doulongvec_minmax, false);
 	set_table_entry(&table[12], "name", sd->name,
 		CORENAME_MAX_SIZE, 0444, proc_dostring, false);
-	/* &table[13] is terminator */
+	sg = sd->groups;
+	if (sg->sge) {
+		char buf[32];
+		struct ctl_table *entry = &table[13];
+
+		do {
+			snprintf(buf, 32, "group%d", i);
+			entry->procname = kstrdup(buf, GFP_KERNEL);
+			entry->mode = 0555;
+			entry->child = sd_alloc_ctl_group_table(sg);
+		} while (entry++, i++, sg = sg->next, sg != sd->groups);
+	}
+	/* &table[nr_entries-1] is terminator */
 
 	return table;
 }
-- 
1.7.9.5


