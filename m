Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754267AbaKYKpq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 05:45:46 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:59255 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932087AbaKYKnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:43:51 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Pawel Moll <pawel.moll@arm.com>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 239/254] perf: Handle compat ioctl
Date: Tue, 25 Nov 2014 10:39:49 +0000
Message-Id: <1416912004-5928-240-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/events/core.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 5dfa199971d2..6bc75223aaa7 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -41,6 +41,7 @@
 #include <linux/cgroup.h>
 #include <linux/module.h>
 #include <linux/mman.h>
+#include <linux/compat.h>
 
 #include "internal.h"
 
@@ -3747,6 +3748,26 @@ static long perf_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	return 0;
 }
 
+#ifdef CONFIG_COMPAT
+static long perf_compat_ioctl(struct file *file, unsigned int cmd,
+				unsigned long arg)
+{
+	switch (_IOC_NR(cmd)) {
+	case _IOC_NR(PERF_EVENT_IOC_SET_FILTER):
+	case _IOC_NR(PERF_EVENT_IOC_ID):
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
@@ -4252,7 +4273,7 @@ static const struct file_operations perf_fops = {
 	.read			= perf_read,
 	.poll			= perf_poll,
 	.unlocked_ioctl		= perf_ioctl,
-	.compat_ioctl		= perf_ioctl,
+	.compat_ioctl		= perf_compat_ioctl,
 	.mmap			= perf_mmap,
 	.fasync			= perf_fasync,
 };
-- 
2.1.0

