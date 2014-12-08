Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756130AbaLHRGJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 12:06:09 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:34656 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbaLHRGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 12:06:07 -0500
X-AuditID: cbfee61a-f79c06d000004e71-1f-5485da7d2a5a
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
Subject: [PATCH v3 1/5] thermal: of: Extend of-thermal.c to provide number of
 trip points
Date: Mon, 08 Dec 2014 18:04:17 +0100
Message-id: <1418058261-25251-2-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1418058261-25251-1-git-send-email-l.majewski@samsung.com>
References: <1416500488-7232-1-git-send-email-l.majewski@samsung.com>
 <1418058261-25251-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPLMWRmVeSWpSXmKPExsVy+t9jAd3aW60hBueeGVg8XrOYyWLjjPWs
	Fl8+97FZzL9yjdVizV8lizePuC3ePNzMaHF51xw2i8+9Rxgtniw8w2Tx4Oo0Not9a5YyWTx5
	CFT/6mAbi8XPXfNYHPg9ds66y+6xeM9LJo91094ye/Q2v2Pz+DtrP4vHzu8N7B59W1Yxenze
	JOexcW5oAGcUl01Kak5mWWqRvl0CV0bP7gtsBdOEKs59ncXawDifv4uRk0NCwETi7o49jBC2
	mMSFe+vZuhi5OIQEFjFK9LUvZ4FwupgkOtYtYgGpYhPQk/h89ykTiC0i4C3xet90RpAiZoE1
	LBIfrt5lA0kIC0RL9O28DjaWRUBVYtLzeewgNq+Am8TcPW9YIdYpSnQ/mwBWzyngLnH+3nVW
	iG1NjBKXd+xkmcDIu4CRYRWjaGpBckFxUnquoV5xYm5xaV66XnJ+7iZGcDA/k9rBuLLB4hCj
	AAejEg/vggctIUKsiWXFlbmHGCU4mJVEeJfvbA0R4k1JrKxKLcqPLyrNSS0+xCjNwaIkznvj
	Zm6IkEB6YklqdmpqQWoRTJaJg1OqgTHDOEcjY/n++kNffB8WReyOuGX1YuJW6TPWH2u/p0t+
	VbpksvuBy9GMbxHr3Nf+imLZMe3Tci2xsPkKc2uSfu2SFnhrqMG0YP218rOPRFq667ksk1e9
	Kvkm7GV5zOWsUY+EZY5Ojd/urpsCVWs6WplTnz8rffoyTL1vxrvOReaHr4ltvJWUfUmJpTgj
	0VCLuag4EQDg9OBLYgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch extends the of-thermal.c to provide information about number of
available trip points.

Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
---
Changes for v3:
- Exporting of_thermal_get_ntrips symbol as a GPL
- Fix build error when CONFIG_THERMAL_OF is disabled

Changes for v2:
- Provide detailed (doxygen like) description of the of_thermal_get_ntrips()
  method
- Check for data pointer not being NULL
---
 drivers/thermal/of-thermal.c   | 21 +++++++++++++++++++++
 drivers/thermal/thermal_core.h |  5 +++++
 2 files changed, 26 insertions(+)

diff --git a/drivers/thermal/of-thermal.c b/drivers/thermal/of-thermal.c
index b7982f0..7facd23 100644
--- a/drivers/thermal/of-thermal.c
+++ b/drivers/thermal/of-thermal.c
@@ -112,6 +112,27 @@ static int of_thermal_get_temp(struct thermal_zone_device *tz,
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
+EXPORT_SYMBOL_GPL(of_thermal_get_ntrips);
+
 static int of_thermal_get_trend(struct thermal_zone_device *tz, int trip,
 				enum thermal_trend *trend)
 {
diff --git a/drivers/thermal/thermal_core.h b/drivers/thermal/thermal_core.h
index d15d243..1cc5041 100644
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
+static inline int of_thermal_get_ntrips(struct thermal_zone_device *tz)
+{
+	return 0;
+}
 #endif
 
 #endif /* __THERMAL_CORE_H__ */
-- 
2.0.0.rc2

