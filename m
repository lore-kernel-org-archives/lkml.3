Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752179AbaFDJM6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 05:12:58 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:7781 "EHLO
	mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751776AbaFDJKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 05:10:00 -0400
X-IronPort-AV: E=Sophos;i="4.98,972,1392159600"; 
   d="scan'208";a="65385496"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: kernel-janitors@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Vineet Gupta <vgupta@synopsys.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 5/10] ARC: use safer test on the result of find_first_zero_bit
Date: Wed,  4 Jun 2014 11:07:55 +0200
Message-Id: <1401872880-23685-6-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1401872880-23685-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1401872880-23685-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Find_first_zero_bit considers BITS_PER_LONG bits at a time, and thus may
return a larger number than the maximum position argument if that position
is not a multiple of BITS_PER_LONG.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression e1,e2,e3;
statement S1,S2;
@@

e1 = find_first_zero_bit(e2,e3)
...
if (e1 
- ==
+ >=
  e3)
S1 else S2
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 arch/arc/kernel/perf_event.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -u -p a/arch/arc/kernel/perf_event.c b/arch/arc/kernel/perf_event.c
--- a/arch/arc/kernel/perf_event.c
+++ b/arch/arc/kernel/perf_event.c
@@ -205,7 +205,7 @@ static int arc_pmu_add(struct perf_event
 	if (__test_and_set_bit(idx, arc_pmu->used_mask)) {
 		idx = find_first_zero_bit(arc_pmu->used_mask,
 					  arc_pmu->n_counters);
-		if (idx == arc_pmu->n_counters)
+		if (idx >= arc_pmu->n_counters)
 			return -EAGAIN;
 
 		__set_bit(idx, arc_pmu->used_mask);

