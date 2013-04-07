Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161563Ab3DGIPI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 04:15:08 -0400
Received: from smtp-out-201.synserver.de ([212.40.185.201]:1047 "EHLO
	smtp-out-198.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1161542Ab3DGIPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 04:15:03 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 28971
From: Lars-Peter Clausen <lars@metafoo.de>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Archit Taneja <archit@ti.com>, linux-omap@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH] OMAPDSS: nec-nl8048 panel: Use dev_pm_ops
Date: Sun,  7 Apr 2013 11:14:13 +0200
Message-Id: <1365326053-16248-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.8.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use dev_pm_ops instead of the deprecated legacy suspend/resume callbacks.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 .../video/omap2/displays/panel-nec-nl8048hl11-01b.c  | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/video/omap2/displays/panel-nec-nl8048hl11-01b.c b/drivers/video/omap2/displays/panel-nec-nl8048hl11-01b.c
index 1e0097d..20c3cd9 100644
--- a/drivers/video/omap2/displays/panel-nec-nl8048hl11-01b.c
+++ b/drivers/video/omap2/displays/panel-nec-nl8048hl11-01b.c
@@ -242,16 +242,22 @@ static int nec_8048_spi_remove(struct spi_device *spi)
 	return 0;
 }
 
-static int nec_8048_spi_suspend(struct spi_device *spi, pm_message_t mesg)
+#ifdef CONFIG_PM_SLEEP
+
+static int nec_8048_spi_suspend(struct device *dev)
 {
+	struct spi_device *spi = to_spi_device(dev);
+
 	nec_8048_spi_send(spi, 2, 0x01);
 	mdelay(40);
 
 	return 0;
 }
 
-static int nec_8048_spi_resume(struct spi_device *spi)
+static int nec_8048_spi_resume(struct device *dev)
 {
+	struct spi_device *spi = to_spi_device(dev);
+
 	/* reinitialize the panel */
 	spi_setup(spi);
 	nec_8048_spi_send(spi, 2, 0x00);
@@ -260,14 +266,20 @@ static int nec_8048_spi_resume(struct spi_device *spi)
 	return 0;
 }
 
+static SIMPLE_DEV_PM_OPS(nec_8048_spi_pm_ops, nec_8048_spi_suspend,
+		nec_8048_spi_resume);
+#define NEC_8048_SPI_PM_OPS (&nec_8048_spi_pm_ops)
+#else
+#define NEC_8048_SPI_PM_OPS NULL
+#endif
+
 static struct spi_driver nec_8048_spi_driver = {
 	.probe		= nec_8048_spi_probe,
 	.remove		= nec_8048_spi_remove,
-	.suspend	= nec_8048_spi_suspend,
-	.resume		= nec_8048_spi_resume,
 	.driver		= {
 		.name	= "nec_8048_spi",
 		.owner	= THIS_MODULE,
+		.pm	= NEC_8048_SPI_PM_OPS,
 	},
 };
 
-- 
1.8.0

