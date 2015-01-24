Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752290AbbAXU3U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 15:29:20 -0500
Received: from exprod5og108.obsmtp.com ([64.18.0.186]:54964 "EHLO
	exprod5og108.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbbAXU3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 15:29:18 -0500
From: Semen Protsenko <semen.protsenko@globallogic.com>
To: Roger Quadros <rogerq@ti.com>, Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] ARM: OMAP2+: gpmc: Fix writing in gpmc_cs_set_memconf
Date: Sat, 24 Jan 2015 22:28:38 +0200
Message-Id: <1422131320-1018-1-git-send-email-semen.protsenko@globallogic.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some GPMC_CONFIG7 register bits marked as "RESERVED", means they
shouldn't be overwritten. A typical approach to handle such bits called
"Read-Modify-Write". Writing procedure used in gpmc_cs_set_memconf()
utilizes RMW technique, but implemented incorrectly. Due to obvious typo
in code read register value is being rewritten by another value, which
leads to loss of read RESERVED bits. This patch fixes this.

While at it, replace magic numbers with named constants to improve code
readability.

Signed-off-by: Semen Protsenko <semen.protsenko@globallogic.com>
---
 drivers/memory/omap-gpmc.c |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/memory/omap-gpmc.c b/drivers/memory/omap-gpmc.c
index 24696f5..10eb4ac 100644
--- a/drivers/memory/omap-gpmc.c
+++ b/drivers/memory/omap-gpmc.c
@@ -153,6 +153,15 @@
 #define GPMC_CONFIG1_FCLK_DIV4          (GPMC_CONFIG1_FCLK_DIV(3))
 #define GPMC_CONFIG7_CSVALID		(1 << 6)
 
+#define GPMC_CONFIG7_BASEADDRESS_MASK	0x3f
+#define GPMC_CONFIG7_CSVALID_MASK	BIT(6)
+#define GPMC_CONFIG7_MASKADDRESS_OFFSET	8
+#define GPMC_CONFIG7_MASKADDRESS_MASK	(0xf << GPMC_CONFIG7_MASKADDRESS_OFFSET)
+/* All CONFIG7 bits except reserved bits */
+#define GPMC_CONFIG7_MASK		(GPMC_CONFIG7_BASEADDRESS_MASK | \
+					 GPMC_CONFIG7_CSVALID_MASK |     \
+					 GPMC_CONFIG7_MASKADDRESS_MASK)
+
 #define GPMC_DEVICETYPE_NOR		0
 #define GPMC_DEVICETYPE_NAND		2
 #define GPMC_CONFIG_WRITEPROTECT	0x00000010
@@ -586,12 +595,15 @@ static int gpmc_cs_set_memconf(int cs, u32 base, u32 size)
 	if (base & (size - 1))
 		return -EINVAL;
 
+	base >>= GPMC_CHUNK_SHIFT;
 	mask = (1 << GPMC_SECTION_SHIFT) - size;
+	mask >>= GPMC_CHUNK_SHIFT;
+	mask <<= GPMC_CONFIG7_MASKADDRESS_OFFSET;
+
 	l = gpmc_cs_read_reg(cs, GPMC_CS_CONFIG7);
-	l &= ~0x3f;
-	l = (base >> GPMC_CHUNK_SHIFT) & 0x3f;
-	l &= ~(0x0f << 8);
-	l |= ((mask >> GPMC_CHUNK_SHIFT) & 0x0f) << 8;
+	l &= ~GPMC_CONFIG7_MASK;
+	l |= base & GPMC_CONFIG7_BASEADDRESS_MASK;
+	l |= mask & GPMC_CONFIG7_MASKADDRESS_MASK;
 	l |= GPMC_CONFIG7_CSVALID;
 	gpmc_cs_write_reg(cs, GPMC_CS_CONFIG7, l);
 
-- 
1.7.9.5

