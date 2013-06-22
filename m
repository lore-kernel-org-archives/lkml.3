Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932174Ab3FVJri (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jun 2013 05:47:38 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:50920 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534Ab3FVJrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jun 2013 05:47:36 -0400
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
        LMML <linux-media@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 1/2] media: i2c: ths8200: support asynchronous probing
Date: Sat, 22 Jun 2013 15:16:34 +0530
Message-Id: <1371894395-14414-2-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1371894395-14414-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1371894395-14414-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

This patch supports both synchronous and asynchronous
ths8200 subdevice probing.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/i2c/ths8200.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ths8200.c b/drivers/media/i2c/ths8200.c
index a24f90c..cc1339a 100644
--- a/drivers/media/i2c/ths8200.c
+++ b/drivers/media/i2c/ths8200.c
@@ -21,6 +21,7 @@
 #include <linux/module.h>
 #include <linux/v4l2-dv-timings.h>
 
+#include <media/v4l2-async.h>
 #include <media/v4l2-device.h>
 
 #include "ths8200_regs.h"
@@ -500,6 +501,7 @@ static int ths8200_probe(struct i2c_client *client,
 {
 	struct ths8200_state *state;
 	struct v4l2_subdev *sd;
+	int error;
 
 	/* Check if the adapter supports the needed features */
 	if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_BYTE_DATA))
@@ -517,6 +519,10 @@ static int ths8200_probe(struct i2c_client *client,
 
 	ths8200_core_init(sd);
 
+	error = v4l2_async_register_subdev(&state->sd);
+	if (error)
+		return error;
+
 	v4l2_info(sd, "%s found @ 0x%x (%s)\n", client->name,
 		  client->addr << 1, client->adapter->name);
 
@@ -526,12 +532,13 @@ static int ths8200_probe(struct i2c_client *client,
 static int ths8200_remove(struct i2c_client *client)
 {
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
+	struct ths8200_state *decoder = to_state(sd);
 
 	v4l2_dbg(1, debug, sd, "%s removed @ 0x%x (%s)\n", client->name,
 		 client->addr << 1, client->adapter->name);
 
 	ths8200_s_power(sd, false);
-
+	v4l2_async_unregister_subdev(&decoder->sd);
 	v4l2_device_unregister_subdev(sd);
 
 	return 0;
-- 
1.7.9.5

