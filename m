Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596AbbAZKoq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 05:44:46 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:18503 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755090AbbAZKoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 05:44:37 -0500
From: Wang Nan <wangnan0@huawei.com>
To: <jolsa@redhat.com>, <jeremie.galarneau@efficios.com>,
        <rostedt@goodmis.org>, <alexmonthy@voxpopuli.im>,
        <bigeasy@linutronix.de>
CC: <lizefan@huawei.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 2/3] perf: convert: fix duplicate field names and avoid reserved keywords.
Date: Mon, 26 Jan 2015 18:38:24 +0800
Message-ID: <1422268705-32084-3-git-send-email-wangnan0@huawei.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1422268705-32084-1-git-send-email-wangnan0@huawei.com>
References: <1422268705-32084-1-git-send-email-wangnan0@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020205.54C61A8F.00A6,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: bfdc7a05e7fa5325577f2adac812b336
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(If Steven Rostedt accept the previous patch which introduce a priv
 field to 'struct format_field', we can use a relative simple method
 for name conversion. If not , perf must track name conversion by
 itself.)

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
 tools/perf/util/data-convert-bt.c | 98 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 94 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/data-convert-bt.c b/tools/perf/util/data-convert-bt.c
index ddecce8..934bd9b 100644
--- a/tools/perf/util/data-convert-bt.c
+++ b/tools/perf/util/data-convert-bt.c
@@ -14,6 +14,7 @@
 #include <babeltrace/ctf-writer/event.h>
 #include <babeltrace/ctf-writer/event-types.h>
 #include <babeltrace/ctf-writer/event-fields.h>
+#include <babeltrace/ctf-ir/utils.h>
 #include <babeltrace/ctf/events.h>
 #include <traceevent/event-parse.h>
 #include "asm/bug.h"
@@ -184,6 +185,7 @@ static int add_tracepoint_field_value(struct ctf_writer *cw,
 	unsigned int len;
 	int ret;
 
+	name = fmtf->priv ? (const char *)fmtf->priv : fmtf->name;
 	offset = fmtf->offset;
 	len = fmtf->size;
 	if (flags & FIELD_IS_STRING)
@@ -567,6 +569,94 @@ static int process_sample_event(struct perf_tool *tool,
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
+	/*
+	 * Add '_' prefix to potential keywork.  According to
+	 * Mathieu Desnoyers (https://lkml.org/lkml/2015/1/23/652),
+	 * futher CTF spec updating may require us to use '$'.
+	 */
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
+static void destroy_field_priv(struct format_field *field)
+{
+	if (!field->priv)
+		return;
+
+	if (field->priv != field->name)
+		free(field->priv);
+
+	field->priv = NULL;
+	field->destroy_priv = NULL;
+}
+
+static int event_class_add_field(struct bt_ctf_event_class *event_class,
+		struct bt_ctf_field_type *type,
+		struct format_field *field)
+{
+	struct bt_ctf_field_type *t = NULL;
+	char *name;
+	int dup = 1;
+	int ret;
+
+	if (field->priv)
+		return bt_ctf_event_class_add_field(event_class, type,
+				(char *)field->priv);
+
+	name = field->name;
+
+	/* If 'name' is a keywork, add prefix. */
+	if (bt_ctf_validate_identifier(name))
+		name = change_name(name, field->name, -1);
+
+	if (!name) {
+		pr_err("Failed to fix invalid identifier.");
+		return -1;
+	}
+	while ((t = bt_ctf_event_class_get_field_by_name(event_class, name))) {
+		bt_ctf_field_type_put(t);
+		name = change_name(name, field->name, dup++);
+		if (!name) {
+			pr_err("Failed to create dup name for '%s'\n", field->name);
+			return -1;
+		}
+	}
+
+	ret = bt_ctf_event_class_add_field(event_class, type, name);
+
+	field->priv = name;
+	field->destroy_priv = destroy_field_priv;
+
+	return ret;
+}
+
 static int add_tracepoint_fields_types(struct ctf_writer *cw,
 				       struct format_field *fields,
 				       struct bt_ctf_event_class *event_class)
@@ -595,14 +685,14 @@ static int add_tracepoint_fields_types(struct ctf_writer *cw,
 		if (flags & FIELD_IS_ARRAY)
 			type = bt_ctf_field_type_array_create(type, field->arraylen);
 
-		ret = bt_ctf_event_class_add_field(event_class, type,
-				field->name);
+		ret = event_class_add_field(event_class, type, field);
 
 		if (flags & FIELD_IS_ARRAY)
 			bt_ctf_field_type_put(type);
 
 		if (ret) {
-			pr_err("Failed to add field '%s\n", field->name);
+			pr_err("Failed to add field '%s': %d\n",
+					field->name, ret);
 			return -1;
 		}
 	}
@@ -646,7 +736,7 @@ static int add_generic_types(struct ctf_writer *cw, struct perf_evsel *evsel,
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

