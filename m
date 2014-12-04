Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619AbaLDPjQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 10:39:16 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:53758 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753681AbaLDPjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 10:39:14 -0500
From: Sifan Naeem <sifan.naeem@imgtec.com>
To: <james.hogan@imgtec.com>, <mchehab@osg.samsung.com>
CC: <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <james.hartley@imgtec.com>, <ezequiel.garcia@imgtec.com>,
        Sifan Naeem <sifan.naeem@imgtec.com>
Subject: [PATCH 1/5] rc: img-ir: add scancode requests to a struct
Date: Thu, 4 Dec 2014 15:38:38 +0000
Message-ID: <1417707523-7730-2-git-send-email-sifan.naeem@imgtec.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1417707523-7730-1-git-send-email-sifan.naeem@imgtec.com>
References: <1417707523-7730-1-git-send-email-sifan.naeem@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.167.63]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The information being requested of hardware decode callbacks through
the img-ir-hw scancode API is mounting up, so combine it into a struct
which can be passed in with a single pointer rather than multiple
pointer arguments. This allows it to be extended more easily without
touching all the hardware decode callbacks.

Signed-off-by: Sifan Naeem <sifan.naeem@imgtec.com>
---
 drivers/media/rc/img-ir/img-ir-hw.c    |   16 +++++++++-------
 drivers/media/rc/img-ir/img-ir-hw.h    |   16 ++++++++++++++--
 drivers/media/rc/img-ir/img-ir-jvc.c   |    8 ++++----
 drivers/media/rc/img-ir/img-ir-nec.c   |   24 ++++++++++++------------
 drivers/media/rc/img-ir/img-ir-sanyo.c |    8 ++++----
 drivers/media/rc/img-ir/img-ir-sharp.c |    8 ++++----
 drivers/media/rc/img-ir/img-ir-sony.c  |   12 ++++++------
 7 files changed, 53 insertions(+), 39 deletions(-)

diff --git a/drivers/media/rc/img-ir/img-ir-hw.c b/drivers/media/rc/img-ir/img-ir-hw.c
index ec49f94..61850a6 100644
--- a/drivers/media/rc/img-ir/img-ir-hw.c
+++ b/drivers/media/rc/img-ir/img-ir-hw.c
@@ -789,20 +789,22 @@ static void img_ir_handle_data(struct img_ir_priv *priv, u32 len, u64 raw)
 	struct img_ir_priv_hw *hw = &priv->hw;
 	const struct img_ir_decoder *dec = hw->decoder;
 	int ret = IMG_IR_SCANCODE;
-	u32 scancode;
-	enum rc_type protocol = RC_TYPE_UNKNOWN;
+	struct img_ir_scancode_req request;
+
+	request.protocol = RC_TYPE_UNKNOWN;
 
 	if (dec->scancode)
-		ret = dec->scancode(len, raw, &protocol, &scancode, hw->enabled_protocols);
+		ret = dec->scancode(len, raw, hw->enabled_protocols, &request);
 	else if (len >= 32)
-		scancode = (u32)raw;
+		request.scancode = (u32)raw;
 	else if (len < 32)
-		scancode = (u32)raw & ((1 << len)-1);
+		request.scancode = (u32)raw & ((1 << len)-1);
 	dev_dbg(priv->dev, "data (%u bits) = %#llx\n",
 		len, (unsigned long long)raw);
 	if (ret == IMG_IR_SCANCODE) {
-		dev_dbg(priv->dev, "decoded scan code %#x\n", scancode);
-		rc_keydown(hw->rdev, protocol, scancode, 0);
+		dev_dbg(priv->dev, "decoded scan code %#x\n",
+			request.scancode);
+		rc_keydown(hw->rdev, request.protocol, request.scancode, 0);
 		img_ir_end_repeat(priv);
 	} else if (ret == IMG_IR_REPEATCODE) {
 		if (hw->mode == IMG_IR_M_REPEATING) {
diff --git a/drivers/media/rc/img-ir/img-ir-hw.h b/drivers/media/rc/img-ir/img-ir-hw.h
index 8fcc16c..1fc9583 100644
--- a/drivers/media/rc/img-ir/img-ir-hw.h
+++ b/drivers/media/rc/img-ir/img-ir-hw.h
@@ -133,6 +133,18 @@ struct img_ir_timing_regvals {
 #define IMG_IR_REPEATCODE	1	/* repeat the previous code */
 
 /**
+ * struct img_ir_scancode_req - Scancode request data.
+ * @protocol:	Protocol code of received message (defaults to
+ *		RC_TYPE_UNKNOWN).
+ * @scancode:	Scan code of received message (must be written by
+ *		handler if IMG_IR_SCANCODE is returned).
+ */
+struct img_ir_scancode_req {
+	enum rc_type protocol;
+	u32 scancode;
+};
+
+/**
  * struct img_ir_decoder - Decoder settings for an IR protocol.
  * @type:	Protocol types bitmap.
  * @tolerance:	Timing tolerance as a percentage (default 10%).
@@ -162,8 +174,8 @@ struct img_ir_decoder {
 	struct img_ir_control		control;
 
 	/* scancode logic */
-	int (*scancode)(int len, u64 raw, enum rc_type *protocol,
-			u32 *scancode, u64 enabled_protocols);
+	int (*scancode)(int len, u64 raw, u64 enabled_protocols,
+			struct img_ir_scancode_req *request);
 	int (*filter)(const struct rc_scancode_filter *in,
 		      struct img_ir_filter *out, u64 protocols);
 };
diff --git a/drivers/media/rc/img-ir/img-ir-jvc.c b/drivers/media/rc/img-ir/img-ir-jvc.c
index a60dda8..d3e2fc0 100644
--- a/drivers/media/rc/img-ir/img-ir-jvc.c
+++ b/drivers/media/rc/img-ir/img-ir-jvc.c
@@ -12,8 +12,8 @@
 #include "img-ir-hw.h"
 
 /* Convert JVC data to a scancode */
-static int img_ir_jvc_scancode(int len, u64 raw, enum rc_type *protocol,
-			       u32 *scancode, u64 enabled_protocols)
+static int img_ir_jvc_scancode(int len, u64 raw, u64 enabled_protocols,
+			       struct img_ir_scancode_req *request)
 {
 	unsigned int cust, data;
 
@@ -23,8 +23,8 @@ static int img_ir_jvc_scancode(int len, u64 raw, enum rc_type *protocol,
 	cust = (raw >> 0) & 0xff;
 	data = (raw >> 8) & 0xff;
 
-	*protocol = RC_TYPE_JVC;
-	*scancode = cust << 8 | data;
+	request->protocol = RC_TYPE_JVC;
+	request->scancode = cust << 8 | data;
 	return IMG_IR_SCANCODE;
 }
 
diff --git a/drivers/media/rc/img-ir/img-ir-nec.c b/drivers/media/rc/img-ir/img-ir-nec.c
index 7398975..27a7ea8 100644
--- a/drivers/media/rc/img-ir/img-ir-nec.c
+++ b/drivers/media/rc/img-ir/img-ir-nec.c
@@ -13,8 +13,8 @@
 #include <linux/bitrev.h>
 
 /* Convert NEC data to a scancode */
-static int img_ir_nec_scancode(int len, u64 raw, enum rc_type *protocol,
-			       u32 *scancode, u64 enabled_protocols)
+static int img_ir_nec_scancode(int len, u64 raw, u64 enabled_protocols,
+			       struct img_ir_scancode_req *request)
 {
 	unsigned int addr, addr_inv, data, data_inv;
 	/* a repeat code has no data */
@@ -30,23 +30,23 @@ static int img_ir_nec_scancode(int len, u64 raw, enum rc_type *protocol,
 	if ((data_inv ^ data) != 0xff) {
 		/* 32-bit NEC (used by Apple and TiVo remotes) */
 		/* scan encoding: as transmitted, MSBit = first received bit */
-		*scancode = bitrev8(addr)     << 24 |
-			    bitrev8(addr_inv) << 16 |
-			    bitrev8(data)     <<  8 |
-			    bitrev8(data_inv);
+		request->scancode = bitrev8(addr)     << 24 |
+				bitrev8(addr_inv) << 16 |
+				bitrev8(data)     <<  8 |
+				bitrev8(data_inv);
 	} else if ((addr_inv ^ addr) != 0xff) {
 		/* Extended NEC */
 		/* scan encoding: AAaaDD */
-		*scancode = addr     << 16 |
-			    addr_inv <<  8 |
-			    data;
+		request->scancode = addr     << 16 |
+				addr_inv <<  8 |
+				data;
 	} else {
 		/* Normal NEC */
 		/* scan encoding: AADD */
-		*scancode = addr << 8 |
-			    data;
+		request->scancode = addr << 8 |
+				data;
 	}
-	*protocol = RC_TYPE_NEC;
+	request->protocol = RC_TYPE_NEC;
 	return IMG_IR_SCANCODE;
 }
 
diff --git a/drivers/media/rc/img-ir/img-ir-sanyo.c b/drivers/media/rc/img-ir/img-ir-sanyo.c
index 6b0653e..f394994 100644
--- a/drivers/media/rc/img-ir/img-ir-sanyo.c
+++ b/drivers/media/rc/img-ir/img-ir-sanyo.c
@@ -23,8 +23,8 @@
 #include "img-ir-hw.h"
 
 /* Convert Sanyo data to a scancode */
-static int img_ir_sanyo_scancode(int len, u64 raw, enum rc_type *protocol,
-				 u32 *scancode, u64 enabled_protocols)
+static int img_ir_sanyo_scancode(int len, u64 raw, u64 enabled_protocols,
+				 struct img_ir_scancode_req *request)
 {
 	unsigned int addr, addr_inv, data, data_inv;
 	/* a repeat code has no data */
@@ -44,8 +44,8 @@ static int img_ir_sanyo_scancode(int len, u64 raw, enum rc_type *protocol,
 		return -EINVAL;
 
 	/* Normal Sanyo */
-	*protocol = RC_TYPE_SANYO;
-	*scancode = addr << 8 | data;
+	request->protocol = RC_TYPE_SANYO;
+	request->scancode = addr << 8 | data;
 	return IMG_IR_SCANCODE;
 }
 
diff --git a/drivers/media/rc/img-ir/img-ir-sharp.c b/drivers/media/rc/img-ir/img-ir-sharp.c
index 3300a38..fe5acc4 100644
--- a/drivers/media/rc/img-ir/img-ir-sharp.c
+++ b/drivers/media/rc/img-ir/img-ir-sharp.c
@@ -12,8 +12,8 @@
 #include "img-ir-hw.h"
 
 /* Convert Sharp data to a scancode */
-static int img_ir_sharp_scancode(int len, u64 raw, enum rc_type *protocol,
-				 u32 *scancode, u64 enabled_protocols)
+static int img_ir_sharp_scancode(int len, u64 raw, u64 enabled_protocols,
+				 struct img_ir_scancode_req *request)
 {
 	unsigned int addr, cmd, exp, chk;
 
@@ -32,8 +32,8 @@ static int img_ir_sharp_scancode(int len, u64 raw, enum rc_type *protocol,
 		/* probably the second half of the message */
 		return -EINVAL;
 
-	*protocol = RC_TYPE_SHARP;
-	*scancode = addr << 8 | cmd;
+	request->protocol = RC_TYPE_SHARP;
+	request->scancode = addr << 8 | cmd;
 	return IMG_IR_SCANCODE;
 }
 
diff --git a/drivers/media/rc/img-ir/img-ir-sony.c b/drivers/media/rc/img-ir/img-ir-sony.c
index 3a0f17b..7f7375f 100644
--- a/drivers/media/rc/img-ir/img-ir-sony.c
+++ b/drivers/media/rc/img-ir/img-ir-sony.c
@@ -12,8 +12,8 @@
 #include "img-ir-hw.h"
 
 /* Convert Sony data to a scancode */
-static int img_ir_sony_scancode(int len, u64 raw, enum rc_type *protocol,
-				u32 *scancode, u64 enabled_protocols)
+static int img_ir_sony_scancode(int len, u64 raw, u64 enabled_protocols,
+				struct img_ir_scancode_req *request)
 {
 	unsigned int dev, subdev, func;
 
@@ -25,7 +25,7 @@ static int img_ir_sony_scancode(int len, u64 raw, enum rc_type *protocol,
 		raw    >>= 7;
 		dev    = raw & 0x1f;	/* next 5 bits */
 		subdev = 0;
-		*protocol = RC_TYPE_SONY12;
+		request->protocol = RC_TYPE_SONY12;
 		break;
 	case 15:
 		if (!(enabled_protocols & RC_BIT_SONY15))
@@ -34,7 +34,7 @@ static int img_ir_sony_scancode(int len, u64 raw, enum rc_type *protocol,
 		raw    >>= 7;
 		dev    = raw & 0xff;	/* next 8 bits */
 		subdev = 0;
-		*protocol = RC_TYPE_SONY15;
+		request->protocol = RC_TYPE_SONY15;
 		break;
 	case 20:
 		if (!(enabled_protocols & RC_BIT_SONY20))
@@ -44,12 +44,12 @@ static int img_ir_sony_scancode(int len, u64 raw, enum rc_type *protocol,
 		dev    = raw & 0x1f;	/* next 5 bits */
 		raw    >>= 5;
 		subdev = raw & 0xff;	/* next 8 bits */
-		*protocol = RC_TYPE_SONY20;
+		request->protocol = RC_TYPE_SONY20;
 		break;
 	default:
 		return -EINVAL;
 	}
-	*scancode = dev << 16 | subdev << 8 | func;
+	request->scancode = dev << 16 | subdev << 8 | func;
 	return IMG_IR_SCANCODE;
 }
 
-- 
1.7.9.5

