Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936578Ab3DIV7w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 17:59:52 -0400
Received: from mail-oa0-f73.google.com ([209.85.219.73]:44226 "EHLO
	mail-oa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934324Ab3DIV7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 17:59:50 -0400
From: Andrew Bresticker <abrestic@chromium.org>
To: Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Bresticker <abrestic@chromium.org>
Subject: [PATCH] thermal: step_wise: set throttle target within thermal instance limits
Date: Tue,  9 Apr 2013 14:59:47 -0700
Message-Id: <1365544787-22940-1-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 1.8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When selecting a target cooling state in get_target_state(), make sure
that the state is at least as high as the minimum when the temperature
is rising and at least as low as the maximum when the temperature is
falling.  This is necessary because, in the THREAML_TREND_RAISING and
THERMAL_TREND_DROPPING cases, the current state may only be incremented
or decremented by one even if it is outside the bounds of the thermal
instance.  This might occur, for example, if the CPU is heating up
and hits a thermal trip point for the first time when it's frequency
is much higher than the range specified by the thermal instance
corresponding to the trip point.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
 drivers/thermal/step_wise.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/thermal/step_wise.c b/drivers/thermal/step_wise.c
index 407cde3..ca4f79f 100644
--- a/drivers/thermal/step_wise.c
+++ b/drivers/thermal/step_wise.c
@@ -59,9 +59,12 @@ static unsigned long get_target_state(struct thermal_instance *instance,
 
 	switch (trend) {
 	case THERMAL_TREND_RAISING:
-		if (throttle)
+		if (throttle) {
 			cur_state = cur_state < instance->upper ?
 				    (cur_state + 1) : instance->upper;
+			if (cur_state < instance->lower)
+				cur_state = instance->lower;
+		}
 		break;
 	case THERMAL_TREND_RAISE_FULL:
 		if (throttle)
@@ -71,8 +74,11 @@ static unsigned long get_target_state(struct thermal_instance *instance,
 		if (cur_state == instance->lower) {
 			if (!throttle)
 				cur_state = -1;
-		} else
+		} else {
 			cur_state -= 1;
+			if (cur_state > instance->upper)
+				cur_state = instance->upper;
+		}
 		break;
 	case THERMAL_TREND_DROP_FULL:
 		if (cur_state == instance->lower) {
-- 
1.8.1.3

