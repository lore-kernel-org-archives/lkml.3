Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765Ab3I2Itm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 04:49:42 -0400
Received: from smtp-out-220.synserver.de ([212.40.185.220]:1321 "EHLO
	smtp-out-220.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754693Ab3I2Iti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 04:49:38 -0400
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
Subject: [PATCH 4/8] drm: encoder_slave: Don't use i2c_client->driver
Date: Sun, 29 Sep 2013 10:51:02 +0200
Message-Id: <1380444666-12019-5-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1380444666-12019-1-git-send-email-lars@metafoo.de>
References: <1380444666-12019-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'driver' field of the i2c_client struct is redundant and is going to be
removed. The results of the expressions 'client->driver.driver->field' and
'client->dev.driver->field' are identical, so replace all occurrences of the
former with the later. To get direct access to the i2c_driver struct use
'to_i2c_driver(client->dev.driver)'.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/gpu/drm/drm_encoder_slave.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/drm_encoder_slave.c b/drivers/gpu/drm/drm_encoder_slave.c
index 0cfb60f..d18b88b 100644
--- a/drivers/gpu/drm/drm_encoder_slave.c
+++ b/drivers/gpu/drm/drm_encoder_slave.c
@@ -67,12 +67,12 @@ int drm_i2c_encoder_init(struct drm_device *dev,
 		goto fail;
 	}
 
-	if (!client->driver) {
+	if (!client->dev.driver) {
 		err = -ENODEV;
 		goto fail_unregister;
 	}
 
-	module = client->driver->driver.owner;
+	module = client->dev.driver->owner;
 	if (!try_module_get(module)) {
 		err = -ENODEV;
 		goto fail_unregister;
@@ -80,7 +80,7 @@ int drm_i2c_encoder_init(struct drm_device *dev,
 
 	encoder->bus_priv = client;
 
-	encoder_drv = to_drm_i2c_encoder_driver(client->driver);
+	encoder_drv = to_drm_i2c_encoder_driver(to_i2c_driver(client->dev.driver));
 
 	err = encoder_drv->encoder_init(client, dev, encoder);
 	if (err)
@@ -111,7 +111,7 @@ void drm_i2c_encoder_destroy(struct drm_encoder *drm_encoder)
 {
 	struct drm_encoder_slave *encoder = to_encoder_slave(drm_encoder);
 	struct i2c_client *client = drm_i2c_encoder_get_client(drm_encoder);
-	struct module *module = client->driver->driver.owner;
+	struct module *module = client->dev.driver->owner;
 
 	i2c_unregister_device(client);
 	encoder->bus_priv = NULL;
-- 
1.8.0

