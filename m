Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174AbaLHRHP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 12:07:15 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:60009 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbaLHRHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 12:07:11 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-b5-5485dabd25d8
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
Subject: [PATCH v3 4/5] thermal: of: Extend of-thermal to export table of trip
 points
Date: Mon, 08 Dec 2014 18:04:20 +0100
Message-id: <1418058261-25251-5-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1418058261-25251-1-git-send-email-l.majewski@samsung.com>
References: <1416500488-7232-1-git-send-email-l.majewski@samsung.com>
 <1418058261-25251-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHLMWRmVeSWpSXmKPExsVy+t9jAd19t1pDDK73MFo8XrOYyWLjjPWs
	Fl8+97FZzL9yjdVizV8lizePuC3ePNzMaHF51xw2i8+9Rxgtniw8w2Tx4Oo0Not9a5YyWTx5
	CFT/6mAbi8XPXfNYHPg9ds66y+6xeM9LJo91094ye/Q2v2Pz+DtrP4vHzu8N7B59W1Yxenze
	JOexcW5oAGcUl01Kak5mWWqRvl0CV8biw5eZC14KVzz58ZS1gfGqQBcjJ4eEgInE3zNNjBC2
	mMSFe+vZuhi5OIQEFjFK3Fh0ngnC6WKS2LTxL1gVm4CexOe7T5lAbBEBb4nX+6YzghQxC6xh
	kfhw9S4bSEJYIFzi0/EdYDaLgKrE9OUzgYo4OHgF3CQavitDbFOU6H42AayEU8Bd4vy966wQ
	y5oYJS7v2MkygZF3ASPDKkbR1ILkguKk9FwjveLE3OLSvHS95PzcTYzgUH4mvYNxVYPFIUYB
	DkYlHt6FD1pChFgTy4orcw8xSnAwK4nwLt/ZGiLEm5JYWZValB9fVJqTWnyIUZqDRUmc98bN
	3BAhgfTEktTs1NSC1CKYLBMHp1QDI9dtFufTUw7McOE4u3tNtvTalTWmm5+cvBJ353uf5Jdz
	Cb9/f41Yv696tvmy2kqzPlm2pMO1CVdFf6te/nH1n8o2ras9jz02GaV9CfKbUOH6g+2q8o/o
	sJXy8fKOmtO9He7bGipZrg9dPy9xS4LRp2Sdxyfv/2mVKD/InZ4genN1+52PLdOWxCuxFGck
	GmoxFxUnAgByPrG4YQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch extends the of-thermal.c to export trip points for a given
thermal zone.

Thermal drivers should use of_thermal_get_trip_points() method to get
pointer to table of thermal trip points.

Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
---
Changes for v3:
- Export of_thermal_get_trip_points symbol as GPL
- Fix the build error when CONFIG_THERMAL_OF is not defined

Changes for v2:
- New patch - as suggested by Eduardo Valentin
---
 drivers/thermal/of-thermal.c   | 22 ++++++++++++++++++++++
 drivers/thermal/thermal_core.h |  7 +++++++
 2 files changed, 29 insertions(+)

diff --git a/drivers/thermal/of-thermal.c b/drivers/thermal/of-thermal.c
index d3ac117..e062bf5 100644
--- a/drivers/thermal/of-thermal.c
+++ b/drivers/thermal/of-thermal.c
@@ -139,6 +139,28 @@ bool of_thermal_is_trip_valid(struct thermal_zone_device *tz, int trip)
 }
 EXPORT_SYMBOL_GPL(of_thermal_is_trip_valid);
 
+/**
+ * of_thermal_get_trip_points - function to get access to a globally exported
+ *				trip points
+ *
+ * @tz:	pointer to a thermal zone
+ *
+ * This function provides a pointer to trip points table
+ *
+ * Return: pointer to trip points table, NULL otherwise
+ */
+const struct thermal_trip * const
+of_thermal_get_trip_points(struct thermal_zone_device *tz)
+{
+	struct __thermal_zone *data = tz->devdata;
+
+	if (!data)
+		return NULL;
+
+	return data->trips;
+}
+EXPORT_SYMBOL_GPL(of_thermal_get_trip_points);
+
 static int of_thermal_get_trend(struct thermal_zone_device *tz, int trip,
 				enum thermal_trend *trend)
 {
diff --git a/drivers/thermal/thermal_core.h b/drivers/thermal/thermal_core.h
index 58a0dfa..9083e75 100644
--- a/drivers/thermal/thermal_core.h
+++ b/drivers/thermal/thermal_core.h
@@ -91,6 +91,8 @@ int of_parse_thermal_zones(void);
 void of_thermal_destroy_zones(void);
 int of_thermal_get_ntrips(struct thermal_zone_device *);
 bool of_thermal_is_trip_valid(struct thermal_zone_device *, int);
+const struct thermal_trip * const
+of_thermal_get_trip_points(struct thermal_zone_device *);
 #else
 static inline int of_parse_thermal_zones(void) { return 0; }
 static inline void of_thermal_destroy_zones(void) { }
@@ -103,6 +105,11 @@ static inline bool of_thermal_is_trip_valid(struct thermal_zone_device *tz,
 {
 	return 0;
 }
+static inline const struct thermal_trip * const
+of_thermal_get_trip_points(struct thermal_zone_device *tz)
+{
+	return NULL;
+}
 #endif
 
 #endif /* __THERMAL_CORE_H__ */
-- 
2.0.0.rc2

