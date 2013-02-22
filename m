Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759359Ab3BVSOd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 13:14:33 -0500
Received: from [89.21.227.133] ([89.21.227.133]:47683 "EHLO
	mail.kdh.itdev.co.uk" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759030Ab3BVSId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 13:08:33 -0500
From: Nick Dyer <nick.dyer@itdev.co.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>, Alan.Bowens@atmel.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        pmeerw@pmeerw.net, bleung@chromium.org, olofj@chromium.org
Cc: Nick Dyer <nick.dyer@itdev.co.uk>
Subject: [PATCH 02/40] Input: atmel_mxt_ts - add macros for object instances and size
Date: Fri, 22 Feb 2013 17:57:49 +0000
Message-Id: <1361555907-19840-3-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1361555907-19840-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1361555907-19840-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The raw Atmel Object Based Protocol stores the instances and size minus one as
an efficiency measure. This can easily lead to bugs. Rename the variables to
make it clear what they are and implement macros for the conversion.

Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |   25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index b4bf946..1de1d24 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -216,6 +216,9 @@
 /* Touchscreen absolute values */
 #define MXT_MAX_AREA		0xff
 
+#define OBP_INSTANCES(o) ((u16)((o)->instances_minus_one) + 1)
+#define OBP_SIZE(o) ((u16)((o)->size_minus_one) + 1)
+
 struct mxt_info {
 	u8 family_id;
 	u8 variant_id;
@@ -229,8 +232,8 @@ struct mxt_info {
 struct mxt_object {
 	u8 type;
 	u16 start_address;
-	u8 size;		/* Size of each instance - 1 */
-	u8 instances;		/* Number of instances - 1 */
+	u8 size_minus_one;
+	u8 instances_minus_one;
 	u8 num_report_ids;
 } __packed;
 
@@ -500,7 +503,7 @@ static int mxt_write_object(struct mxt_data *data,
 	u16 reg;
 
 	object = mxt_get_object(data, type);
-	if (!object || offset >= object->size + 1)
+	if (!object || offset >= OBP_SIZE(object))
 		return -EINVAL;
 
 	reg = object->start_address;
@@ -684,7 +687,7 @@ static int mxt_check_reg_init(struct mxt_data *data)
 		if (!mxt_object_writable(object->type))
 			continue;
 
-		size = (object->size + 1) * (object->instances + 1);
+		size = OBP_SIZE(object) * OBP_INSTANCES(object);
 		if (index + size > pdata->config_length) {
 			dev_err(dev, "Not enough config data!\n");
 			return -EINVAL;
@@ -809,7 +812,7 @@ static int mxt_get_object_table(struct mxt_data *data)
 		if (object->num_report_ids) {
 			min_id = reportid;
 			reportid += object->num_report_ids *
-					(object->instances + 1);
+					OBP_INSTANCES(object);
 			max_id = reportid - 1;
 		} else {
 			min_id = 0;
@@ -818,8 +821,8 @@ static int mxt_get_object_table(struct mxt_data *data)
 
 		dev_dbg(&data->client->dev,
 			"Type %2d Start %3d Size %3d Instances %2d ReportIDs %3u : %3u\n",
-			object->type, object->start_address, object->size + 1,
-			object->instances + 1, min_id, max_id);
+			object->type, object->start_address, OBP_SIZE(object),
+			OBP_INSTANCES(object), min_id, max_id);
 
 		switch (object->type) {
 		case MXT_GEN_COMMAND_T6:
@@ -949,11 +952,11 @@ static ssize_t mxt_show_instance(char *buf, int count,
 {
 	int i;
 
-	if (object->instances > 0)
+	if (OBP_INSTANCES(object) > 1)
 		count += scnprintf(buf + count, PAGE_SIZE - count,
 				   "Instance %u\n", instance);
 
-	for (i = 0; i < object->size + 1; i++)
+	for (i = 0; i < OBP_SIZE(object); i++)
 		count += scnprintf(buf + count, PAGE_SIZE - count,
 				"\t[%2u]: %02x (%d)\n", i, val[i], val[i]);
 	count += scnprintf(buf + count, PAGE_SIZE - count, "\n");
@@ -986,8 +989,8 @@ static ssize_t mxt_object_show(struct device *dev,
 		count += scnprintf(buf + count, PAGE_SIZE - count,
 				"T%u:\n", object->type);
 
-		for (j = 0; j < object->instances + 1; j++) {
-			u16 size = object->size + 1;
+		for (j = 0; j < OBP_INSTANCES(object); j++) {
+			u16 size = OBP_SIZE(object);
 			u16 addr = object->start_address + j * size;
 
 			error = __mxt_read_reg(data->client, addr, size, obuf);
-- 
1.7.10.4

