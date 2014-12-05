Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245AbaLEVw4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 16:52:56 -0500
Received: from mga11.intel.com ([192.55.52.93]:34419 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751734AbaLEVwx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 16:52:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,525,1413270000"; 
   d="scan'208";a="633469790"
From: Irina Tirdea <irina.tirdea@intel.com>
To: Jonathan Cameron <jic23@kernel.org>, linux-iio@vger.kernel.org
Cc: Peter Meerwald <pmeerw@pmeerw.net>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Daniel Baluta <daniel.baluta@intel.com>, linux-kernel@vger.kernel.org,
        Irina Tirdea <irina.tirdea@intel.com>
Subject: [PATCH 4/4] iio: accel: kxcjk-1013: power off device if probe fails
Date: Sat,  6 Dec 2014 00:18:10 +0200
Message-Id: <1417817890-10252-5-git-send-email-irina.tirdea@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1417817890-10252-1-git-send-email-irina.tirdea@intel.com>
References: <1417817890-10252-1-git-send-email-irina.tirdea@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the device is initialized in probe, it is also powered on.
If there is an error after the initialization, the device will
remain powered on.

Power off the device in case probe fails after device initialization.

Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
Suggested-by: Daniel Baluta <daniel.baluta@intel.com>
---
 drivers/iio/accel/kxcjk-1013.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/iio/accel/kxcjk-1013.c b/drivers/iio/accel/kxcjk-1013.c
index 74b196f..bc04c2f 100644
--- a/drivers/iio/accel/kxcjk-1013.c
+++ b/drivers/iio/accel/kxcjk-1013.c
@@ -1239,21 +1239,25 @@ static int kxcjk1013_probe(struct i2c_client *client,
 						KXCJK1013_IRQ_NAME,
 						indio_dev);
 		if (ret)
-			return ret;
+			goto err_poweroff;
 
 		data->dready_trig = devm_iio_trigger_alloc(&client->dev,
 							   "%s-dev%d",
 							   indio_dev->name,
 							   indio_dev->id);
-		if (!data->dready_trig)
-			return -ENOMEM;
+		if (!data->dready_trig) {
+			ret = -ENOMEM;
+			goto err_poweroff;
+		}
 
 		data->motion_trig = devm_iio_trigger_alloc(&client->dev,
 							  "%s-any-motion-dev%d",
 							  indio_dev->name,
 							  indio_dev->id);
-		if (!data->motion_trig)
-			return -ENOMEM;
+		if (!data->motion_trig) {
+			ret = -ENOMEM;
+			goto err_poweroff;
+		}
 
 		data->dready_trig->dev.parent = &client->dev;
 		data->dready_trig->ops = &kxcjk1013_trigger_ops;
@@ -1262,7 +1266,7 @@ static int kxcjk1013_probe(struct i2c_client *client,
 		iio_trigger_get(indio_dev->trig);
 		ret = iio_trigger_register(data->dready_trig);
 		if (ret)
-			return ret;
+			goto err_poweroff;
 
 		data->motion_trig->dev.parent = &client->dev;
 		data->motion_trig->ops = &kxcjk1013_trigger_ops;
@@ -1311,6 +1315,8 @@ err_trigger_unregister:
 		iio_trigger_unregister(data->dready_trig);
 	if (data->motion_trig)
 		iio_trigger_unregister(data->motion_trig);
+err_poweroff:
+	kxcjk1013_set_mode(data, STANDBY);
 
 	return ret;
 }
-- 
1.7.9.5

