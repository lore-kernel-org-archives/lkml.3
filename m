Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090Ab3G2COl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jul 2013 22:14:41 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:18237 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239Ab3G2COj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jul 2013 22:14:39 -0400
Message-ID: <51F5CFFF.3090502@huawei.com>
Date: Mon, 29 Jul 2013 10:14:23 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Borislav Petkov <bp@alien8.de>, Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 2/2] tracing: Shrink the size of struct ftrace_event_field
References: <51F08D1B.1080300@huawei.com> <51F08D4B.3010201@huawei.com>  <1374851376.6580.34.camel@gandalf.local.home> <51F33F41.9040902@huawei.com>  <1374896842.6580.44.camel@gandalf.local.home>  <20130727084528.GA6923@pd.tnic> <1374924938.6580.46.camel@gandalf.local.home>
In-Reply-To: <1374924938.6580.46.camel@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use bit fields, and the size of struct ftrace_event_field can be
shrunk from 48 bytes to 40 bytes on 64bit kernel.

slab_name active_obj nr_obj size obj_per_slab
---------------------------------------------
ftrace_event_field   1105   1105     48   85  (before)
ftrace_event_field   1224   1224     40  102  (after)

This saves a few Kbytes: (1224 * 40) - (1105 * 48) = 4080

v2:
- use !!is_signed, and nuke the check on this field.
- use a different way to detect overflow.
(both suggested by Steven)

v3:
- use plain WARN_ON() instead of a macro. (suggeusted by Borislav)

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/trace/trace.h        |  8 ++++----
 kernel/trace/trace_events.c | 12 ++++++++----
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 4a4f6e1..3e8c97f 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -904,10 +904,10 @@ struct ftrace_event_field {
 	struct list_head	link;
 	const char		*name;
 	const char		*type;
-	int			filter_type;
-	int			offset;
-	int			size;
-	int			is_signed;
+	unsigned int		filter_type:4;
+	unsigned int		offset:12;
+	unsigned int		size:12;
+	unsigned int		is_signed:1;
 };
 
 struct event_filter {
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 7d85429..6509afe 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -120,13 +120,17 @@ static int __trace_define_field(struct list_head *head, const char *type,
 	field->type = type;
 
 	if (filter_type == FILTER_OTHER)
-		field->filter_type = filter_assign_type(type);
-	else
-		field->filter_type = filter_type;
+		filter_type = filter_assign_type(type);
 
+	field->filter_type = filter_type;
 	field->offset = offset;
 	field->size = size;
-	field->is_signed = is_signed;
+	field->is_signed = !!is_signed;
+
+	/* detect bit-field overflow */
+	WARN_ON(filter_type > field->filter_type);
+	WARN_ON(offset > field->offset);
+	WARN_ON(size > field->size);
 
 	list_add(&field->link, head);
 
-- 
1.8.0.2

