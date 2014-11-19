Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901AbaKSKSJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 05:18:09 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:60487 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755847AbaKSKSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 05:18:03 -0500
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: rjw@rjwysocki.net
Cc: Lorenzo.Pieralisi@arm.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 2/3] drivers: cpuidle: Add idle-state-name description to ARM idle states
Date: Wed, 19 Nov 2014 11:17:57 +0100
Message-Id: <1416392278-18397-2-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416392278-18397-1-git-send-email-daniel.lezcano@linaro.org>
References: <546C6DEB.8060204@linaro.org>
 <1416392278-18397-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>

On ARM machines, where generally speaking the idle state numbering has
no fixed and standard meaning it is useful to provide a description
of the idle state inner workings for benchmarking and monitoring purposes.

This patch adds a property to the idle states bindings that if present
gives platform firmware a means of describing the idle state and export
the string description to user space.

The patch updates the DT parsing code accordingly to take the description,
if present, into consideration.

Acked-by: Kevin Hilman <khilman@linaro.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 Documentation/devicetree/bindings/arm/idle-states.txt | 6 ++++++
 drivers/cpuidle/dt_idle_states.c                      | 7 ++++++-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/arm/idle-states.txt b/Documentation/devicetree/bindings/arm/idle-states.txt
index 5e51511..a8274ea 100644
--- a/Documentation/devicetree/bindings/arm/idle-states.txt
+++ b/Documentation/devicetree/bindings/arm/idle-states.txt
@@ -331,6 +331,12 @@ follows:
 			    If the property is not present the idle-state must
 			    be considered operational.
 
+	- idle-state-name:
+		Usage: Optional
+		Value type: <string>
+		Definition: A string used as a descriptive name for the idle
+			    state.
+
 	In addition to the properties listed above, a state node may require
 	additional properties specifics to the entry-method defined in the
 	idle-states node, please refer to the entry-method bindings
diff --git a/drivers/cpuidle/dt_idle_states.c b/drivers/cpuidle/dt_idle_states.c
index 22840f4..5301912 100644
--- a/drivers/cpuidle/dt_idle_states.c
+++ b/drivers/cpuidle/dt_idle_states.c
@@ -27,6 +27,7 @@ static int init_state_node(struct cpuidle_state *idle_state,
 {
 	int err;
 	const struct of_device_id *match_id;
+	const char *desc;
 
 	match_id = of_match_node(matches, state_node);
 	if (!match_id)
@@ -73,6 +74,10 @@ static int init_state_node(struct cpuidle_state *idle_state,
 		return -EINVAL;
 	}
 
+	err = of_property_read_string(state_node, "idle-state-name", &desc);
+	if (err)
+		desc = state_node->name;
+
 	idle_state->flags = CPUIDLE_FLAG_TIME_VALID;
 	if (of_property_read_bool(state_node, "local-timer-stop"))
 		idle_state->flags |= CPUIDLE_FLAG_TIMER_STOP;
@@ -82,7 +87,7 @@ static int init_state_node(struct cpuidle_state *idle_state,
 	 *	and desc become string pointers
 	 */
 	strncpy(idle_state->name, state_node->name, CPUIDLE_NAME_LEN - 1);
-	strncpy(idle_state->desc, state_node->name, CPUIDLE_DESC_LEN - 1);
+	strncpy(idle_state->desc, desc, CPUIDLE_DESC_LEN - 1);
 	return 0;
 }
 
-- 
1.9.1

