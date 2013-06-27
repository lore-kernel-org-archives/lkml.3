Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753689Ab3F0NIo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 09:08:44 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:48951 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752708Ab3F0Mue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 08:50:34 -0400
From: Nick Dyer <nick.dyer@itdev.co.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Daniel Kurtz <djkurtz@chromium.org>, Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Alan Bowens <Alan.Bowens@atmel.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Meerwald <pmeerw@pmeerw.net>,
        Benson Leung <bleung@chromium.org>,
        Olof Johansson <olofj@chromium.org>, Nick Dyer <nick.dyer@itdev.co.uk>
Subject: [PATCH 04/51] Input: atmel_mxt_ts - define helper functions for size and instances
Date: Thu, 27 Jun 2013 13:48:39 +0100
Message-Id: <1372337366-9286-5-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1372337366-9286-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1372337366-9286-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Kurtz <djkurtz@chromium.org>

These two object table entry fields are reported 1 less than their value.
When used, however, we always want the actual size and instances.

To keep the object size and instances 1-byte fields, and thus preserve
the object-table struct's 6-byte packed alignment, add some convenient
accessor functions that do the +1 every time these fields are accessed.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
Acked-by: Benson Leung <bleung@chromium.org>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |   35 ++++++++++++++++++++----------
 1 file changed, 24 insertions(+), 11 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 2a06657..7de3b47 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -2,6 +2,8 @@
  * Atmel maXTouch Touchscreen driver
  *
  * Copyright (C) 2010 Samsung Electronics Co.Ltd
+ * Copyright (C) 2012 Google, Inc.
+ *
  * Author: Joonyoung Shim <jy0922.shim@samsung.com>
  *
  * This program is free software; you can redistribute  it and/or modify it
@@ -227,8 +229,8 @@ struct mxt_info {
 struct mxt_object {
 	u8 type;
 	u16 start_address;
-	u8 size;		/* Size of each instance - 1 */
-	u8 instances;		/* Number of instances - 1 */
+	u8 size_minus_one;
+	u8 instances_minus_one;
 	u8 num_report_ids;
 } __packed;
 
@@ -257,6 +259,16 @@ struct mxt_data {
 	u8 T19_reportid;
 };
 
+static inline size_t mxt_obj_size(const struct mxt_object *obj)
+{
+	return obj->size_minus_one + 1;
+}
+
+static inline size_t mxt_obj_instances(const struct mxt_object *obj)
+{
+	return obj->instances_minus_one + 1;
+}
+
 static bool mxt_object_readable(unsigned int type)
 {
 	switch (type) {
@@ -499,7 +511,7 @@ static int mxt_write_object(struct mxt_data *data,
 	u16 reg;
 
 	object = mxt_get_object(data, type);
-	if (!object || offset >= object->size + 1)
+	if (!object || offset >= mxt_obj_size(object))
 		return -EINVAL;
 
 	reg = object->start_address;
@@ -641,7 +653,7 @@ static int mxt_check_reg_init(struct mxt_data *data)
 		if (!mxt_object_writable(object->type))
 			continue;
 
-		size = (object->size + 1) * (object->instances + 1);
+		size = mxt_obj_size(object) * mxt_obj_instances(object);
 		if (index + size > pdata->config_length) {
 			dev_err(dev, "Not enough config data!\n");
 			return -EINVAL;
@@ -718,7 +730,7 @@ static int mxt_get_object_table(struct mxt_data *data)
 		if (object->num_report_ids) {
 			min_id = reportid;
 			reportid += object->num_report_ids *
-					(object->instances + 1);
+					mxt_obj_instances(object);
 			max_id = reportid - 1;
 		} else {
 			min_id = 0;
@@ -727,8 +739,9 @@ static int mxt_get_object_table(struct mxt_data *data)
 
 		dev_dbg(&data->client->dev,
 			"Type %2d Start %3d Size %3d Instances %2d ReportIDs %3u : %3u\n",
-			object->type, object->start_address, object->size + 1,
-			object->instances + 1, min_id, max_id);
+			object->type, object->start_address,
+			mxt_obj_size(object), mxt_obj_instances(object),
+			min_id, max_id);
 
 		switch (object->type) {
 		case MXT_GEN_COMMAND_T6:
@@ -865,11 +878,11 @@ static ssize_t mxt_show_instance(char *buf, int count,
 {
 	int i;
 
-	if (object->instances > 0)
+	if (mxt_obj_instances(object) > 1)
 		count += scnprintf(buf + count, PAGE_SIZE - count,
 				   "Instance %u\n", instance);
 
-	for (i = 0; i < object->size + 1; i++)
+	for (i = 0; i < mxt_obj_size(object); i++)
 		count += scnprintf(buf + count, PAGE_SIZE - count,
 				"\t[%2u]: %02x (%d)\n", i, val[i], val[i]);
 	count += scnprintf(buf + count, PAGE_SIZE - count, "\n");
@@ -902,8 +915,8 @@ static ssize_t mxt_object_show(struct device *dev,
 		count += scnprintf(buf + count, PAGE_SIZE - count,
 				"T%u:\n", object->type);
 
-		for (j = 0; j < object->instances + 1; j++) {
-			u16 size = object->size + 1;
+		for (j = 0; j < mxt_obj_instances(object); j++) {
+			u16 size = mxt_obj_size(object);
 			u16 addr = object->start_address + j * size;
 
 			error = __mxt_read_reg(data->client, addr, size, obuf);
-- 
1.7.10.4

