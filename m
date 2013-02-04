Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754452Ab3BDLxa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 06:53:30 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:56901 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754243Ab3BDLx1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 06:53:27 -0500
From: "J, KEERTHY" <j-keerthy@ti.com>
To: "J, KEERTHY" <j-keerthy@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>
Subject: RE: [PATCH] Regulator: Reorder the min max assignment in the
 sequence of regulator_set_voltage function
Thread-Topic: [PATCH] Regulator: Reorder the min max assignment in the
 sequence of regulator_set_voltage function
Thread-Index: AQHOADnufPb44Tk3JkCHdcW8IZFak5hpm8OQ
Date: Mon, 4 Feb 2013 11:53:20 +0000
Message-ID: <DC88CAD03C0052499C1907B327FC63229B84BD@DBDE01.ent.ti.com>
References: <1359695098-3630-1-git-send-email-j-keerthy@ti.com>
In-Reply-To: <1359695098-3630-1-git-send-email-j-keerthy@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.159.88]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark/Liam,

Any comments in this?

Regards,
Keerthy

-----Original Message-----
From: J, KEERTHY 
Sent: Friday, February 01, 2013 10:35 AM
To: linux-kernel@vger.kernel.org; lgirdwood@gmail.com; broonie@opensource.wolfsonmicro.com
Cc: J, KEERTHY
Subject: [PATCH] Regulator: Reorder the min max assignment in the sequence of regulator_set_voltage function

The min and max values for regulators are getting assigned before actually
the voltage is set. So making sure that min and max values are assigned
only if the voltage is successfully set else keeping the last successfully
set voltage's min and max values.

This is boot tested on OMAP4430 and OMAP4460 boards.

Signed-off-by: J Keerthy <j-keerthy@ti.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com> 
---
 drivers/regulator/core.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 2785843..12140fb 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -81,6 +81,8 @@ struct regulator {
 	int uA_load;
 	int min_uV;
 	int max_uV;
+	int curr_min_uV;
+	int curr_max_uV;
 	char *supply_name;
 	struct device_attribute dev_attr;
 	struct regulator_dev *rdev;
@@ -2315,6 +2317,8 @@ int regulator_set_voltage(struct regulator *regulator, int min_uV, int max_uV)
 	ret = regulator_check_voltage(rdev, &min_uV, &max_uV);
 	if (ret < 0)
 		goto out;
+	regulator->curr_min_uV = regulator->min_uV;
+	regulator->curr_max_uV = regulator->max_uV;
 	regulator->min_uV = min_uV;
 	regulator->max_uV = max_uV;
 
@@ -2325,6 +2329,11 @@ int regulator_set_voltage(struct regulator *regulator, int min_uV, int max_uV)
 	ret = _regulator_do_set_voltage(rdev, min_uV, max_uV);
 
 out:
+	if (ret) {
+		regulator->min_uV = regulator->curr_min_uV;
+		regulator->max_uV = regulator->curr_max_uV;
+	}
+
 	mutex_unlock(&rdev->mutex);
 	return ret;
 }
-- 
1.7.5.4

