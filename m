Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756784Ab3HRUje (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 16:39:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43744 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756523Ab3HRUfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 16:35:14 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Vince Weaver <vincent.weaver@maine.edu>,
        Mark Rutland <mark.rutland@arm.com>, Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [ 40/45] ARM: 7809/1: perf: fix event validation for software group leaders
Date: Sun, 18 Aug 2013 13:36:29 -0700
Message-Id: <20130818203623.774544918@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.3.825.g36032ce.dirty
In-Reply-To: <20130818203620.996166594@linuxfoundation.org>
References: <20130818203620.996166594@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/kernel/perf_event.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/arm/kernel/perf_event.c
+++ b/arch/arm/kernel/perf_event.c
@@ -258,6 +258,9 @@ validate_event(struct pmu_hw_events *hw_
 	struct arm_pmu *armpmu = to_arm_pmu(event->pmu);
 	struct pmu *leader_pmu = event->group_leader->pmu;
 
+	if (is_software_event(event))
+		return 1;
+
 	if (event->pmu != leader_pmu || event->state < PERF_EVENT_STATE_OFF)
 		return 1;
 


