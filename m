Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758217Ab3HMO7J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 10:59:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758107Ab3HMO63 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 10:58:29 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Alexander Holler <holler@ahsoftware.de>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] HID: Use existing parser for pre-scanning the report descriptors
Date: Tue, 13 Aug 2013 16:58:07 +0200
Message-Id: <1376405889-12378-2-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1376405889-12378-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1376405889-12378-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hid_scan_report() implements its own HID report descriptor parsing. It was
fine until we added the SENSOR_HUB detection. It is going to be even worse
with the detection of Win 8 certified touchscreen, as this detection
relies on a special feature and on the report_size and report_count fields.

We can use the existing HID parser in hid-core for hid_scan_report()
by re-using the code from hid_open_report(). hid_parser_global,
hid_parser_local and hid_parser_reserved does not have any side effects.
We just need to reimplement the MAIN_ITEM callback to have a proper
parsing without side effects.

Instead of directly overwriting the ->group field, this patch introduce
a ->flags field and then decide which group the device belongs to,
depending on the whole parsing (not just the local item). This will be
useful for Win 8 multitouch devices, which are multitouch devices and
Win 8 certified (so 2 flags to check).

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/hid/hid-core.c | 131 +++++++++++++++++++++++++++++++++++--------------
 include/linux/hid.h    |   4 ++
 2 files changed, 97 insertions(+), 38 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 3efe19f..d8cdb0a 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -677,10 +677,49 @@ static u8 *fetch_item(__u8 *start, __u8 *end, struct hid_item *item)
 	return NULL;
 }
 
-static void hid_scan_usage(struct hid_device *hid, u32 usage)
+static void hid_scan_input_usage(struct hid_parser *parser, u32 usage)
 {
 	if (usage == HID_DG_CONTACTID)
-		hid->group = HID_GROUP_MULTITOUCH;
+		parser->flags |= HID_FLAG_MULTITOUCH;
+}
+
+static void hid_scan_open_collection(struct hid_parser *parser, unsigned type)
+{
+	if (parser->global.usage_page == HID_UP_SENSOR &&
+	    type == HID_COLLECTION_PHYSICAL)
+		parser->flags |= HID_FLAG_SENSOR_HUB;
+}
+
+static int hid_scan_main(struct hid_parser *parser, struct hid_item *item)
+{
+	__u32 data;
+	int i;
+
+	data = item_udata(item);
+
+	switch (item->tag) {
+	case HID_MAIN_ITEM_TAG_BEGIN_COLLECTION:
+		hid_scan_open_collection(parser, data & 0xff);
+		break;
+	case HID_MAIN_ITEM_TAG_END_COLLECTION:
+		break;
+	case HID_MAIN_ITEM_TAG_INPUT:
+		for (i = 0; i < parser->local.usage_index; i++)
+			hid_scan_input_usage(parser, parser->local.usage[i]);
+		break;
+	case HID_MAIN_ITEM_TAG_OUTPUT:
+		break;
+	case HID_MAIN_ITEM_TAG_FEATURE:
+		break;
+	default:
+		hid_err(parser->device, "unknown main item tag 0x%x\n",
+			item->tag);
+	}
+
+	/* Reset the local parser environment */
+	memset(&parser->local, 0, sizeof(parser->local));
+
+	return 0;
 }
 
 /*
@@ -690,49 +729,65 @@ static void hid_scan_usage(struct hid_device *hid, u32 usage)
  */
 static int hid_scan_report(struct hid_device *hid)
 {
-	unsigned int page = 0, delim = 0;
+	struct hid_parser *parser;
+	struct hid_item item;
 	__u8 *start = hid->dev_rdesc;
 	__u8 *end = start + hid->dev_rsize;
-	unsigned int u, u_min = 0, u_max = 0;
-	struct hid_item item;
+	int ret;
+	static int (*dispatch_type[])(struct hid_parser *parser,
+				      struct hid_item *item) = {
+		hid_scan_main,
+		hid_parser_global,
+		hid_parser_local,
+		hid_parser_reserved
+	};
 
-	hid->group = HID_GROUP_GENERIC;
+	parser = vzalloc(sizeof(struct hid_parser));
+	if (!parser)
+		return -ENOMEM;
+
+	parser->device = hid;
+
+	ret = -EINVAL;
 	while ((start = fetch_item(start, end, &item)) != NULL) {
-		if (item.format != HID_ITEM_FORMAT_SHORT)
-			return -EINVAL;
-		if (item.type == HID_ITEM_TYPE_GLOBAL) {
-			if (item.tag == HID_GLOBAL_ITEM_TAG_USAGE_PAGE)
-				page = item_udata(&item) << 16;
-		} else if (item.type == HID_ITEM_TYPE_LOCAL) {
-			if (delim > 1)
-				break;
-			u = item_udata(&item);
-			if (item.size <= 2)
-				u += page;
-			switch (item.tag) {
-			case HID_LOCAL_ITEM_TAG_DELIMITER:
-				delim += !!u;
-				break;
-			case HID_LOCAL_ITEM_TAG_USAGE:
-				hid_scan_usage(hid, u);
-				break;
-			case HID_LOCAL_ITEM_TAG_USAGE_MINIMUM:
-				u_min = u;
-				break;
-			case HID_LOCAL_ITEM_TAG_USAGE_MAXIMUM:
-				u_max = u;
-				for (u = u_min; u <= u_max; u++)
-					hid_scan_usage(hid, u);
-				break;
+
+		if (item.format != HID_ITEM_FORMAT_SHORT) {
+			hid_err(hid, "unexpected long global item\n");
+			goto out;
+		}
+
+		if (dispatch_type[item.type](parser, &item)) {
+			hid_err(hid, "item %u %u %u %u parsing failed\n",
+				item.format, (unsigned)item.size,
+				(unsigned)item.type, (unsigned)item.tag);
+			goto out;
+		}
+
+		if (start == end) {
+			if (parser->local.delimiter_depth) {
+				hid_err(hid, "unbalanced delimiter at end of report description\n");
+				goto out;
 			}
-		} else if (page == HID_UP_SENSOR &&
-			item.type == HID_ITEM_TYPE_MAIN &&
-			item.tag == HID_MAIN_ITEM_TAG_BEGIN_COLLECTION &&
-			(item_udata(&item) & 0xff) == HID_COLLECTION_PHYSICAL)
-			hid->group = HID_GROUP_SENSOR_HUB;
+			ret = 0;
+			goto out;
+		}
 	}
 
-	return 0;
+	hid_err(hid, "item fetching failed at offset %d\n", (int)(end - start));
+out:
+	switch (parser->flags) {
+	case HID_FLAG_MULTITOUCH:
+		hid->group = HID_GROUP_MULTITOUCH;
+		break;
+	case HID_FLAG_SENSOR_HUB:
+		hid->group = HID_GROUP_SENSOR_HUB;
+		break;
+	default:
+		hid->group = HID_GROUP_GENERIC;
+	}
+
+	vfree(parser);
+	return ret;
 }
 
 /**
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 5a4e789..7d823db 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -533,6 +533,9 @@ static inline void hid_set_drvdata(struct hid_device *hdev, void *data)
 #define HID_GLOBAL_STACK_SIZE 4
 #define HID_COLLECTION_STACK_SIZE 4
 
+#define HID_FLAG_MULTITOUCH		0x0001
+#define HID_FLAG_SENSOR_HUB		0x0002
+
 struct hid_parser {
 	struct hid_global     global;
 	struct hid_global     global_stack[HID_GLOBAL_STACK_SIZE];
@@ -541,6 +544,7 @@ struct hid_parser {
 	unsigned              collection_stack[HID_COLLECTION_STACK_SIZE];
 	unsigned              collection_stack_ptr;
 	struct hid_device    *device;
+	unsigned              flags;
 };
 
 struct hid_class_descriptor {
-- 
1.8.3.1

