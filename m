Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753707AbaATMlR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 07:41:17 -0500
Received: from service87.mimecast.com ([91.220.42.44]:51797 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150AbaATMkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 07:40:08 -0500
From: dietmar.eggemann@arm.com
To: peterz@infradead.org, mingo@redhat.com, vincent.guittot@linaro.org,
        morten.rasmussen@arm.com, chris.redpath@arm.com
Cc: linux-kernel@vger.kernel.org, dietmar.eggemann@arm.com
Subject: [RFC v2 PATCH 10/11] sched: delete sd ptr arg in arch_scale_freq_power()
Date: Mon, 20 Jan 2014 12:39:47 +0000
Message-Id: <1390221588-20473-11-git-send-email-dietmar.eggemann@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1390221588-20473-1-git-send-email-dietmar.eggemann@arm.com>
References: <1390221588-20473-1-git-send-email-dietmar.eggemann@arm.com>
X-OriginalArrivalTime: 20 Jan 2014 12:40:06.0113 (UTC) FILETIME=[BF289510:01CF15DC]
X-MC-Unique: 114012012400702901
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id s0KCfZJK003802

From: Dietmar Eggemann <dietmar.eggemann@arm.com>

The ARM arch_scale_freq_power function is the only one outside the core
scheduler code using struct sched_domain.  This argument is not used in
the call chain.  This patch deletes it to make it possible to un-export
struct sched_domain.

Signed-off-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
---
 arch/arm/kernel/topology.c |    4 ++--
 kernel/sched/fair.c        |   10 +++++-----
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/arm/kernel/topology.c b/arch/arm/kernel/topology.c
index 85a87370f144..ae209ce7d78f 100644
--- a/arch/arm/kernel/topology.c
+++ b/arch/arm/kernel/topology.c
@@ -42,7 +42,7 @@
  */
 static DEFINE_PER_CPU(unsigned long, cpu_scale);
 
-unsigned long arch_scale_freq_power(struct sched_domain *sd, int cpu)
+unsigned long arch_scale_freq_power(int cpu)
 {
 	return per_cpu(cpu_scale, cpu);
 }
@@ -166,7 +166,7 @@ void update_cpu_power(unsigned int cpu)
 	set_power_scale(cpu, cpu_capacity(cpu) / middle_capacity);
 
 	printk(KERN_INFO "CPU%u: update cpu_power %lu\n",
-		cpu, arch_scale_freq_power(NULL, cpu));
+		cpu, arch_scale_freq_power(cpu));
 }
 
 #else
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index c7395d97e4cb..cb93cb09caf8 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5257,14 +5257,14 @@ static inline int get_sd_load_idx(struct sched_domain *sd,
 	return load_idx;
 }
 
-static unsigned long default_scale_freq_power(struct sched_domain *sd, int cpu)
+static unsigned long default_scale_freq_power(int cpu)
 {
 	return SCHED_POWER_SCALE;
 }
 
-unsigned long __weak arch_scale_freq_power(struct sched_domain *sd, int cpu)
+unsigned long __weak arch_scale_freq_power(int cpu)
 {
-	return default_scale_freq_power(sd, cpu);
+	return default_scale_freq_power(cpu);
 }
 
 static unsigned long default_scale_smt_power(struct sched_domain *sd, int cpu)
@@ -5329,9 +5329,9 @@ static void update_cpu_power(struct sched_domain *sd, int cpu)
 	sdg->sgp->power_orig = power;
 
 	if (sched_feat(ARCH_POWER))
-		power *= arch_scale_freq_power(sd, cpu);
+		power *= arch_scale_freq_power(cpu);
 	else
-		power *= default_scale_freq_power(sd, cpu);
+		power *= default_scale_freq_power(cpu);
 
 	power >>= SCHED_POWER_SHIFT;
 
-- 
1.7.9.5


