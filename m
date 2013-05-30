Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030578Ab3E3Kob (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 06:44:31 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:40331 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030476Ab3E3KoD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 06:44:03 -0400
From: Andrii Tseglytskyi <andrii.tseglytskyi@ti.com>
To: <khilman@linaro.org>, <j-keerthy@ti.com>
CC: <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-pm@vger.kernel.org>
Subject: [PATCH v1 2/2] PM / AVS: SmartReflex/class3: Fix order of initialization of SR class and SR driver
Date: Thu, 30 May 2013 13:43:57 +0300
Message-ID: <1369910637-19100-3-git-send-email-andrii.tseglytskyi@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1369910637-19100-1-git-send-email-andrii.tseglytskyi@ti.com>
References: <1369910637-19100-1-git-send-email-andrii.tseglytskyi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SmartReflex consists of three entities: SR device, SR class and
SR driver. SmartReflex driver depends on SmartReflex class, but
order of their initialization is not clear. They both use
late_initcall(), and order depends on Makefile calls.
Patch moves initialization of SR class to device_initcall(),
and removes redundant call of sr_late_init().

This provides predictable order of SmartReflex initcalls:
1. device_initcall() -> SmartReflex class init
2. late_initcall() -> SmartReflex driver init

Signed-off-by: Andrii Tseglytskyi <andrii.tseglytskyi@ti.com>
---
 arch/arm/mach-omap2/smartreflex-class3.c |    2 +-
 drivers/power/avs/smartreflex.c          |    9 ---------
 2 files changed, 1 insertion(+), 10 deletions(-)

diff --git a/arch/arm/mach-omap2/smartreflex-class3.c b/arch/arm/mach-omap2/smartreflex-class3.c
index aee3c89..50523b8 100644
--- a/arch/arm/mach-omap2/smartreflex-class3.c
+++ b/arch/arm/mach-omap2/smartreflex-class3.c
@@ -59,4 +59,4 @@ static int __init sr_class3_init(void)
 	pr_info("SmartReflex Class3 initialized\n");
 	return sr_register_class(&class3_data);
 }
-omap_late_initcall(sr_class3_init);
+omap_device_initcall(sr_class3_init);
diff --git a/drivers/power/avs/smartreflex.c b/drivers/power/avs/smartreflex.c
index 60cf0ee..8a68b4f 100644
--- a/drivers/power/avs/smartreflex.c
+++ b/drivers/power/avs/smartreflex.c
@@ -651,8 +651,6 @@ void sr_disable(struct voltagedomain *voltdm)
  */
 int sr_register_class(struct omap_sr_class_data *class_data)
 {
-	struct omap_sr *sr_info;
-
 	if (!class_data) {
 		pr_warning("%s:, Smartreflex class data passed is NULL\n",
 			__func__);
@@ -667,13 +665,6 @@ int sr_register_class(struct omap_sr_class_data *class_data)
 
 	sr_class = class_data;
 
-	/*
-	 * Call into late init to do intializations that require
-	 * both sr driver and sr class driver to be initiallized.
-	 */
-	list_for_each_entry(sr_info, &sr_list, node)
-		sr_late_init(sr_info);
-
 	return 0;
 }
 
-- 
1.7.9.5

