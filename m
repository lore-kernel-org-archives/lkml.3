Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752027Ab3A2QMc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 11:12:32 -0500
Received: from us01smtp3.synopsys.com ([198.182.44.81]:49130 "EHLO
	hermes.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809Ab3A2QM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 11:12:29 -0500
X-Greylist: delayed 493 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Jan 2013 11:12:29 EST
From: Alexey Brodkin <Alexey.Brodkin@synopsys.com>
To: <linux-kernel@vger.kernel.org>
CC: <grant.likely@secretlab.ca>, <arnd.bergmann@linaro.org>,
        <Vineet.Gupta1@synopsys.com>,
        Alexey Brodkin <Alexey.Brodkin@synopsys.com>
Subject: [PATCH] drivers/block/xsysace - replace in(out)_8/in(out)_be16/in(out)_le16 with generic iowrite(read)8/16(be)
Date: Tue, 29 Jan 2013 20:02:59 +0400
Message-ID: <1359475380-31512-1-git-send-email-abrodkin@synopsys.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.121.8.82]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

in(out)_8/in(out)_be16/in(out)_le16 are very powerpc/microblaze
specific. To enable use of Xilinx System ACE driver build for other
architectures (for example it's possible to use it on Xilinx ml-509
board with ARC700 in FPGA) we need to use generic implementation of
accessors.

Current implementation was successfully built with Sourcery G++ Lite
2011.03-39 for Power EABI (ppc44x_defconfig).

Signed-off-by: Alexey Brodkin <abrodkin@synopsys.com>
---
 drivers/block/xsysace.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/block/xsysace.c b/drivers/block/xsysace.c
index 1f38643..64fd3c0 100644
--- a/drivers/block/xsysace.c
+++ b/drivers/block/xsysace.c
@@ -232,14 +232,14 @@ struct ace_reg_ops {
 static u16 ace_in_8(struct ace_device *ace, int reg)
 {
 	void __iomem *r = ace->baseaddr + reg;
-	return in_8(r) | (in_8(r + 1) << 8);
+	return ioread8(r) | (ioread8(r + 1) << 8);
 }
 
 static void ace_out_8(struct ace_device *ace, int reg, u16 val)
 {
 	void __iomem *r = ace->baseaddr + reg;
-	out_8(r, val);
-	out_8(r + 1, val >> 8);
+	iowrite8(val, r);
+	iowrite8(val >> 8, r + 1);
 }
 
 static void ace_datain_8(struct ace_device *ace)
@@ -248,7 +248,7 @@ static void ace_datain_8(struct ace_device *ace)
 	u8 *dst = ace->data_ptr;
 	int i = ACE_FIFO_SIZE;
 	while (i--)
-		*dst++ = in_8(r++);
+		*dst++ = ioread8(r++);
 	ace->data_ptr = dst;
 }
 
@@ -258,7 +258,7 @@ static void ace_dataout_8(struct ace_device *ace)
 	u8 *src = ace->data_ptr;
 	int i = ACE_FIFO_SIZE;
 	while (i--)
-		out_8(r++, *src++);
+		iowrite8(*src++, r++);
 	ace->data_ptr = src;
 }
 
@@ -272,12 +272,12 @@ static struct ace_reg_ops ace_reg_8_ops = {
 /* 16 bit big endian bus attachment */
 static u16 ace_in_be16(struct ace_device *ace, int reg)
 {
-	return in_be16(ace->baseaddr + reg);
+	return ioread16be(ace->baseaddr + reg);
 }
 
 static void ace_out_be16(struct ace_device *ace, int reg, u16 val)
 {
-	out_be16(ace->baseaddr + reg, val);
+	iowrite16be(val, ace->baseaddr + reg);
 }
 
 static void ace_datain_be16(struct ace_device *ace)
@@ -285,7 +285,7 @@ static void ace_datain_be16(struct ace_device *ace)
 	int i = ACE_FIFO_SIZE / 2;
 	u16 *dst = ace->data_ptr;
 	while (i--)
-		*dst++ = in_le16(ace->baseaddr + 0x40);
+		*dst++ = ioread16(ace->baseaddr + 0x40);
 	ace->data_ptr = dst;
 }
 
@@ -294,19 +294,19 @@ static void ace_dataout_be16(struct ace_device *ace)
 	int i = ACE_FIFO_SIZE / 2;
 	u16 *src = ace->data_ptr;
 	while (i--)
-		out_le16(ace->baseaddr + 0x40, *src++);
+		iowrite16(*src++, ace->baseaddr + 0x40);
 	ace->data_ptr = src;
 }
 
 /* 16 bit little endian bus attachment */
 static u16 ace_in_le16(struct ace_device *ace, int reg)
 {
-	return in_le16(ace->baseaddr + reg);
+	return ioread16(ace->baseaddr + reg);
 }
 
 static void ace_out_le16(struct ace_device *ace, int reg, u16 val)
 {
-	out_le16(ace->baseaddr + reg, val);
+	iowrite16(val, ace->baseaddr + reg);
 }
 
 static void ace_datain_le16(struct ace_device *ace)
@@ -314,7 +314,7 @@ static void ace_datain_le16(struct ace_device *ace)
 	int i = ACE_FIFO_SIZE / 2;
 	u16 *dst = ace->data_ptr;
 	while (i--)
-		*dst++ = in_be16(ace->baseaddr + 0x40);
+		*dst++ = ioread16be(ace->baseaddr + 0x40);
 	ace->data_ptr = dst;
 }
 
@@ -323,7 +323,7 @@ static void ace_dataout_le16(struct ace_device *ace)
 	int i = ACE_FIFO_SIZE / 2;
 	u16 *src = ace->data_ptr;
 	while (i--)
-		out_be16(ace->baseaddr + 0x40, *src++);
+		iowrite16be(*src++, ace->baseaddr + 0x40);
 	ace->data_ptr = src;
 }
 
-- 
1.7.10.4

