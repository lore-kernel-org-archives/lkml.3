Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549AbaCZLW2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 07:22:28 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:35860 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754320AbaCZLWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 07:22:24 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, linaro-networking@linaro.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 06/14] hrtimer: don't rewrite same value to expires_next in hrtimer_force_reprogram()
Date: Wed, 26 Mar 2014 16:51:12 +0530
Message-Id: <479d66f80874a0dedb97a1e98b40d5130386e880.1395832156.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1395832156.git.viresh.kumar@linaro.org>
References: <cover.1395832156.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1395832156.git.viresh.kumar@linaro.org>
References: <cover.1395832156.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have just checked that expires_next.tv64 == cpu_base->expires_next.tv64, and
in this case we shouldn't rewrite the same value again. Rewrite code to fix
this.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/hrtimer.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index e5d81ee..32d1504 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -561,11 +561,11 @@ hrtimer_force_reprogram(struct hrtimer_cpu_base *cpu_base, int skip_equal)
 			expires_next = expires;
 	}
 
-	if (skip_equal && expires_next.tv64 == cpu_base->expires_next.tv64)
+	if (expires_next.tv64 != cpu_base->expires_next.tv64)
+		cpu_base->expires_next.tv64 = expires_next.tv64;
+	else if (skip_equal)
 		return;
 
-	cpu_base->expires_next.tv64 = expires_next.tv64;
-
 	if (cpu_base->expires_next.tv64 != KTIME_MAX)
 		tick_program_event(cpu_base->expires_next, 1);
 }
-- 
1.7.12.rc2.18.g61b472e

