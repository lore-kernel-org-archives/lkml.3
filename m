Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757718AbaKTQV5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 11:21:57 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:12410 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757656AbaKTQVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 11:21:53 -0500
X-AuditID: cbfee61a-f79c06d000004e71-1f-546e151f9838
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
Subject: [PATCH v2 2/4] thermal: of: Extend of-thermal.c to provide check if
 trip point is enabled
Date: Thu, 20 Nov 2014 17:21:26 +0100
Message-id: <1416500488-7232-3-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1416500488-7232-1-git-send-email-l.majewski@samsung.com>
References: <1412872737-624-1-git-send-email-l.majewski@samsung.com>
 <1416500488-7232-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFLMWRmVeSWpSXmKPExsVy+t9jAV150bwQgxnPVSwer1nMZLFxxnpW
	iy+f+9gs5l+5xmqx5q+SxZtH3BZvHm5mtLi8aw6bxefeI4wWTxaeYbJ4cHUam8WTh0Clrw62
	sVj83DWPxYHPY+esu+wei/e8ZPJYN+0ts0dv8zs2j7+z9rN47PzewO7Rt2UVo8fnTXIeG+eG
	BnBGcdmkpOZklqUW6dslcGVsWj2DreCsYMW3e4/ZGxgv8HUxcnJICJhIvH/WzAJhi0lcuLee
	rYuRi0NIYBGjxPmGTVBOF5PEzNUX2ECq2AT0JD7ffcoEYosIeEu83jedEaSIWaCdReL6od2M
	IAlhgRSJnw9bmUFsFgFVidMLD4Ct4BVwlbiw/Bw7xDpFie5nE8CGcgq4SWxcBnIGyLYGRokJ
	d1oYJzDyLmBkWMUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kRHMLPpHYwrmywOMQowMGoxMOb
	YJEbIsSaWFZcmXuIUYKDWUmEV449L0SINyWxsiq1KD++qDQntfgQozQHi5I4742bQNUC6Ykl
	qdmpqQWpRTBZJg5OqQbG84fSrvHx72a5Kq+ryvxgk2ZpWqXQkexKkVn9S1vsDuXs7ZPwenG0
	O37OwjeRMx7/DJWuSZv+6mPmpcWnM0IKfrxQk3wU+vHulUmrNUQSjjhfmRk25+XCeFOVhPRt
	7FI11tkXyvYdv/b0oA2bVfnPkhndZ0vTWKPypwR8eFR7S/7/rXmbw329lFiKMxINtZiLihMB
	4uIK1V0CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch extends the of-thermal.c to provide check if trip point is
enabled.

Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
---
Changes for v2:
- Replace int with bool
- Replace 1/0 with true/false
- Add check if data pointer is not NULL
- Add missing doxygen style comment for the function
---
 drivers/thermal/of-thermal.c   | 20 ++++++++++++++++++++
 drivers/thermal/thermal_core.h |  5 +++++
 2 files changed, 25 insertions(+)

diff --git a/drivers/thermal/of-thermal.c b/drivers/thermal/of-thermal.c
index 7170822..336af7f 100644
--- a/drivers/thermal/of-thermal.c
+++ b/drivers/thermal/of-thermal.c
@@ -132,6 +132,26 @@ int of_thermal_get_ntrips(struct thermal_zone_device *tz)
 	return data->ntrips;
 }
 
+/**
+ * of_thermal_is_trip_en - function to check if trip point is enabled
+ *
+ * @tz:	pointer to a thermal zone
+ * @trip:	trip point to evaluate
+ *
+ * This function is responsible for checking if passed trip point is enabled
+ *
+ * Return: true if trip point is enabled, false otherwise
+ */
+bool of_thermal_is_trip_en(struct thermal_zone_device *tz, int trip)
+{
+	struct __thermal_zone *data = tz->devdata;
+
+	if (!data || trip >= data->ntrips || trip < 0)
+		return false;
+
+	return true;
+}
+
 static int of_thermal_get_trend(struct thermal_zone_device *tz, int trip,
 				enum thermal_trend *trend)
 {
diff --git a/drivers/thermal/thermal_core.h b/drivers/thermal/thermal_core.h
index c3c7b82..466208c 100644
--- a/drivers/thermal/thermal_core.h
+++ b/drivers/thermal/thermal_core.h
@@ -90,6 +90,7 @@ static inline void thermal_gov_user_space_unregister(void) {}
 int of_parse_thermal_zones(void);
 void of_thermal_destroy_zones(void);
 int of_thermal_get_ntrips(struct thermal_zone_device *);
+bool of_thermal_is_trip_en(struct thermal_zone_device *, int);
 #else
 static inline int of_parse_thermal_zones(void) { return 0; }
 static inline void of_thermal_destroy_zones(void) { }
@@ -97,6 +98,10 @@ static inline int of_thermal_get_ntrips(struct thermal_zone_device *)
 {
 	return 0;
 }
+static inline bool of_thermal_is_trip_en(struct thermal_zone_device *, int)
+{
+	return 0;
+}
 #endif
 
 #endif /* __THERMAL_CORE_H__ */
-- 
2.0.0.rc2

