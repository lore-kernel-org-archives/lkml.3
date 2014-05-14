Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752393AbaENVKX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 17:10:23 -0400
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:63967 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751173AbaENVKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 17:10:22 -0400
Message-ID: <1400101765.9826.6.camel@x220>
Subject: [PATCH] arm: msm: remove board file for the HTC Sapphire device
From: Paul Bolle <pebolle@tiscali.nl>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Wed, 14 May 2014 23:09:25 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 May 2014 21:09:26.0150 (UTC) FILETIME=[C973AA60:01CF6FB8]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 614ad9814850 ("arm: msm: add board file for the HTC Sapphire
device") added just board-sapphire.c. It did not add board-sapphire.h,
Makefile changes or Kconfig changes.

Four years have passed and this file is still dangling. Remove it.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Also untested.

 arch/arm/mach-msm/board-sapphire.c | 117 -------------------------------------
 1 file changed, 117 deletions(-)
 delete mode 100644 arch/arm/mach-msm/board-sapphire.c

diff --git a/arch/arm/mach-msm/board-sapphire.c b/arch/arm/mach-msm/board-sapphire.c
deleted file mode 100644
index 327605174d63..000000000000
--- a/arch/arm/mach-msm/board-sapphire.c
+++ /dev/null
@@ -1,117 +0,0 @@
-/* linux/arch/arm/mach-msm/board-sapphire.c
- * Copyright (C) 2007-2009 HTC Corporation.
- * Author: Thomas Tsai <thomas_tsai@htc.com>
- *
- * This software is licensed under the terms of the GNU General Public
- * License version 2, as published by the Free Software Foundation, and
- * may be copied, distributed, and modified under those terms.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
-*/
-#include <linux/gpio.h>
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/platform_device.h>
-#include <linux/input.h>
-#include <linux/interrupt.h>
-#include <linux/irq.h>
-#include <linux/device.h>
-
-#include <linux/delay.h>
-
-#include <mach/hardware.h>
-#include <asm/mach-types.h>
-#include <asm/mach/arch.h>
-#include <asm/mach/map.h>
-#include <asm/mach/flash.h>
-#include <mach/vreg.h>
-
-#include <asm/io.h>
-#include <asm/delay.h>
-#include <asm/setup.h>
-
-#include <linux/mtd/nand.h>
-#include <linux/mtd/partitions.h>
-
-#include "gpio_chip.h"
-#include "board-sapphire.h"
-#include "proc_comm.h"
-#include "devices.h"
-#include "common.h"
-
-void msm_init_irq(void);
-void msm_init_gpio(void);
-
-static struct platform_device *devices[] __initdata = {
-	&msm_device_smd,
-	&msm_device_dmov,
-	&msm_device_nand,
-	&msm_device_uart1,
-	&msm_device_uart3,
-};
-
-void msm_timer_init(void);
-
-static void __init sapphire_init_irq(void)
-{
-	msm_init_irq();
-}
-
-static void __init sapphire_init(void)
-{
-	platform_add_devices(devices, ARRAY_SIZE(devices));
-}
-
-static struct map_desc sapphire_io_desc[] __initdata = {
-	{
-		.virtual = SAPPHIRE_CPLD_BASE,
-		.pfn     = __phys_to_pfn(SAPPHIRE_CPLD_START),
-		.length  = SAPPHIRE_CPLD_SIZE,
-		.type    = MT_DEVICE_NONSHARED
-	}
-};
-
-static void __init sapphire_fixup(struct tag *tags, char **cmdline,
-				  struct meminfo *mi)
-{
-	int smi_sz = parse_tag_smi((const struct tag *)tags);
-
-	mi->nr_banks = 1;
-	mi->bank[0].start = PHYS_OFFSET;
-	mi->bank[0].node = PHYS_TO_NID(PHYS_OFFSET);
-	if (smi_sz == 32) {
-		mi->bank[0].size = (84*1024*1024);
-	} else if (smi_sz == 64) {
-		mi->bank[0].size = (101*1024*1024);
-	} else {
-		/* Give a default value when not get smi size */
-		smi_sz = 64;
-		mi->bank[0].size = (101*1024*1024);
-	}
-}
-
-static void __init sapphire_map_io(void)
-{
-	msm_map_common_io();
-	iotable_init(sapphire_io_desc, ARRAY_SIZE(sapphire_io_desc));
-	msm_clock_init();
-}
-
-static void __init sapphire_init_late(void)
-{
-	smd_debugfs_init();
-}
-
-MACHINE_START(SAPPHIRE, "sapphire")
-/* Maintainer: Brian Swetland <swetland@google.com> */
-	.atag_offset    = 0x100,
-	.fixup          = sapphire_fixup,
-	.map_io         = sapphire_map_io,
-	.init_irq       = sapphire_init_irq,
-	.init_machine   = sapphire_init,
-	.init_late      = sapphire_init_late,
-	.init_time	= msm_timer_init,
-MACHINE_END
-- 
1.9.0



