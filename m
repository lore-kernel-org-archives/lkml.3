Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936639Ab3DHX4R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 19:56:17 -0400
Received: from mail-ia0-f202.google.com ([209.85.210.202]:64959 "EHLO
	mail-ia0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936583Ab3DHX4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 19:56:14 -0400
From: Andrew Bresticker <abrestic@chromium.org>
To: Zhang Rui <rui.zhang@intel.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Bresticker <abrestic@chromium.org>
Subject: [PATCH] thermal: step_wise: set throttle target within thermal instance limits
Date: Mon,  8 Apr 2013 16:56:11 -0700
Message-Id: <1365465371-24652-1-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 1.8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When selecting a target cooling state in get_target_state(), make sure
that the state is at least as high as the minimum when the temperature
is rising and at least as low as the maximum when the temperature is
falling.  Previously the cooling level would only be incremented or
decremented by one in these cases.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
 drivers/thermal/step_wise.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/thermal/step_wise.c b/drivers/thermal/step_wise.c
index 0cd5e9f..49992a4 100644
--- a/drivers/thermal/step_wise.c
+++ b/drivers/thermal/step_wise.c
@@ -47,9 +47,13 @@ static unsigned long get_target_state(struct thermal_instance *instance,
 	if (trend == THERMAL_TREND_RAISING) {
 		cur_state = cur_state < instance->upper ?
 			    (cur_state + 1) : instance->upper;
+		if (cur_state < instance->lower)
+			cur_state = instance->lower;
 	} else if (trend == THERMAL_TREND_DROPPING) {
 		cur_state = cur_state > instance->lower ?
 			    (cur_state - 1) : instance->lower;
+		if (cur_state > instance->upper)
+			cur_state = instance->upper;
 	}
 
 	return cur_state;
-- 
1.8.1.3

