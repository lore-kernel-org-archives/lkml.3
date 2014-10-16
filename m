Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752275AbaJPQuM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 12:50:12 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:35000 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207AbaJPQuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 12:50:08 -0400
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Mark Brown <broonie@kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>, Doug Anderson <dianders@chromium.org>,
        Chanwoo Choi <cw00.choi@samsung.com>, Olof Johansson <olof@lixom.net>,
        Chris Zhong <zyw@rock-chips.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH v2 6/7] regulator: max77802: Parse regulator operating mode properties
Date: Thu, 16 Oct 2014 18:48:52 +0200
Message-Id: <1413478133-2577-7-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1413478133-2577-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1413478133-2577-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The max77802 PMIC regulators output can be configured in one of two
modes: Output ON (normal) and Output ON in Low Power Mode. Some of
the regulators support their operating mode to be changed on startup
or by consumers when the system is running while others only support
their operating mode to be changed while the system has entered in a
suspend state.

The max77802 PMIC Device Tree binding document a set of properties to
configure the regulators operating modes from a FDT. This patch parse
those properties and fills the regulator constraints so the regulator
core can call the suspend handlers when the system enters into sleep.

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---

Changes since v1:
 - Use the static inline max77802_map_mode() function instead of a macro.
   Suggested by Mark Brown.

 drivers/regulator/max77802.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/regulator/max77802.c b/drivers/regulator/max77802.c
index 5839c45..e2fbd45 100644
--- a/drivers/regulator/max77802.c
+++ b/drivers/regulator/max77802.c
@@ -518,6 +518,22 @@ static struct regulator_desc regulators[] = {
 };
 
 #ifdef CONFIG_OF
+
+static void max77802_parse_opmodes(struct device_node *np,
+				   struct regulation_constraints *cons)
+{
+	u32 pval;
+
+	if (!of_property_read_u32(np, "maxim,regulator-initial-mode", &pval))
+		cons->initial_mode = max77802_map_mode(pval);
+
+	if (!of_property_read_u32(np, "maxim,regulator-disk-mode", &pval))
+		cons->state_disk.mode = max77802_map_mode(pval);
+
+	if (!of_property_read_u32(np, "maxim,regulator-mem-mode", &pval))
+		cons->state_mem.mode = max77802_map_mode(pval);
+}
+
 static int max77802_pmic_dt_parse_pdata(struct platform_device *pdev,
 					struct max77686_platform_data *pdata)
 {
@@ -555,6 +571,8 @@ static int max77802_pmic_dt_parse_pdata(struct platform_device *pdev,
 		rdata[i].initdata = rmatch.init_data;
 		rdata[i].of_node = rmatch.of_node;
 		rdata[i].id = regulators[i].id;
+		max77802_parse_opmodes(rdata[i].of_node,
+				       &rdata[i].initdata->constraints);
 	}
 
 	pdata->regulators = rdata;
-- 
2.1.0

