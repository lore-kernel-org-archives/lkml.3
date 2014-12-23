Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932200AbaLWNVZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 08:21:25 -0500
Received: from mga14.intel.com ([192.55.52.115]:12998 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755986AbaLWNVX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 08:21:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,632,1413270000"; 
   d="scan'208";a="652169851"
From: Daniel Baluta <daniel.baluta@intel.com>
To: jic23@kernel.org, knaack.h@gmx.de
Cc: lars@metafoo.de, pmeerw@pmeerw.net, daniel.baluta@intel.com,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        srinivas.pandruvada@linux.intel.com
Subject: [PATCH 02/10] iio: imu: kmx61: Don't ignore kmx61_set_power_state errors
Date: Tue, 23 Dec 2014 15:22:25 +0200
Message-Id: <1419340953-23161-3-git-send-email-daniel.baluta@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1419340953-23161-1-git-send-email-daniel.baluta@intel.com>
References: <1419340953-23161-1-git-send-email-daniel.baluta@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

..except while in an error handler, where there is nothing
to be done anyway.

Signed-off-by: Daniel Baluta <daniel.baluta@intel.com>
---
 drivers/iio/imu/kmx61.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/imu/kmx61.c b/drivers/iio/imu/kmx61.c
index fe0cee7..e9cbd91 100644
--- a/drivers/iio/imu/kmx61.c
+++ b/drivers/iio/imu/kmx61.c
@@ -830,7 +830,12 @@ static int kmx61_read_raw(struct iio_dev *indio_dev,
 		}
 		mutex_lock(&data->lock);
 
-		kmx61_set_power_state(data, true, chan->address);
+		ret = kmx61_set_power_state(data, true, chan->address);
+		if (ret) {
+			mutex_unlock(&data->lock);
+			return ret;
+		}
+
 		ret = kmx61_read_measurement(data, base_reg, chan->scan_index);
 		if (ret < 0) {
 			kmx61_set_power_state(data, false, chan->address);
@@ -839,9 +844,11 @@ static int kmx61_read_raw(struct iio_dev *indio_dev,
 		}
 		*val = sign_extend32(ret >> chan->scan_type.shift,
 				     chan->scan_type.realbits - 1);
-		kmx61_set_power_state(data, false, chan->address);
+		ret = kmx61_set_power_state(data, false, chan->address);
 
 		mutex_unlock(&data->lock);
+		if (ret)
+			return ret;
 		return IIO_VAL_INT;
 	case IIO_CHAN_INFO_SCALE:
 		switch (chan->type) {
-- 
1.9.1

