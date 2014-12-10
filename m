Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932717AbaLJP7G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 10:59:06 -0500
Received: from mga09.intel.com ([134.134.136.24]:5896 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932638AbaLJP6P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 10:58:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="496704518"
From: Irina Tirdea <irina.tirdea@intel.com>
To: Jonathan Cameron <jic23@kernel.org>, linux-iio@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Daniel Baluta <daniel.baluta@intel.com>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Irina Tirdea <irina.tirdea@intel.com>
Subject: [PATCH v2 3/4] iio: accel: kxcjk-1013: error handling when set mode fails
Date: Wed, 10 Dec 2014 18:23:53 +0200
Message-Id: <1418228634-10505-4-git-send-email-irina.tirdea@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1418228634-10505-1-git-send-email-irina.tirdea@intel.com>
References: <1418228634-10505-1-git-send-email-irina.tirdea@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If there is an error in set mode at runtime resume, reset the state of
the runtime usage count.

If there is an error in set mode at runtime suspend, make sure the framework
retries to suspend the device.

Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
Reviewed-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
---
 drivers/iio/accel/kxcjk-1013.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/accel/kxcjk-1013.c b/drivers/iio/accel/kxcjk-1013.c
index 7b0a9da..0dc6ccf 100644
--- a/drivers/iio/accel/kxcjk-1013.c
+++ b/drivers/iio/accel/kxcjk-1013.c
@@ -388,6 +388,8 @@ static int kxcjk1013_set_power_state(struct kxcjk1013_data *data, bool on)
 	if (ret < 0) {
 		dev_err(&data->client->dev,
 			"Failed: kxcjk1013_set_power_state for %d\n", on);
+		if (on)
+			pm_runtime_put_noidle(&data->client->dev);
 		return ret;
 	}
 #endif
@@ -859,6 +861,8 @@ static int kxcjk1013_write_event_config(struct iio_dev *indio_dev,
 
 	ret =  kxcjk1013_setup_any_motion_interrupt(data, state);
 	if (ret < 0) {
+		kxcjk1013_set_power_state(data, false);
+		data->ev_enable_state = 0;
 		mutex_unlock(&data->mutex);
 		return ret;
 	}
@@ -1009,6 +1013,7 @@ static int kxcjk1013_data_rdy_trigger_set_state(struct iio_trigger *trig,
 	else
 		ret = kxcjk1013_setup_new_data_interrupt(data, state);
 	if (ret < 0) {
+		kxcjk1013_set_power_state(data, false);
 		mutex_unlock(&data->mutex);
 		return ret;
 	}
@@ -1368,8 +1373,14 @@ static int kxcjk1013_runtime_suspend(struct device *dev)
 {
 	struct iio_dev *indio_dev = i2c_get_clientdata(to_i2c_client(dev));
 	struct kxcjk1013_data *data = iio_priv(indio_dev);
+	int ret;
 
-	return kxcjk1013_set_mode(data, STANDBY);
+	ret = kxcjk1013_set_mode(data, STANDBY);
+	if (ret < 0) {
+		dev_err(&data->client->dev, "powering off device failed\n");
+		return -EAGAIN;
+	}
+	return 0;
 }
 
 static int kxcjk1013_runtime_resume(struct device *dev)
-- 
1.7.9.5

