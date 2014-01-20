Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753115AbaATMkI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 07:40:08 -0500
Received: from service87.mimecast.com ([91.220.42.44]:51548 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942AbaATMkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 07:40:05 -0500
From: dietmar.eggemann@arm.com
To: peterz@infradead.org, mingo@redhat.com, vincent.guittot@linaro.org,
        morten.rasmussen@arm.com, chris.redpath@arm.com
Cc: linux-kernel@vger.kernel.org, dietmar.eggemann@arm.com
Subject: [RFC v2 PATCH 01/11] sched: define sched_domain_topology_info
Date: Mon, 20 Jan 2014 12:39:38 +0000
Message-Id: <1390221588-20473-2-git-send-email-dietmar.eggemann@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1390221588-20473-1-git-send-email-dietmar.eggemann@arm.com>
References: <1390221588-20473-1-git-send-email-dietmar.eggemann@arm.com>
X-OriginalArrivalTime: 20 Jan 2014 12:40:01.0972 (UTC) FILETIME=[BCB0B740:01CF15DC]
X-MC-Unique: 114012012400306601
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id s0KCfKgW003794

From: Dietmar Eggemann <dietmar.eggemann@arm.com>

The idea behind creating the struct sched_domain_topology_info is to be
able to only export the scheduler data which can be changed by the arch.

Exporting the existing struct sched_domain_topology_level means that we
also have to expose struct sd_data anf other scheduler internals.

The extra step of allocating the sched_domain_topology array for pure
conventional sched domain set-up doesn't harm when this will be
consolidated with the existing code in the sched_init_numa() function.

This patch extracts the topology information which can be set by the arch
(cpu mask and sd topology flags) from the existing struct
sched_domain_topology and puts it in struct sched_domain_topology_info.

The struct sched_domain_topology_info is exported in
include/linux/sched.h.  It defines the default struct
sched_domain_topology_info default_topology_info[] for all conventional
scheduler domain level (SMT, MC, BOOK, CPU).

In case an arch wants to use a different default topology info array, it
can overwrite the pointer to this table via the new function
set_sd_topology_info().

Signed-off-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
---
 include/linux/sched.h |   10 ++++++++++
 kernel/sched/core.c   |   29 ++++++++++++++++++++++++++++-
 2 files changed, 38 insertions(+), 1 deletion(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 53f97eb8dbc7..bf2ee608af67 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2780,4 +2780,14 @@ static inline unsigned long rlimit_max(unsigned int limit)
 	return task_rlimit_max(current, limit);
 }
 
+typedef const struct cpumask *(*sched_domain_mask_f)(int cpu);
+
+struct sched_domain_topology_info {
+	sched_domain_mask_f mask;
+	int		    flags;
+};
+
+extern void
+set_sd_topology_info(struct sched_domain_topology_info *ti, unsigned int s);
+
 #endif
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index a88f4a485c5e..8b8a37697a7d 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5014,7 +5014,6 @@ enum s_alloc {
 struct sched_domain_topology_level;
 
 typedef struct sched_domain *(*sched_domain_init_f)(struct sched_domain_topology_level *tl, int cpu);
-typedef const struct cpumask *(*sched_domain_mask_f)(int cpu);
 
 #define SDTL_OVERLAP	0x01
 
@@ -5393,7 +5392,35 @@ static struct sched_domain_topology_level default_topology[] = {
 	{ NULL, },
 };
 
+/*
+ * Topology info list, bottom-up.
+ */
+static struct sched_domain_topology_info default_topology_info[] = {
+#ifdef CONFIG_SCHED_SMT
+	{ cpu_smt_mask, SD_SHARE_CPUPOWER | SD_SHARE_PKG_RESOURCES },
+#endif
+#ifdef CONFIG_SCHED_MC
+	{ cpu_coregroup_mask, SD_SHARE_PKG_RESOURCES },
+#endif
+#ifdef CONFIG_SCHED_BOOK
+	{ cpu_book_mask, },
+#endif
+	{ cpu_cpu_mask, },
+	{ NULL, },
+};
+
 static struct sched_domain_topology_level *sched_domain_topology = default_topology;
+static struct sched_domain_topology_info *sched_domain_topology_info =
+		default_topology_info;
+static unsigned int sched_domain_topology_info_size =
+		ARRAY_SIZE(default_topology_info);
+
+void
+set_sd_topology_info(struct sched_domain_topology_info *ti, unsigned int s)
+{
+	sched_domain_topology_info = ti;
+	sched_domain_topology_info_size = s;
+}
 
 #define for_each_sd_topology(tl)			\
 	for (tl = sched_domain_topology; tl->init; tl++)
-- 
1.7.9.5


