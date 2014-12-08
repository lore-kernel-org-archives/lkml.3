Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140AbaLHRG5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 12:06:57 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:42916 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbaLHRG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 12:06:56 -0500
X-AuditID: cbfee61a-f79c06d000004e71-9e-5485daae8a34
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
        navneet kumar <navneetk@nvidia.com>,
        Lukasz Majewski <l.majewski@samsung.com>
Subject: [PATCH v3 2/5] thermal: of: Extend of-thermal.c to provide check if
 trip point is valid
Date: Mon, 08 Dec 2014 18:04:18 +0100
Message-id: <1418058261-25251-3-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1418058261-25251-1-git-send-email-l.majewski@samsung.com>
References: <1416500488-7232-1-git-send-email-l.majewski@samsung.com>
 <1418058261-25251-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPLMWRmVeSWpSXmKPExsVy+t9jAd11t1pDDLofC1k8XrOYyWLjjPWs
	Fl8+97FZzL9yjdVizV8lizePuC3ePNzMaHF51xw2i8+9Rxgtniw8w2Tx4Oo0Not9a5YyWTx5
	CFT/6mAbi8XPXfNYHPg9ds66y+6xeM9LJo91094ye/Q2v2Pz+DtrP4vHzu8N7B59W1Yxenze
	JOexcW5oAGcUl01Kak5mWWqRvl0CV8b5Y3eYC14LV3R+WcrewHhUoIuRk0NCwETi+/u1jBC2
	mMSFe+vZuhi5OIQEFjFK7F79ghnC6WKSuDKtkwWkik1AT+Lz3adMILaIgLfE633TGUGKmAXW
	sEh8uHqXDSQhLJAksejjSjCbRUBVYuuaPWA2r4CbxPrD+6HWKUp0P5sAFucUcJc4f+86K8S2
	JkaJyzt2skxg5F3AyLCKUTS1ILmgOCk911CvODG3uDQvXS85P3cTIziYn0ntYFzZYHGIUYCD
	UYmHd8GDlhAh1sSy4srcQ4wSHMxKIrzLd7aGCPGmJFZWpRblxxeV5qQWH2KU5mBREue9cTM3
	REggPbEkNTs1tSC1CCbLxMEp1cBYsqMwUbdGWPtFTLrK3qKXDfyByueWpLskydyc57IgOuh1
	y6IFLx1qpv3LerU30TVj2/+Qz8/0BW1ShIo3fJl4L/CSlk5X0tP5R6ZuV8rL/KF5wH/9nDTm
	G22n/XtmbcucGHkwZs23a2Yt2huu/7d1XuY2c++uS/vkRETmHs7jvqNd8jDcKfa4EktxRqKh
	FnNRcSIAm5oWQGICAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch extends the of-thermal.c to provide check if trip point is
valid.

Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
---
Changes for v3:
- Rename of_thermal_is_trip_en() to of_thermal_is_trip_valid()
- Export of_thermal_is_trip_valid symbol as GPL
- Fix the build error when CONFIG_THERMAL_OF is not defined

Changes for v2:
- Replace int with bool
- Replace 1/0 with true/false
- Add check if data pointer is not NULL
- Add missing doxygen style comment for the function
---
 drivers/thermal/of-thermal.c   | 21 +++++++++++++++++++++
 drivers/thermal/thermal_core.h |  6 ++++++
 2 files changed, 27 insertions(+)

diff --git a/drivers/thermal/of-thermal.c b/drivers/thermal/of-thermal.c
index 7facd23..87b9cfe 100644
--- a/drivers/thermal/of-thermal.c
+++ b/drivers/thermal/of-thermal.c
@@ -133,6 +133,27 @@ int of_thermal_get_ntrips(struct thermal_zone_device *tz)
 }
 EXPORT_SYMBOL_GPL(of_thermal_get_ntrips);
 
+/**
+ * of_thermal_is_trip_valid - function to check if trip point is valid
+ *
+ * @tz:	pointer to a thermal zone
+ * @trip:	trip point to evaluate
+ *
+ * This function is responsible for checking if passed trip point is valid
+ *
+ * Return: true if trip point is valid, false otherwise
+ */
+bool of_thermal_is_trip_valid(struct thermal_zone_device *tz, int trip)
+{
+	struct __thermal_zone *data = tz->devdata;
+
+	if (!data || trip >= data->ntrips || trip < 0)
+		return false;
+
+	return true;
+}
+EXPORT_SYMBOL_GPL(of_thermal_is_trip_valid);
+
 static int of_thermal_get_trend(struct thermal_zone_device *tz, int trip,
 				enum thermal_trend *trend)
 {
diff --git a/drivers/thermal/thermal_core.h b/drivers/thermal/thermal_core.h
index 1cc5041..58a0dfa 100644
--- a/drivers/thermal/thermal_core.h
+++ b/drivers/thermal/thermal_core.h
@@ -90,6 +90,7 @@ static inline void thermal_gov_user_space_unregister(void) {}
 int of_parse_thermal_zones(void);
 void of_thermal_destroy_zones(void);
 int of_thermal_get_ntrips(struct thermal_zone_device *);
+bool of_thermal_is_trip_valid(struct thermal_zone_device *, int);
 #else
 static inline int of_parse_thermal_zones(void) { return 0; }
 static inline void of_thermal_destroy_zones(void) { }
@@ -97,6 +98,11 @@ static inline int of_thermal_get_ntrips(struct thermal_zone_device *tz)
 {
 	return 0;
 }
+static inline bool of_thermal_is_trip_valid(struct thermal_zone_device *tz,
+					    int trip)
+{
+	return 0;
+}
 #endif
 
 #endif /* __THERMAL_CORE_H__ */
-- 
2.0.0.rc2

