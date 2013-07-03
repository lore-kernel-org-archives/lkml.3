Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933001Ab3GCOEr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 10:04:47 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:55403 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932804Ab3GCOEk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 10:04:40 -0400
From: Luciano Coelho <coelho@ti.com>
To: <linux-wireless@vger.kernel.org>, <tony@atomide.com>, <nsekhar@ti.com>
CC: <mturquette@linaro.org>, <mark.rutland@arm.com>, <balbi@ti.com>,
        <grant.likely@linaro.org>, <rob.herring@calxeda.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <coelho@ti.com>, <nm@ti.com>
Subject: [PATCH v3 6/8] wlcore: sdio: add wilink clock providers
Date: Wed, 3 Jul 2013 17:03:27 +0300
Message-ID: <1372860209-3504-7-git-send-email-coelho@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1372860209-3504-1-git-send-email-coelho@ti.com>
References: <1372860209-3504-1-git-send-email-coelho@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add refclock and tcxoclock as clock providers in WiLink.  These clocks
are not accesible outside the WiLink module, but they are registered
in the clock framework anyway.  Only the WiLink chip consumes these
clocks.

In theory, the WiLink chip could be connected to external clocks
instead of using these internal clocks, so make the clock consumer
code generic enough.  If external clocks are used, then the internal
clock device tree nodes are not necessary, but the external ones must
be specified.

Signed-off-by: Luciano Coelho <coelho@ti.com>
Reviewed-by: Felipe Balbi <balbi@ti.com>
---
 drivers/net/wireless/ti/wlcore/sdio.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/wireless/ti/wlcore/sdio.c b/drivers/net/wireless/ti/wlcore/sdio.c
index 9370d7e..980bf3d 100644
--- a/drivers/net/wireless/ti/wlcore/sdio.c
+++ b/drivers/net/wireless/ti/wlcore/sdio.c
@@ -34,6 +34,7 @@
 #include <linux/wl12xx.h>
 #include <linux/pm_runtime.h>
 #include <linux/printk.h>
+#include <linux/clk-provider.h>
 
 #include "wlcore.h"
 #include "wl12xx_80211.h"
@@ -214,10 +215,15 @@ static struct wl1271_if_operations sdio_ops = {
 	.set_block_size = wl1271_sdio_set_block_size,
 };
 
+static const struct of_device_id wlcore_sdio_of_clk_match_table[] = {
+	{ .compatible = "ti,wilink-clock" },
+};
+
 static struct wl12xx_platform_data *wlcore_get_pdata_from_of(struct device *dev)
 {
 	struct wl12xx_platform_data *pdata;
 	struct device_node *np = dev->of_node;
+	struct device_node *clock_node;
 
 	if (!np) {
 		np = of_find_matching_node(NULL, dev->driver->of_match_table);
@@ -241,6 +247,9 @@ static struct wl12xx_platform_data *wlcore_get_pdata_from_of(struct device *dev)
 		goto out_free;
 	}
 
+	for_each_matching_node(clock_node, wlcore_sdio_of_clk_match_table)
+		of_fixed_clk_setup(clock_node);
+
 	goto out;
 
 out_free:
-- 
1.7.10.4

