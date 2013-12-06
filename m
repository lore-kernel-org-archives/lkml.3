Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758562Ab3LFNiS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:38:18 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44302 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757984Ab3LFNDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:03:00 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Jiri Kosina <jkosina@suse.cz>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 156/272] HID: hid-sensor-hub: fix report size
Date: Fri,  6 Dec 2013 12:57:25 +0000
Message-Id: <1386334761-25517-157-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

commit d4b1bba76171cb783e32441b28462fe841073ed8 upstream.

Most of the hid sensor field size is reported in report_size field
in the report descriptor. For rotation fusion sensor the quaternion
data is 16 byte field, the report size was set to 4 and report
count field is set to 4. So the total size is 16 bytes. But the current
driver has a bug and not taking account for report count field. This
causes user space to see only 4 bytes of data sent via IIO interface.
The number of bytes in a field needs to take account of report_count
field. Need to multiply report_size and report_count to get total
number of bytes.

Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/hid/hid-sensor-hub.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/hid/hid-sensor-hub.c b/drivers/hid/hid-sensor-hub.c
index aa34755..b189feb 100644
--- a/drivers/hid/hid-sensor-hub.c
+++ b/drivers/hid/hid-sensor-hub.c
@@ -327,7 +327,8 @@ int sensor_hub_input_get_attribute_info(struct hid_sensor_hub_device *hsdev,
 				field->logical == attr_usage_id) {
 				sensor_hub_fill_attr_info(info, i, report->id,
 					field->unit, field->unit_exponent,
-					field->report_size);
+					field->report_size *
+							field->report_count);
 				ret = 0;
 			} else {
 				for (j = 0; j < field->maxusage; ++j) {
@@ -339,7 +340,8 @@ int sensor_hub_input_get_attribute_info(struct hid_sensor_hub_device *hsdev,
 							i, report->id,
 							field->unit,
 							field->unit_exponent,
-							field->report_size);
+							field->report_size *
+							field->report_count);
 						ret = 0;
 						break;
 					}
@@ -426,9 +428,10 @@ static int sensor_hub_raw_event(struct hid_device *hdev,
 		hid_dbg(hdev, "%d collection_index:%x hid:%x sz:%x\n",
 				i, report->field[i]->usage->collection_index,
 				report->field[i]->usage->hid,
-				report->field[i]->report_size/8);
-
-		sz = report->field[i]->report_size/8;
+				(report->field[i]->report_size *
+					report->field[i]->report_count)/8);
+		sz = (report->field[i]->report_size *
+					report->field[i]->report_count)/8;
 		if (pdata->pending.status && pdata->pending.attr_usage_id ==
 				report->field[i]->usage->hid) {
 			hid_dbg(hdev, "data was pending ...\n");
-- 
1.8.3.2

