Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756747Ab3IYAUt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 20:20:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39712 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756656Ab3IYAUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:20:45 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Richard Ryniker <ryniker@alum.mit.edu>,
        Alan Stern <stern@rowland.harvard.edu>, Jiri Kosina <jkosina@suse.cz>
Subject: [ 080/117] HID: battery: dont do DMA from stack
Date: Tue, 24 Sep 2013 17:19:06 -0700
Message-Id: <20130925001749.699707899@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130925001740.833541979@linuxfoundation.org>
References: <20130925001740.833541979@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Kosina <jkosina@suse.cz>

commit 6c2794a2984f4c17a58117a68703cc7640f01c5a upstream.

Instead of using data from stack for DMA in hidinput_get_battery_property(),
allocate the buffer dynamically.

Reported-by: Richard Ryniker <ryniker@alum.mit.edu>
Reported-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hid-input.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -340,7 +340,7 @@ static int hidinput_get_battery_property
 {
 	struct hid_device *dev = container_of(psy, struct hid_device, battery);
 	int ret = 0;
-	__u8 buf[2] = {};
+	__u8 *buf;
 
 	switch (prop) {
 	case POWER_SUPPLY_PROP_PRESENT:
@@ -349,12 +349,19 @@ static int hidinput_get_battery_property
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
@@ -364,6 +371,7 @@ static int hidinput_get_battery_property
 		    buf[1] <= dev->battery_max)
 			val->intval = (100 * (buf[1] - dev->battery_min)) /
 				(dev->battery_max - dev->battery_min);
+		kfree(buf);
 		break;
 
 	case POWER_SUPPLY_PROP_MODEL_NAME:


