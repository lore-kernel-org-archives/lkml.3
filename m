Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755014Ab3DVOaS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 10:30:18 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51549 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754854Ab3DVOaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 10:30:04 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
        "Will Deacon" <will.deacon@arm.com>,
        "Russell King" <rmk+kernel@arm.linux.org.uk>,
        "Arnaldo Carvalho de Melo" <acme@ghostprotocols.net>,
        "Sudeep KarkadaNagesha" <Sudeep.KarkadaNagesha@arm.com>,
        "Jiri Olsa" <jolsa@redhat.com>
Date: Mon, 22 Apr 2013 15:25:59 +0100
Message-ID: <lsq.1366640759.296132055@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [49/75] ARM: 7698/1: perf: fix group validation when using
 enable_on_exec
In-Reply-To: <lsq.1366640759.151900666@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:6834:ff73:7553:7f84
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.44-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/arm/kernel/perf_event.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/arch/arm/kernel/perf_event.c
+++ b/arch/arm/kernel/perf_event.c
@@ -326,7 +326,10 @@ validate_event(struct pmu_hw_events *hw_
 	struct hw_perf_event fake_event = event->hw;
 	struct pmu *leader_pmu = event->group_leader->pmu;
 
-	if (event->pmu != leader_pmu || event->state <= PERF_EVENT_STATE_OFF)
+	if (event->pmu != leader_pmu || event->state < PERF_EVENT_STATE_OFF)
+		return 1;
+
+	if (event->state == PERF_EVENT_STATE_OFF && !event->attr.enable_on_exec)
 		return 1;
 
 	return armpmu->get_event_idx(hw_events, &fake_event) >= 0;

