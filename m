Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266AbbAUD3r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 22:29:47 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:32909 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683AbbAUD3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 22:29:46 -0500
From: Wang Nan <wangnan0@huawei.com>
To: <jolsa@redhat.com>
CC: <jeremie.galarneau@efficios.com>, <bigeasy@linutronix.de>,
        <lizefan@huawei.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] perf: convert: fix duplicate field names and avoid reserved keywords.
Date: Wed, 21 Jan 2015 11:23:54 +0800
Message-ID: <1421810634-1373-1-git-send-email-wangnan0@huawei.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <20150120130609.GC15315@krava.brq.redhat.com>
References: <20150120130609.GC15315@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some parameters of syscall tracepoints named as 'nr', 'event', etc.
When dealing with them, perf convert to ctf meets some problem:

 1. If a parameter with name 'nr', it will duplicate syscall's
    common field 'nr'. One such syscall is io_submit().

 2. If a parameter with name 'event', it is denied to be inserted
    because 'event' is a babeltrace keywork. One such syscall is
    epoll_ctl.

This patch appends '_dupl_X' suffix to avoid problem 1, prepend a '_'
prefix to avoid problem 2.

Signed-off-by: Wang Nan <wangnan0@huawei.com>
---
 tools/perf/util/data-convert-bt.c | 65 ++++++++++++++++++++++++++++++++++++---
 1 file changed, 61 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/data-convert-bt.c b/tools/perf/util/data-convert-bt.c
index ddecce8..b0a042d 100644
--- a/tools/perf/util/data-convert-bt.c
+++ b/tools/perf/util/data-convert-bt.c
@@ -567,6 +567,38 @@ static int process_sample_event(struct perf_tool *tool,
 	return cs ? 0 : -1;
 }
 
+/* If dup < 0, add a prefix. Else, add _dupl_X suffix. */
+static char *change_name(char *name, char *orig_name, int dup)
+{
+	char *new_name = NULL;
+	size_t len;
+
+	if (!name)
+		name = orig_name;
+
+	if (dup >= 10)
+		goto out;
+
+	if (dup < 0)
+		len = strlen(name) + sizeof("_");
+	else
+		len = strlen(orig_name) + sizeof("_dupl_X");
+
+	new_name = malloc(len);
+	if (!new_name)
+		goto out;
+
+	if (dup < 0)
+		snprintf(new_name, len, "_%s", name);
+	else
+		snprintf(new_name, len, "%s_dupl_%d", orig_name, dup);
+
+out:
+	if (name != orig_name)
+		free(name);
+	return new_name;
+}
+
 static int add_tracepoint_fields_types(struct ctf_writer *cw,
 				       struct format_field *fields,
 				       struct bt_ctf_event_class *event_class)
@@ -577,6 +609,9 @@ static int add_tracepoint_fields_types(struct ctf_writer *cw,
 	for (field = fields; field; field = field->next) {
 		struct bt_ctf_field_type *type;
 		unsigned long flags = field->flags;
+		struct bt_ctf_field_type *f = NULL;
+		char *name;
+		int dup = 1;
 
 		pr2("  field '%s'\n", field->name);
 
@@ -595,14 +630,36 @@ static int add_tracepoint_fields_types(struct ctf_writer *cw,
 		if (flags & FIELD_IS_ARRAY)
 			type = bt_ctf_field_type_array_create(type, field->arraylen);
 
-		ret = bt_ctf_event_class_add_field(event_class, type,
-				field->name);
+		/* Check name duplication */
+		name = field->name;
+		while (f = bt_ctf_event_class_get_field_by_name(event_class, name)) {
+			bt_ctf_field_type_put(f);
+			name = change_name(name, field->name, dup++);
+			if (!name) {
+				pr_err("Failed to create dup name for '%s'\n", field->name);
+				return -1;
+			}
+		}
+
+		ret = bt_ctf_event_class_add_field(event_class, type, name);
+		/* if failed, we may hit a keywork. try again with a '_' prefix */
+		if (ret) {
+			name = change_name(name, field->name, -1);
+			if (!name) {
+				pr_err("Failed to alloc name for '_%s'\n", field->name);
+				return -1;
+			}
+			ret = bt_ctf_event_class_add_field(event_class, type, name);
+		}
+		if (name != field->name)
+			free(name);
 
 		if (flags & FIELD_IS_ARRAY)
 			bt_ctf_field_type_put(type);
 
 		if (ret) {
-			pr_err("Failed to add field '%s\n", field->name);
+			pr_err("Failed to add field '%s': %d\n",
+					field->name, ret);
 			return -1;
 		}
 	}
@@ -646,7 +703,7 @@ static int add_generic_types(struct ctf_writer *cw, struct perf_evsel *evsel,
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

