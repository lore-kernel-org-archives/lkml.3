Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753647Ab3BCBZQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 20:25:16 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:47596 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754171Ab3BCBXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 20:23:07 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, bfields@fieldses.org,
        skinsbursky@parallels.com, ebiederm@xmission.com, jmorris@namei.org,
        axboe@kernel.dk, Tejun Heo <tj@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH 56/62] events: convert to idr_alloc()
Date: Sat,  2 Feb 2013 17:20:57 -0800
Message-Id: <1359854463-2538-57-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1359854463-2538-1-git-send-email-tj@kernel.org>
References: <1359854463-2538-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to the much saner new idr interface.

Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
---
This patch depends on an earlier idr changes and I think it would be
best to route these together through -mm.  Please holler if there's
any objection.  Thanks.

 kernel/events/core.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 301079d..2ed1e98 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5956,13 +5956,9 @@ int perf_pmu_register(struct pmu *pmu, char *name, int type)
 	pmu->name = name;
 
 	if (type < 0) {
-		int err = idr_pre_get(&pmu_idr, GFP_KERNEL);
-		if (!err)
-			goto free_pdc;
-
-		err = idr_get_new_above(&pmu_idr, pmu, PERF_TYPE_MAX, &type);
-		if (err) {
-			ret = err;
+		type = idr_alloc(&pmu_idr, pmu, PERF_TYPE_MAX, 0, GFP_KERNEL);
+		if (type < 0) {
+			ret = type;
 			goto free_pdc;
 		}
 	}
-- 
1.8.1

