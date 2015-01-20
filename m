Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697AbbATLNt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 06:13:49 -0500
Received: from [119.145.14.65] ([119.145.14.65]:39927 "EHLO
	szxga02-in.huawei.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753549AbbATLNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 06:13:47 -0500
From: Wang Nan <wangnan0@huawei.com>
To: <jolsa@redhat.com>
CC: <jeremie.galarneau@efficios.com>, <bigeasy@linutronix.de>,
        <lizefan@huawei.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] perf: convert: fix signess of value.
Date: Tue, 20 Jan 2015 19:07:09 +0800
Message-ID: <1421752029-64237-3-git-send-email-wangnan0@huawei.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1421752029-64237-1-git-send-email-wangnan0@huawei.com>
References: <1421752029-64237-1-git-send-email-wangnan0@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
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
 tools/perf/util/data-convert-bt.c | 41 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 40 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/data-convert-bt.c b/tools/perf/util/data-convert-bt.c
index 2b87097..d43b8a1 100644
--- a/tools/perf/util/data-convert-bt.c
+++ b/tools/perf/util/data-convert-bt.c
@@ -165,6 +165,44 @@ get_tracepoint_field_type(struct ctf_writer *cw, struct format_field *field)
 		return cw->data.u32;
 }
 
+static unsigned long long adjust_signess(unsigned long long value_int, int size)
+{
+	int signbit;
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
@@ -243,7 +281,8 @@ static int add_tracepoint_field_value(struct ctf_writer *cw,
 					field, value_int);
 		else
 			ret = bt_ctf_field_signed_integer_set_value(
-					field, value_int);
+					field, adjust_signess(value_int, len));
+
 		if (ret) {
 			pr_err("failed to set file value %s\n", name);
 			goto err_put_field;
-- 
1.8.4

