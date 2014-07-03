Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758863AbaGCJjA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 05:39:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52439 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030407AbaGCJYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:24:35 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thomas Gleixner <tglx@linutronix.de>, Rui Xiang <rui.xiang@huawei.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 158/198] nohz: Fix another inconsistency between CONFIG_NO_HZ=n and nohz=off
Date: Thu,  3 Jul 2014 10:20:01 +0100
Message-Id: <1404379241-8590-159-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit 0e576acbc1d9600cf2d9b4a141a2554639959d50 upstream.

If CONFIG_NO_HZ=n tick_nohz_get_sleep_length() returns NSEC_PER_SEC/HZ.

If CONFIG_NO_HZ=y and the nohz functionality is disabled via the
command line option "nohz=off" or not enabled due to missing hardware
support, then tick_nohz_get_sleep_length() returns 0. That happens
because ts->sleep_length is never set in that case.

Set it to NSEC_PER_SEC/HZ when the NOHZ mode is inactive.

Reported-by: Michal Hocko <mhocko@suse.cz>
Reported-by: Borislav Petkov <bp@alien8.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Rui Xiang <rui.xiang@huawei.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/time/tick-sched.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index e8a1516cc0a3..9e62bdc9b095 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -714,8 +714,10 @@ static bool can_stop_idle_tick(int cpu, struct tick_sched *ts)
 		return false;
 	}
 
-	if (unlikely(ts->nohz_mode == NOHZ_MODE_INACTIVE))
+	if (unlikely(ts->nohz_mode == NOHZ_MODE_INACTIVE)) {
+		ts->sleep_length = (ktime_t) { .tv64 = NSEC_PER_SEC/HZ };
 		return false;
+	}
 
 	if (need_resched())
 		return false;
-- 
1.9.1

