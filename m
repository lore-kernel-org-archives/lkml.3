Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755918AbaKSKSL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 05:18:11 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:52520 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755366AbaKSKSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 05:18:01 -0500
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: rjw@rjwysocki.net
Cc: Lorenzo.Pieralisi@arm.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 1/3] drivers: cpuidle: Add status property to ARM idle states
Date: Wed, 19 Nov 2014 11:17:56 +0100
Message-Id: <1416392278-18397-1-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <546C6DEB.8060204@linaro.org>
References: <546C6DEB.8060204@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>

On some platforms the device tree bindings must provide the kernel
with a status flag for idle states, that defines whether the idle
state is operational or not in the current configuration.

This patch adds a status property to the ARM idle states compliant
with ePAPR v1.1 and updates the DT parsing code accordingly.

Acked-by: Kevin Hilman <khilman@linaro.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 Documentation/devicetree/bindings/arm/idle-states.txt | 14 ++++++++++++++
 drivers/cpuidle/dt_idle_states.c                      |  3 +++
 2 files changed, 17 insertions(+)

diff --git a/Documentation/devicetree/bindings/arm/idle-states.txt b/Documentation/devicetree/bindings/arm/idle-states.txt
index 37375c7..5e51511 100644
--- a/Documentation/devicetree/bindings/arm/idle-states.txt
+++ b/Documentation/devicetree/bindings/arm/idle-states.txt
@@ -317,6 +317,20 @@ follows:
 			    In such systems entry-latency-us + exit-latency-us
 			    will exceed wakeup-latency-us by this duration.
 
+	- status:
+		Usage: Optional
+		Value type: <string>
+		Definition: A standard device tree property [5] that indicates
+			    the operational status of an idle-state.
+			    If present, it shall be:
+			    "okay": to indicate that the idle state is
+				    operational.
+			    "disabled": to indicate that the idle state has
+					been disabled in firmware so it is not
+					operational.
+			    If the property is not present the idle-state must
+			    be considered operational.
+
 	In addition to the properties listed above, a state node may require
 	additional properties specifics to the entry-method defined in the
 	idle-states node, please refer to the entry-method bindings
diff --git a/drivers/cpuidle/dt_idle_states.c b/drivers/cpuidle/dt_idle_states.c
index 52f4d11..22840f4 100644
--- a/drivers/cpuidle/dt_idle_states.c
+++ b/drivers/cpuidle/dt_idle_states.c
@@ -169,6 +169,9 @@ int dt_init_idle_driver(struct cpuidle_driver *drv,
 		if (!state_node)
 			break;
 
+		if (!of_device_is_available(state_node))
+			continue;
+
 		if (!idle_state_valid(state_node, i, cpumask)) {
 			pr_warn("%s idle state not valid, bailing out\n",
 				state_node->full_name);
-- 
1.9.1

