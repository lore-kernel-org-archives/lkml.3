Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751363AbaLRRPc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 12:15:32 -0500
Received: from mga11.intel.com ([192.55.52.93]:40090 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751117AbaLRRPb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 12:15:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,601,1413270000"; 
   d="scan'208";a="639824528"
From: Daniel Baluta <daniel.baluta@intel.com>
To: jic23@kernel.org
Cc: knaack.h@gmx.de, lars@metafoo.de, pmeerw@pmeerw.net, gwendal@chromium.org,
        srinivas.pandruvada@linux.intel.com, beomho.seo@samsung.com,
        daniel.baluta@intel.com, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, octavian.purdila@intel.com
Subject: [RFC PATCH] iio: ak8975: Make sure chipset is always initialized
Date: Thu, 18 Dec 2014 19:16:42 +0200
Message-Id: <1418923002-901-1-git-send-email-daniel.baluta@intel.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When using ACPI, if acpi_match_device fails then chipset enum will be
uninitialized and &ak_def_array[chipset] will point to some bad address.

This fixes the following compilation warning:

drivers/iio/magnetometer/ak8975.c: In function ‘ak8975_probe’:
drivers/iio/magnetometer/ak8975.c:788:14: warning: ‘chipset’ may be used
uninitialized in this function [-Wmaybe-uninitialized]
  data->def = &ak_def_array[chipset];

Reported-by: Octavian Purdila <octavian.purdila@intel.com>
Signed-off-by: Daniel Baluta <daniel.baluta@intel.com>
---
This is a RFC because while I'm pretty sure that chipset should be initialized
with AK_MAX_TYPE in ak8975_match_acpi_device, I am not sure if we can live with
a NULL return value of ak8975_match_acpi_device. Current implementation ignores
return value of ak8975_match_acpi_device.

The same situation is for kxcjk-1013, bmc150-accel, bmg160 and possible other
drivers.

 drivers/iio/magnetometer/ak8975.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iio/magnetometer/ak8975.c b/drivers/iio/magnetometer/ak8975.c
index 0d10a4b..cdf9e77 100644
--- a/drivers/iio/magnetometer/ak8975.c
+++ b/drivers/iio/magnetometer/ak8975.c
@@ -716,6 +716,7 @@ static const char *ak8975_match_acpi_device(struct device *dev,
 {
 	const struct acpi_device_id *id;
 
+	*chipset = AK_MAX_TYPE;
 	id = acpi_match_device(dev->driver->acpi_match_table, dev);
 	if (!id)
 		return NULL;
-- 
1.9.1

