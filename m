Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753732AbaDQRoJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 13:44:09 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:60323 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753173AbaDQRnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 13:43:23 -0400
From: Leif Lindholm <leif.lindholm@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: patches@linaro.org, Leif Lindholm <leif.lindholm@linaro.org>,
        linuxppc-dev@lists.ozlabs.org, Grant Likely <grant.likely@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org
Subject: [PATCH 3/3] of: Handle memory@0 node on PPC32 only
Date: Thu, 17 Apr 2014 18:42:01 +0100
Message-Id: <1397756521-29387-4-git-send-email-leif.lindholm@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1397756521-29387-1-git-send-email-leif.lindholm@linaro.org>
References: <1397756521-29387-1-git-send-email-leif.lindholm@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to deal with an firmware bug on a specific ppc32 platform
(longtrail), early_init_dt_scan_memory() looks for a node called
memory@0 on all platforms. Restrict this quirk to ppc32 kernels only.

Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
Cc: linuxppc-dev@lists.ozlabs.org
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: devicetree@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/of/fdt.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index fa16a91..7368472 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -887,14 +887,19 @@ int __init early_init_dt_scan_memory(unsigned long node, const char *uname,
 
 	/* We are scanning "memory" nodes only */
 	if (type == NULL) {
+#ifdef CONFIG_PPC32
 		/*
 		 * The longtrail doesn't have a device_type on the
 		 * /memory node, so look for the node called /memory@0.
 		 */
 		if (depth != 1 || strcmp(uname, "memory@0") != 0)
 			return 0;
-	} else if (strcmp(type, "memory") != 0)
+#else
+		return 0;
+#endif
+	} else if (strcmp(type, "memory") != 0) {
 		return 0;
+	}
 
 	reg = of_get_flat_dt_prop(node, "linux,usable-memory", &l);
 	if (reg == NULL)
-- 
1.7.10.4

