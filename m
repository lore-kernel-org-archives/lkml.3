Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932352Ab3EGNkf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 09:40:35 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42057 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932201Ab3EGNkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:40:32 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jiri Olsa <jolsa@redhat.com>, Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 007/118] ARM: 7698/1: perf: fix group validation when using enable_on_exec
Date: Tue,  7 May 2013 14:37:33 +0100
Message-Id: <1367933964-1564-8-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
References: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will.deacon@arm.com>

commit cb2d8b342aa084d1f3ac29966245dec9163677fb upstream.

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
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
[ luis: adjust context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/kernel/perf_event.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm/kernel/perf_event.c b/arch/arm/kernel/perf_event.c
index a02eada..952a5a7 100644
--- a/arch/arm/kernel/perf_event.c
+++ b/arch/arm/kernel/perf_event.c
@@ -319,7 +319,10 @@ validate_event(struct pmu_hw_events *hw_events,
 	struct hw_perf_event fake_event = event->hw;
 	struct pmu *leader_pmu = event->group_leader->pmu;
 
-	if (event->pmu != leader_pmu || event->state <= PERF_EVENT_STATE_OFF)
+	if (event->pmu != leader_pmu || event->state < PERF_EVENT_STATE_OFF)
+		return 1;
+
+	if (event->state == PERF_EVENT_STATE_OFF && !event->attr.enable_on_exec)
 		return 1;
 
 	return armpmu->get_event_idx(hw_events, &fake_event) >= 0;
-- 
1.8.1.2

