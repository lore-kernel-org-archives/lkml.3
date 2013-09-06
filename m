Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751073Ab3IFGpz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 02:45:55 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:54704 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031Ab3IFGpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 02:45:52 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: anton@enomsg.org, dwmw2@infradead.org, lee.jones@linaro.org,
        sachin.kamat@linaro.org
Subject: [PATCH v2 3/4] pm2301-charger: Check return value of regulator_enable
Date: Fri,  6 Sep 2013 11:57:52 +0530
Message-Id: <1378448873-4430-3-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1378448873-4430-1-git-send-email-sachin.kamat@linaro.org>
References: <1378448873-4430-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check the return value of regulator_enable to silence the following
warning:
drivers/power/pm2301_charger.c:725:20: warning:
ignoring return value of ‘regulator_enable’, declared with
attribute warn_unused_result [-Wunused-result]

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Lee Jones <lee.jones@linaro.org>
---
Compile tested.
Changes since v1:
* converted dev_err and return to dev_warn as suggested by Lee Jones.
---
 drivers/power/pm2301_charger.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/power/pm2301_charger.c b/drivers/power/pm2301_charger.c
index ffa10ed..e55d809 100644
--- a/drivers/power/pm2301_charger.c
+++ b/drivers/power/pm2301_charger.c
@@ -722,8 +722,14 @@ static int pm2xxx_charger_ac_en(struct ux500_charger *charger,
 
 		dev_dbg(pm2->dev, "Enable AC: %dmV %dmA\n", vset, iset);
 		if (!pm2->vddadc_en_ac) {
-			regulator_enable(pm2->regu);
-			pm2->vddadc_en_ac = true;
+			ret = regulator_enable(pm2->regu);
+			if (ret) {
+				dev_warn(pm2->dev,
+					"Failed to enable vddadc regulator\n");
+				pm2->vddadc_en_ac = false;
+			} else {
+				pm2->vddadc_en_ac = true;
+			}
 		}
 
 		ret = pm2xxx_charging_init(pm2);
-- 
1.7.9.5

