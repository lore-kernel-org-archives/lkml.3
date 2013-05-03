Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933358Ab3ECOdu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 10:33:50 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:38054 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933201Ab3ECOdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 10:33:46 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Per Forlin <per.forlin@stericsson.com>, Rabin Vincent <rabin@rab.in>
Subject: [PATCH 12/63] dmaengine: ste_dma40: Remove home-brew MAX() macro
Date: Fri,  3 May 2013 15:31:58 +0100
Message-Id: <1367591569-32197-13-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1367591569-32197-1-git-send-email-lee.jones@linaro.org>
References: <1367591569-32197-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current implementation of the DMA40's local MAX() macro evaluates
its arguments more times than is necessary and it not type checked.
This patch strips replaces it with a new, more efficient constant.

Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <djbw@fb.com>
Cc: Per Forlin <per.forlin@stericsson.com>
Cc: Rabin Vincent <rabin@rab.in>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Reported-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/dma/ste_dma40.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 2354474..9a04559 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -53,8 +53,6 @@
 #define D40_ALLOC_PHY		(1 << 30)
 #define D40_ALLOC_LOG_FREE	0
 
-#define MAX(a, b) (((a) < (b)) ? (b) : (a))
-
 /* Reserved event lines for memcpy only. */
 static int dma40_memcpy_channels[] = { 56, 57, 58, 59, 60 };
 
@@ -202,6 +200,9 @@ static u32 d40_backup_regs_chan[] = {
 	D40_CHAN_REG_SDLNK,
 };
 
+#define BACKUP_REGS_SZ_MAX ((BACKUP_REGS_SZ_V4A > BACKUP_REGS_SZ_V4B) ? \
+			     BACKUP_REGS_SZ_V4A : BACKUP_REGS_SZ_V4B)
+
 /**
  * struct d40_interrupt_lookup - lookup table for interrupt handler
  *
@@ -565,7 +566,7 @@ struct d40_base {
 	resource_size_t			  lcpa_size;
 	struct kmem_cache		 *desc_slab;
 	u32				  reg_val_backup[BACKUP_REGS_SZ];
-	u32				  reg_val_backup_v4[MAX(BACKUP_REGS_SZ_V4A, BACKUP_REGS_SZ_V4B)];
+	u32				  reg_val_backup_v4[BACKUP_REGS_SZ_MAX];
 	u32				 *reg_val_backup_chan;
 	u16				  gcc_pwr_off_mask;
 	bool				  initialized;
-- 
1.7.10.4

