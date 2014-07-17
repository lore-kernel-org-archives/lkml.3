Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933147AbaGQNyI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 09:54:08 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:33754 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932139AbaGQNyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 09:54:06 -0400
From: Andrey Utkin <andrey.krieger.utkin@gmail.com>
To: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Cc: arnd@arndb.de, carlos.chinea@nokia.com, sre@kernel.org,
        Andrey Utkin <andrey.krieger.utkin@gmail.com>
Subject: [PATCH 1/4] drivers/hsi/controllers/omap_ssi{,_port}.c: fix failure checks
Date: Thu, 17 Jul 2014 16:53:54 +0300
Message-Id: <1405605234-13559-1-git-send-email-andrey.krieger.utkin@gmail.com>
X-Mailer: git-send-email 1.8.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1.

[linux-3.16-rc5/drivers/hsi/controllers/omap_ssi.c:357]: (style) Checking if
unsigned variable 'gdd_irq' is less than zero.

Source code is

    omap_ssi->gdd_irq = platform_get_irq_byname(pd, "gdd_mpu");
    if (omap_ssi->gdd_irq < 0) {

2.

[linux-3.16-rc5/drivers/hsi/controllers/omap_ssi_port.c:1017]: (style) Checking
if unsigned variable 'irq' is less than zero.

Source code is

    omap_port->irq = platform_get_irq(pd, 0);
    if (omap_port->irq < 0) {

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=80441
Reported-by: David Binderman <dcb314@hotmail.com>
Signed-off-by: Andrey Utkin <andrey.krieger.utkin@gmail.com>
---
 drivers/hsi/controllers/omap_ssi.c      | 6 +++---
 drivers/hsi/controllers/omap_ssi_port.c | 7 ++++---
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/hsi/controllers/omap_ssi.c b/drivers/hsi/controllers/omap_ssi.c
index 0fc7a7f..232ab73 100644
--- a/drivers/hsi/controllers/omap_ssi.c
+++ b/drivers/hsi/controllers/omap_ssi.c
@@ -353,12 +353,12 @@ static int __init ssi_add_controller(struct hsi_controller *ssi,
 	err = ssi_get_iomem(pd, "gdd", &omap_ssi->gdd, NULL);
 	if (err < 0)
 		goto out_err;
-	omap_ssi->gdd_irq = platform_get_irq_byname(pd, "gdd_mpu");
-	if (omap_ssi->gdd_irq < 0) {
+	err = platform_get_irq_byname(pd, "gdd_mpu");
+	if (err < 0) {
 		dev_err(&pd->dev, "GDD IRQ resource missing\n");
-		err = omap_ssi->gdd_irq;
 		goto out_err;
 	}
+	omap_ssi->gdd_irq = err;
 	tasklet_init(&omap_ssi->gdd_tasklet, ssi_gdd_tasklet,
 							(unsigned long)ssi);
 	err = devm_request_irq(&ssi->device, omap_ssi->gdd_irq, ssi_gdd_isr,
diff --git a/drivers/hsi/controllers/omap_ssi_port.c b/drivers/hsi/controllers/omap_ssi_port.c
index 29aea0b..001b868 100644
--- a/drivers/hsi/controllers/omap_ssi_port.c
+++ b/drivers/hsi/controllers/omap_ssi_port.c
@@ -1013,11 +1013,12 @@ static int __init ssi_port_irq(struct hsi_port *port,
 	struct omap_ssi_port *omap_port = hsi_port_drvdata(port);
 	int err;
 
-	omap_port->irq = platform_get_irq(pd, 0);
-	if (omap_port->irq < 0) {
+	err = platform_get_irq(pd, 0);
+	if (err < 0) {
 		dev_err(&port->device, "Port IRQ resource missing\n");
-		return omap_port->irq;
+		return err;
 	}
+	omap_port->irq = err;
 	tasklet_init(&omap_port->pio_tasklet, ssi_pio_tasklet,
 							(unsigned long)port);
 	err = devm_request_irq(&port->device, omap_port->irq, ssi_pio_isr,
-- 
1.8.5.5

