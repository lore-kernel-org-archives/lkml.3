Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736AbaEHO6v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 10:58:51 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:52350 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754159AbaEHO5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 10:57:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Jingoo Han <jg1.han@samsung.com>, linux-mtd@lists.infradead.org
Subject: [PATCH 2/2] mtd: orion-nand: fix build error with ARMv4
Date: Thu,  8 May 2014 16:56:15 +0200
Message-Id: <1399560990-1402858-4-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1399560990-1402858-1-git-send-email-arnd@arndb.de>
References: <1399560433-1402630-1-git-send-email-arnd@arndb.de>
 <1399560990-1402858-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:SKdOhcRT1QwVjJnZH5ehAXrdV3GzZcDUuiiu6MtuHTa
 NLQGS+0jVcjWJvh1Xp0xuJ7dVgewnGyuWq4XdCALyQlU1xF9BL
 swDT1FW59wNUBd+5EIMe0u/DFbmYfMnLc1Dwoim2e9qSxtgT5/
 l/5JYi6yXFx7hHZyFlDh0dy7kjp0iHPWvAXKF8i3SSXM45T71c
 9b2R0dyP2HnB53iTFpS43PqA/Gem8bJsK9N2UrWmQ11woFtew8
 A2kEzrqU6ukFiCbF8lnVm6OLCJYeYt6PvxfYFqy7WgDERIBBRp
 6mFeAwCjhqyGhlh2Yt0jwwpO/u2ve9uvLcd8BFlY0t9Pxcf8/o
 TUntqecX92asbx1y2C0lXgwMDRpdJbKJdJfl7PNr9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

orion_nand_read_buf uses an inline assembly with the "ldrd"
instruction, which is only available from ARMv5 upwards. This
used to be fine, since all users have an ARMv5 or ARMv7 CPU,
but now we can also build a multiplatform kernel with ARMv4
support enabled in addition to the "kirkwood" (mvebu) platform.

This provides an alternative to call the readsl() function that
is supposed to have the same effect and is also optimized for
performance.

This patch is untested, and it would be worthwhile to check
if there is any performance impact, especially in case the readsl
version is actually faster.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Brian Norris <computersforpeace@gmail.com>
Cc: Jingoo Han <jg1.han@samsung.com>
Cc: linux-mtd@lists.infradead.org
---
 drivers/mtd/nand/orion_nand.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/mtd/nand/orion_nand.c b/drivers/mtd/nand/orion_nand.c
index dd7fe81..c7b5e8a 100644
--- a/drivers/mtd/nand/orion_nand.c
+++ b/drivers/mtd/nand/orion_nand.c
@@ -56,6 +56,7 @@ static void orion_nand_read_buf(struct mtd_info *mtd, uint8_t *buf, int len)
 		*buf++ = readb(io_base);
 		len--;
 	}
+#if __LINUX_ARM_ARCH__ >= 5
 	buf64 = (uint64_t *)buf;
 	while (i < len/8) {
 		/*
@@ -68,6 +69,10 @@ static void orion_nand_read_buf(struct mtd_info *mtd, uint8_t *buf, int len)
 		asm volatile ("ldrd\t%0, [%1]" : "=&r" (x) : "r" (io_base));
 		buf64[i++] = x;
 	}
+#else
+	readsl(io_base, buf, len/8);
+	i = len / 8 * 8;
+#endif
 	i *= 8;
 	while (i < len)
 		buf[i++] = readb(io_base);
-- 
1.8.3.2

