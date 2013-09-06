Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750900Ab3IFGps (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 02:45:48 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:43466 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771Ab3IFGpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 02:45:47 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: anton@enomsg.org, dwmw2@infradead.org, lee.jones@linaro.org,
        sachin.kamat@linaro.org
Subject: [PATCH v2 1/4] ab8500-charger: Check return value of regulator_enable
Date: Fri,  6 Sep 2013 11:57:50 +0530
Message-Id: <1378448873-4430-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check the return value of regulator_enable to silence the following
type of warnings:
drivers/power/ab8500_charger.c:1390:20: warning: ignoring return value
of ‘regulator_enable’, declared with attribute warn_unused_result
[-Wunused-result]

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Lee Jones <lee.jones@linaro.org>
---
Compile tested.
Changes since v1:
 * converted dev_err and return to dev_warn as suggested by Lee Jones.
---
 drivers/power/ab8500_charger.c |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/power/ab8500_charger.c b/drivers/power/ab8500_charger.c
index a4c4a10..0d355a9 100644
--- a/drivers/power/ab8500_charger.c
+++ b/drivers/power/ab8500_charger.c
@@ -1387,8 +1387,14 @@ static int ab8500_charger_ac_en(struct ux500_charger *charger,
 		 * the GPADC module independant of the AB8500 chargers
 		 */
 		if (!di->vddadc_en_ac) {
-			regulator_enable(di->regu);
-			di->vddadc_en_ac = true;
+			ret = regulator_enable(di->regu);
+			if (ret) {
+				dev_warn(di->dev,
+					"Failed to enable regulator\n");
+				di->vddadc_en_ac = false;
+			} else {
+				di->vddadc_en_ac = true;
+			}
 		}
 
 		/* Check if the requested voltage or current is valid */
@@ -1556,8 +1562,14 @@ static int ab8500_charger_usb_en(struct ux500_charger *charger,
 		 * the GPADC module independant of the AB8500 chargers
 		 */
 		if (!di->vddadc_en_usb) {
-			regulator_enable(di->regu);
-			di->vddadc_en_usb = true;
+			ret = regulator_enable(di->regu);
+			if (ret) {
+				dev_warn(di->dev,
+					"Failed to enable regulator\n");
+				di->vddadc_en_usb = false;
+			} else {
+				di->vddadc_en_usb = true;
+			}
 		}
 
 		/* Enable USB charging */
-- 
1.7.9.5

