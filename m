Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031AbaAOR65 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 12:58:57 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:44896 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752650AbaAORzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 12:55:40 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Will Deacon <will.deacon@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 4/7] ARM: perf_event: Add hook for event index clearing
Date: Wed, 15 Jan 2014 09:55:32 -0800
Message-Id: <1389808535-23852-5-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.5.2.228.g8f9f19c
In-Reply-To: <1389808535-23852-1-git-send-email-sboyd@codeaurora.org>
References: <1389808535-23852-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Krait processors we have a many-to-one relationship between
raw CPU events and the event programmed into the PMNx counter.
Two raw CPU events could map to the same value programmed in the
PMNx counter. To avoid this problem, we check for collisions
during the get_event_idx() callback by setting a bit in a bitmap
whenever a certain event is used in a PMNx counter (see the next
patch). Unfortunately, we don't have a hook to clear this bit in
the bitmap when the event is deleted so let's add an optional
clear_event_idx() callback for this purpose.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/include/asm/pmu.h   | 1 +
 arch/arm/kernel/perf_event.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/arch/arm/include/asm/pmu.h b/arch/arm/include/asm/pmu.h
index f24edad26c70..994ac445e792 100644
--- a/arch/arm/include/asm/pmu.h
+++ b/arch/arm/include/asm/pmu.h
@@ -71,6 +71,7 @@ struct arm_pmu {
 	void		(*disable)(struct perf_event *event);
 	int		(*get_event_idx)(struct pmu_hw_events *hw_events,
 					 struct perf_event *event);
+	void		(*clear_event_idx)(struct perf_event *event);
 	int		(*set_event_filter)(struct hw_perf_event *evt,
 					    struct perf_event_attr *attr);
 	u32		(*read_counter)(struct perf_event *event);
diff --git a/arch/arm/kernel/perf_event.c b/arch/arm/kernel/perf_event.c
index e76750980b38..06c6b191c8db 100644
--- a/arch/arm/kernel/perf_event.c
+++ b/arch/arm/kernel/perf_event.c
@@ -207,6 +207,8 @@ armpmu_del(struct perf_event *event, int flags)
 	armpmu_stop(event, PERF_EF_UPDATE);
 	hw_events->events[idx] = NULL;
 	clear_bit(idx, hw_events->used_mask);
+	if (armpmu->clear_event_idx)
+		armpmu->clear_event_idx(event);
 
 	perf_event_update_userpage(event);
 }
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

