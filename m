Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757224Ab3GYTmO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 15:42:14 -0400
Received: from mail-gg0-f202.google.com ([209.85.161.202]:37874 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756158Ab3GYTmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 15:42:12 -0400
From: Vincent Palatin <vpalatin@chromium.org>
To: Mark Brown <broonie@kernel.org>, Grant Likely <grant.likely@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>
Cc: linux-kernel@vger.kernel.org, Olof Johansson <olofj@chromium.org>,
        devicetree@vger.kernel.org, Vincent Palatin <vpalatin@chromium.org>
Subject: [PATCH] regulator: read low power states configuration from device tree
Date: Thu, 25 Jul 2013 12:42:00 -0700
Message-Id: <1374781320-10793-1-git-send-email-vpalatin@chromium.org>
X-Mailer: git-send-email 1.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The regulators state during a system wide low power state can currently
only be described in platform data. Add the option to configure them
from the device tree.

Signed-off-by: Vincent Palatin <vpalatin@chromium.org>
---
 .../devicetree/bindings/regulator/regulator.txt    |  6 +++++
 drivers/regulator/of_regulator.c                   | 31 ++++++++++++++++++++++
 2 files changed, 37 insertions(+)

diff --git a/Documentation/devicetree/bindings/regulator/regulator.txt b/Documentation/devicetree/bindings/regulator/regulator.txt
index 48a3b8e..e259b43 100644
--- a/Documentation/devicetree/bindings/regulator/regulator.txt
+++ b/Documentation/devicetree/bindings/regulator/regulator.txt
@@ -10,6 +10,12 @@ Optional properties:
 - regulator-always-on: boolean, regulator should never be disabled
 - regulator-boot-on: bootloader/firmware enabled regulator
 - regulator-allow-bypass: allow the regulator to go into bypass mode
+- regulator-suspend-disk-microvolt: voltage applied when entering S2D
+- regulator-suspend-disk-disabled: turn off when entering S2D
+- regulator-suspend-mem-microvolt: voltage applied when entering S2M
+- regulator-suspend-mem-disabled: turn off when entering S2M
+- regulator-suspend-standby-microvolt: voltage applied when entering standby
+- regulator-suspend-standby-disabled: turn off when entering standby
 - <name>-supply: phandle to the parent supply/regulator node
 - regulator-ramp-delay: ramp delay for regulator(in uV/uS)
 
diff --git a/drivers/regulator/of_regulator.c b/drivers/regulator/of_regulator.c
index f3c8f8f..4abc18c 100644
--- a/drivers/regulator/of_regulator.c
+++ b/drivers/regulator/of_regulator.c
@@ -21,6 +21,7 @@ static void of_get_regulation_constraints(struct device_node *np,
 {
 	const __be32 *min_uV, *max_uV, *uV_offset;
 	const __be32 *min_uA, *max_uA, *ramp_delay;
+	const __be32 *state_disk_uV, *state_mem_uV, *state_standby_uV;
 	struct regulation_constraints *constraints = &(*init_data)->constraints;
 
 	constraints->name = of_get_property(np, "regulator-name", NULL);
@@ -67,6 +68,36 @@ static void of_get_regulation_constraints(struct device_node *np,
 	ramp_delay = of_get_property(np, "regulator-ramp-delay", NULL);
 	if (ramp_delay)
 		constraints->ramp_delay = be32_to_cpu(*ramp_delay);
+
+	/* regulator state for suspend to disk */
+	state_disk_uV = of_get_property(np, "regulator-suspend-disk-microvolt",
+					NULL);
+	if (state_disk_uV) {
+		constraints->state_disk.uV = be32_to_cpu(*state_disk_uV);
+		constraints->state_disk.enabled = true;
+	}
+	if (of_find_property(np, "regulator-suspend-disk-disabled", NULL))
+		constraints->state_disk.disabled = true;
+
+	/* regulator state for suspend to RAM */
+	state_mem_uV = of_get_property(np, "regulator-suspend-mem-microvolt",
+					NULL);
+	if (state_mem_uV) {
+		constraints->state_mem.uV = be32_to_cpu(*state_mem_uV);
+		constraints->state_mem.enabled = true;
+	}
+	if (of_find_property(np, "regulator-suspend-mem-disabled", NULL))
+		constraints->state_mem.disabled = true;
+
+	/* regulator state for standby */
+	state_standby_uV = of_get_property(np,
+		"regulator-suspend-standby-microvolt", NULL);
+	if (state_standby_uV) {
+		constraints->state_standby.uV = be32_to_cpu(*state_standby_uV);
+		constraints->state_standby.enabled = true;
+	}
+	if (of_find_property(np, "regulator-suspend-standby-disabled", NULL))
+		constraints->state_standby.disabled = true;
 }
 
 /**
-- 
1.8.3

