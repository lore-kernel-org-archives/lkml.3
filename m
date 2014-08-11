Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753926AbaHKSDS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 14:03:18 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:43525 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717AbaHKSDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 14:03:13 -0400
Date: Mon, 11 Aug 2014 11:03:09 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: linux-input@vger.kernel.org
Cc: Nick Dyer <nick.dyer@itdev.co.uk>, Yufeng Shen <miletus@chromium.org>,
        Benson Leung <bleung@chromium.org>,
        Stephen Warren <swarren@nvidia.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] Input: atmel_mxt_ts - fix a few issues reported by Coverity
Message-ID: <20140811180307.GA25677@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This should fix the following issues reported by Coverity:

*** CID 1230625:  Logically dead code  (DEADCODE)
/drivers/input/touchscreen/atmel_mxt_ts.c: 1692 in mxt_initialize()

*** CID 1230627:  Missing break in switch  (MISSING_BREAK)
/drivers/input/touchscreen/atmel_mxt_ts.c: 1436 in mxt_get_object_table()

*** CID 1230629:  Out-of-bounds write  (OVERRUN)
/drivers/input/touchscreen/atmel_mxt_ts.c: 1267 in mxt_update_cfg()

*** CID 1230632:  Unused pointer value  (UNUSED_VALUE)
/drivers/input/touchscreen/atmel_mxt_ts.c: 1211 in mxt_update_cfg()

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/input/touchscreen/atmel_mxt_ts.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index bbaf3ff..db178ed 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -1098,8 +1098,12 @@ static int mxt_prepare_cfg_mem(struct mxt_data *data,
 			/* Skip object */
 			for (i = 0; i < size; i++) {
 				ret = sscanf(cfg->data + data_pos, "%hhx%n",
-					     &val,
-					     &offset);
+					     &val, &offset);
+				if (ret != 1) {
+					dev_err(dev, "Bad format in T%d at %d\n",
+						type, i);
+					return -EINVAL;
+				}
 				data_pos += offset;
 			}
 			continue;
@@ -1139,7 +1143,8 @@ static int mxt_prepare_cfg_mem(struct mxt_data *data,
 				     &val,
 				     &offset);
 			if (ret != 1) {
-				dev_err(dev, "Bad format in T%d\n", type);
+				dev_err(dev, "Bad format in T%d at %d\n",
+					type, i);
 				return -EINVAL;
 			}
 			data_pos += offset;
@@ -1149,8 +1154,7 @@ static int mxt_prepare_cfg_mem(struct mxt_data *data,
 
 			byte_offset = reg + i - cfg_start_ofs;
 
-			if (byte_offset >= 0 &&
-			    byte_offset <= config_mem_size) {
+			if (byte_offset >= 0 && byte_offset < config_mem_size) {
 				*(config_mem + byte_offset) = val;
 			} else {
 				dev_err(dev, "Bad object: reg:%d, T%d, ofs=%d\n",
@@ -1454,6 +1458,7 @@ static int mxt_get_object_table(struct mxt_data *data)
 				data->T5_msg_size = mxt_obj_size(object) - 1;
 			}
 			data->T5_address = object->start_address;
+			break;
 		case MXT_GEN_COMMAND_T6:
 			data->T6_reportid = min_id;
 			data->T6_address = object->start_address;
@@ -1707,7 +1712,7 @@ static int mxt_initialize(struct mxt_data *data)
 		return error;
 	}
 
-	mxt_acquire_irq(data);
+	error = mxt_acquire_irq(data);
 	if (error)
 		goto err_free_object_table;
 
-- 
2.0.0.526.g5318336


-- 
Dmitry
