Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760925AbaLLGpq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 01:45:46 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51805 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758943AbaLLGQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 01:16:55 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Pawel Moll" <pawel.moll@arm.com>,
        "Ingo Molnar" <mingo@kernel.org>, "Jiri Olsa" <jolsa@redhat.com>,
        "Zefan Li" <lizefan@huawei.com>, "David Ahern" <dsahern@gmail.com>,
        "Drew Richardson" <drew.richardson@arm.com>,
        "Peter Zijlstra" <peterz@infradead.org>,
        "Arnaldo Carvalho de Melo" <acme@kernel.org>
Date: Fri, 12 Dec 2014 06:14:26 +0000
Message-ID: <lsq.1418364866.74149207@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 164/164] perf: Handle compat ioctl
In-Reply-To: <lsq.1418364865.554543691@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:c97:8151:cc89:c28d
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.65-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Pawel Moll <pawel.moll@arm.com>

commit b3f207855f57b9c8f43a547a801340bb5cbc59e5 upstream.

When running a 32-bit userspace on a 64-bit kernel (eg. i386
application on x86_64 kernel or 32-bit arm userspace on arm64
kernel) some of the perf ioctls must be treated with special
care, as they have a pointer size encoded in the command.

For example, PERF_EVENT_IOC_ID in 32-bit world will be encoded
as 0x80042407, but 64-bit kernel will expect 0x80082407. In
result the ioctl will fail returning -ENOTTY.

This patch solves the problem by adding code fixing up the
size as compat_ioctl file operation.

Reported-by: Drew Richardson <drew.richardson@arm.com>
Signed-off-by: Pawel Moll <pawel.moll@arm.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/r/1402671812-9078-1-git-send-email-pawel.moll@arm.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
[lizf: Backported to 3.4 by David Ahern]
Signed-off-by: Zefan Li <lizefan@huawei.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/events/core.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -36,6 +36,7 @@
 #include <linux/perf_event.h>
 #include <linux/ftrace_event.h>
 #include <linux/hw_breakpoint.h>
+#include <linux/compat.h>
 
 #include "internal.h"
 
@@ -3444,6 +3445,25 @@ static long perf_ioctl(struct file *file
 	return 0;
 }
 
+#ifdef CONFIG_COMPAT
+static long perf_compat_ioctl(struct file *file, unsigned int cmd,
+				unsigned long arg)
+{
+	switch (_IOC_NR(cmd)) {
+	case _IOC_NR(PERF_EVENT_IOC_SET_FILTER):
+		/* Fix up pointer size (usually 4 -> 8 in 32-on-64-bit case */
+		if (_IOC_SIZE(cmd) == sizeof(compat_uptr_t)) {
+			cmd &= ~IOCSIZE_MASK;
+			cmd |= sizeof(void *) << IOCSIZE_SHIFT;
+		}
+		break;
+	}
+	return perf_ioctl(file, cmd, arg);
+}
+#else
+# define perf_compat_ioctl NULL
+#endif
+
 int perf_event_task_enable(void)
 {
 	struct perf_event *event;
@@ -3910,7 +3930,7 @@ static const struct file_operations perf
 	.read			= perf_read,
 	.poll			= perf_poll,
 	.unlocked_ioctl		= perf_ioctl,
-	.compat_ioctl		= perf_ioctl,
+	.compat_ioctl		= perf_compat_ioctl,
 	.mmap			= perf_mmap,
 	.fasync			= perf_fasync,
 };

