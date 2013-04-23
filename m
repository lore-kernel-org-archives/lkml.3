Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932277Ab3DWVy2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 17:54:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34250 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757732Ab3DWVyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 17:54:19 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jiri Olsa <jolsa@redhat.com>, Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [ 13/26] ARM: 7698/1: perf: fix group validation when using enable_on_exec
Date: Tue, 23 Apr 2013 14:53:53 -0700
Message-Id: <20130423215334.726196467@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130423215333.344045754@linuxfoundation.org>
References: <20130423215333.344045754@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will.deacon@arm.com>

commit cb2d8b342aa084d1f3ac29966245dec9163677fb upstream.

Events may be created with attr->disabled == 1 and attr->enable_on_exec
== 1, which confuses the group validation code because events with the
PERF_EVENT_STATE_OFF are not considered candidates for scheduling, which
may lead to failure at group scheduling time.

This patch fixes the validation check for ARM, so that events in the
OFF state are still considered when enable_on_exec is true.

Reported-by: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/kernel/perf_event.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/arch/arm/kernel/perf_event.c
+++ b/arch/arm/kernel/perf_event.c
@@ -319,7 +319,10 @@ validate_event(struct pmu_hw_events *hw_
 	struct hw_perf_event fake_event = event->hw;
 	struct pmu *leader_pmu = event->group_leader->pmu;
 
-	if (event->pmu != leader_pmu || event->state <= PERF_EVENT_STATE_OFF)
+	if (event->pmu != leader_pmu || event->state < PERF_EVENT_STATE_OFF)
+		return 1;
+
+	if (event->state == PERF_EVENT_STATE_OFF && !event->attr.enable_on_exec)
 		return 1;
 
 	return armpmu->get_event_idx(hw_events, &fake_event) >= 0;


