Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433Ab3C0GSi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 02:18:38 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:57841 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754259Ab3C0GSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 02:18:37 -0400
Message-ID: <51528EB9.6070003@huawei.com>
Date: Wed, 27 Mar 2013 14:16:25 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] tracing: Shrink the size of struct ftrace_event_field
References: <51528E89.6080508@huawei.com>
In-Reply-To: <51528E89.6080508@huawei.com>
Content-Type: text/plain; charset="GB2312"
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

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/trace/trace.h        | 8 ++++----
 kernel/trace/trace_events.c | 5 +++++
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 9e01458..a3365a4 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -916,10 +916,10 @@ struct ftrace_event_field {
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
index 53582e9..67aee85 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -111,6 +111,11 @@ static int __trace_define_field(struct list_head *head, const char *type,
 	field->size = size;
 	field->is_signed = is_signed;
 
+	WARN_ON(offset >= (1 << 12));
+	WARN_ON(size >= (1 << 12));
+	WARN_ON(is_signed >= (1 << 1));
+	WARN_ON(field->filter_type >= (1 << 4));
+
 	list_add(&field->link, head);
 
 	return 0;
-- 
1.8.0.2
