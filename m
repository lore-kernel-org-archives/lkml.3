Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754946Ab3CONoi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 09:44:38 -0400
Received: from multi.imgtec.com ([194.200.65.239]:34611 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754397Ab3CONog (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 09:44:36 -0400
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH 7/9] metag: perf: don't reset TXTACTCYC
Date: Fri, 15 Mar 2013 13:43:46 +0000
Message-ID: <1363355028-23278-8-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363355028-23278-1-git-send-email-james.hogan@imgtec.com>
References: <1363355028-23278-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_03_15_13_44_35
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The thread active cycle counter TXTACTCYC is used in __delay so it
shouldn't really be reset to zero by perf. Fix perf to just read the
value, and instead of clearing it, record the prev_count value in
enable_counter so that the delta calculations know about the previous
value.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
---
 arch/metag/kernel/perf/perf_event.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/metag/kernel/perf/perf_event.c b/arch/metag/kernel/perf/perf_event.c
index 54fde35..a1eff36 100644
--- a/arch/metag/kernel/perf/perf_event.c
+++ b/arch/metag/kernel/perf/perf_event.c
@@ -617,9 +617,7 @@ static void metag_pmu_enable_counter(struct hw_perf_event *event, int idx)
 		WARN_ONCE((config != 0x100),
 			"invalid configuration (%d) for counter (%d)\n",
 			config, idx);
-
-		/* Reset the cycle count */
-		__core_reg_set(TXTACTCYC, 0);
+		local64_set(&event->prev_count, __core_reg_get(TXTACTCYC));
 		goto unlock;
 	}
 
@@ -708,9 +706,8 @@ static u64 metag_pmu_read_counter(int idx)
 {
 	u32 tmp = 0;
 
-	/* The act of reading the cycle counter also clears it */
 	if (METAG_INST_COUNTER == idx) {
-		__core_reg_swap(TXTACTCYC, tmp);
+		tmp = __core_reg_get(TXTACTCYC);
 		goto out;
 	}
 
-- 
1.8.1.2


