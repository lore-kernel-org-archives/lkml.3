Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545Ab3LSL4v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 06:56:51 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44692 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754504Ab3LSL4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:56:45 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 059/208] ARM: OMAPFB: panel-sony-acx565akm: fix bad unlock balance
Date: Thu, 19 Dec 2013 11:52:37 +0000
Message-Id: <1387454106-19326-60-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
References: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaro Koskinen <aaro.koskinen@iki.fi>

commit c37dd677988ca50bc8bc60ab5ab053720583c168 upstream.

When booting Nokia N900 smartphone with v3.12 + omap2plus_defconfig
(LOCKDEP enabled) and CONFIG_DISPLAY_PANEL_SONY_ACX565AKM enabled,
the following BUG is seen during the boot:

[    7.302154] =====================================
[    7.307128] [ BUG: bad unlock balance detected! ]
[    7.312103] 3.12.0-los.git-2093492-00120-g5e01dc7 #3 Not tainted
[    7.318450] -------------------------------------
[    7.323425] kworker/u2:1/12 is trying to release lock (&ddata->mutex) at:
[    7.330657] [<c031b760>] acx565akm_enable+0x12c/0x18c
[    7.335998] but there are no more locks to release!

Fix by removing double unlock and handling the locking completely inside
acx565akm_panel_power_on() when doing the power on.

Reported-by: Eduardo Valentin <eduardo.valentin@ti.com>
Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/video/omap2/displays-new/panel-sony-acx565akm.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/video/omap2/displays-new/panel-sony-acx565akm.c b/drivers/video/omap2/displays-new/panel-sony-acx565akm.c
index e6d56f7..d94f35d 100644
--- a/drivers/video/omap2/displays-new/panel-sony-acx565akm.c
+++ b/drivers/video/omap2/displays-new/panel-sony-acx565akm.c
@@ -526,6 +526,8 @@ static int acx565akm_panel_power_on(struct omap_dss_device *dssdev)
 	struct omap_dss_device *in = ddata->in;
 	int r;
 
+	mutex_lock(&ddata->mutex);
+
 	dev_dbg(&ddata->spi->dev, "%s\n", __func__);
 
 	in->ops.sdi->set_timings(in, &ddata->videomode);
@@ -614,10 +616,7 @@ static int acx565akm_enable(struct omap_dss_device *dssdev)
 	if (omapdss_device_is_enabled(dssdev))
 		return 0;
 
-	mutex_lock(&ddata->mutex);
 	r = acx565akm_panel_power_on(dssdev);
-	mutex_unlock(&ddata->mutex);
-
 	if (r)
 		return r;
 
-- 
1.8.3.2

