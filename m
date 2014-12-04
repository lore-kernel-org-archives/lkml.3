Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932748AbaLDQmS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 11:42:18 -0500
Received: from sauhun.de ([89.238.76.85]:33600 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932590AbaLDQmP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 11:42:15 -0500
From: Wolfram Sang <wsa@the-dreams.de>
To: linuxppc-dev@ozlabs.org
Cc: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Wolfram Sang <wsa@the-dreams.de>
Subject: [RFC 2/2] sound: ppc: keywest: drop using attach adapter
Date: Thu,  4 Dec 2014 17:41:53 +0100
Message-Id: <1417711313-7257-3-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417711313-7257-1-git-send-email-wsa@the-dreams.de>
References: <1417711313-7257-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As we now have deferred probing, we can use a custom mechanism and
finally get rid of the legacy interface from the i2c core.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
 sound/ppc/keywest.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/sound/ppc/keywest.c b/sound/ppc/keywest.c
index 0d1c27e911b8..a957f32368fa 100644
--- a/sound/ppc/keywest.c
+++ b/sound/ppc/keywest.c
@@ -52,7 +52,7 @@ static int keywest_attach_adapter(struct i2c_adapter *adapter)
 		return -EINVAL;
 
 	if (strncmp(adapter->name, "mac-io", 6))
-		return 0; /* ignored */
+		return -EINVAL; /* ignored */
 
 	memset(&info, 0, sizeof(struct i2c_board_info));
 	strlcpy(info.type, "keywest", I2C_NAME_SIZE);
@@ -100,7 +100,6 @@ static struct i2c_driver keywest_driver = {
 	.driver = {
 		.name = "PMac Keywest Audio",
 	},
-	.attach_adapter = keywest_attach_adapter,
 	.probe = keywest_probe,
 	.remove = keywest_remove,
 	.id_table = keywest_i2c_id,
@@ -132,16 +131,32 @@ int snd_pmac_tumbler_post_init(void)
 /* exported */
 int snd_pmac_keywest_init(struct pmac_keywest *i2c)
 {
-	int err;
+	struct i2c_adapter *adap;
+	int err, i = 0;
 
 	if (keywest_ctx)
 		return -EBUSY;
 
+	adap = i2c_get_adapter(0);
+	if (!adap)
+		return -EPROBE_DEFER;
+
 	keywest_ctx = i2c;
 
 	if ((err = i2c_add_driver(&keywest_driver))) {
 		snd_printk(KERN_ERR "cannot register keywest i2c driver\n");
+		i2c_put_adapter(adap);
 		return err;
 	}
+
+	/* We assume Macs have consecutive I2C bus numbers starting at 0 */
+	while (adap) {
+		err = keywest_attach_adapter(adap);
+		if (!err)
+			break;
+		i2c_put_adapter(adap);
+		adap = i2c_get_adapter(++i);
+	}
+
 	return 0;
 }
-- 
2.1.3

