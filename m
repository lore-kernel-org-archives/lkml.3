Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755632AbbAZKos (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 05:44:48 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:18500 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755093AbbAZKoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 05:44:37 -0500
From: Wang Nan <wangnan0@huawei.com>
To: <jolsa@redhat.com>, <jeremie.galarneau@efficios.com>,
        <rostedt@goodmis.org>, <alexmonthy@voxpopuli.im>,
        <bigeasy@linutronix.de>
CC: <lizefan@huawei.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 3/3] perf: convert: fix signess of value.
Date: Mon, 26 Jan 2015 18:38:25 +0800
Message-ID: <1422268705-32084-4-git-send-email-wangnan0@huawei.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1422268705-32084-1-git-send-email-wangnan0@huawei.com>
References: <1422268705-32084-1-git-send-email-wangnan0@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020206.54C61A8F.0017,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 8a85538849d0a27f2cb73f2806e96a24
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When converting int values, perf first extractes it to a ulonglong, then
feeds it to babeltrace as a signed value. For negative 32 bit values
(for example, return values of failed syscalls), the extracted data
should be something like 0xfffffffe (-2). It becomes a large int64
value. Babeltrace denies to insert it with
bt_ctf_field_signed_integer_set_value() because it is larger than
0x7fffffff, the largest positive value a signed 32 bit int can be.

This patch introduces adjust_signess(), which fills high bits of
ulonglong with 1 if the value is negative.

Signed-off-by: Wang Nan <wangnan0@huawei.com>
---
 tools/perf/util/data-convert-bt.c | 63 +++++++++++++++++++++++++++++++--------
 1 file changed, 51 insertions(+), 12 deletions(-)

diff --git a/tools/perf/util/data-convert-bt.c b/tools/perf/util/data-convert-bt.c
index 934bd9b..a89f879 100644
--- a/tools/perf/util/data-convert-bt.c
+++ b/tools/perf/util/data-convert-bt.c
@@ -166,6 +166,43 @@ get_tracepoint_field_type(struct ctf_writer *cw, struct format_field *field)
 		return cw->data.u32;
 }
 
+static unsigned long long adjust_signess(unsigned long long value_int, int size)
+{
+	unsigned long long value_mask;
+
+	/*
+	 * value_mask = (1 << (size * 8 - 1)) - 1.
+	 * Directly set value_mask for code readers.
+	 */
+	switch (size) {
+	case 1:
+		value_mask = 0x7fULL;
+		break;
+	case 2:
+		value_mask = 0x7fffULL;
+		break;
+	case 4:
+		value_mask = 0x7fffffffULL;
+		break;
+	case 8:
+		/*
+		 * For 64 bit value, return it self. There is no need
+		 * to fill high bit.
+		 */
+		/* Fall through */
+	default:
+		/* BUG! */
+		return value_int;
+	}
+
+	/* If it is a positive value, don't adjust. */
+	if ((value_int & (~0ULL - value_mask)) == 0)
+		return value_int;
+
+	/* Fill upper part of value_int with 1 to make it a negative long long. */
+	return (value_int & value_mask) | ~value_mask;
+}
+
 static int add_tracepoint_field_value(struct ctf_writer *cw,
 				      struct bt_ctf_event_class *event_class,
 				      struct bt_ctf_event *event,
@@ -177,7 +214,6 @@ static int add_tracepoint_field_value(struct ctf_writer *cw,
 	struct bt_ctf_field *field;
 	const char *name = fmtf->name;
 	void *data = sample->raw_data;
-	unsigned long long value_int;
 	unsigned long flags = fmtf->flags;
 	unsigned int n_items;
 	unsigned int i;
@@ -222,11 +258,6 @@ static int add_tracepoint_field_value(struct ctf_writer *cw,
 	type = get_tracepoint_field_type(cw, fmtf);
 
 	for (i = 0; i < n_items; i++) {
-		if (!(flags & FIELD_IS_STRING))
-			value_int = pevent_read_number(
-					fmtf->event->pevent,
-					data + offset + i * len, len);
-
 		if (flags & FIELD_IS_ARRAY)
 			field = bt_ctf_field_array_get_field(array_field, i);
 		else
@@ -240,12 +271,20 @@ static int add_tracepoint_field_value(struct ctf_writer *cw,
 		if (flags & FIELD_IS_STRING)
 			ret = bt_ctf_field_string_set_value(field,
 					data + offset + i * len);
-		else if (!(flags & FIELD_IS_SIGNED))
-			ret = bt_ctf_field_unsigned_integer_set_value(
-					field, value_int);
-		else
-			ret = bt_ctf_field_signed_integer_set_value(
-					field, value_int);
+		else {
+			unsigned long long value_int;
+			value_int = pevent_read_number(
+					fmtf->event->pevent,
+					data + offset + i * len, len);
+
+			if (!(flags & FIELD_IS_SIGNED))
+				ret = bt_ctf_field_unsigned_integer_set_value(
+						field, value_int);
+			else
+				ret = bt_ctf_field_signed_integer_set_value(
+						field, adjust_signess(value_int, len));
+		}
+
 		if (ret) {
 			pr_err("failed to set file value %s\n", name);
 			goto err_put_field;
-- 
1.8.4

