Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936Ab3LPRmR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 12:42:17 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:44587 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754565Ab3LPRmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 12:42:15 -0500
From: Stephen Warren <swarren@wwwdotorg.org>
To: Alessandro Zummo <a.zummo@towertech.it>, akpm@linux-foundation.org
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH REPOST] rtc: honor device tree /alias entries when assigning IDs
Date: Mon, 16 Dec 2013 10:42:07 -0700
Message-Id: <1387215727-20493-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.8.1.5
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

Assign RTC device IDs based on device tree /aliases entries if present,
falling back to the existing numbering scheme if there is no /aliases
entry (which includes when the system isn't booted using DT), or there
is a numbering conflict.

This is useful in systems with multiple RTC devices, to ensure that the
best RTC device is selected as /dev/rtc0, which provides the overall
system time.

For example, Tegra has an on-SoC RTC that is not battery backed,
typically coupled with an off-SoC RTC that is battery backed. Only the
latter is useful for populating the system time, yet the former is
useful e.g. for wakeup timing, since the time is not lost when the
system is sleeps.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
The 3 patches in this series are all independent; they can be applied
to their respective subsystems in any order. I'm simply posting them as
a series to make the use-case more obvious.
---
 drivers/rtc/class.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/rtc/class.c b/drivers/rtc/class.c
index 02426812bebc..7989b5d030cb 100644
--- a/drivers/rtc/class.c
+++ b/drivers/rtc/class.c
@@ -14,6 +14,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/module.h>
+#include <linux/of.h>
 #include <linux/rtc.h>
 #include <linux/kdev_t.h>
 #include <linux/idr.h>
@@ -157,12 +158,25 @@ struct rtc_device *rtc_device_register(const char *name, struct device *dev,
 {
 	struct rtc_device *rtc;
 	struct rtc_wkalrm alrm;
-	int id, err;
+	int of_id, id = -1, err;
+
+	if (dev->of_node) {
+		of_id = of_alias_get_id(dev->of_node, "rtc");
+		if (of_id >= 0) {
+			id = ida_simple_get(&rtc_ida, of_id, of_id + 1,
+					    GFP_KERNEL);
+			if (id < 0)
+				dev_warn(dev, "/aliases ID %d not available\n",
+					 of_id);
+		}
+	}
 
-	id = ida_simple_get(&rtc_ida, 0, 0, GFP_KERNEL);
 	if (id < 0) {
-		err = id;
-		goto exit;
+		id = ida_simple_get(&rtc_ida, 0, 0, GFP_KERNEL);
+		if (id < 0) {
+			err = id;
+			goto exit;
+		}
 	}
 
 	rtc = kzalloc(sizeof(struct rtc_device), GFP_KERNEL);
-- 
1.8.1.5

