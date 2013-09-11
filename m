Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885Ab3IKE6b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:58:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3257 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754228Ab3IKE45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:56:57 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=a682mLe7bbsA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=6D3Axr6Th74A:10 a=7CQSdrXTAAAA:8 a=VwQbUJbxAAAA:8 a=drOt6m5kAAAA:8 a=5cIBTxRJ4pZzZk2xk6UA:9 a=ESTKKtUg-DoA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042927.578173318@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:30:40 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Vince Weaver <vincent.weaver@maine.edu>,
        Mark Rutland <mark.rutland@arm.com>, Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [213/251] ARM: 7809/1: perf: fix event validation for software group leaders
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0213-ARM-7809-1-perf-fix-event-validation-for-software-gr.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Will Deacon <will.deacon@arm.com>

[ Upstream commit c95eb3184ea1a3a2551df57190c81da695e2144b ]

It is possible to construct an event group with a software event as a
group leader and then subsequently add a hardware event to the group.
This results in the event group being validated by adding all members
of the group to a fake PMU and attempting to allocate each event on
their respective PMU.

Unfortunately, for software events wthout a corresponding arm_pmu, this
results in a kernel crash attempting to dereference the ->get_event_idx
function pointer.

This patch fixes the problem by checking explicitly for software events
and ignoring those in event validation (since they can always be
scheduled). We will probably want to revisit this for 3.12, since the
validation checks don't appear to work correctly when dealing with
multiple hardware PMUs anyway.

Cc: <stable@vger.kernel.org>
Reported-by: Vince Weaver <vincent.weaver@maine.edu>
Tested-by: Vince Weaver <vincent.weaver@maine.edu>
Tested-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/arm/kernel/perf_event.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/kernel/perf_event.c b/arch/arm/kernel/perf_event.c
index 22a022a..7cdecea 100644
--- a/arch/arm/kernel/perf_event.c
+++ b/arch/arm/kernel/perf_event.c
@@ -321,6 +321,9 @@ validate_event(struct pmu_hw_events *hw_events,
 	struct hw_perf_event fake_event = event->hw;
 	struct pmu *leader_pmu = event->group_leader->pmu;
 
+	if (is_software_event(event))
+		return 1;
+
 	if (event->pmu != leader_pmu || event->state < PERF_EVENT_STATE_OFF)
 		return 1;
 
-- 
1.7.10.4


