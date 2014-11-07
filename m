Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710AbaKGQ1H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 11:27:07 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:48297 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751667AbaKGQ1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 11:27:03 -0500
From: Mark Rutland <mark.rutland@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, will.deacon@arm.com,
        Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH 05/11] arm: perf: reject multi-pmu groups
Date: Fri,  7 Nov 2014 16:25:30 +0000
Message-Id: <1415377536-12841-6-git-send-email-mark.rutland@arm.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415377536-12841-1-git-send-email-mark.rutland@arm.com>
References: <1415377536-12841-1-git-send-email-mark.rutland@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An event group spanning multiple CPU PMUs can never be scheduled, as at
least one event should always fail, and are therefore nonsensical.
Additionally, groups spanning multiple PMUs would require additional
validation logic throughout the driver to prevent CPU PMUs from stepping
on each others' internal state. Given that such groups are nonsensical
to begin with, the simple option is to reject such groups entirely.
Groups consisting of software events and CPU PMU events are benign so
long as the CPU PMU events only target a single CPU PMU.

This patch ensures that we reject the creation of event groups which
span multiple CPU PMUs, avoiding the issues described above. The
addition of this_pmu to the validation logic made the fake_pmu more
confusing than it already was; so this is renamed to the more accurate
hw_events. As hw_events was being modified anyway, the initialisation of
hw_events.used_mask is also simplified with the use of a designated
initializer rather than the existing memset.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
---
 arch/arm/kernel/perf_event.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/arch/arm/kernel/perf_event.c b/arch/arm/kernel/perf_event.c
index b00f6aa..41dcfc0 100644
--- a/arch/arm/kernel/perf_event.c
+++ b/arch/arm/kernel/perf_event.c
@@ -258,13 +258,17 @@ out:
 }
 
 static int
-validate_event(struct pmu_hw_events *hw_events,
+validate_event(struct pmu *this_pmu,
+	       struct pmu_hw_events *hw_events,
 	       struct perf_event *event)
 {
 	struct arm_pmu *armpmu = to_arm_pmu(event->pmu);
 
 	if (is_software_event(event))
 		return 1;
+	
+	if (event->pmu != this_pmu)
+		return 0;
 
 	if (event->state < PERF_EVENT_STATE_OFF)
 		return 1;
@@ -279,23 +283,20 @@ static int
 validate_group(struct perf_event *event)
 {
 	struct perf_event *sibling, *leader = event->group_leader;
-	struct pmu_hw_events fake_pmu;
-
-	/*
-	 * Initialise the fake PMU. We only need to populate the
-	 * used_mask for the purposes of validation.
-	 */
-	memset(&fake_pmu.used_mask, 0, sizeof(fake_pmu.used_mask));
+	struct pmu *this_pmu = event->pmu;
+	struct pmu_hw_events hw_events = {
+		.used_mask = { 0 },
+	};
 
-	if (!validate_event(&fake_pmu, leader))
+	if (!validate_event(this_pmu, &hw_events, leader))
 		return -EINVAL;
 
 	list_for_each_entry(sibling, &leader->sibling_list, group_entry) {
-		if (!validate_event(&fake_pmu, sibling))
+		if (!validate_event(this_pmu, &hw_events, sibling))
 			return -EINVAL;
 	}
 
-	if (!validate_event(&fake_pmu, event))
+	if (!validate_event(this_pmu, &hw_events, event))
 		return -EINVAL;
 
 	return 0;
-- 
1.9.1

