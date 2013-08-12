Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089Ab3HLKRT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 06:17:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47659 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756011Ab3HLKRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 06:17:12 -0400
Date: Mon, 12 Aug 2013 03:16:32 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-v1bn5cto707jn0bon34afqr1@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf:
  Add PERF_EVENT_IOC_ID ioctl to return event ID
Git-Commit-ID: cf4957f17f2a89984915ea808876d9c82225b862
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 12 Aug 2013 03:16:40 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cf4957f17f2a89984915ea808876d9c82225b862
Gitweb:     http://git.kernel.org/tip/cf4957f17f2a89984915ea808876d9c82225b862
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Wed, 24 Oct 2012 13:37:58 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 7 Aug 2013 17:35:19 -0300

perf: Add PERF_EVENT_IOC_ID ioctl to return event ID

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
