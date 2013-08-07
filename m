Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933436Ab3HGVLe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 17:11:34 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47021 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933390Ab3HGVL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 17:11:28 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 01/47] perf: Add PERF_EVENT_IOC_ID ioctl to return event ID
Date: Wed,  7 Aug 2013 18:10:28 -0300
Message-Id: <1375909874-22073-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1375909874-22073-1-git-send-email-acme@infradead.org>
References: <1375909874-22073-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

The only way to get the event ID is by reading the event fd,
followed by parsing the ID value out of the returned data.

While this is ok for current read format used by perf tool,
it is not ok when we use PERF_FORMAT_GROUP format.

With this format the data are returned for the whole group
and there's no way to find out what ID belongs to our fd
(if we are not group leader event).

Adding a simple ioctl that returns event primary ID for given fd.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-v1bn5cto707jn0bon34afqr1@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 include/uapi/linux/perf_event.h | 1 +
 kernel/events/core.c            | 9 +++++++++
 2 files changed, 10 insertions(+)

diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index efef1d3..62c25a2 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -321,6 +321,7 @@ struct perf_event_attr {
 #define PERF_EVENT_IOC_PERIOD		_IOW('$', 4, __u64)
 #define PERF_EVENT_IOC_SET_OUTPUT	_IO ('$', 5)
 #define PERF_EVENT_IOC_SET_FILTER	_IOW('$', 6, char *)
+#define PERF_EVENT_IOC_ID		_IOR('$', 7, u64 *)
 
 enum perf_event_ioc_flags {
 	PERF_IOC_FLAG_GROUP		= 1U << 0,
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 916cf1f..5200b60 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3568,6 +3568,15 @@ static long perf_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	case PERF_EVENT_IOC_PERIOD:
 		return perf_event_period(event, (u64 __user *)arg);
 
+	case PERF_EVENT_IOC_ID:
+	{
+		u64 id = primary_event_id(event);
+
+		if (copy_to_user((void __user *)arg, &id, sizeof(id)))
+			return -EFAULT;
+		return 0;
+	}
+
 	case PERF_EVENT_IOC_SET_OUTPUT:
 	{
 		int ret;
-- 
1.8.1.4

