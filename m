Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933054AbaLKUGN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 15:06:13 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:38509 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758821AbaLKUF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 15:05:59 -0500
From: Sifan Naeem <sifan.naeem@imgtec.com>
To: <james.hogan@imgtec.com>, <mchehab@osg.samsung.com>
CC: <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <james.hartley@imgtec.com>, <ezequiel.garcia@imgtec.com>,
        Sifan Naeem <sifan.naeem@imgtec.com>
Subject: [PATCH v2 5/5] rc: img-ir: add philips rc6 decoder module
Date: Thu, 11 Dec 2014 20:06:26 +0000
Message-ID: <1418328386-9802-6-git-send-email-sifan.naeem@imgtec.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1418328386-9802-1-git-send-email-sifan.naeem@imgtec.com>
References: <1418328386-9802-1-git-send-email-sifan.naeem@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.167.63]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add img-ir module for decoding Philips rc6 protocol.

Changes from v1:
 * Phillips renamed to Philips

Signed-off-by: Sifan Naeem <sifan.naeem@imgtec.com>
---
 drivers/media/rc/img-ir/Kconfig      |    8 +++
 drivers/media/rc/img-ir/Makefile     |    1 +
 drivers/media/rc/img-ir/img-ir-hw.c  |    3 +
 drivers/media/rc/img-ir/img-ir-hw.h  |    1 +
 drivers/media/rc/img-ir/img-ir-rc6.c |  117 ++++++++++++++++++++++++++++++++++
 5 files changed, 130 insertions(+)
 create mode 100644 drivers/media/rc/img-ir/img-ir-rc6.c

diff --git a/drivers/media/rc/img-ir/Kconfig b/drivers/media/rc/img-ir/Kconfig
index b20b3e9..a896d3c 100644
--- a/drivers/media/rc/img-ir/Kconfig
+++ b/drivers/media/rc/img-ir/Kconfig
@@ -67,3 +67,11 @@ config IR_IMG_RC5
 	help
 	   Say Y here to enable support for the RC5 protocol in the ImgTec
 	   infrared decoder block.
+
+config IR_IMG_RC6
+	bool "Philips RC6 protocol support"
+	depends on IR_IMG_HW
+	help
+	   Say Y here to enable support for the RC6 protocol in the ImgTec
+	   infrared decoder block.
+	   Note: This version only supports mode 0.
diff --git a/drivers/media/rc/img-ir/Makefile b/drivers/media/rc/img-ir/Makefile
index 898b1b8..8e6d458 100644
--- a/drivers/media/rc/img-ir/Makefile
+++ b/drivers/media/rc/img-ir/Makefile
@@ -7,6 +7,7 @@ img-ir-$(CONFIG_IR_IMG_SONY)	+= img-ir-sony.o
 img-ir-$(CONFIG_IR_IMG_SHARP)	+= img-ir-sharp.o
 img-ir-$(CONFIG_IR_IMG_SANYO)	+= img-ir-sanyo.o
 img-ir-$(CONFIG_IR_IMG_RC5)	+= img-ir-rc5.o
+img-ir-$(CONFIG_IR_IMG_RC6)	+= img-ir-rc6.o
 img-ir-objs			:= $(img-ir-y)
 
 obj-$(CONFIG_IR_IMG)		+= img-ir.o
diff --git a/drivers/media/rc/img-ir/img-ir-hw.c b/drivers/media/rc/img-ir/img-ir-hw.c
index 13f0b1e..7bb71bc 100644
--- a/drivers/media/rc/img-ir/img-ir-hw.c
+++ b/drivers/media/rc/img-ir/img-ir-hw.c
@@ -45,6 +45,9 @@ static struct img_ir_decoder *img_ir_decoders[] = {
 #ifdef CONFIG_IR_IMG_RC5
 	&img_ir_rc5,
 #endif
+#ifdef CONFIG_IR_IMG_RC6
+	&img_ir_rc6,
+#endif
 	NULL
 };
 
diff --git a/drivers/media/rc/img-ir/img-ir-hw.h b/drivers/media/rc/img-ir/img-ir-hw.h
index b9e799d5..91a2977 100644
--- a/drivers/media/rc/img-ir/img-ir-hw.h
+++ b/drivers/media/rc/img-ir/img-ir-hw.h
@@ -188,6 +188,7 @@ extern struct img_ir_decoder img_ir_sony;
 extern struct img_ir_decoder img_ir_sharp;
 extern struct img_ir_decoder img_ir_sanyo;
 extern struct img_ir_decoder img_ir_rc5;
+extern struct img_ir_decoder img_ir_rc6;
 
 /**
  * struct img_ir_reg_timings - Reg values for decoder timings at clock rate.
diff --git a/drivers/media/rc/img-ir/img-ir-rc6.c b/drivers/media/rc/img-ir/img-ir-rc6.c
new file mode 100644
index 0000000..de1e275
--- /dev/null
+++ b/drivers/media/rc/img-ir/img-ir-rc6.c
@@ -0,0 +1,117 @@
+/*
+ * ImgTec IR Decoder setup for Philips RC-6 protocol.
+ *
+ * Copyright 2012-2014 Imagination Technologies Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2 of the License, or (at your
+ * option) any later version.
+ */
+
+#include "img-ir-hw.h"
+
+/* Convert RC6 data to a scancode */
+static int img_ir_rc6_scancode(int len, u64 raw, u64 enabled_protocols,
+				struct img_ir_scancode_req *request)
+{
+	unsigned int addr, cmd, mode, trl1, trl2;
+
+	/*
+	 * Due to a side effect of the decoder handling the double length
+	 * Trailer bit, the header information is a bit scrambled, and the
+	 * raw data is shifted incorrectly.
+	 * This workaround effectively recovers the header bits.
+	 *
+	 * The Header field should look like this:
+	 *
+	 * StartBit ModeBit2 ModeBit1 ModeBit0 TrailerBit
+	 *
+	 * But what we get is:
+	 *
+	 * ModeBit2 ModeBit1 ModeBit0 TrailerBit1 TrailerBit2
+	 *
+	 * The start bit is not important to recover the scancode.
+	 */
+
+	raw	>>= 27;
+
+	trl1	= (raw >>  17)	& 0x01;
+	trl2	= (raw >>  16)	& 0x01;
+
+	mode	= (raw >>  18)	& 0x07;
+	addr	= (raw >>   8)	& 0xff;
+	cmd	=  raw		& 0xff;
+
+	/*
+	 * Due to the above explained irregularity the trailer bits cannot
+	 * have the same value.
+	 */
+	if (trl1 == trl2)
+		return -EINVAL;
+
+	/* Only mode 0 supported for now */
+	if (mode)
+		return -EINVAL;
+
+	request->protocol = RC_TYPE_RC6_0;
+	request->scancode = addr << 8 | cmd;
+	request->toggle	  = trl2;
+	return IMG_IR_SCANCODE;
+}
+
+/* Convert RC6 scancode to RC6 data filter */
+static int img_ir_rc6_filter(const struct rc_scancode_filter *in,
+				 struct img_ir_filter *out, u64 protocols)
+{
+	/* Not supported by the hw. */
+	return -EINVAL;
+}
+
+/*
+ * RC-6 decoder
+ * see http://www.sbprojects.com/knowledge/ir/rc6.php
+ */
+struct img_ir_decoder img_ir_rc6 = {
+	.type		= RC_BIT_RC6_0,
+	.control	= {
+		.bitorien	= 1,
+		.code_type	= IMG_IR_CODETYPE_BIPHASE,
+		.decoden	= 1,
+		.decodinpol	= 1,
+	},
+	/* main timings */
+	.tolerance	= 20,
+	/*
+	 * Due to a quirk in the img-ir decoder, default header values do
+	 * not work, the values described below were extracted from
+	 * successful RTL test cases.
+	 */
+	.timings	= {
+		/* leader symbol */
+		.ldr = {
+			.pulse	= { 650 },
+			.space	= { 660 },
+		},
+		/* 0 symbol */
+		.s00 = {
+			.pulse	= { 370 },
+			.space	= { 370 },
+		},
+		/* 01 symbol */
+		.s01 = {
+			.pulse	= { 370 },
+			.space	= { 370 },
+		},
+		/* free time */
+		.ft  = {
+			.minlen = 21,
+			.maxlen = 21,
+			.ft_min = 2666,	/* 2.666 ms */
+		},
+	},
+
+	/* scancode logic */
+	.scancode	= img_ir_rc6_scancode,
+	.filter		= img_ir_rc6_filter,
+};
-- 
1.7.9.5

