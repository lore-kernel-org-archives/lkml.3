Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084AbaKJITE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 03:19:04 -0500
Received: from mga02.intel.com ([134.134.136.20]:15444 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751933AbaKJITC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 03:19:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,351,1413270000"; 
   d="scan'208";a="605172975"
From: Daniel Baluta <daniel.baluta@intel.com>
To: jic23@kernel.org
Cc: srinivas.pandruvada@linux.intel.com, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] iio: accel: kxcjk-1013: Fix kxcjk10013_set_range
Date: Mon, 10 Nov 2014 10:20:16 +0200
Message-Id: <1415607616-17215-1-git-send-email-daniel.baluta@intel.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, we get the new GSEL bits by OR-ing the old values
with the new ones. This only works first time when the old
values are 0.

Startup:
	* GSEL0 = 0, GSEL1 = 0

Set range to 4G: (GSEL0 = 1, GSEL1 = 0)
	* GSEL0 = 0 | 1 = 1
	* GSEL1 = 0 | 0 = 0
	* correct

Change range to 2G: (GSEL0 = 0, GSEL1 = 0)
	* GSEL0 = 1 | 0 = 1
	* GSEL1 = 0 | 0 = 0
	* wrong, GSEL0 should be 0

This has the nice effect that we can use the full scale range,
exported in in_accel_scale_available.

Fixes: a735e3d7f03 (iio: accel: kxcjk-1013: Set adjustable range)
Signed-off-by: Daniel Baluta <daniel.baluta@intel.com>
Reviewed-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
---
 drivers/iio/accel/kxcjk-1013.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/iio/accel/kxcjk-1013.c b/drivers/iio/accel/kxcjk-1013.c
index 98909a9..21f1279 100644
--- a/drivers/iio/accel/kxcjk-1013.c
+++ b/drivers/iio/accel/kxcjk-1013.c
@@ -269,6 +269,8 @@ static int kxcjk1013_set_range(struct kxcjk1013_data *data, int range_index)
 		return ret;
 	}
 
+	ret &= ~(KXCJK1013_REG_CTRL1_BIT_GSEL0 |
+		 KXCJK1013_REG_CTRL1_BIT_GSEL1);
 	ret |= (KXCJK1013_scale_table[range_index].gsel_0 << 3);
 	ret |= (KXCJK1013_scale_table[range_index].gsel_1 << 4);
 
-- 
1.9.1

