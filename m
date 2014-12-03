Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267AbaLCQZA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 11:25:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56179 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752509AbaLCQYz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 11:24:55 -0500
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jeremie Galarneau <jgalar@efficios.com>, Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 5/8] perf data: Add tracepoint events fields CTF conversion support
Date: Wed,  3 Dec 2014 17:23:59 +0100
Message-Id: <1417623842-14331-6-git-send-email-jolsa@kernel.org>
In-Reply-To: <1417623842-14331-1-git-send-email-jolsa@kernel.org>
References: <1417623842-14331-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Adding support to convert tracepoint event fields into CTF
event fields.

We parse each tracepoint event for CTF conversion and add
tracepoint fields as regular CTF event fields, so they
appear in babeltrace output like:

  $ babeltrace ./ctf-data/
  ...
  [09:02:00.950703057] (+?.?????????) sched:sched_stat_runtime: { }, { perf_ip = ... SNIP ... common_type = 298, common_flags = 1, \
  common_preempt_count = 0, common_pid = 31813, comm = "perf", pid = 31813, runtime = 458800, vruntime = 52059858071 }
  ...

Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jeremie Galarneau <jgalar@efficios.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Tom Zanussi <tzanussi@gmail.com>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 tools/perf/util/data-convert-bt.c | 242 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 242 insertions(+)

diff --git a/tools/perf/util/data-convert-bt.c b/tools/perf/util/data-convert-bt.c
index 3c39fae9c07e..cf1b16c89120 100644
--- a/tools/perf/util/data-convert-bt.c
+++ b/tools/perf/util/data-convert-bt.c
@@ -126,6 +126,177 @@ FUNC_VALUE_SET(s64)
 FUNC_VALUE_SET(u64)
 __FUNC_VALUE_SET(u64_hex, u64)
 
+static struct bt_ctf_field_type*
+get_tracepoint_field_type(struct ctf_writer *cw, struct format_field *field)
+{
+	unsigned long flags = field->flags;
+
+	if (flags & FIELD_IS_STRING)
+		return cw->data.string;
+
+	if (!(flags & FIELD_IS_SIGNED)) {
+		/* unsigned long are mostly pointers */
+		if (flags & FIELD_IS_LONG || flags & FIELD_IS_POINTER)
+			return cw->data.u64_hex;
+	}
+
+	if (flags & FIELD_IS_SIGNED) {
+		if (field->size == 8)
+			return cw->data.s64;
+		else
+			return cw->data.s32;
+	}
+
+	if (field->size == 8)
+		return cw->data.u64;
+	else
+		return cw->data.u32;
+}
+
+static int add_tracepoint_field_value(struct ctf_writer *cw,
+				      struct bt_ctf_event_class *event_class,
+				      struct bt_ctf_event *event,
+				      struct perf_sample *sample,
+				      struct format_field *fmtf)
+{
+	struct bt_ctf_field_type *type;
+	struct bt_ctf_field *array_field;
+	struct bt_ctf_field *field;
+	const char *name = fmtf->name;
+	void *data = sample->raw_data;
+	unsigned long long value_int;
+	unsigned long flags = fmtf->flags;
+	unsigned int n_items;
+	unsigned int i;
+	unsigned int offset;
+	unsigned int len;
+	int ret;
+
+	offset = fmtf->offset;
+	len = fmtf->size;
+	if (flags & FIELD_IS_STRING)
+		flags &= ~FIELD_IS_ARRAY;
+
+	if (flags & FIELD_IS_DYNAMIC) {
+		unsigned long long tmp_val;
+
+		tmp_val = pevent_read_number(fmtf->event->pevent,
+				data + offset, len);
+		offset = tmp_val;
+		len = offset >> 16;
+		offset &= 0xffff;
+	}
+
+	if (flags & FIELD_IS_ARRAY) {
+
+		type = bt_ctf_event_class_get_field_by_name(
+				event_class, name);
+		array_field = bt_ctf_field_create(type);
+		bt_ctf_field_type_put(type);
+		if (!array_field) {
+			pr_err("Failed to create array type %s\n", name);
+			return -1;
+		}
+
+		len = fmtf->size / fmtf->arraylen;
+		n_items = fmtf->arraylen;
+	} else {
+		n_items = 1;
+		array_field = NULL;
+	}
+
+	type = get_tracepoint_field_type(cw, fmtf);
+
+	for (i = 0; i < n_items; i++) {
+		if (!(flags & FIELD_IS_STRING))
+			value_int = pevent_read_number(
+					fmtf->event->pevent,
+					data + offset + i * len, len);
+
+		if (flags & FIELD_IS_ARRAY)
+			field = bt_ctf_field_array_get_field(array_field, i);
+		else
+			field = bt_ctf_field_create(type);
+
+		if (!field) {
+			pr_err("failed to create a field %s\n", name);
+			return -1;
+		}
+
+		if (flags & FIELD_IS_STRING)
+			ret = bt_ctf_field_string_set_value(field,
+					data + offset + i * len);
+		else if (!(flags & FIELD_IS_SIGNED))
+			ret = bt_ctf_field_unsigned_integer_set_value(
+					field, value_int);
+		else
+			ret = bt_ctf_field_signed_integer_set_value(
+					field, value_int);
+		if (ret) {
+			pr_err("failed to set file value %s\n", name);
+			goto err_put_field;
+		}
+		if (!(flags & FIELD_IS_ARRAY)) {
+			ret = bt_ctf_event_set_payload(event, name, field);
+			if (ret) {
+				pr_err("failed to set payload %s\n", name);
+				goto err_put_field;
+			}
+		}
+		bt_ctf_field_put(field);
+	}
+	if (flags & FIELD_IS_ARRAY) {
+		ret = bt_ctf_event_set_payload(event, name, array_field);
+		if (ret) {
+			pr_err("Failed add payload array %s\n", name);
+			return -1;
+		}
+		bt_ctf_field_put(array_field);
+	}
+	return 0;
+
+err_put_field:
+	bt_ctf_field_put(field);
+	return -1;
+}
+
+static int add_tracepoint_fields_values(struct ctf_writer *cw,
+					struct bt_ctf_event_class *event_class,
+					struct bt_ctf_event *event,
+					struct format_field *fields,
+					struct perf_sample *sample)
+{
+	struct format_field *field;
+	int ret;
+
+	for (field = fields; field; field = field->next) {
+		ret = add_tracepoint_field_value(cw, event_class, event, sample,
+				field);
+		if (ret)
+			return -1;
+	}
+	return 0;
+}
+
+static int add_tracepoint_values(struct ctf_writer *cw,
+				 struct bt_ctf_event_class *event_class,
+				 struct bt_ctf_event *event,
+				 struct perf_evsel *evsel,
+				 struct perf_sample *sample)
+{
+	struct format_field *common_fields = evsel->tp_format->format.common_fields;
+	struct format_field *fields        = evsel->tp_format->format.fields;
+	int ret;
+
+	ret = add_tracepoint_fields_values(cw, event_class, event,
+					   common_fields, sample);
+	if (!ret)
+		ret = add_tracepoint_fields_values(cw, event_class, event,
+						   fields, sample);
+
+	return ret;
+}
+
 static int add_generic_values(struct ctf_writer *cw,
 			      struct bt_ctf_event *event,
 			      struct perf_evsel *evsel,
@@ -246,11 +417,76 @@ static int process_sample_event(struct perf_tool *tool,
 	if (ret)
 		return -1;
 
+	if (evsel->attr.type == PERF_TYPE_TRACEPOINT) {
+		ret = add_tracepoint_values(cw, event_class, event,
+					    evsel, sample);
+		if (ret)
+			return -1;
+	}
+
 	bt_ctf_stream_append_event(cw->stream, event);
 	bt_ctf_event_put(event);
 	return 0;
 }
 
+static int add_tracepoint_fields_types(struct ctf_writer *cw,
+				       struct format_field *fields,
+				       struct bt_ctf_event_class *event_class)
+{
+	struct format_field *field;
+	int ret;
+
+	for (field = fields; field; field = field->next) {
+		struct bt_ctf_field_type *type;
+		unsigned long flags = field->flags;
+
+		pr2("  field '%s'\n", field->name);
+
+		type = get_tracepoint_field_type(cw, field);
+		if (!type)
+			return -1;
+
+		/*
+		 * A string is an array of chars. For this we use the string
+		 * type and don't care that it is an array. What we don't
+		 * support is an array of strings.
+		 */
+		if (flags & FIELD_IS_STRING)
+			flags &= ~FIELD_IS_ARRAY;
+
+		if (flags & FIELD_IS_ARRAY)
+			type = bt_ctf_field_type_array_create(type, field->arraylen);
+
+		ret = bt_ctf_event_class_add_field(event_class, type,
+				field->name);
+
+		if (flags & FIELD_IS_ARRAY)
+			bt_ctf_field_type_put(type);
+
+		if (ret) {
+			pr_err("Failed to add field '%s\n", field->name);
+			return -1;
+		}
+	}
+
+	return 0;
+}
+
+static int add_tracepoint_types(struct ctf_writer *cw,
+				struct perf_evsel *evsel,
+				struct bt_ctf_event_class *class)
+{
+	struct format_field *common_fields = evsel->tp_format->format.common_fields;
+	struct format_field *fields        = evsel->tp_format->format.fields;
+	int ret;
+
+	ret = add_tracepoint_fields_types(cw, common_fields, class);
+	if (!ret)
+		ret = add_tracepoint_fields_types(cw, fields, class);
+
+	return ret;
+}
+
 static int add_generic_types(struct ctf_writer *cw, struct perf_evsel *evsel,
 			     struct bt_ctf_event_class *event_class)
 {
@@ -328,6 +564,12 @@ static int add_event(struct ctf_writer *cw, struct perf_evsel *evsel)
 	if (ret)
 		goto err;
 
+	if (evsel->attr.type == PERF_TYPE_TRACEPOINT) {
+		ret = add_tracepoint_types(cw, evsel, event_class);
+		if (ret)
+			goto err;
+	}
+
 	ret = bt_ctf_stream_class_add_event_class(cw->stream_class, event_class);
 	if (ret) {
 		pr("Failed to add event class into stream.\n");
-- 
1.9.3

