Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933516Ab3FRX6o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 19:58:44 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:59797 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755322Ab3FRX6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 19:58:40 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linaro-kernel@lists.linaro.org, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 2/2] sched/nohz: fix overflow error in scheduler_tick_max_deferment()
Date: Tue, 18 Jun 2013 16:58:29 -0700
Message-Id: <1371599913-1232-2-git-send-email-khilman@linaro.org>
X-Mailer: git-send-email 1.8.3
In-Reply-To: <1371599913-1232-1-git-send-email-khilman@linaro.org>
References: <1371599913-1232-1-git-send-email-khilman@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The conversion of the max deferment from usecs to nsecs can easily
overflow on platforms where a long is 32-bits.  To fix, cast the usecs
value to u64 before multiplying by NSECS_PER_USEC.

This was discovered on 32-bit ARM platform when extending the max
deferment value.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Kevin Hilman <khilman@linaro.org>
---
 kernel/sched/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index b5d3f99..b506722 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2765,7 +2765,7 @@ u64 scheduler_tick_max_deferment(void)
 	if (time_before_eq(next, now))
 		return 0;
 
-	return jiffies_to_usecs(next - now) * NSEC_PER_USEC;
+	return (u64)jiffies_to_usecs(next - now) * NSEC_PER_USEC;
 }
 #endif
 
-- 
1.8.3

