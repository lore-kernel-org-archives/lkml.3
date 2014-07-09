Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754968AbaGIG4m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 02:56:42 -0400
Received: from mail-qc0-f177.google.com ([209.85.216.177]:60482 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754242AbaGIG4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 02:56:39 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, arvind.chauhan@arm.com, preeti@linux.vnet.ibm.com,
        khilman@linaro.org, Viresh Kumar <viresh.kumar@linaro.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [RFC 7/7] net: don't check for active hrtimer after adding it
Date: Wed,  9 Jul 2014 12:25:39 +0530
Message-Id: <a8994b5dda7599c0d8ce9f66aef40b8587acf691.1404888801.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <cover.1404888801.git.viresh.kumar@linaro.org>
References: <cover.1404888801.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1404888801.git.viresh.kumar@linaro.org>
References: <cover.1404888801.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hrtimer_start*() family never fails to enqueue a hrtimer to a clock-base. The
only special case is when the hrtimer was in past. If it is getting enqueued to
local CPUs's clock-base, we raise a softirq and exit, else we handle that on
next interrupt on remote CPU.

At several places in the kernel, we try to make sure if hrtimer was added
properly or not by calling hrtimer_active(), like:

	hrtimer_start(timer, expires, mode);
	if (hrtimer_active(timer)) {
		/* Added successfully */
	} else {
		/* Was added in the past */
	}

As hrtimer_start*() never fails, hrtimer_active() is guaranteed to return '1'.
So, there is no point calling hrtimer_active().

This patch updates net core to get this fixed.

Cc: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 net/core/pktgen.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/core/pktgen.c b/net/core/pktgen.c
index fc17a9d..f911acd 100644
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -2186,8 +2186,6 @@ static void spin(struct pktgen_dev *pkt_dev, ktime_t spin_until)
 		do {
 			set_current_state(TASK_INTERRUPTIBLE);
 			hrtimer_start_expires(&t.timer, HRTIMER_MODE_ABS);
-			if (!hrtimer_active(&t.timer))
-				t.task = NULL;
 
 			if (likely(t.task))
 				schedule();
-- 
2.0.0.rc2

