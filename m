Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157AbaLVJj6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 04:39:58 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:62143 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753733AbaLVJj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 04:39:56 -0500
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Russell King <linux@arm.linux.org.uk>, Will Deacon <will.deacon@arm.com>
Cc: Daniel Thompson <daniel.thompson@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>
Subject: [PATCH 3.19-rc1 v3] arm: perf: Prevent wraparound during overflow
Date: Mon, 22 Dec 2014 09:39:45 +0000
Message-Id: <1419241185-31317-1-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1416412346-8759-1-git-send-email-daniel.thompson@linaro.org>
References: <1416412346-8759-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the overflow threshold for a counter is set above or near the
0xffffffff boundary then the kernel may lose track of the overflow
causing only events that occur *after* the overflow to be recorded.
Specifically the problem occurs when the value of the performance counter
overtakes its original programmed value due to wrap around.

Typical solutions to this problem are either to avoid programming in
values likely to be overtaken or to treat the overflow bit as the 33rd
bit of the counter.

Its somewhat fiddly to refactor the code to correctly handle the 33rd bit
during irqsave sections (context switches for example) so instead we take
the simpler approach of avoiding values likely to be overtaken.

We set the limit to half of max_period because this matches the limit
imposed in __hw_perf_event_init(). This causes a doubling of the interrupt
rate for large threshold values, however even with a very fast counter
ticking at 4GHz the interrupt rate would only be ~1Hz.

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Acked-by: Will Deacon <will.deacon@arm.com>
---

Notes:
    v3:
    
    * Rebased on 3.19-rc1 and dropped the arm64 patches (which are
      already upstream).
    
    v2:
    
    * Remove the redundant cast to s64 (Will Deacon).
    

 arch/arm/kernel/perf_event.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/arm/kernel/perf_event.c b/arch/arm/kernel/perf_event.c
index f7c65adaa428..557e128e4df0 100644
--- a/arch/arm/kernel/perf_event.c
+++ b/arch/arm/kernel/perf_event.c
@@ -116,8 +116,14 @@ int armpmu_event_set_period(struct perf_event *event)
 		ret = 1;
 	}

-	if (left > (s64)armpmu->max_period)
-		left = armpmu->max_period;
+	/*
+	 * Limit the maximum period to prevent the counter value
+	 * from overtaking the one we are about to program. In
+	 * effect we are reducing max_period to account for
+	 * interrupt latency (and we are being very conservative).
+	 */
+	if (left > (armpmu->max_period >> 1))
+		left = armpmu->max_period >> 1;

 	local64_set(&hwc->prev_count, (u64)-left);

--
1.9.3

