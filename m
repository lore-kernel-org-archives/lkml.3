Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934175AbaGOVmz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 17:42:55 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55119 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934070AbaGOVj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 17:39:29 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Brian Norris <computersforpeace@gmail.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 070/198] mtd: pxa3xx_nand: make the driver work on big-endian systems
Date: Tue, 15 Jul 2014 14:29:00 -0700
Message-Id: <1405459868-15089-71-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405459868-15089-1-git-send-email-kamal@canonical.com>
References: <1405459868-15089-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

commit b7e460624f0f3c31150f3b09e75b0d009e22ba5f upstream.

The pxa3xx_nand driver currently uses __raw_writel() and __raw_readl()
to access I/O registers. However, those functions do not do any
endianness swapping, which means that they won't work when the CPU
runs in big-endian but the I/O registers are little endian, which is
the common situation for ARM systems running big endian.

Since __raw_writel() and __raw_readl() do not include any memory
barriers and the pxa3xx_nand driver can only be compiled for ARM
platforms, the closest I/o accessors functions that do endianess
swapping are writel_relaxed() and readl_relaxed().

This patch has been verified to work on Armada XP GP: without the
patch, the NAND is not detected when the kernel runs big endian while
it is properly detected when the kernel runs little endian. With the
patch applied, the NAND is properly detected in both situations
(little and big endian).

Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Signed-off-by: Brian Norris <computersforpeace@gmail.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/mtd/nand/pxa3xx_nand.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/nand/pxa3xx_nand.c b/drivers/mtd/nand/pxa3xx_nand.c
index 4b3aaa8..0527537 100644
--- a/drivers/mtd/nand/pxa3xx_nand.c
+++ b/drivers/mtd/nand/pxa3xx_nand.c
@@ -110,10 +110,10 @@
 
 /* macros for registers read/write */
 #define nand_writel(info, off, val)	\
-	__raw_writel((val), (info)->mmio_base + (off))
+	writel_relaxed((val), (info)->mmio_base + (off))
 
 #define nand_readl(info, off)		\
-	__raw_readl((info)->mmio_base + (off))
+	readl_relaxed((info)->mmio_base + (off))
 
 /* error code and state */
 enum {
-- 
1.9.1

