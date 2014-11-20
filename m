Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757653AbaKTQVv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 11:21:51 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:57693 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756725AbaKTQVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 11:21:47 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-73-546e1519cfa0
From: Lukasz Majewski <l.majewski@samsung.com>
To: Eduardo Valentin <edubezval@gmail.com>, Zhang Rui <rui.zhang@intel.com>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        Mikko Perttunen <mperttunen@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org,
        Caesar Wang <caesar.wang@rock-chips.com>,
        Lukasz Majewski <l.majewski@samsung.com>
Subject: [PATCH v2 1/4] thermal: of: Extend of-thermal.c to provide number of
 trip points
Date: Thu, 20 Nov 2014 17:21:25 +0100
Message-id: <1416500488-7232-2-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1416500488-7232-1-git-send-email-l.majewski@samsung.com>
References: <1412872737-624-1-git-send-email-l.majewski@samsung.com>
 <1416500488-7232-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOLMWRmVeSWpSXmKPExsVy+t9jAV1J0bwQg/vPjCwer1nMZLFxxnpW
	iy+f+9gs5l+5xmqx5q+SxZtH3BZvHm5mtLi8aw6bxefeI4wWTxaeYbJ4cHUam8WTh0Clrw62
	sVj83DWPxYHPY+esu+wei/e8ZPJYN+0ts0dv8zs2j7+z9rN47PzewO7Rt2UVo8fnTXIeG+eG
	BnBGcdmkpOZklqUW6dslcGUsXutY8FqgYtXvuAbGXr4uRg4OCQETiSsPHLoYOYFMMYkL99az
	dTFycQgJLGKU+P/qNROE08Uk8fn8OyaQKjYBPYnPd5+C2SIC3hKv901nBCliFmhnkbh+aDcj
	SEJYIFpi3pZzYDaLgKrEjinX2EFsXgFXidVdG5gh1ilKdD+bwAZicwq4SWxc1swCsa2BUWLC
	nRbGCYy8CxgZVjGKphYkFxQnpeca6RUn5haX5qXrJefnbmIEB+8z6R2MqxosDjEKcDAq8fAm
	WOSGCLEmlhVX5h5ilOBgVhLhlWPPCxHiTUmsrEotyo8vKs1JLT7EKM3BoiTOe+MmULVAemJJ
	anZqakFqEUyWiYNTqoFxWdbb5sSMU7Zr762IY+7mejSB9fyTl+ZLF83TdjqcULP8l3rYDn0G
	2cVHeIOnLpntNkf0g2PkXw3ztULm8urxs5lrrvYw/2wXO7YycA3zthzP1wYT3t1Q5nv/alai
	8rQOT57Iu8f2MTavynFyuzh9msgjjaWzkiX35bmWRswQUHl/zKFSwc5NiaU4I9FQi7moOBEA
	EOTCg1oCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch extends the of-thermal.c to provide information about number of
available trip points.

Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
---
Changes for v2:
- Provide detailed (doxygen like) description of the of_thermal_get_ntrips()
  method
- Check for data pointer not being NULL
---
 drivers/thermal/of-thermal.c   | 20 ++++++++++++++++++++
 drivers/thermal/thermal_core.h |  5 +++++
 2 files changed, 25 insertions(+)

diff --git a/drivers/thermal/of-thermal.c b/drivers/thermal/of-thermal.c
index b7982f0..7170822 100644
--- a/drivers/thermal/of-thermal.c
+++ b/drivers/thermal/of-thermal.c
@@ -112,6 +112,26 @@ static int of_thermal_get_temp(struct thermal_zone_device *tz,
 	return data->ops->get_temp(data->sensor_data, temp);
 }
 
+/**
+ * of_thermal_get_ntrips - function to export number of available trip
+ *			   points.
+ * @tz: pointer to a thermal zone
+ *
+ * This function is a globally visible wrapper to get number of trip points
+ * stored in the local struct __thermal_zone
+ *
+ * Return: number of available trip points, -ENODEV when data not available
+ */
+int of_thermal_get_ntrips(struct thermal_zone_device *tz)
+{
+	struct __thermal_zone *data = tz->devdata;
+
+	if (!data || IS_ERR(data))
+		return -ENODEV;
+
+	return data->ntrips;
+}
+
 static int of_thermal_get_trend(struct thermal_zone_device *tz, int trip,
 				enum thermal_trend *trend)
 {
diff --git a/drivers/thermal/thermal_core.h b/drivers/thermal/thermal_core.h
index d15d243..c3c7b82 100644
--- a/drivers/thermal/thermal_core.h
+++ b/drivers/thermal/thermal_core.h
@@ -89,9 +89,14 @@ static inline void thermal_gov_user_space_unregister(void) {}
 #ifdef CONFIG_THERMAL_OF
 int of_parse_thermal_zones(void);
 void of_thermal_destroy_zones(void);
+int of_thermal_get_ntrips(struct thermal_zone_device *);
 #else
 static inline int of_parse_thermal_zones(void) { return 0; }
 static inline void of_thermal_destroy_zones(void) { }
+static inline int of_thermal_get_ntrips(struct thermal_zone_device *)
+{
+	return 0;
+}
 #endif
 
 #endif /* __THERMAL_CORE_H__ */
-- 
2.0.0.rc2

