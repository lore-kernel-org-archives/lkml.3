Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932777AbaIRPgA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 11:36:00 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:47361 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932385AbaIRP3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 11:29:05 -0400
X-AuditID: cbfee61a-f79e46d00000134f-6d-541afa3f4fc8
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Eduardo Valentin <edubezval@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH 11/33] thermal: exynos: replace tmu_pmin check by Exynos5440 one
Date: Thu, 18 Sep 2014 17:27:28 +0200
Message-id: <1411054070-25757-12-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1411054070-25757-1-git-send-email-b.zolnierkie@samsung.com>
References: <1411054070-25757-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHLMWRmVeSWpSXmKPExsVy+t9jAV37X1IhBu8Wi1g0XA2x2DhjPavF
	3eeHGS3mX7nGanG26Q27xZuHmxktLu+aw2bxufcIo8WM8/uYLJ487GNz4PLYOesuu8fiPS+Z
	PPq2rGL0+LxJLoAlissmJTUnsyy1SN8ugSuj4/1K1oI20Yq2c0tYGxh/CHYxcnJICJhIHHu9
	hxXCFpO4cG89WxcjF4eQwCJGia6ZG9ghnC4mif83N7GBVLEJWElMbF/FCGKLCGhJnLi0nQmk
	iFngFpPE6xuTwRLCAgESL6euB2tgEVCVWHWnByzOK+ApcfriLKh1ihLdzyaA1XACxRtubWIH
	sYUEPCTattxlnsDIu4CRYRWjaGpBckFxUnquoV5xYm5xaV66XnJ+7iZGcKg9k9rBuLLB4hCj
	AAejEg/vAV6pECHWxLLiytxDjBIczEoivH8+AoV4UxIrq1KL8uOLSnNSiw8xSnOwKInzHmi1
	DhQSSE8sSc1OTS1ILYLJMnFwSjUwHs+5ZZgjPGdKXYHZ6+kH5d23npvw6JZlRuBDQ62Stev3
	JgpbavaoZfqfv2jBm9e1KPPb3U0+iWYV7NyHGwRSFvUyxFcmSJrLdvWU59l/t2HJeP7Mpyrm
	RPifx9N9vzvcCPqdl3WCv3nW9197+f08k79wqCj8PJpfE1zOnnokxtx67qG9VfOVWIozEg21
	mIuKEwEjdOM4MQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

reg->tmu_pmin is set to non-zero value only for Exynos5440
so replace check for non-zero value of reg->tmu_pmin by
explicitly checking for Exynos5440 SoC type.  Then remove no
longer needed reg->tmu_pmin register abstraction.

There should be no functional changes caused by this patch.

Cc: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: Amit Daniel Kachhap <amit.daniel@samsung.com>
Cc: Lukasz Majewski <l.majewski@samsung.com>
Cc: Eduardo Valentin <edubezval@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/thermal/samsung/exynos_tmu.c      | 4 ++--
 drivers/thermal/samsung/exynos_tmu.h      | 3 ---
 drivers/thermal/samsung/exynos_tmu_data.c | 1 -
 3 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index 85e74e1..f009a04 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -256,8 +256,8 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
 		}
 	}
 	/*Clear the PMIN in the common TMU register*/
-	if (reg->tmu_pmin && !data->id)
-		writel(0, data->base_second + reg->tmu_pmin);
+	if (data->soc == SOC_ARCH_EXYNOS5440 && !data->id)
+		writel(0, data->base_second + EXYNOS5440_TMU_PMIN);
 out:
 	clk_disable(data->clk);
 	mutex_unlock(&data->lock);
diff --git a/drivers/thermal/samsung/exynos_tmu.h b/drivers/thermal/samsung/exynos_tmu.h
index 5ab7482..7098e37 100644
--- a/drivers/thermal/samsung/exynos_tmu.h
+++ b/drivers/thermal/samsung/exynos_tmu.h
@@ -96,7 +96,6 @@ enum soc_type {
  * @intclr_rise_mask: mask bits of all rising interrupt bits.
  * @intclr_fall_mask: mask bits of all rising interrupt bits.
  * @emul_con: TMU emulation controller register.
- * @tmu_pmin: register to get/set the Pmin value.
  */
 struct exynos_tmu_registers {
 	u32	tmu_ctrl;
@@ -124,8 +123,6 @@ struct exynos_tmu_registers {
 	u32	intclr_rise_mask;
 
 	u32	emul_con;
-
-	u32	tmu_pmin;
 };
 
 /**
diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/thermal/samsung/exynos_tmu_data.c
index 5811b99..23beb70 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.c
+++ b/drivers/thermal/samsung/exynos_tmu_data.c
@@ -423,7 +423,6 @@ static const struct exynos_tmu_registers exynos5440_tmu_registers = {
 	.intclr_rise_mask = EXYNOS5440_TMU_RISE_INT_MASK,
 	.intclr_fall_mask = EXYNOS5440_TMU_FALL_INT_MASK,
 	.emul_con = EXYNOS5440_TMU_S0_7_DEBUG,
-	.tmu_pmin = EXYNOS5440_TMU_PMIN,
 };
 
 #define EXYNOS5440_TMU_DATA \
-- 
1.8.2.3

