Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932254Ab3IBJJ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 05:09:59 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37705 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758295Ab3IBIzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 04:55:07 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 18/58] ARM: 7809/1: perf: fix event validation for software group leaders
Date: Mon,  2 Sep 2013 09:54:03 +0100
Message-Id: <1378112083-9475-19-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1378112083-9475-1-git-send-email-luis.henriques@canonical.com>
References: <1378112083-9475-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.21 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will.deacon@arm.com>

commit c95eb3184ea1a3a2551df57190c81da695e2144b upstream.

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

Reported-by: Vince Weaver <vincent.weaver@maine.edu>
Tested-by: Vince Weaver <vincent.weaver@maine.edu>
Tested-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/kernel/perf_event.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/kernel/perf_event.c b/arch/arm/kernel/perf_event.c
index 55790a5..522c11d 100644
--- a/arch/arm/kernel/perf_event.c
+++ b/arch/arm/kernel/perf_event.c
@@ -319,6 +319,9 @@ validate_event(struct pmu_hw_events *hw_events,
 	struct hw_perf_event fake_event = event->hw;
 	struct pmu *leader_pmu = event->group_leader->pmu;
 
+	if (is_software_event(event))
+		return 1;
+
 	if (event->pmu != leader_pmu || event->state < PERF_EVENT_STATE_OFF)
 		return 1;
 
-- 
1.8.3.2

