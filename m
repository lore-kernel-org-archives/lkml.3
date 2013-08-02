Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865Ab3HBOuw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 10:50:52 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:56152 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766Ab3HBOus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 10:50:48 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-sh@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        Simon Horman <horms@verge.net.au>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
Subject: [PATCH v5 3/7] DMA: shdma: add a header with common for ARM SoCs defines
Date: Fri,  2 Aug 2013 16:50:38 +0200
Message-Id: <1375455042-24093-4-git-send-email-g.liakhovetski@gmx.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1375455042-24093-1-git-send-email-g.liakhovetski@gmx.de>
References: <1375455042-24093-1-git-send-email-g.liakhovetski@gmx.de>
X-Provags-ID: V02:K0:kfhmUMW9tO+abHzmK/nNYN8F2rIRAIkr8cmk2TxOlyT
 kBgKNA/5u4WoIeoVPzuajflfS06gamxFb30vmwbsfREYtvLs1H
 yRgWSTzn4LKoCwqVLhb0+cYCjQDul35bn+tD8g0RZBs5+/Apax
 U3vmow4/tmUzhSRDBOLAtMmzO56OaJNgsB4i9dOvgWDYO0S7fj
 WlThLOl2OZTRSq7M8L/D2TqHqlayxOwoWtpury9KSRyblsvs2i
 MHG4dM4MNi9ToLgGqTmnRZo6b2NWaowwq7SRVZXGJsNGmw2uCw
 wV+RqauQ/DHxKt6YZBRlpqjIHFL3zpSZe83qGXhbeScCBhbC7c
 6LBtDJkK7eOog6trylQbd9nk/0spQ5kjZ4Oymx7quh14SwwHMC
 j50UzuBrdT3Bg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All shdma DMACs on ARM SoCs share certain register layout patterns, which
are currently defined in arch/arm/mach-shmobile/include/mach/dma-register.h.
That header is included by SoC-specific setup-*.c files to be used in DMAC
platform data. That header, however, cannot be directly used by the driver.
This patch copies those defines into a driver-local header to be used by
Device Tree configurations.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
---
 drivers/dma/sh/shdma-arm.h |   51 ++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 51 insertions(+), 0 deletions(-)
 create mode 100644 drivers/dma/sh/shdma-arm.h

diff --git a/drivers/dma/sh/shdma-arm.h b/drivers/dma/sh/shdma-arm.h
new file mode 100644
index 0000000..a2b8258
--- /dev/null
+++ b/drivers/dma/sh/shdma-arm.h
@@ -0,0 +1,51 @@
+/*
+ * Renesas SuperH DMA Engine support
+ *
+ * Copyright (C) 2013 Renesas Electronics, Inc.
+ *
+ * This is free software; you can redistribute it and/or modify it under the
+ * terms of version 2 the GNU General Public License as published by the Free
+ * Software Foundation.
+ */
+
+#ifndef SHDMA_ARM_H
+#define SHDMA_ARM_H
+
+#include "shdma.h"
+
+/* Transmit sizes and respective CHCR register values */
+enum {
+	XMIT_SZ_8BIT		= 0,
+	XMIT_SZ_16BIT		= 1,
+	XMIT_SZ_32BIT		= 2,
+	XMIT_SZ_64BIT		= 7,
+	XMIT_SZ_128BIT		= 3,
+	XMIT_SZ_256BIT		= 4,
+	XMIT_SZ_512BIT		= 5,
+};
+
+/* log2(size / 8) - used to calculate number of transfers */
+#define SH_DMAE_TS_SHIFT {		\
+	[XMIT_SZ_8BIT]		= 0,	\
+	[XMIT_SZ_16BIT]		= 1,	\
+	[XMIT_SZ_32BIT]		= 2,	\
+	[XMIT_SZ_64BIT]		= 3,	\
+	[XMIT_SZ_128BIT]	= 4,	\
+	[XMIT_SZ_256BIT]	= 5,	\
+	[XMIT_SZ_512BIT]	= 6,	\
+}
+
+#define TS_LOW_BIT	0x3 /* --xx */
+#define TS_HI_BIT	0xc /* xx-- */
+
+#define TS_LOW_SHIFT	(3)
+#define TS_HI_SHIFT	(20 - 2)	/* 2 bits for shifted low TS */
+
+#define TS_INDEX2VAL(i) \
+	((((i) & TS_LOW_BIT) << TS_LOW_SHIFT) |\
+	 (((i) & TS_HI_BIT)  << TS_HI_SHIFT))
+
+#define CHCR_TX(xmit_sz) (DM_FIX | SM_INC | 0x800 | TS_INDEX2VAL((xmit_sz)))
+#define CHCR_RX(xmit_sz) (DM_INC | SM_FIX | 0x800 | TS_INDEX2VAL((xmit_sz)))
+
+#endif
-- 
1.7.2.5

