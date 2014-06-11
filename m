Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755712AbaFKI6T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 04:58:19 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:59795 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932316AbaFKI6P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 04:58:15 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>, <dwmw2@infradead.org>, <computersforpeace@gmail.com>
CC: <kyungmin.park@samsung.com>, <pekon@ti.com>,
        <ezequiel.garcia@free-electrons.com>, <javier@dowhile0.org>,
        <nsekhar@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-mtd@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: [PATCH 17/36] ARM: OMAP2+: gpmc-onenand: Use Async settings/timings by default
Date: Wed, 11 Jun 2014 11:56:22 +0300
Message-ID: <1402477001-31132-18-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1402477001-31132-1-git-send-email-rogerq@ti.com>
References: <1402477001-31132-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Onenand device operates in Asynchronous mode by default. So
configure GPMC settings/timings based on Async mode before the onenand
device is created.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/mach-omap2/gpmc-onenand.c | 66 ++++++++++++++++++--------------------
 1 file changed, 32 insertions(+), 34 deletions(-)

diff --git a/arch/arm/mach-omap2/gpmc-onenand.c b/arch/arm/mach-omap2/gpmc-onenand.c
index 8b6876c..bed8efe 100644
--- a/arch/arm/mach-omap2/gpmc-onenand.c
+++ b/arch/arm/mach-omap2/gpmc-onenand.c
@@ -61,9 +61,8 @@ static struct gpmc_settings onenand_sync = {
 	.wait_pin	= 0,
 };
 
-static void omap2_onenand_calc_async_timings(struct gpmc_timings *t)
+static void omap2_onenand_get_async_timings(struct gpmc_device_timings *dev_t)
 {
-	struct gpmc_device_timings dev_t;
 	const int t_cer = 15;
 	const int t_avdp = 12;
 	const int t_aavdh = 7;
@@ -74,20 +73,18 @@ static void omap2_onenand_calc_async_timings(struct gpmc_timings *t)
 	const int t_wpl = 40;
 	const int t_wph = 30;
 
-	memset(&dev_t, 0, sizeof(dev_t));
-
-	dev_t.t_avdp_r = max_t(int, t_avdp, t_cer) * 1000;
-	dev_t.t_avdp_w = dev_t.t_avdp_r;
-	dev_t.t_aavdh = t_aavdh * 1000;
-	dev_t.t_aa = t_aa * 1000;
-	dev_t.t_ce = t_ce * 1000;
-	dev_t.t_oe = t_oe * 1000;
-	dev_t.t_cez_r = t_cez * 1000;
-	dev_t.t_cez_w = dev_t.t_cez_r;
-	dev_t.t_wpl = t_wpl * 1000;
-	dev_t.t_wph = t_wph * 1000;
-
-	gpmc_calc_timings(t, &onenand_async, &dev_t);
+	memset(dev_t, 0, sizeof(*dev_t));
+
+	dev_t->t_avdp_r = max_t(int, t_avdp, t_cer) * 1000;
+	dev_t->t_avdp_w = dev_t->t_avdp_r;
+	dev_t->t_aavdh = t_aavdh * 1000;
+	dev_t->t_aa = t_aa * 1000;
+	dev_t->t_ce = t_ce * 1000;
+	dev_t->t_oe = t_oe * 1000;
+	dev_t->t_cez_r = t_cez * 1000;
+	dev_t->t_cez_w = dev_t->t_cez_r;
+	dev_t->t_wpl = t_wpl * 1000;
+	dev_t->t_wph = t_wph * 1000;
 }
 
 static void omap2_onenand_set_async_mode(void __iomem *onenand_base)
@@ -267,9 +264,10 @@ static void omap2_onenand_calc_sync_timings(struct gpmc_timings *t,
 	gpmc_calc_timings(t, &onenand_sync, &dev_t);
 }
 
-static int omap2_onenand_setup_async(void __iomem *onenand_base)
+static int omap2_onenand_setup_async(void)
 {
-	struct gpmc_timings t;
+	struct gpmc_timings gpmc_t;
+	struct gpmc_device_timings dev_t;
 	int ret;
 
 	if (gpmc_onenand_data->of_node) {
@@ -286,19 +284,14 @@ static int omap2_onenand_setup_async(void __iomem *onenand_base)
 		}
 	}
 
-	omap2_onenand_set_async_mode(onenand_base);
-
-	omap2_onenand_calc_async_timings(&t);
-
 	ret = gpmc_cs_program_settings(gpmc_onenand_data->cs, &onenand_async);
 	if (ret < 0)
 		return ret;
 
-	ret = gpmc_cs_set_timings(gpmc_onenand_data->cs, &t);
-	if (ret < 0)
-		return ret;
-
-	omap2_onenand_set_async_mode(onenand_base);
+	omap2_onenand_get_async_timings(&dev_t);
+	gpmc_calc_timings(&gpmc_t, &onenand_async, &dev_t);
+	if (gpmc_cs_set_timings(gpmc_onenand_data->cs, &gpmc_t))
+		return -EINVAL;
 
 	return 0;
 }
@@ -349,11 +342,7 @@ static int gpmc_onenand_setup(void __iomem *onenand_base, int *freq_ptr)
 	unsigned l = ONENAND_SYNC_READ | ONENAND_SYNC_READWRITE;
 	int ret;
 
-	ret = omap2_onenand_setup_async(onenand_base);
-	if (ret) {
-		dev_err(dev, "unable to set to async mode\n");
-		return ret;
-	}
+	omap2_onenand_set_async_mode(onenand_base);
 
 	if (!(gpmc_onenand_data->flags & l))
 		return 0;
@@ -396,9 +385,18 @@ void gpmc_onenand_init(struct omap_onenand_platform_data *_onenand_data)
 	gpmc_onenand_resource.end = gpmc_onenand_resource.start +
 							ONENAND_IO_SIZE - 1;
 
+	if (omap2_onenand_setup_async()) {
+		pr_err("%s: Failed to setup ASYNC timings\n", __func__);
+		goto fail;
+	}
+
 	if (platform_device_register(&gpmc_onenand_device) < 0) {
 		dev_err(dev, "Unable to register OneNAND device\n");
-		gpmc_cs_free(gpmc_onenand_data->cs);
-		return;
+		goto fail;
 	}
+
+	return;
+
+fail:
+	gpmc_cs_free(gpmc_onenand_data->cs);
 }
-- 
1.8.3.2

