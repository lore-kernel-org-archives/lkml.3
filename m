Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933365AbaLKUGw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 15:06:52 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:23884 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758819AbaLKUF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 15:05:58 -0500
From: Sifan Naeem <sifan.naeem@imgtec.com>
To: <james.hogan@imgtec.com>, <mchehab@osg.samsung.com>
CC: <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <james.hartley@imgtec.com>, <ezequiel.garcia@imgtec.com>,
        Sifan Naeem <sifan.naeem@imgtec.com>
Subject: [PATCH v2 4/5] rc: img-ir: add philips rc5 decoder module
Date: Thu, 11 Dec 2014 20:06:25 +0000
Message-ID: <1418328386-9802-5-git-send-email-sifan.naeem@imgtec.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1418328386-9802-1-git-send-email-sifan.naeem@imgtec.com>
References: <1418328386-9802-1-git-send-email-sifan.naeem@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.167.63]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add img-ir module for decoding Philips rc5 protocol.

Changes from v1:
 * Phillips renamed to Philips

Signed-off-by: Sifan Naeem <sifan.naeem@imgtec.com>
---
 drivers/media/rc/img-ir/Kconfig      |    7 +++
 drivers/media/rc/img-ir/Makefile     |    1 +
 drivers/media/rc/img-ir/img-ir-hw.c  |    3 ++
 drivers/media/rc/img-ir/img-ir-hw.h  |    1 +
 drivers/media/rc/img-ir/img-ir-rc5.c |   88 ++++++++++++++++++++++++++++++++++
 5 files changed, 100 insertions(+)
 create mode 100644 drivers/media/rc/img-ir/img-ir-rc5.c

diff --git a/drivers/media/rc/img-ir/Kconfig b/drivers/media/rc/img-ir/Kconfig
index 580715c..b20b3e9 100644
--- a/drivers/media/rc/img-ir/Kconfig
+++ b/drivers/media/rc/img-ir/Kconfig
@@ -60,3 +60,10 @@ config IR_IMG_SANYO
 	help
 	   Say Y here to enable support for the Sanyo protocol (used by Sanyo,
 	   Aiwa, Chinon remotes) in the ImgTec infrared decoder block.
+
+config IR_IMG_RC5
+	bool "Philips RC5 protocol support"
+	depends on IR_IMG_HW
+	help
+	   Say Y here to enable support for the RC5 protocol in the ImgTec
+	   infrared decoder block.
diff --git a/drivers/media/rc/img-ir/Makefile b/drivers/media/rc/img-ir/Makefile
index 92a459d..898b1b8 100644
--- a/drivers/media/rc/img-ir/Makefile
+++ b/drivers/media/rc/img-ir/Makefile
@@ -6,6 +6,7 @@ img-ir-$(CONFIG_IR_IMG_JVC)	+= img-ir-jvc.o
 img-ir-$(CONFIG_IR_IMG_SONY)	+= img-ir-sony.o
 img-ir-$(CONFIG_IR_IMG_SHARP)	+= img-ir-sharp.o
 img-ir-$(CONFIG_IR_IMG_SANYO)	+= img-ir-sanyo.o
+img-ir-$(CONFIG_IR_IMG_RC5)	+= img-ir-rc5.o
 img-ir-objs			:= $(img-ir-y)
 
 obj-$(CONFIG_IR_IMG)		+= img-ir.o
diff --git a/drivers/media/rc/img-ir/img-ir-hw.c b/drivers/media/rc/img-ir/img-ir-hw.c
index 5c32f05..13f0b1e 100644
--- a/drivers/media/rc/img-ir/img-ir-hw.c
+++ b/drivers/media/rc/img-ir/img-ir-hw.c
@@ -42,6 +42,9 @@ static struct img_ir_decoder *img_ir_decoders[] = {
 #ifdef CONFIG_IR_IMG_SANYO
 	&img_ir_sanyo,
 #endif
+#ifdef CONFIG_IR_IMG_RC5
+	&img_ir_rc5,
+#endif
 	NULL
 };
 
diff --git a/drivers/media/rc/img-ir/img-ir-hw.h b/drivers/media/rc/img-ir/img-ir-hw.h
index b31ffc9..b9e799d5 100644
--- a/drivers/media/rc/img-ir/img-ir-hw.h
+++ b/drivers/media/rc/img-ir/img-ir-hw.h
@@ -187,6 +187,7 @@ extern struct img_ir_decoder img_ir_jvc;
 extern struct img_ir_decoder img_ir_sony;
 extern struct img_ir_decoder img_ir_sharp;
 extern struct img_ir_decoder img_ir_sanyo;
+extern struct img_ir_decoder img_ir_rc5;
 
 /**
  * struct img_ir_reg_timings - Reg values for decoder timings at clock rate.
diff --git a/drivers/media/rc/img-ir/img-ir-rc5.c b/drivers/media/rc/img-ir/img-ir-rc5.c
new file mode 100644
index 0000000..a8a28a3
--- /dev/null
+++ b/drivers/media/rc/img-ir/img-ir-rc5.c
@@ -0,0 +1,88 @@
+/*
+ * ImgTec IR Decoder setup for Philips RC-5 protocol.
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
+/* Convert RC5 data to a scancode */
+static int img_ir_rc5_scancode(int len, u64 raw, u64 enabled_protocols,
+				struct img_ir_scancode_req *request)
+{
+	unsigned int addr, cmd, tgl, start;
+
+	/* Quirk in the decoder shifts everything by 2 to the left. */
+	raw   >>= 2;
+
+	start	=  (raw >> 13)	& 0x01;
+	tgl	=  (raw >> 11)	& 0x01;
+	addr	=  (raw >>  6)	& 0x1f;
+	cmd	=   raw		& 0x3f;
+	/*
+	 * 12th bit is used to extend the command in extended RC5 and has
+	 * no effect on standard RC5.
+	 */
+	cmd	+= ((raw >> 12) & 0x01) ? 0 : 0x40;
+
+	if (!start)
+		return -EINVAL;
+
+	request->protocol = RC_TYPE_RC5;
+	request->scancode = addr << 8 | cmd;
+	request->toggle   = tgl;
+	return IMG_IR_SCANCODE;
+}
+
+/* Convert RC5 scancode to RC5 data filter */
+static int img_ir_rc5_filter(const struct rc_scancode_filter *in,
+				 struct img_ir_filter *out, u64 protocols)
+{
+	/* Not supported by the hw. */
+	return -EINVAL;
+}
+
+/*
+ * RC-5 decoder
+ * see http://www.sbprojects.com/knowledge/ir/rc5.php
+ */
+struct img_ir_decoder img_ir_rc5 = {
+	.type      = RC_BIT_RC5,
+	.control   = {
+		.bitoriend2	= 1,
+		.code_type	= IMG_IR_CODETYPE_BIPHASE,
+		.decodend2	= 1,
+	},
+	/* main timings */
+	.tolerance	= 16,
+	.unit		= 888888, /* 1/36k*32=888.888microseconds */
+	.timings	= {
+		/* 10 symbol */
+		.s10 = {
+			.pulse	= { 1 },
+			.space	= { 1 },
+		},
+
+		/* 11 symbol */
+		.s11 = {
+			.pulse	= { 1 },
+			.space	= { 1 },
+		},
+
+		/* free time */
+		.ft  = {
+			.minlen = 14,
+			.maxlen = 14,
+			.ft_min = 5,
+		},
+	},
+
+	/* scancode logic */
+	.scancode	= img_ir_rc5_scancode,
+	.filter		= img_ir_rc5_filter,
+};
-- 
1.7.9.5

