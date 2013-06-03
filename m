Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759507Ab3FCR1a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 13:27:30 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:62618 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759300Ab3FCR12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 13:27:28 -0400
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        LMML <linux-media@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 2/2] media: i2c: ths8200: add support v4l-async
Date: Mon,  3 Jun 2013 22:56:18 +0530
Message-Id: <1370280378-2570-3-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1370280378-2570-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1370280378-2570-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.csengg@gmail.com>

This patch supports ths8200 driver for v4l-async subdevice
probing.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/i2c/ths8200.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/drivers/media/i2c/ths8200.c b/drivers/media/i2c/ths8200.c
index 9396829..d1bddcc 100644
--- a/drivers/media/i2c/ths8200.c
+++ b/drivers/media/i2c/ths8200.c
@@ -21,6 +21,7 @@
 #include <linux/module.h>
 #include <linux/v4l2-dv-timings.h>
 
+#include <media/v4l2-async.h>
 #include <media/v4l2-device.h>
 
 #include "ths8200_regs.h"
@@ -504,6 +505,7 @@ static int ths8200_probe(struct i2c_client *client,
 {
 	struct ths8200_state *state;
 	struct v4l2_subdev *sd;
+	int error;
 
 	/* Check if the adapter supports the needed features */
 	if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_BYTE_DATA))
@@ -521,6 +523,11 @@ static int ths8200_probe(struct i2c_client *client,
 
 	ths8200_core_init(sd);
 
+	state->sd.dev = &client->dev;
+	error = v4l2_async_register_subdev(&state->sd);
+	if (error)
+		return error;
+
 	v4l2_info(sd, "%s found @ 0x%x (%s)\n", client->name,
 		  client->addr << 1, client->adapter->name);
 
@@ -530,12 +537,13 @@ static int ths8200_probe(struct i2c_client *client,
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
1.7.0.4

