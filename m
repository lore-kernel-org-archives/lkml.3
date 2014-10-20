Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834AbaJTOtt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 10:49:49 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:39917 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144AbaJTOsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 10:48:41 -0400
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Mark Brown <broonie@kernel.org>
Cc: Chanwoo Choi <cw00.choi@samsung.com>, Olof Johansson <olof@lixom.net>,
        Chris Zhong <zyw@rock-chips.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH v3 4/5] regulator: max77802: Parse regulator operating mode properties
Date: Mon, 20 Oct 2014 16:47:51 +0200
Message-Id: <1413816472-1895-5-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1413816472-1895-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1413816472-1895-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The max77802 PMIC regulators output can be configured in one of two
modes: Output ON (normal) and Output ON in Low Power Mode. Some of
the regulators support their operating mode to be changed on startup
or by consumers when the system is running while others only support
their operating mode to be changed while the system has entered in a
suspend state.

The regulator Device Tree binding documents a set of properties to
configure the regulators operating modes from a FDT. This patch parse
those properties and fills the regulator constraints so the regulator
core can call the suspend handlers when the system enters into sleep.

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---

Changes since v2:
 - Use the standard suspend states binding instead of custom properties.
   Suggested by Mark Brown.

Changes since v1:
 - Use the static inline max77802_map_mode() function instead of a macro.
   Suggested by Mark Brown.

 drivers/regulator/max77802.c | 44 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/drivers/regulator/max77802.c b/drivers/regulator/max77802.c
index 5839c45..2cbf980 100644
--- a/drivers/regulator/max77802.c
+++ b/drivers/regulator/max77802.c
@@ -518,6 +518,48 @@ static struct regulator_desc regulators[] = {
 };
 
 #ifdef CONFIG_OF
+
+static void max77802_parse_opmodes(struct device_node *np,
+				   struct regulation_constraints *cons)
+{
+	u32 pval;
+	int i;
+	char *states[PM_SUSPEND_MAX + 1] = {
+		[PM_SUSPEND_MEM] = "regulator-state-mem",
+		[PM_SUSPEND_MAX] = "regulator-state-disk",
+	};
+	struct regulator_state *state;
+	struct device_node *state_np;
+
+	if (!of_property_read_u32(np, "regulator-initial-mode", &pval))
+		cons->initial_mode = max77802_map_mode(pval);
+
+	for (i = 0; i < ARRAY_SIZE(states); i++) {
+		switch (i) {
+		case PM_SUSPEND_MEM:
+			state = &cons->state_mem;
+			break;
+		case PM_SUSPEND_MAX:
+			state = &cons->state_disk;
+			break;
+		default:
+			continue;
+		};
+
+		state_np = of_get_child_by_name(np, states[i]);
+		if (!state_np || !state)
+			continue;
+
+		if (!of_property_read_u32(np, "regulator-mode", &pval))
+			state->mode = max77802_map_mode(pval);
+
+		of_node_put(state_np);
+
+		state = NULL;
+		state_np = NULL;
+	};
+}
+
 static int max77802_pmic_dt_parse_pdata(struct platform_device *pdev,
 					struct max77686_platform_data *pdata)
 {
@@ -555,6 +597,8 @@ static int max77802_pmic_dt_parse_pdata(struct platform_device *pdev,
 		rdata[i].initdata = rmatch.init_data;
 		rdata[i].of_node = rmatch.of_node;
 		rdata[i].id = regulators[i].id;
+		max77802_parse_opmodes(rdata[i].of_node,
+				       &rdata[i].initdata->constraints);
 	}
 
 	pdata->regulators = rdata;
-- 
2.1.0

