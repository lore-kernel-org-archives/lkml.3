Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194Ab3CKFGc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 01:06:32 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:45356 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752006Ab3CKFG0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 01:06:26 -0400
From: Lokesh Vutla <lokeshvutla@ti.com>
To: <linux-kernel@vger.kernel.org>, <santosh.shilimkar@ti.com>,
        <gregkh@linuxfoundation.org>
CC: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Lokesh Vutla <lokeshvutla@ti.com>
Subject: [PATCH 8/8] memory: emif: Load the correct custom config values from dt
Date: Mon, 11 Mar 2013 10:36:05 +0530
Message-ID: <1362978365-5593-9-git-send-email-lokeshvutla@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1362978365-5593-1-git-send-email-lokeshvutla@ti.com>
References: <1362978365-5593-1-git-send-email-lokeshvutla@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

of_get_property returns value in Big Endian format.
Before using this value it should be converted to little endian
using be32_to_cpup().
Custom configs of emif are read from dt using of_get_property,
but these are not converted to litte endian format.
Correcting the same here.

Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>
---
 drivers/memory/emif.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/memory/emif.c b/drivers/memory/emif.c
index 119503a..4866f1b 100644
--- a/drivers/memory/emif.c
+++ b/drivers/memory/emif.c
@@ -1258,7 +1258,7 @@ static void __init_or_module of_get_custom_configs(struct device_node *np_emif,
 {
 	struct emif_custom_configs	*cust_cfgs = NULL;
 	int				len;
-	const int			*lpmode, *poll_intvl;
+	const __be32			*lpmode, *poll_intvl;
 
 	lpmode = of_get_property(np_emif, "low-power-mode", &len);
 	poll_intvl = of_get_property(np_emif, "temp-alert-poll-interval", &len);
@@ -1272,7 +1272,7 @@ static void __init_or_module of_get_custom_configs(struct device_node *np_emif,
 
 	if (lpmode) {
 		cust_cfgs->mask |= EMIF_CUSTOM_CONFIG_LPMODE;
-		cust_cfgs->lpmode = *lpmode;
+		cust_cfgs->lpmode = be32_to_cpup(lpmode);
 		of_property_read_u32(np_emif,
 				"low-power-mode-timeout-performance",
 				&cust_cfgs->lpmode_timeout_performance);
@@ -1287,7 +1287,8 @@ static void __init_or_module of_get_custom_configs(struct device_node *np_emif,
 	if (poll_intvl) {
 		cust_cfgs->mask |=
 				EMIF_CUSTOM_CONFIG_TEMP_ALERT_POLL_INTERVAL;
-		cust_cfgs->temp_alert_poll_interval_ms = *poll_intvl;
+		cust_cfgs->temp_alert_poll_interval_ms =
+						be32_to_cpup(poll_intvl);
 	}
 
 	if (of_find_property(np_emif, "extended-temp-part", &len))
-- 
1.7.9.5

