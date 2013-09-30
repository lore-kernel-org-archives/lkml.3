Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756286Ab3I3KVt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 06:21:49 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43706 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755681Ab3I3KNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 06:13:09 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jiri Kosina <jkosina@suse.cz>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 074/104] HID: battery: don't do DMA from stack
Date: Mon, 30 Sep 2013 11:10:51 +0100
Message-Id: <1380535881-9239-75-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
References: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.22 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Kosina <jkosina@suse.cz>

commit 6c2794a2984f4c17a58117a68703cc7640f01c5a upstream.

Instead of using data from stack for DMA in hidinput_get_battery_property(),
allocate the buffer dynamically.

Reported-by: Richard Ryniker <ryniker@alum.mit.edu>
Reported-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/hid/hid-input.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index 73f2f7c..c460b74 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -325,7 +325,7 @@ static int hidinput_get_battery_property(struct power_supply *psy,
 {
 	struct hid_device *dev = container_of(psy, struct hid_device, battery);
 	int ret = 0;
-	__u8 buf[2] = {};
+	__u8 *buf;
 
 	switch (prop) {
 	case POWER_SUPPLY_PROP_PRESENT:
@@ -334,12 +334,19 @@ static int hidinput_get_battery_property(struct power_supply *psy,
 		break;
 
 	case POWER_SUPPLY_PROP_CAPACITY:
+
+		buf = kmalloc(2 * sizeof(__u8), GFP_KERNEL);
+		if (!buf) {
+			ret = -ENOMEM;
+			break;
+		}
 		ret = dev->hid_get_raw_report(dev, dev->battery_report_id,
-					      buf, sizeof(buf),
+					      buf, 2,
 					      dev->battery_report_type);
 
 		if (ret != 2) {
 			ret = -ENODATA;
+			kfree(buf);
 			break;
 		}
 		ret = 0;
@@ -349,6 +356,7 @@ static int hidinput_get_battery_property(struct power_supply *psy,
 		    buf[1] <= dev->battery_max)
 			val->intval = (100 * (buf[1] - dev->battery_min)) /
 				(dev->battery_max - dev->battery_min);
+		kfree(buf);
 		break;
 
 	case POWER_SUPPLY_PROP_MODEL_NAME:
-- 
1.8.3.2

