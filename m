Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836Ab3LMMMa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 07:12:30 -0500
Received: from service87.mimecast.com ([91.220.42.44]:50896 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723Ab3LMMLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 07:11:25 -0500
From: dietmar.eggemann@arm.com
To: peterz@infradead.org, mingo@redhat.com, vincent.guittot@linaro.org,
        morten.rasmussen@arm.com, chris.redpath@arm.com
Cc: linux-kernel@vger.kernel.org, dietmar.eggemann@arm.com
Subject: [RFC PATCH 6/8] sched: replace for_each_sd_topology with explicit for loop
Date: Fri, 13 Dec 2013 12:11:26 +0000
Message-Id: <1386936688-29113-7-git-send-email-dietmar.eggemann@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386936688-29113-1-git-send-email-dietmar.eggemann@arm.com>
References: <1386936688-29113-1-git-send-email-dietmar.eggemann@arm.com>
X-OriginalArrivalTime: 13 Dec 2013 12:11:21.0897 (UTC) FILETIME=[6FBF9990:01CEF7FC]
X-MC-Unique: 113121312112309101
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id rBDCCpdk009926

From: Dietmar Eggemann <dietmar.eggemann@arm.com>

This patch prepares the scheduler domain level set up code to be able to
not rely on the default_topology[] any more.
The for_each_sd_topology macro is replaced with an explicit for loop
iterating over the sched_domain_topology array.  It introduces the file
global variable sched_domains_levels to hold the number of scheduler
domain levels.

Signed-off-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
---
 kernel/sched/core.c |   27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 37febb067bad..897ff9222cab 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5379,9 +5379,7 @@ static struct sched_domain_topology_level default_topology[] = {
 };
 
 static struct sched_domain_topology_level *sched_domain_topology = default_topology;
-
-#define for_each_sd_topology(tl)			\
-	for (tl = sched_domain_topology; tl->init; tl++)
+static int sched_domains_levels;
 
 #ifdef CONFIG_NUMA
 
@@ -5734,7 +5732,9 @@ static void sched_alloc(void)
 	}
 #endif /* CONFIG_NUMA */
 
-	tl = kzalloc((ARRAY_SIZE(default_topology) + level) *
+	sched_domains_levels = arch_sd_levels();
+
+	tl = kzalloc((sched_domains_levels + level) *
 			sizeof(struct sched_domain_topology_level), GFP_KERNEL);
 	if (!tl)
 		return;
@@ -5761,15 +5761,16 @@ static void sched_alloc(void)
 	}
 
 	sched_domains_numa_levels = level;
+	sched_domains_levels += level;
 #endif /* CONFIG_NUMA */
 }
 
 static int __sdt_alloc(const struct cpumask *cpu_map)
 {
-	struct sched_domain_topology_level *tl;
-	int j;
+	int i, j;
 
-	for_each_sd_topology(tl) {
+	for (i = 0; i < sched_domains_levels; i++) {
+		struct sched_domain_topology_level *tl = &sched_domain_topology[i];
 		struct sd_data *sdd = &tl->data;
 
 		sdd->sd = alloc_percpu(struct sched_domain *);
@@ -5819,10 +5820,10 @@ static int __sdt_alloc(const struct cpumask *cpu_map)
 
 static void __sdt_free(const struct cpumask *cpu_map)
 {
-	struct sched_domain_topology_level *tl;
-	int j;
+	int i, j;
 
-	for_each_sd_topology(tl) {
+	for (i = 0; i < sched_domains_levels; i++) {
+		struct sched_domain_topology_level *tl = &sched_domain_topology[i];
 		struct sd_data *sdd = &tl->data;
 
 		for_each_cpu(j, cpu_map) {
@@ -5887,10 +5888,10 @@ static int build_sched_domains(const struct cpumask *cpu_map,
 
 	/* Set up domains for cpus specified by the cpu_map. */
 	for_each_cpu(i, cpu_map) {
-		struct sched_domain_topology_level *tl;
-
+		int y;
 		sd = NULL;
-		for_each_sd_topology(tl) {
+		for (y = 0; y < sched_domains_levels; y++) {
+			struct sched_domain_topology_level *tl = &sched_domain_topology[y];
 			sd = build_sched_domain(tl, cpu_map, attr, sd, i);
 			if (tl == sched_domain_topology)
 				*per_cpu_ptr(d.sd, i) = sd;
-- 
1.7.9.5


