Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757278Ab3DWQiP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 12:38:15 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:56773 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756699Ab3DWQbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 12:31:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Rob Clark <robdclark@gmail.com>, Dave Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH 11/21] drm/tilcdc: use only a single module device table
Date: Tue, 23 Apr 2013 18:30:43 +0200
Message-Id: <1366734653-488286-12-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366734653-488286-1-git-send-email-arnd@arndb.de>
References: <1366734653-488286-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:1noHhA1rNQTuequcP1yYGGL2et3BgCFqr46ZEhLhx9u
 TEQMfOxv5XoThhUCwjK3sw6p9qjvdfUUx7M2mqiYxzbMiJe4t0
 oYC0VAnA2+IGGOGnCPK3CFTSNgSam+x3z/s3sVHE87eDIabRPX
 Ry6UhQUFI6FaAugZ/pm2NfNAD2Vb7aOgf7zjYom3evTXJC1qvi
 qOrGioAKaBm1tYoyU3aXFhS0PNm9viybxg/hygYOZ7letVFVJB
 OMB+r2EYaM5Bd7poFrr6EwJXSOW92zK3FH/8ZIITTuvjC7kjMr
 PwhZNDS0UsNWDiTyLifCp+Q+r85tZ5Yvw27CAlh7ElPraEL6dL
 NDd/iO62hMp1/XPyKJzQXSGjQ8z1c6kCdOnTIpwjw
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tilcdc driver fails to be built as a module because of extraneous
MODULE_DEVICE_TABLE entries:

drivers/gpu/drm/tilcdc/tilcdc_slave.o:(.data+0x54): multiple definition of `__mod_of_device_table'
drivers/gpu/drm/tilcdc/tilcdc_tfp410.o:(.data+0x54): first defined here
drivers/gpu/drm/tilcdc/tilcdc_panel.o:(.data+0x54): multiple definition of `__mod_of_device_table'
drivers/gpu/drm/tilcdc/tilcdc_tfp410.o:(.data+0x54): first defined here
drivers/gpu/drm/tilcdc/tilcdc_drv.o:(.data+0x184): multiple definition of `__mod_of_device_table'
drivers/gpu/drm/tilcdc/tilcdc_tfp410.o:(.data+0x54): first defined here

Since the entire point of these entries is to make the module autoload
when one of the devices is present, it's enough to keep the one entry
for "ti,am33xx-tilcdc", which should always be there if any of the
others are.

Cc: Rob Clark <robdclark@gmail.com>
Cc: Dave Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/gpu/drm/tilcdc/tilcdc_panel.c  | 1 -
 drivers/gpu/drm/tilcdc/tilcdc_slave.c  | 1 -
 drivers/gpu/drm/tilcdc/tilcdc_tfp410.c | 1 -
 3 files changed, 3 deletions(-)

diff --git a/drivers/gpu/drm/tilcdc/tilcdc_panel.c b/drivers/gpu/drm/tilcdc/tilcdc_panel.c
index 580b74e..eb99f42 100644
--- a/drivers/gpu/drm/tilcdc/tilcdc_panel.c
+++ b/drivers/gpu/drm/tilcdc/tilcdc_panel.c
@@ -413,7 +413,6 @@ static struct of_device_id panel_of_match[] = {
 		{ .compatible = "ti,tilcdc,panel", },
 		{ },
 };
-MODULE_DEVICE_TABLE(of, panel_of_match);
 
 struct platform_driver panel_driver = {
 	.probe = panel_probe,
diff --git a/drivers/gpu/drm/tilcdc/tilcdc_slave.c b/drivers/gpu/drm/tilcdc/tilcdc_slave.c
index 568dc1c..db1d2fc 100644
--- a/drivers/gpu/drm/tilcdc/tilcdc_slave.c
+++ b/drivers/gpu/drm/tilcdc/tilcdc_slave.c
@@ -353,7 +353,6 @@ static struct of_device_id slave_of_match[] = {
 		{ .compatible = "ti,tilcdc,slave", },
 		{ },
 };
-MODULE_DEVICE_TABLE(of, slave_of_match);
 
 struct platform_driver slave_driver = {
 	.probe = slave_probe,
diff --git a/drivers/gpu/drm/tilcdc/tilcdc_tfp410.c b/drivers/gpu/drm/tilcdc/tilcdc_tfp410.c
index 58d487b..a36788f 100644
--- a/drivers/gpu/drm/tilcdc/tilcdc_tfp410.c
+++ b/drivers/gpu/drm/tilcdc/tilcdc_tfp410.c
@@ -396,7 +396,6 @@ static struct of_device_id tfp410_of_match[] = {
 		{ .compatible = "ti,tilcdc,tfp410", },
 		{ },
 };
-MODULE_DEVICE_TABLE(of, tfp410_of_match);
 
 struct platform_driver tfp410_driver = {
 	.probe = tfp410_probe,
-- 
1.8.1.2

