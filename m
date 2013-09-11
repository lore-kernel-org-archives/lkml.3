Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755060Ab3IKPct (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 11:32:49 -0400
Received: from mga14.intel.com ([143.182.124.37]:13815 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754560Ab3IKPcr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 11:32:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,885,1371106800"; 
   d="scan'208";a="293584879"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-i2c@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lv Zheng <lv.zheng@intel.com>, Aaron Lu <aaron.lu@intel.com>,
        linux-arm-kernel@lists.infradead.org, Mark Brown <broonie@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH v2 4/9] [media] s5p-tv: convert to use I2C core runtime PM
Date: Wed, 11 Sep 2013 18:32:35 +0300
Message-Id: <1378913560-2752-5-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1378913560-2752-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1378913560-2752-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The I2C core now prepares runtime PM on behalf of the I2C client device, so
only thing the driver needs to do is to call pm_runtime_put() at the end of
its ->probe().

This patch converts s5p-tv driver to use this model.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/media/platform/s5p-tv/sii9234_drv.c | 30 ++++++-----------------------
 1 file changed, 6 insertions(+), 24 deletions(-)

diff --git a/drivers/media/platform/s5p-tv/sii9234_drv.c b/drivers/media/platform/s5p-tv/sii9234_drv.c
index 3dd762e..c0e8d42 100644
--- a/drivers/media/platform/s5p-tv/sii9234_drv.c
+++ b/drivers/media/platform/s5p-tv/sii9234_drv.c
@@ -325,8 +325,7 @@ static int sii9234_probe(struct i2c_client *client,
 	ctx = devm_kzalloc(&client->dev, sizeof(*ctx), GFP_KERNEL);
 	if (!ctx) {
 		dev_err(dev, "out of memory\n");
-		ret = -ENOMEM;
-		goto fail;
+		return -ENOMEM;
 	}
 	ctx->client = client;
 
@@ -345,42 +344,25 @@ static int sii9234_probe(struct i2c_client *client,
 
 	v4l2_i2c_subdev_init(&ctx->sd, client, &sii9234_ops);
 
-	pm_runtime_enable(dev);
-
-	/* enable device */
-	ret = pm_runtime_get_sync(dev);
-	if (ret)
-		goto fail_pm;
-
 	/* verify chip version */
 	ret = sii9234_verify_version(client);
-	if (ret)
-		goto fail_pm_get;
+	if (ret) {
+		dev_err(dev, "failed to verify chip version\n");
+		return ret;
+	}
 
-	/* stop processing */
 	pm_runtime_put(dev);
 
 	dev_info(dev, "probe successful\n");
 
 	return 0;
-
-fail_pm_get:
-	pm_runtime_put_sync(dev);
-
-fail_pm:
-	pm_runtime_disable(dev);
-
-fail:
-	dev_err(dev, "probe failed\n");
-
-	return ret;
 }
 
 static int sii9234_remove(struct i2c_client *client)
 {
 	struct device *dev = &client->dev;
 
-	pm_runtime_disable(dev);
+	pm_runtime_get(dev);
 
 	dev_info(dev, "remove successful\n");
 
-- 
1.8.4.rc3

