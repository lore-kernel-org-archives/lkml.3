Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966Ab3LBTiV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:38:21 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39577 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754904Ab3LBTSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:18:49 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 3.12 179/212] HID: hid-sensor-hub: fix report size
Date: Mon,  2 Dec 2013 11:16:10 -0800
Message-Id: <20131202191308.387638867@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191248.517975703@linuxfoundation.org>
References: <20131202191248.517975703@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hid-sensor-hub.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/drivers/hid/hid-sensor-hub.c
+++ b/drivers/hid/hid-sensor-hub.c
@@ -326,7 +326,8 @@ int sensor_hub_input_get_attribute_info(
 				field->logical == attr_usage_id) {
 				sensor_hub_fill_attr_info(info, i, report->id,
 					field->unit, field->unit_exponent,
-					field->report_size);
+					field->report_size *
+							field->report_count);
 				ret = 0;
 			} else {
 				for (j = 0; j < field->maxusage; ++j) {
@@ -338,7 +339,8 @@ int sensor_hub_input_get_attribute_info(
 							i, report->id,
 							field->unit,
 							field->unit_exponent,
-							field->report_size);
+							field->report_size *
+							field->report_count);
 						ret = 0;
 						break;
 					}
@@ -425,9 +427,10 @@ static int sensor_hub_raw_event(struct h
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


