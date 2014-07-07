Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755819AbaGHBQP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 21:16:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55237 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752672AbaGGXxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 19:53:48 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Brian Norris <computersforpeace@gmail.com>
Subject: [PATCH 3.15 024/122] mtd: pxa3xx_nand: make the driver work on big-endian systems
Date: Mon,  7 Jul 2014 16:56:26 -0700
Message-Id: <20140707235734.972984784@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140707235734.234226883@linuxfoundation.org>
References: <20140707235734.234226883@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/nand/pxa3xx_nand.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/mtd/nand/pxa3xx_nand.c
+++ b/drivers/mtd/nand/pxa3xx_nand.c
@@ -127,10 +127,10 @@
 
 /* macros for registers read/write */
 #define nand_writel(info, off, val)	\
-	__raw_writel((val), (info)->mmio_base + (off))
+	writel_relaxed((val), (info)->mmio_base + (off))
 
 #define nand_readl(info, off)		\
-	__raw_readl((info)->mmio_base + (off))
+	readl_relaxed((info)->mmio_base + (off))
 
 /* error code and state */
 enum {


