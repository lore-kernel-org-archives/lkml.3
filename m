Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529AbaCKMjc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 08:39:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35672 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755496AbaCKMj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 08:39:29 -0400
Date: Tue, 11 Mar 2014 05:38:54 -0700
From: tip-bot for Dave Jones <tipbot@zytor.com>
Message-ID: <tip-b7b4839d93e50adccef29eccb694807cdcb8bee3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        davej@fedoraproject.org, peterz@infradead.org, davej@redhat.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        davej@fedoraproject.org, peterz@infradead.org, tglx@linutronix.de,
        davej@redhat.com
In-Reply-To: <20140306172028.GA552@redhat.com>
References: <20140306172028.GA552@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf/x86:
  Fix leak in uncore_type_init failure paths
Git-Commit-ID: b7b4839d93e50adccef29eccb694807cdcb8bee3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b7b4839d93e50adccef29eccb694807cdcb8bee3
Gitweb:     http://git.kernel.org/tip/b7b4839d93e50adccef29eccb694807cdcb8bee3
Author:     Dave Jones <davej@redhat.com>
AuthorDate: Thu, 6 Mar 2014 12:20:28 -0500
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 11 Mar 2014 11:59:34 +0100

perf/x86: Fix leak in uncore_type_init failure paths

The error path of uncore_type_init() frees up any allocations
that were made along the way, but it relies upon type->pmus
being set, which only happens if the function succeeds. As
type->pmus remains null in this case, the call to
uncore_type_exit will do nothing.

Moving the assignment earlier will allow us to actually free
those allocations should something go awry.

Signed-off-by: Dave Jones <davej@fedoraproject.org>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20140306172028.GA552@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index c88f7f4..047f540 100644
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
