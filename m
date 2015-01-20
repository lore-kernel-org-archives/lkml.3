Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669AbbATLNl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 06:13:41 -0500
Received: from [119.145.14.65] ([119.145.14.65]:39926 "EHLO
	szxga02-in.huawei.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754603AbbATLNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 06:13:38 -0500
From: Wang Nan <wangnan0@huawei.com>
To: <jolsa@redhat.com>
CC: <jeremie.galarneau@efficios.com>, <bigeasy@linutronix.de>,
        <lizefan@huawei.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] perf: convert: fix duplicate field names.
Date: Tue, 20 Jan 2015 19:07:08 +0800
Message-ID: <1421752029-64237-2-git-send-email-wangnan0@huawei.com>
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

Some parameters of syscall tracepoints named as 'nr', 'event', etc.
When dealing with them, perf convert to ctf meets some problems:

 1. If a parameter with name 'nr', it duplicate syscall's
    common field 'nr'. One example syscall is io_submit().

 2. If a parameter with name 'event', it is denied to be inserted
    because 'event' is a babeltrace keywork. One example syscall
    is epoll_ctl().

This patch appends '_dupl_X' postfix for those fields to avoid
these problems.

Signed-off-by: Wang Nan <wangnan0@huawei.com>
---
 tools/perf/util/data-convert-bt.c | 60 ++++++++++++++++++++++++++++++++++++---
 1 file changed, 56 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/data-convert-bt.c b/tools/perf/util/data-convert-bt.c
index ddecce8..2b87097 100644
--- a/tools/perf/util/data-convert-bt.c
+++ b/tools/perf/util/data-convert-bt.c
@@ -567,6 +567,27 @@ static int process_sample_event(struct perf_tool *tool,
 	return cs ? 0 : -1;
 }
 
+static char *get_dupl_name(const char *name, int dup)
+{
+	int size;
+	char *str;
+
+	if (dup == 0)
+		return strdup(name);
+
+	if (dup >= 10)
+		return NULL;
+
+	/* null byte is considered by sizeof. */
+	size = strlen(name) + sizeof("_dupl_X");
+	str = malloc(size);
+	if (!str)
+		return NULL;
+
+	snprintf(str, size, "%s_dupl_%d", name, dup);
+	return str;
+}
+
 static int add_tracepoint_fields_types(struct ctf_writer *cw,
 				       struct format_field *fields,
 				       struct bt_ctf_event_class *event_class)
@@ -577,6 +598,7 @@ static int add_tracepoint_fields_types(struct ctf_writer *cw,
 	for (field = fields; field; field = field->next) {
 		struct bt_ctf_field_type *type;
 		unsigned long flags = field->flags;
+		int dup;
 
 		pr2("  field '%s'\n", field->name);
 
@@ -595,14 +617,44 @@ static int add_tracepoint_fields_types(struct ctf_writer *cw,
 		if (flags & FIELD_IS_ARRAY)
 			type = bt_ctf_field_type_array_create(type, field->arraylen);
 
-		ret = bt_ctf_event_class_add_field(event_class, type,
-				field->name);
+		/*
+		 * Babeltrace doesn't allow duplication field name in a structure.
+		 * bt_ctf_event_class_get_field_by_name() can be used to check
+		 * duplication, but babeltrace has some 'reserved_keywords' which
+		 * are also disallowed. 'event' is one of those trouble makers.
+		 *
+		 * So instead of checking duplication, simply tries 10 times.
+		 */
+		for (dup = 0; dup < 10; dup ++) {
+			struct bt_ctf_field_type *f;
+			char *dupl_name = get_dupl_name(field->name, dup);
+
+			if (!dupl_name) {
+				pr_err("Failed to alloc memory for dup '%s'\n",
+						field->name);
+				return -1;
+			}
+
+			ret = bt_ctf_event_class_add_field(event_class, type,
+					dupl_name);
+			free(dupl_name);
+			if (ret)
+				continue;
+			break;
+		}
+
+		if (dup >= 10) {
+			pr_err("Failed to add field '%s': tried 10 times\n",
+					field->name);
+			return -1;
+		}
 
 		if (flags & FIELD_IS_ARRAY)
 			bt_ctf_field_type_put(type);
 
 		if (ret) {
-			pr_err("Failed to add field '%s\n", field->name);
+			pr_err("Failed to add field '%s': %d\n",
+					field->name, ret);
 			return -1;
 		}
 	}
@@ -646,7 +698,7 @@ static int add_generic_types(struct ctf_writer *cw, struct perf_evsel *evsel,
 	do {								\
 		pr2("  field '%s'\n", n);				\
 		if (bt_ctf_event_class_add_field(cl, t, n)) {		\
-			pr_err("Failed to add field '%s;\n", n);	\
+			pr_err("Failed to add field '%s';\n", n);	\
 			return -1;					\
 		}							\
 	} while (0)
-- 
1.8.4

