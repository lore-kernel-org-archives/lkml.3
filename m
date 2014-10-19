Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751580AbaJSPXo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 11:23:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46495 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750957AbaJSPXn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 11:23:43 -0400
From: Mark Salter <msalter@redhat.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sudeep Holla <sudeep.holla@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Stephen Boyd <sboyd@codeaurora.org>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Mark Salter <msalter@redhat.com>
Subject: [PATCH] clocksource: arm_arch_timer: fix system hang
Date: Sun, 19 Oct 2014 11:22:44 -0400
Message-Id: <1413732164-19545-1-git-send-email-msalter@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arm allows for two possible architectural clock sources. One memory mapped
and the other coprocessor based. If both timers exist, then the driver waits
for both to be probed before registering a clocksource.

Commit c387f07e6205 ("clocksource: arm_arch_timer: Discard unavailable timers
correctly") attempted to fix a hang occurring when one of the two possible
timers had a device node, but was disabled. In that case, the second probe
would never occur and the system would hang without a clocksource being
registered.

Unfortunately, incorrect logic in that commit made things worse such that
a hang would occur unless both timers had a device node and were enabled.
This patch fixes the logic so that we don't wait to probe a second timer
unless it exists and is enabled.

Signed-off-by: Mark Salter <msalter@redhat.com>
---
 drivers/clocksource/arm_arch_timer.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index d1a5e35..b73392b 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -666,13 +666,14 @@ static bool __init
 arch_timer_probed(int type, const struct of_device_id *matches)
 {
 	struct device_node *dn;
-	bool probed = false;
+	bool probed = true;
 
 	dn = of_find_matching_node(NULL, matches);
-	if (dn && of_device_is_available(dn) && (arch_timers_present & type))
-		probed = true;
-	of_node_put(dn);
-
+	if (dn) {
+		if (of_device_is_available(dn) && !(arch_timers_present & type))
+			probed = false;
+		of_node_put(dn);
+	}
 	return probed;
 }
 
-- 
1.8.3.1

