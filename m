Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062AbaJOQXV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 12:23:21 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:33542 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698AbaJOQU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 12:20:58 -0400
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Mark Brown <broonie@kernel.org>
Cc: Doug Anderson <dianders@chromium.org>,
        Chanwoo Choi <cw00.choi@samsung.com>, Olof Johansson <olof@lixom.net>,
        Chris Zhong <zyw@rock-chips.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH 3/9] regulator: max77802: Split regulator operations for BUCKs
Date: Wed, 15 Oct 2014 18:20:33 +0200
Message-Id: <1413390039-19364-4-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1413390039-19364-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1413390039-19364-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not all the max77802 BUCKs regulators have the same functionality, for
example BUCKs 2-4 support the output to be configured as normal or Low
Power Mode by the PWRREQ enable pin while the other BUCKs only support
their output to be set ON or OFF by PWRREQ. As a preparation for adding
a set_suspend_mode function handler for all the regulators that support
Low Power Mode by PWRREQ, split the operations for BUCKs regulators.

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---
 drivers/regulator/max77802.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/max77802.c b/drivers/regulator/max77802.c
index baf834d..a621700 100644
--- a/drivers/regulator/max77802.c
+++ b/drivers/regulator/max77802.c
@@ -330,7 +330,22 @@ static struct regulator_ops max77802_buck_16_dvs_ops = {
 	.set_suspend_disable	= max77802_set_suspend_disable,
 };
 
-/* BUCKs 2-4, 5, 7-10 */
+/* BUCKs 2-4 */
+static struct regulator_ops max77802_buck_234_ops = {
+	.list_voltage		= regulator_list_voltage_linear,
+	.map_voltage		= regulator_map_voltage_linear,
+	.is_enabled		= regulator_is_enabled_regmap,
+	.enable			= max77802_enable,
+	.disable		= regulator_disable_regmap,
+	.get_voltage_sel	= regulator_get_voltage_sel_regmap,
+	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
+	.set_voltage_time_sel	= regulator_set_voltage_time_sel,
+	.set_ramp_delay		= max77802_set_ramp_delay_2bit,
+	.set_suspend_enable	= max77802_enable,
+	.set_suspend_disable	= max77802_set_suspend_disable,
+};
+
+/* BUCKs 5, 7-10 */
 static struct regulator_ops max77802_buck_dvs_ops = {
 	.list_voltage		= regulator_list_voltage_linear,
 	.map_voltage		= regulator_map_voltage_linear,
@@ -404,7 +419,7 @@ static struct regulator_ops max77802_buck_dvs_ops = {
 	.name		= "BUCK"#num,					\
 	.id		= MAX77802_BUCK##num,				\
 	.supply_name	= "inb"#num,					\
-	.ops		= &max77802_buck_dvs_ops,			\
+	.ops		= &max77802_buck_234_ops,			\
 	.type		= REGULATOR_VOLTAGE,				\
 	.owner		= THIS_MODULE,					\
 	.min_uV		= 600000,					\
-- 
2.1.0

