Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757882Ab3BGK2L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 05:28:11 -0500
Received: from service87.mimecast.com ([91.220.42.44]:52826 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757687Ab3BGK2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 05:28:04 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl, valdis.kletnieks@vt.edu, artem.savkov@gmail.com
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        robin.randhawa@arm.com, Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 3/4] cpufreq: Create a macro for unlock_policy_rwsem{read,write}
Date: Thu,  7 Feb 2013 15:57:45 +0530
Message-Id: <7b681ffe08aa44d93a81297c1fb6f7702c9c9b2b.1360232293.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1360232293.git.viresh.kumar@linaro.org>
References: <cover.1360232293.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1360232293.git.viresh.kumar@linaro.org>
References: <cover.1360232293.git.viresh.kumar@linaro.org>
X-OriginalArrivalTime: 07 Feb 2013 10:28:01.0536 (UTC) FILETIME=[CE66D800:01CE051D]
X-MC-Unique: 113020710280211901
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r17ASFGW028050

On the lines of macro: lock_policy_rwsem, we can create another macro for
unlock_policy_rwsem. Lets do it.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq.c | 24 +++++++++---------------
 1 file changed, 9 insertions(+), 15 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 795b0e8..c46aed4 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -70,8 +70,7 @@ static DEFINE_PER_CPU(int, cpufreq_policy_cpu);
 static DEFINE_PER_CPU(struct rw_semaphore, cpu_policy_rwsem);
 
 #define lock_policy_rwsem(mode, cpu)					\
-static int lock_policy_rwsem_##mode					\
-(int cpu)								\
+static int lock_policy_rwsem_##mode(int cpu)				\
 {									\
 	int policy_cpu = per_cpu(cpufreq_policy_cpu, cpu);		\
 	BUG_ON(policy_cpu == -1);					\
@@ -81,23 +80,18 @@ static int lock_policy_rwsem_##mode					\
 }
 
 lock_policy_rwsem(read, cpu);
-
 lock_policy_rwsem(write, cpu);
 
-static void unlock_policy_rwsem_read(int cpu)
-{
-	int policy_cpu = per_cpu(cpufreq_policy_cpu, cpu);
-	BUG_ON(policy_cpu == -1);
-	up_read(&per_cpu(cpu_policy_rwsem, policy_cpu));
-}
-
-static void unlock_policy_rwsem_write(int cpu)
-{
-	int policy_cpu = per_cpu(cpufreq_policy_cpu, cpu);
-	BUG_ON(policy_cpu == -1);
-	up_write(&per_cpu(cpu_policy_rwsem, policy_cpu));
+#define unlock_policy_rwsem(mode, cpu)					\
+static void unlock_policy_rwsem_##mode(int cpu)				\
+{									\
+	int policy_cpu = per_cpu(cpufreq_policy_cpu, cpu);		\
+	BUG_ON(policy_cpu == -1);					\
+	up_##mode(&per_cpu(cpu_policy_rwsem, policy_cpu));		\
 }
 
+unlock_policy_rwsem(read, cpu);
+unlock_policy_rwsem(write, cpu);
 
 /* internal prototypes */
 static int __cpufreq_governor(struct cpufreq_policy *policy,
-- 
1.7.12.rc2.18.g61b472e


