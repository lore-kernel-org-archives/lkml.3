Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932082Ab3ITU15 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 16:27:57 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41524 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754646Ab3ITUNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 16:13:08 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jiri Kosina <jkosina@suse.cz>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 58/93] HID: battery: don't do DMA from stack
Date: Fri, 20 Sep 2013 13:08:53 -0700
Message-Id: <1379707768-1804-59-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379707768-1804-1-git-send-email-kamal@canonical.com>
References: <1379707768-1804-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Kosina <jkosina@suse.cz>

commit 6c2794a2984f4c17a58117a68703cc7640f01c5a upstream.

Instead of using data from stack for DMA in hidinput_get_battery_property(),
allocate the buffer dynamically.

Reported-by: Richard Ryniker <ryniker@alum.mit.edu>
Reported-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
[ kamal: backport to 3.8 (context) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/hid/hid-input.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index 21b196c..f495ada 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -340,7 +340,7 @@ static int hidinput_get_battery_property(struct power_supply *psy,
 {
 	struct hid_device *dev = container_of(psy, struct hid_device, battery);
 	int ret = 0;
-	__u8 buf[2] = {};
+	__u8 *buf;
 
 	switch (prop) {
 	case POWER_SUPPLY_PROP_PRESENT:
@@ -349,13 +349,19 @@ static int hidinput_get_battery_property(struct power_supply *psy,
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
-			if (ret >= 0)
-				ret = -EINVAL;
+			ret = -ENODATA;
+			kfree(buf);
 			break;
 		}
 
@@ -364,6 +370,7 @@ static int hidinput_get_battery_property(struct power_supply *psy,
 		    buf[1] <= dev->battery_max)
 			val->intval = (100 * (buf[1] - dev->battery_min)) /
 				(dev->battery_max - dev->battery_min);
+		kfree(buf);
 		break;
 
 	case POWER_SUPPLY_PROP_MODEL_NAME:
-- 
1.8.1.2

