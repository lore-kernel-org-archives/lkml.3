Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932088AbaGIGz6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 02:55:58 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:62272 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542AbaGIGzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 02:55:55 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, arvind.chauhan@arm.com, preeti@linux.vnet.ibm.com,
        khilman@linaro.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [RFC 1/7] hrtimer: Warn if hrtimer_start*() failed to enqueue hrtimer
Date: Wed,  9 Jul 2014 12:25:33 +0530
Message-Id: <bc8cabd00810c2f91cb45a64514f5c4ca12d584c.1404888801.git.viresh.kumar@linaro.org>
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

At several places in kernel we check if hrtimer is enqueued properly with
hrtimer_active(). This isn't required and can be dropped.

Before fixing that, lets make sure hrtimer is always enqueued properly by adding

	WARN_ON_ONCE(!hrtimer_active(timer));

towards the end of __hrtimer_start_range_ns().

Suggested-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/hrtimer.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 3ab2899..cf40209 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1037,6 +1037,8 @@ int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
 
 	unlock_hrtimer_base(timer, &flags);
 
+	/* Make sure timer is enqueued */
+	WARN_ON_ONCE(!hrtimer_active(timer));
 	return ret;
 }
 EXPORT_SYMBOL_GPL(__hrtimer_start_range_ns);
-- 
2.0.0.rc2

