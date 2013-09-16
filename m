Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751633Ab3IPWoA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 18:44:00 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:53639 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974Ab3IPWny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 18:43:54 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] sched/nohz: fix overflow error in scheduler_tick_max_deferment()
Date: Mon, 16 Sep 2013 15:43:49 -0700
Message-Id: <1379371429-22214-2-git-send-email-khilman@linaro.org>
X-Mailer: git-send-email 1.8.3
In-Reply-To: <1379371429-22214-1-git-send-email-khilman@linaro.org>
References: <1379371429-22214-1-git-send-email-khilman@linaro.org>
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
index 4b1fe3e..3d7c80e 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2203,7 +2203,7 @@ u64 scheduler_tick_max_deferment(void)
 	if (time_before_eq(next, now))
 		return 0;
 
-	return jiffies_to_usecs(next - now) * NSEC_PER_USEC;
+	return (u64)jiffies_to_usecs(next - now) * NSEC_PER_USEC;
 }
 
 static __init int sched_nohz_full_init_debug(void)
-- 
1.8.3

