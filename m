Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695AbaLDPld (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 10:41:33 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:3404 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753332AbaLDPjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 10:39:13 -0500
From: Sifan Naeem <sifan.naeem@imgtec.com>
To: <james.hogan@imgtec.com>, <mchehab@osg.samsung.com>
CC: <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <james.hartley@imgtec.com>, <ezequiel.garcia@imgtec.com>,
        Sifan Naeem <sifan.naeem@imgtec.com>
Subject: [PATCH 2/5] rc: img-ir: pass toggle bit to the rc driver
Date: Thu, 4 Dec 2014 15:38:39 +0000
Message-ID: <1417707523-7730-3-git-send-email-sifan.naeem@imgtec.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1417707523-7730-1-git-send-email-sifan.naeem@imgtec.com>
References: <1417707523-7730-1-git-send-email-sifan.naeem@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.167.63]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add toggle bit to struct img_ir_scancode_req so that protocols can
provide it to img_ir_handle_data(), and pass that toggle bit up to
rc_keydown instead of 0.

This is nedded for the upcoming rc-5 and rc-6 patches.

Signed-off-by: Sifan Naeem <sifan.naeem@imgtec.com>
---
 drivers/media/rc/img-ir/img-ir-hw.c |    8 +++++---
 drivers/media/rc/img-ir/img-ir-hw.h |    2 ++
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/media/rc/img-ir/img-ir-hw.c b/drivers/media/rc/img-ir/img-ir-hw.c
index 61850a6..4a1407b 100644
--- a/drivers/media/rc/img-ir/img-ir-hw.c
+++ b/drivers/media/rc/img-ir/img-ir-hw.c
@@ -792,6 +792,7 @@ static void img_ir_handle_data(struct img_ir_priv *priv, u32 len, u64 raw)
 	struct img_ir_scancode_req request;
 
 	request.protocol = RC_TYPE_UNKNOWN;
+	request.toggle   = 0;
 
 	if (dec->scancode)
 		ret = dec->scancode(len, raw, hw->enabled_protocols, &request);
@@ -802,9 +803,10 @@ static void img_ir_handle_data(struct img_ir_priv *priv, u32 len, u64 raw)
 	dev_dbg(priv->dev, "data (%u bits) = %#llx\n",
 		len, (unsigned long long)raw);
 	if (ret == IMG_IR_SCANCODE) {
-		dev_dbg(priv->dev, "decoded scan code %#x\n",
-			request.scancode);
-		rc_keydown(hw->rdev, request.protocol, request.scancode, 0);
+		dev_dbg(priv->dev, "decoded scan code %#x, toggle %u\n",
+			request.scancode, request.toggle);
+		rc_keydown(hw->rdev, request.protocol, request.scancode,
+			   request.toggle);
 		img_ir_end_repeat(priv);
 	} else if (ret == IMG_IR_REPEATCODE) {
 		if (hw->mode == IMG_IR_M_REPEATING) {
diff --git a/drivers/media/rc/img-ir/img-ir-hw.h b/drivers/media/rc/img-ir/img-ir-hw.h
index 1fc9583..5e59e8e 100644
--- a/drivers/media/rc/img-ir/img-ir-hw.h
+++ b/drivers/media/rc/img-ir/img-ir-hw.h
@@ -138,10 +138,12 @@ struct img_ir_timing_regvals {
  *		RC_TYPE_UNKNOWN).
  * @scancode:	Scan code of received message (must be written by
  *		handler if IMG_IR_SCANCODE is returned).
+ * @toggle:	Toggle bit (defaults to 0).
  */
 struct img_ir_scancode_req {
 	enum rc_type protocol;
 	u32 scancode;
+	u8 toggle;
 };
 
 /**
-- 
1.7.9.5

