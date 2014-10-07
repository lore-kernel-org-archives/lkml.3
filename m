Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753644AbaJGJv3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 05:51:29 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:54144 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753332AbaJGJut (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 05:50:49 -0400
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: "Ivan T. Ivanov" <iivanov@mm-sol.com>, Stephen Boyd <sboyd@codeaurora.org>,
        linux-input@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: [PATCH 3/4] Input: pmic8xxx-keypad - add support keypad found in pm8941
Date: Tue,  7 Oct 2014 12:50:47 +0300
Message-Id: <1412675448-11990-4-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412675448-11990-1-git-send-email-iivanov@mm-sol.com>
References: <1412675448-11990-1-git-send-email-iivanov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Controller seems to be the same. Just access to it is over SPMI bus
and registers and bits are reshuffled. Hopefully this is nicely
abstracted by regmap helpers.

Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
---
 .../bindings/input/qcom,pm8xxx-keypad.txt          |  1 +
 drivers/input/keyboard/pmic8xxx-keypad.c           | 27 ++++++++++++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/Documentation/devicetree/bindings/input/qcom,pm8xxx-keypad.txt b/Documentation/devicetree/bindings/input/qcom,pm8xxx-keypad.txt
index 7d8cb92..2b60f8a 100644
--- a/Documentation/devicetree/bindings/input/qcom,pm8xxx-keypad.txt
+++ b/Documentation/devicetree/bindings/input/qcom,pm8xxx-keypad.txt
@@ -8,6 +8,7 @@ PROPERTIES
 	Definition: must be one of:
 		    "qcom,pm8058-keypad"
 		    "qcom,pm8921-keypad"
+		    "qcom,pm8941-keypad"
 
 - reg:
 	Usage: required
diff --git a/drivers/input/keyboard/pmic8xxx-keypad.c b/drivers/input/keyboard/pmic8xxx-keypad.c
index b82d161..2d4fa07 100644
--- a/drivers/input/keyboard/pmic8xxx-keypad.c
+++ b/drivers/input/keyboard/pmic8xxx-keypad.c
@@ -136,6 +136,32 @@ static const struct pmic8xxx_kp_info ssbi_kp = {
 	.row_hold	= REG_FIELD(0x149, 6, 7),
 };
 
+static const struct pmic8xxx_kp_info spmi_kp = {
+	.max_rows	= 10,
+	.min_rows	= 2,
+	.max_cols	= 8,
+	.min_cols	= 1,
+
+	.rows_select = {
+		1, 2, 3, 4, 5, 6, 7,
+		8, 9, 10
+	},
+
+	.recent_data	= 0xa87c,
+	.old_data	= 0xa85c,
+	.read_stride	= 2,
+
+	.events		= REG_FIELD(0xa808, 0, 1),
+	.scan_rows	= REG_FIELD(0xa840, 0, 3),
+	.scan_cols	= REG_FIELD(0xa840, 4, 6),
+	.enable		= REG_FIELD(0xa846, 7, 7),
+
+	.read_state	= REG_FIELD(0xa844, 0, 0),
+	.dbonce		= REG_FIELD(0xa842, 0, 1),
+	.pause		= REG_FIELD(0xa842, 3, 5),
+	.row_hold	= REG_FIELD(0xa842, 6, 7),
+};
+
 static u8 pmic8xxx_col_state(struct pmic8xxx_kp *kp, u8 col)
 {
 	/* all keys pressed on that particular row? */
@@ -715,6 +741,7 @@ static SIMPLE_DEV_PM_OPS(pm8xxx_kp_pm_ops,
 static const struct of_device_id pm8xxx_match_table[] = {
 	{ .compatible = "qcom,pm8058-keypad", .data = (void *)&ssbi_kp },
 	{ .compatible = "qcom,pm8921-keypad", .data = (void *)&ssbi_kp },
+	{ .compatible = "qcom,pm8941-keypad", .data = (void *)&spmi_kp },
 	{ }
 };
 MODULE_DEVICE_TABLE(of, pm8xxx_match_table);
-- 
1.9.1

