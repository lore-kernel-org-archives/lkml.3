Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131Ab3EIOXH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 10:23:07 -0400
Received: from mxout1.idt.com ([157.165.5.25]:44642 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752821Ab3EIOXF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 10:23:05 -0400
From: Alexandre Bounine <alexandre.bounine@idt.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Cc: Alexandre Bounine <alexandre.bounine@idt.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Li Yang <leoli@freescale.com>, Kumar Gala <galak@kernel.crashing.org>
Subject: [PATCH] rapidio/switches: remove tsi500 driver
Date: Thu,  9 May 2013 10:20:47 -0400
Message-Id: <1368109247-16914-1-git-send-email-alexandre.bounine@idt.com>
X-Mailer: git-send-email 1.7.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the driver for Tsi500 Parallel RapidIO switch because this device is
not available for several years. Since the first introduction of Tsi500,
the parallel RapidIO interface was replaced by the serial RapidIO (sRIO)
and therefore there is no value in keeping this driver.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
---
 drivers/rapidio/switches/Kconfig  |    7 ---
 drivers/rapidio/switches/Makefile |    1 -
 drivers/rapidio/switches/tsi500.c |   78 -------------------------------------
 3 files changed, 0 insertions(+), 86 deletions(-)
 delete mode 100644 drivers/rapidio/switches/tsi500.c

diff --git a/drivers/rapidio/switches/Kconfig b/drivers/rapidio/switches/Kconfig
index f47fee5..62d4a06 100644
--- a/drivers/rapidio/switches/Kconfig
+++ b/drivers/rapidio/switches/Kconfig
@@ -26,10 +26,3 @@ config RAPIDIO_CPS_GEN2
 	default n
 	---help---
 	  Includes support for ITD CPS Gen.2 serial RapidIO switches.
-
-config RAPIDIO_TSI500
-	bool "Tsi500 Parallel RapidIO switch support"
-	depends on RAPIDIO
-	default n
-	---help---
-	  Includes support for IDT Tsi500 parallel RapidIO switch.
diff --git a/drivers/rapidio/switches/Makefile b/drivers/rapidio/switches/Makefile
index c4d3acc..051cc6b 100644
--- a/drivers/rapidio/switches/Makefile
+++ b/drivers/rapidio/switches/Makefile
@@ -5,5 +5,4 @@
 obj-$(CONFIG_RAPIDIO_TSI57X)	+= tsi57x.o
 obj-$(CONFIG_RAPIDIO_CPS_XX)	+= idtcps.o
 obj-$(CONFIG_RAPIDIO_TSI568)	+= tsi568.o
-obj-$(CONFIG_RAPIDIO_TSI500)	+= tsi500.o
 obj-$(CONFIG_RAPIDIO_CPS_GEN2)	+= idt_gen2.o
diff --git a/drivers/rapidio/switches/tsi500.c b/drivers/rapidio/switches/tsi500.c
deleted file mode 100644
index 914eddd..0000000
--- a/drivers/rapidio/switches/tsi500.c
+++ /dev/null
@@ -1,78 +0,0 @@
-/*
- * RapidIO Tsi500 switch support
- *
- * Copyright 2009-2010 Integrated Device Technology, Inc.
- * Alexandre Bounine <alexandre.bounine@idt.com>
- *  - Modified switch operations initialization.
- *
- * Copyright 2005 MontaVista Software, Inc.
- * Matt Porter <mporter@kernel.crashing.org>
- *
- * This program is free software; you can redistribute  it and/or modify it
- * under  the terms of  the GNU General  Public License as published by the
- * Free Software Foundation;  either version 2 of the  License, or (at your
- * option) any later version.
- */
-
-#include <linux/rio.h>
-#include <linux/rio_drv.h>
-#include <linux/rio_ids.h>
-#include "../rio.h"
-
-static int
-tsi500_route_add_entry(struct rio_mport *mport, u16 destid, u8 hopcount, u16 table, u16 route_destid, u8 route_port)
-{
-	int i;
-	u32 offset = 0x10000 + 0xa00 + ((route_destid / 2)&~0x3);
-	u32 result;
-
-	if (table == 0xff) {
-		rio_mport_read_config_32(mport, destid, hopcount, offset, &result);
-		result &= ~(0xf << (4*(route_destid & 0x7)));
-		for (i=0;i<4;i++)
-			rio_mport_write_config_32(mport, destid, hopcount, offset + (0x20000*i), result | (route_port << (4*(route_destid & 0x7))));
-	}
-	else {
-		rio_mport_read_config_32(mport, destid, hopcount, offset + (0x20000*table), &result);
-		result &= ~(0xf << (4*(route_destid & 0x7)));
-		rio_mport_write_config_32(mport, destid, hopcount, offset + (0x20000*table), result | (route_port << (4*(route_destid & 0x7))));
-	}
-
-	return 0;
-}
-
-static int
-tsi500_route_get_entry(struct rio_mport *mport, u16 destid, u8 hopcount, u16 table, u16 route_destid, u8 *route_port)
-{
-	int ret = 0;
-	u32 offset = 0x10000 + 0xa00 + ((route_destid / 2)&~0x3);
-	u32 result;
-
-	if (table == 0xff)
-		rio_mport_read_config_32(mport, destid, hopcount, offset, &result);
-	else
-		rio_mport_read_config_32(mport, destid, hopcount, offset + (0x20000*table), &result);
-
-	result &= 0xf << (4*(route_destid & 0x7));
-	*route_port = result >> (4*(route_destid & 0x7));
-	if (*route_port > 3)
-		ret = -1;
-
-	return ret;
-}
-
-static int tsi500_switch_init(struct rio_dev *rdev, int do_enum)
-{
-	pr_debug("RIO: %s for %s\n", __func__, rio_name(rdev));
-	rdev->rswitch->add_entry = tsi500_route_add_entry;
-	rdev->rswitch->get_entry = tsi500_route_get_entry;
-	rdev->rswitch->clr_table = NULL;
-	rdev->rswitch->set_domain = NULL;
-	rdev->rswitch->get_domain = NULL;
-	rdev->rswitch->em_init = NULL;
-	rdev->rswitch->em_handle = NULL;
-
-	return 0;
-}
-
-DECLARE_RIO_SWITCH_INIT(RIO_VID_TUNDRA, RIO_DID_TSI500, tsi500_switch_init);
-- 
1.7.8.4

