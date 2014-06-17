Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965161AbaFQRby (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 13:31:54 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:45550 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964772AbaFQRbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 13:31:16 -0400
X-AuditID: cbfee61b-b7fbb6d000001be3-39-53a07b39bd1a
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH v2 6/9] thermal: exynos: simplify temp_to_code() and
 code_to_temp()
Date: Tue, 17 Jun 2014 19:27:22 +0200
Message-id: <1403026045-16024-7-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1403026045-16024-1-git-send-email-b.zolnierkie@samsung.com>
References: <1403026045-16024-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrILMWRmVeSWpSXmKPExsVy+t9jQV2r6gXBBp3zGS0aroZYbJyxntVi
	zf6fTBZnm96wW1zeNYfN4nPvEUaLGef3MVmcOX2J1eLJwz42i/UzXrM4cHks3vOSyWPL1XYW
	j74tqxg9jt/YzuTxeZNcAGsUl01Kak5mWWqRvl0CV8b/R1vYC1aJVJw4vJGxgfGqQBcjB4eE
	gInEotWsXYycQKaYxIV769lAbCGB6YwSG57IdzFyAdldTBINO78zgiTYBKwkJravArNFBPQk
	brx4wgRSxCxwnEni5+/zYN3CAqESHxfuZAKxWQRUJdY8+MMCYvMKeEjMuDWNCWKbokT3swlg
	9ZwCnhI37rVAbfaQmH+xk2kCI+8CRoZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmbGMEB90x6
	B+OqBotDjAIcjEo8vBy5C4KFWBPLiitzDzFKcDArifCeywIK8aYkVlalFuXHF5XmpBYfYpTm
	YFES5z3Yah0oJJCeWJKanZpakFoEk2Xi4JRqYORdZdwbujDrX0fOTGXtuTnceu69v9x+3FYU
	mLmAueL+qmfVLaeM+cokF7gqbjD6d9dT+U3eS8E7uvunc5rfeygl+f6R2Cb7gDyJ2XPW/s7b
	kfDtmq/fk6tfc6aE+Z019NHZt9T63K8w66SzVX9aqvrYNn21/rl9V2RVM2PGYobmrx7sL97K
	bFZiKc5INNRiLipOBAC1szhWNAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Remove dead temp check from temp_to_code() (this function users
  in exynos_tmu_initialize() always pass correct temperatures and
  exynos_tmu_set_emulation() returns early for EXYNOS4210 because
  TMU_SUPPORT_EMULATION flag is not set on this SoC).

* Move temp_code check from code_to_temp() to exynos_tmu_read()
  (code_to_temp() only user).

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Reviewed-by: Amit Daniel Kachhap<amit.daniel@samsung.com>
---
 drivers/thermal/samsung/exynos_tmu.c | 38 +++++++++++-------------------------
 1 file changed, 11 insertions(+), 27 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index 204f811..34ac081 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -72,19 +72,7 @@ struct exynos_tmu_data {
  */
 static int temp_to_code(struct exynos_tmu_data *data, u8 temp)
 {
-	struct exynos_tmu_platform_data *pdata = data->pdata;
-	int temp_code;
-
-	if (data->soc == SOC_ARCH_EXYNOS4210)
-		/* temp should range between 25 and 125 */
-		if (temp < 25 || temp > 125) {
-			temp_code = -EINVAL;
-			goto out;
-		}
-
-	temp_code = temp + data->temp_error - pdata->first_point_trim;
-out:
-	return temp_code;
+	return temp + data->temp_error - data->pdata->first_point_trim;
 }
 
 /*
@@ -93,19 +81,7 @@ out:
  */
 static int code_to_temp(struct exynos_tmu_data *data, u8 temp_code)
 {
-	struct exynos_tmu_platform_data *pdata = data->pdata;
-	int temp;
-
-	if (data->soc == SOC_ARCH_EXYNOS4210)
-		/* temp_code should range between 75 and 175 */
-		if (temp_code < 75 || temp_code > 175) {
-			temp = -ENODATA;
-			goto out;
-		}
-
-	temp = temp_code - data->temp_error + pdata->first_point_trim;
-out:
-	return temp;
+	return temp_code - data->temp_error + data->pdata->first_point_trim;
 }
 
 static int exynos_tmu_initialize(struct platform_device *pdev)
@@ -311,8 +287,16 @@ static int exynos_tmu_read(struct exynos_tmu_data *data)
 	clk_enable(data->clk);
 
 	temp_code = readb(data->base + reg->tmu_cur_temp);
-	temp = code_to_temp(data, temp_code);
 
+	if (data->soc == SOC_ARCH_EXYNOS4210)
+		/* temp_code should range between 75 and 175 */
+		if (temp_code < 75 || temp_code > 175) {
+			temp = -ENODATA;
+			goto out;
+		}
+
+	temp = code_to_temp(data, temp_code);
+out:
 	clk_disable(data->clk);
 	mutex_unlock(&data->lock);
 
-- 
1.8.2.3

