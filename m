Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751898AbaDRCbN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 22:31:13 -0400
Received: from mail-ig0-f176.google.com ([209.85.213.176]:64437 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203AbaDRCaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 22:30:21 -0400
From: Alex Elder <elder@linaro.org>
To: bcm@fixthebug.org, mporter@linaro.org
Cc: bcm-kernel-feedback-list@broadcom.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 02/10] ARM: bcm: err, don't BUG() on SMC init failures
Date: Thu, 17 Apr 2014 21:30:07 -0500
Message-Id: <1397788215-20279-3-git-send-email-elder@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1397788215-20279-1-git-send-email-elder@linaro.org>
References: <1397788215-20279-1-git-send-email-elder@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several conditions in bcm_kona_smc_init() are handled with BUG_ON().
That function is capable of returning an error, so do that instead.

Also, don't assume of_get_address() returns a valid pointer.

Signed-off-by: Alex Elder <elder@linaro.org>
Reviewed-by: Tim Kryger <tim.kryger@linaro.org>
Reviewed-by: Markus Mayer <markus.mayer@linaro.org>
Reviewed-by: Matt Porter <mporter@linaro.org>
---
 arch/arm/mach-bcm/bcm_kona_smc.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-bcm/bcm_kona_smc.c b/arch/arm/mach-bcm/bcm_kona_smc.c
index d881c72..ddc2f17 100644
--- a/arch/arm/mach-bcm/bcm_kona_smc.c
+++ b/arch/arm/mach-bcm/bcm_kona_smc.c
@@ -45,6 +45,7 @@ static const struct of_device_id bcm_kona_smc_ids[] __initconst = {
 int __init bcm_kona_smc_init(void)
 {
 	struct device_node *node;
+	const __be32 *prop_val;
 
 	/* Read buffer addr and size from the device tree node */
 	node = of_find_matching_node(NULL, bcm_kona_smc_ids);
@@ -52,12 +53,17 @@ int __init bcm_kona_smc_init(void)
 		return -ENODEV;
 
 	/* Don't care about size or flags of the DT node */
-	bridge_data.buffer_addr =
-		be32_to_cpu(*of_get_address(node, 0, NULL, NULL));
-	BUG_ON(!bridge_data.buffer_addr);
+	prop_val = of_get_address(node, 0, NULL, NULL);
+	if (!prop_val)
+		return -EINVAL;
+
+	bridge_data.buffer_addr = be32_to_cpu(*prop_val);
+	if (!bridge_data.buffer_addr)
+		return -EINVAL;
 
 	bridge_data.bounce = of_iomap(node, 0);
-	BUG_ON(!bridge_data.bounce);
+	if (!bridge_data.bounce)
+		return -ENOMEM;
 
 	bridge_data.initialized = 1;
 
-- 
1.7.9.5

