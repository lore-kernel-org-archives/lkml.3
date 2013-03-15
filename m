Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898Ab3CODbo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 23:31:44 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:4325 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753689Ab3CODbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 23:31:41 -0400
X-IronPort-AV: E=Sophos;i="4.84,849,1355126400"; 
   d="scan'208";a="29880100"
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 1/3] ARM: msm: Stop counting before reprogramming clockevent
Date: Thu, 14 Mar 2013 20:31:37 -0700
Message-Id: <1363318299-10814-2-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.2.rc2.4.g7799588
In-Reply-To: <1363318299-10814-1-git-send-email-sboyd@codeaurora.org>
References: <1363318299-10814-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the clockevent is forcibly reprogrammed to have a different
match value we mistakenly assume the timer is not ticking and
program a new match value while the timer is running. Although we
clear the timer before programming a new match, it's better to
stop the timer before clearing it so that we're sure the proper
amount of ticks are counted. Failure to do so can lead to missed
ticks and system hangs.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/mach-msm/timer.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-msm/timer.c b/arch/arm/mach-msm/timer.c
index 2969027..f9fd77e 100644
--- a/arch/arm/mach-msm/timer.c
+++ b/arch/arm/mach-msm/timer.c
@@ -62,7 +62,10 @@ static int msm_timer_set_next_event(unsigned long cycles,
 {
 	u32 ctrl = readl_relaxed(event_base + TIMER_ENABLE);
 
-	writel_relaxed(0, event_base + TIMER_CLEAR);
+	ctrl &= ~TIMER_ENABLE_EN;
+	writel_relaxed(ctrl, event_base + TIMER_ENABLE);
+
+	writel_relaxed(ctrl, event_base + TIMER_CLEAR);
 	writel_relaxed(cycles, event_base + TIMER_MATCH_VAL);
 	writel_relaxed(ctrl | TIMER_ENABLE_EN, event_base + TIMER_ENABLE);
 	return 0;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

