Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932588AbaJUSbP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 14:31:15 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:33044 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932224AbaJUSbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 14:31:10 -0400
From: Tomas Melin <tomas.melin@iki.fi>
To: m.chehab@samsung.com, david@hardeman.nu
Cc: james.hogan@imgtec.com, a.seppala@gmail.com, bay@hackerdom.ru,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tomas Melin <tomas.melin@iki.fi>
Subject: [PATCH v2 2/2] [media] rc-core: change enabled_protocol default setting
Date: Tue, 21 Oct 2014 21:30:18 +0300
Message-Id: <1413916218-7481-2-git-send-email-tomas.melin@iki.fi>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1413916218-7481-1-git-send-email-tomas.melin@iki.fi>
References: <1413916218-7481-1-git-send-email-tomas.melin@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change default setting for enabled protocols.
Instead of enabling all protocols during registration,
disable all except default keymap and lirc.
Reduces overhead since all protocols not handled by default.
Protocol to use will be enabled when keycode table is written by userspace.

Signed-off-by: Tomas Melin <tomas.melin@iki.fi>
---
 drivers/media/rc/rc-ir-raw.c |    1 -
 drivers/media/rc/rc-main.c   |    6 ++++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/media/rc/rc-ir-raw.c b/drivers/media/rc/rc-ir-raw.c
index a118539..d3b1e76 100644
--- a/drivers/media/rc/rc-ir-raw.c
+++ b/drivers/media/rc/rc-ir-raw.c
@@ -256,7 +256,6 @@ int ir_raw_event_register(struct rc_dev *dev)
 		return -ENOMEM;
 
 	dev->raw->dev = dev;
-	dev->enabled_protocols = ~0;
 	rc = kfifo_alloc(&dev->raw->kfifo,
 			 sizeof(struct ir_raw_event) * MAX_IR_EVENT_SIZE,
 			 GFP_KERNEL);
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 633c682..dcdf4cd 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -1320,6 +1320,8 @@ int rc_register_device(struct rc_dev *dev)
 		rc_map = rc_map_get(RC_MAP_EMPTY);
 	if (!rc_map || !rc_map->scan || rc_map->size == 0)
 		return -EINVAL;
+	/* get default keymap type */
+	u64 rc_type = (1 << rc_map->rc_type);
 
 	set_bit(EV_KEY, dev->input_dev->evbit);
 	set_bit(EV_REP, dev->input_dev->evbit);
@@ -1412,16 +1414,16 @@ int rc_register_device(struct rc_dev *dev)
 			raw_init = true;
 		}
 		rc = ir_raw_event_register(dev);
+		dev->enabled_protocols = (rc_type | RC_BIT_LIRC);
 		if (rc < 0)
 			goto out_input;
 	}
 
 	if (dev->change_protocol) {
-		u64 rc_type = (1 << rc_map->rc_type);
 		rc = dev->change_protocol(dev, &rc_type);
 		if (rc < 0)
 			goto out_raw;
-		dev->enabled_protocols = rc_type;
+		dev->enabled_protocols = (rc_type | RC_BIT_LIRC);
 	}
 
 	mutex_unlock(&dev->lock);
-- 
1.7.10.4

