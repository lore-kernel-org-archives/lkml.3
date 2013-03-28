Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926Ab3C1SHS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 14:07:18 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:47578 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752272Ab3C1SHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 14:07:15 -0400
From: Will Deacon <will.deacon@arm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Will Deacon <will.deacon@arm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH] ARM: perf: fix group validation when using enable_on_exec
Date: Thu, 28 Mar 2013 18:06:46 +0000
Message-Id: <1364494006-17228-1-git-send-email-will.deacon@arm.com>
X-Mailer: git-send-email 1.8.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Events may be created with attr->disabled == 1 and attr->enable_on_exec
== 1, which confuses the group validation code because events with the
PERF_EVENT_STATE_OFF are not considered candidates for scheduling, which
may lead to failure at group scheduling time.

This patch fixes the validation check for ARM, so that events in the
OFF state are still considered when enable_on_exec is true.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Jiri Olsa <jolsa@redhat.com>
Reported-by: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
---

CC'ing some of the core guys here because I think this affects multiple
(all?) architectures.

 arch/arm/kernel/perf_event.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm/kernel/perf_event.c b/arch/arm/kernel/perf_event.c
index 146157d..8c3094d 100644
--- a/arch/arm/kernel/perf_event.c
+++ b/arch/arm/kernel/perf_event.c
@@ -253,7 +253,10 @@ validate_event(struct pmu_hw_events *hw_events,
 	struct arm_pmu *armpmu = to_arm_pmu(event->pmu);
 	struct pmu *leader_pmu = event->group_leader->pmu;
 
-	if (event->pmu != leader_pmu || event->state <= PERF_EVENT_STATE_OFF)
+	if (event->pmu != leader_pmu || event->state < PERF_EVENT_STATE_OFF)
+		return 1;
+
+	if (event->state == PERF_EVENT_STATE_OFF && !event->attr.enable_on_exec)
 		return 1;
 
 	return armpmu->get_event_idx(hw_events, event) >= 0;
-- 
1.8.0

