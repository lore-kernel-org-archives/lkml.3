Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676AbaAPMor (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 07:44:47 -0500
Received: from mga01.intel.com ([192.55.52.88]:4679 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751592AbaAPMoo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 07:44:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,667,1384329600"; 
   d="scan'208";a="466088550"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Alessandro Zummo <a.zummo@towertech.it>
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH] drivers/rtc/rtc-cmos.c: fix compilation warning when !CONFIG_PM_SLEEP
Date: Thu, 16 Jan 2014 14:44:17 +0200
Message-Id: <1389876257-4986-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.8.5.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_PM will be set also if only CONFIG_PM_RUNTIME is set which causes
the compiler to emit following warning:

drivers/rtc/rtc-cmos.c:845:12: warning: ‘cmos_resume’ defined but not used [-Wunused-function]

Fix this by using CONFIG_PM_SLEEP instead of CONFIG_PM and removing it from
the driver pm ops as this has been taken care by SIMPLE_DEV_PM_OPS()
already.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/rtc/rtc-cmos.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index f14876256a4a..8d3b80d5f337 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -791,7 +791,7 @@ static void __exit cmos_do_remove(struct device *dev)
 	cmos->dev = NULL;
 }
 
-#ifdef	CONFIG_PM
+#ifdef	CONFIG_PM_SLEEP
 
 static int cmos_suspend(struct device *dev)
 {
@@ -889,8 +889,6 @@ static int cmos_resume(struct device *dev)
 	return 0;
 }
 
-static SIMPLE_DEV_PM_OPS(cmos_pm_ops, cmos_suspend, cmos_resume);
-
 #else
 
 static inline int cmos_poweroff(struct device *dev)
@@ -900,6 +898,8 @@ static inline int cmos_poweroff(struct device *dev)
 
 #endif
 
+static SIMPLE_DEV_PM_OPS(cmos_pm_ops, cmos_suspend, cmos_resume);
+
 /*----------------------------------------------------------------*/
 
 /* On non-x86 systems, a "CMOS" RTC lives most naturally on platform_bus.
@@ -1042,11 +1042,9 @@ static struct pnp_driver cmos_pnp_driver = {
 
 	/* flag ensures resume() gets called, and stops syslog spam */
 	.flags		= PNP_DRIVER_RES_DO_NOT_CHANGE,
-#ifdef CONFIG_PM_SLEEP
 	.driver		= {
 			.pm = &cmos_pm_ops,
 	},
-#endif
 };
 
 #endif	/* CONFIG_PNP */
-- 
1.8.5.2

