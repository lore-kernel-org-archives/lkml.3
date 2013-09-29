Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755149Ab3I2IvU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 04:51:20 -0400
Received: from smtp-out-220.synserver.de ([212.40.185.220]:1237 "EHLO
	smtp-out-220.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754537Ab3I2Itf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 04:49:35 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 1782
From: Lars-Peter Clausen <lars@metafoo.de>
To: Wolfram Sang <wsa@the-dreams.de>, David Airlie <airlied@linux.ie>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        alsa-devel@alsa-project.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 3/8] [media] core: Don't use i2c_client->driver
Date: Sun, 29 Sep 2013 10:51:01 +0200
Message-Id: <1380444666-12019-4-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1380444666-12019-1-git-send-email-lars@metafoo.de>
References: <1380444666-12019-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'driver' field of the i2c_client struct is redundant and is going to be
removed. The results of the expressions 'client->driver.driver->field' and
'client->dev.driver->field' are identical, so replace all occurrences of the
former with the later.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/media/v4l2-core/tuner-core.c  |  6 +++---
 drivers/media/v4l2-core/v4l2-common.c | 10 +++++-----
 include/media/v4l2-common.h           |  2 +-
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/media/v4l2-core/tuner-core.c b/drivers/media/v4l2-core/tuner-core.c
index ddc9379..4133af0 100644
--- a/drivers/media/v4l2-core/tuner-core.c
+++ b/drivers/media/v4l2-core/tuner-core.c
@@ -43,7 +43,7 @@
 
 #define UNSET (-1U)
 
-#define PREFIX (t->i2c->driver->driver.name)
+#define PREFIX (t->i2c->dev.driver->name)
 
 /*
  * Driver modprobe parameters
@@ -452,7 +452,7 @@ static void set_type(struct i2c_client *c, unsigned int type,
 	}
 
 	tuner_dbg("%s %s I2C addr 0x%02x with type %d used for 0x%02x\n",
-		  c->adapter->name, c->driver->driver.name, c->addr << 1, type,
+		  c->adapter->name, c->dev.driver->name, c->addr << 1, type,
 		  t->mode_mask);
 	return;
 
@@ -556,7 +556,7 @@ static void tuner_lookup(struct i2c_adapter *adap,
 		int mode_mask;
 
 		if (pos->i2c->adapter != adap ||
-		    strcmp(pos->i2c->driver->driver.name, "tuner"))
+		    strcmp(pos->i2c->dev.driver->name, "tuner"))
 			continue;
 
 		mode_mask = pos->mode_mask;
diff --git a/drivers/media/v4l2-core/v4l2-common.c b/drivers/media/v4l2-core/v4l2-common.c
index 037d7a5..433d6d7 100644
--- a/drivers/media/v4l2-core/v4l2-common.c
+++ b/drivers/media/v4l2-core/v4l2-common.c
@@ -236,14 +236,14 @@ void v4l2_i2c_subdev_init(struct v4l2_subdev *sd, struct i2c_client *client,
 	v4l2_subdev_init(sd, ops);
 	sd->flags |= V4L2_SUBDEV_FL_IS_I2C;
 	/* the owner is the same as the i2c_client's driver owner */
-	sd->owner = client->driver->driver.owner;
+	sd->owner = client->dev.driver->owner;
 	sd->dev = &client->dev;
 	/* i2c_client and v4l2_subdev point to one another */
 	v4l2_set_subdevdata(sd, client);
 	i2c_set_clientdata(client, sd);
 	/* initialize name */
 	snprintf(sd->name, sizeof(sd->name), "%s %d-%04x",
-		client->driver->driver.name, i2c_adapter_id(client->adapter),
+		client->dev.driver->name, i2c_adapter_id(client->adapter),
 		client->addr);
 }
 EXPORT_SYMBOL_GPL(v4l2_i2c_subdev_init);
@@ -274,11 +274,11 @@ struct v4l2_subdev *v4l2_i2c_new_subdev_board(struct v4l2_device *v4l2_dev,
 	   loaded. This delay-load mechanism doesn't work if other drivers
 	   want to use the i2c device, so explicitly loading the module
 	   is the best alternative. */
-	if (client == NULL || client->driver == NULL)
+	if (client == NULL || client->dev.driver == NULL)
 		goto error;
 
 	/* Lock the module so we can safely get the v4l2_subdev pointer */
-	if (!try_module_get(client->driver->driver.owner))
+	if (!try_module_get(client->dev.driver->owner))
 		goto error;
 	sd = i2c_get_clientdata(client);
 
@@ -287,7 +287,7 @@ struct v4l2_subdev *v4l2_i2c_new_subdev_board(struct v4l2_device *v4l2_dev,
 	if (v4l2_device_register_subdev(v4l2_dev, sd))
 		sd = NULL;
 	/* Decrease the module use count to match the first try_module_get. */
-	module_put(client->driver->driver.owner);
+	module_put(client->dev.driver->owner);
 
 error:
 	/* If we have a client but no subdev, then something went wrong and
diff --git a/include/media/v4l2-common.h b/include/media/v4l2-common.h
index 16550c4..a707529 100644
--- a/include/media/v4l2-common.h
+++ b/include/media/v4l2-common.h
@@ -35,7 +35,7 @@
 	printk(level "%s %d-%04x: " fmt, name, i2c_adapter_id(adapter), addr , ## arg)
 
 #define v4l_client_printk(level, client, fmt, arg...)			    \
-	v4l_printk(level, (client)->driver->driver.name, (client)->adapter, \
+	v4l_printk(level, (client)->dev.driver->name, (client)->adapter, \
 		   (client)->addr, fmt , ## arg)
 
 #define v4l_err(client, fmt, arg...) \
-- 
1.8.0

