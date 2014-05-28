Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932115AbaE1GSS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 02:18:18 -0400
Received: from mga11.intel.com ([192.55.52.93]:20591 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751155AbaE1GSQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 02:18:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,926,1392192000"; 
   d="scan'208";a="538750610"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, mingo@elte.hu, eranian@google.com,
        ak@linux.intel.com, "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [RFC PATCH 1/7] perf, core: Add all PMUs to pmu_idr
Date: Wed, 28 May 2014 14:18:04 +0800
Message-Id: <1401257890-30535-2-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1401257890-30535-1-git-send-email-zheng.z.yan@intel.com>
References: <1401257890-30535-1-git-send-email-zheng.z.yan@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, the build-in PMUs are not added to pmu_idr. This makes
a inconvenience for finding PMU by type.

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
---
 kernel/events/core.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index ed50b09..bafc416 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6496,14 +6496,15 @@ int perf_pmu_register(struct pmu *pmu, const char *name, int type)
 		goto skip_type;
 	pmu->name = name;
 
-	if (type < 0) {
-		type = idr_alloc(&pmu_idr, pmu, PERF_TYPE_MAX, 0, GFP_KERNEL);
-		if (type < 0) {
-			ret = type;
-			goto free_pdc;
-		}
+	ret = idr_alloc(&pmu_idr, pmu, type >= 0 ? type : PERF_TYPE_MAX,
+			0, GFP_KERNEL);
+	if (ret < 0)
+		goto free_pdc;
+	pmu->type = ret;
+	if (WARN_ON_ONCE(type >= 0 && pmu->type != type)) {
+		ret = -EINVAL;
+		goto free_idr;
 	}
-	pmu->type = type;
 
 	if (pmu_bus_running) {
 		ret = pmu_dev_alloc(pmu);
@@ -6575,8 +6576,7 @@ free_dev:
 	put_device(pmu->dev);
 
 free_idr:
-	if (pmu->type >= PERF_TYPE_MAX)
-		idr_remove(&pmu_idr, pmu->type);
+	idr_remove(&pmu_idr, pmu->type);
 
 free_pdc:
 	free_percpu(pmu->pmu_disable_count);
@@ -6598,8 +6598,7 @@ void perf_pmu_unregister(struct pmu *pmu)
 	synchronize_rcu();
 
 	free_percpu(pmu->pmu_disable_count);
-	if (pmu->type >= PERF_TYPE_MAX)
-		idr_remove(&pmu_idr, pmu->type);
+	idr_remove(&pmu_idr, pmu->type);
 	device_del(pmu->dev);
 	put_device(pmu->dev);
 	free_pmu_context(pmu);
-- 
1.9.0

