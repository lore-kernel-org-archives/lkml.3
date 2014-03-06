Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125AbaCFRVX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 12:21:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15890 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751130AbaCFRVW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 12:21:22 -0500
Date: Thu, 6 Mar 2014 12:20:28 -0500
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, x86@kernel.org
Subject: x86: Fix leak in uncore_type_init failure paths
Message-ID: <20140306172028.GA552@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Peter Zijlstra <peterz@infradead.org>, x86@kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The error path of uncore_type_init() frees up any allocations that were made
along the way, but it relies upon type->pmus being set, which only happens
if the function succeeds. As type->pmus remains null in this case, the call
to uncore_type_exit will do nothing.

Moving the assignment earlier will allow us to actually free those allocations
should something go awry.

Signed-off-by: Dave Jones <davej@fedoraproject.org>

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index c88f7f4b03ee..047f540cf3f7 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -3334,6 +3334,8 @@ static int __init uncore_type_init(struct intel_uncore_type *type)
 	if (!pmus)
 		return -ENOMEM;
 
+	type->pmus = pmus;
+
 	type->unconstrainted = (struct event_constraint)
 		__EVENT_CONSTRAINT(0, (1ULL << type->num_counters) - 1,
 				0, type->num_counters, 0, 0);
@@ -3369,7 +3371,6 @@ static int __init uncore_type_init(struct intel_uncore_type *type)
 	}
 
 	type->pmu_group = &uncore_pmu_attr_group;
-	type->pmus = pmus;
 	return 0;
 fail:
 	uncore_type_exit(type);
