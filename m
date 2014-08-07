Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667AbaHGHpK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 03:45:10 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:35321 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754119AbaHGHpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 03:45:08 -0400
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Nick Dyer <nick.dyer@itdev.co.uk>, Stephen Warren <swarren@nvidia.com>,
        Yufeng Shen <miletus@chromium.org>, Benson Leung <bleung@chromium.org>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Tomasz Figa <tomasz.figa@gmail.com>, linux-input@vger.kernel.org,
        devicetree@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH v2 1/1] Input: atmel_mxt_ts - Get IRQ edge/level flags on DT booting
Date: Thu,  7 Aug 2014 09:44:52 +0200
Message-Id: <1407397492-17475-1-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.0.0.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Atmel maXTouch driver assumed that the IRQ type flags will
always be passed using platform data but this is not true when
booting using Device Trees. In these setups the interrupt type
was ignored by the driver when requesting an IRQ.

This means that it will fail if a machine specified other type
than IRQ_TYPE_NONE. The right approach is to get the IRQ flags
that was parsed by OF from the "interrupt" Device Tree propery.

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---

This patch was first sent as a part of a two part series along
with [PATCH 2/2] Input: atmel_mxt_ts - Add keycodes array example.

But there are no dependencies between these two patches so there
is no need to resend that one with no changes for v2.

Changes since v1:
 - Assign flags to pdata->irqflags in mxt_parse_dt() instead of probe().
   Suggested by Tomasz Figa.

 drivers/input/touchscreen/atmel_mxt_ts.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 03b8571..5c8cbd3 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -22,6 +22,7 @@
 #include <linux/i2c.h>
 #include <linux/i2c/atmel_mxt_ts.h>
 #include <linux/input/mt.h>
+#include <linux/irq.h>
 #include <linux/interrupt.h>
 #include <linux/of.h>
 #include <linux/slab.h>
@@ -2093,6 +2094,8 @@ static struct mxt_platform_data *mxt_parse_dt(struct i2c_client *client)
 	if (!pdata)
 		return ERR_PTR(-ENOMEM);
 
+	pdata->irqflags = irq_get_trigger_type(client->irq);
+
 	if (of_find_property(client->dev.of_node, "linux,gpio-keymap",
 			     &proplen)) {
 		pdata->t19_num_keys = proplen / sizeof(u32);
-- 
2.0.0.rc2

