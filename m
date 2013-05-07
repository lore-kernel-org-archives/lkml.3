Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759765Ab3EGEct (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 00:32:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13075 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932585Ab3EGEZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 00:25:54 -0400
X-Authority-Analysis: v=2.0 cv=cOZiQyiN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=gEddqr2wq04A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=No_1_ZOhmYQA:10 a=7CQSdrXTAAAA:8 a=VwQbUJbxAAAA:8 a=h3sCQ_blAAAA:8 a=20KFwNOVAAAA:8 a=drOt6m5kAAAA:8 a=fC4T7qsy4_4xvlMS5R0A:9 a=ESTKKtUg-DoA:10 a=fNChW5oJl9MA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035853.627352642@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:58:28 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jiri Olsa <jolsa@redhat.com>,
        Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [076/126] ARM: 7698/1: perf: fix group validation when using enable_on_exec
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0076-ARM-7698-1-perf-fix-group-validation-when-using-enab.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Will Deacon <will.deacon@arm.com>

[ Upstream commit cb2d8b342aa084d1f3ac29966245dec9163677fb ]

Events may be created with attr->disabled == 1 and attr->enable_on_exec
== 1, which confuses the group validation code because events with the
PERF_EVENT_STATE_OFF are not considered candidates for scheduling, which
may lead to failure at group scheduling time.

This patch fixes the validation check for ARM, so that events in the
OFF state are still considered when enable_on_exec is true.

Cc: stable@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Jiri Olsa <jolsa@redhat.com>
Reported-by: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/arm/kernel/perf_event.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm/kernel/perf_event.c b/arch/arm/kernel/perf_event.c
index ab243b8..5770b9d 100644
--- a/arch/arm/kernel/perf_event.c
+++ b/arch/arm/kernel/perf_event.c
@@ -316,7 +316,10 @@ validate_event(struct pmu_hw_events *hw_events,
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
1.7.10.4


