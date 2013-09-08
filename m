Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932211Ab3IHDVE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 23:21:04 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56232 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756778Ab3IHDSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 23:18:55 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Vince Weaver" <vincent.weaver@maine.edu>,
        "Mark Rutland" <mark.rutland@arm.com>,
        "Russell King" <rmk+kernel@arm.linux.org.uk>,
        "Will Deacon" <will.deacon@arm.com>
Date: Sun, 08 Sep 2013 03:52:01 +0100
Message-ID: <lsq.1378608721.604456037@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [070/121] ARM: 7809/1: perf: fix event validation for software
 group leaders
In-Reply-To: <lsq.1378608720.401499712@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.51-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/arm/kernel/perf_event.c | 3 +++
 1 file changed, 3 insertions(+)

--- a/arch/arm/kernel/perf_event.c
+++ b/arch/arm/kernel/perf_event.c
@@ -326,6 +326,9 @@ validate_event(struct pmu_hw_events *hw_
 	struct hw_perf_event fake_event = event->hw;
 	struct pmu *leader_pmu = event->group_leader->pmu;
 
+	if (is_software_event(event))
+		return 1;
+
 	if (event->pmu != leader_pmu || event->state < PERF_EVENT_STATE_OFF)
 		return 1;
 

