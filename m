Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751933AbaHTIU5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 04:20:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46982 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423AbaHTIUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 04:20:53 -0400
Date: Wed, 20 Aug 2014 01:18:37 -0700
From: tip-bot for Pawel Moll <tipbot@zytor.com>
Message-ID: <tip-b3f207855f57b9c8f43a547a801340bb5cbc59e5@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, drew.richardson@arm.com, acme@kernel.org,
        jolsa@redhat.com, pawel.moll@arm.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, drew.richardson@arm.com, acme@kernel.org,
        jolsa@redhat.com, pawel.moll@arm.com, tglx@linutronix.de
In-Reply-To: <1402671812-9078-1-git-send-email-pawel.moll@arm.com>
References: <1402671812-9078-1-git-send-email-pawel.moll@arm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf: Handle compat ioctl
Git-Commit-ID: b3f207855f57b9c8f43a547a801340bb5cbc59e5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b3f207855f57b9c8f43a547a801340bb5cbc59e5
Gitweb:     http://git.kernel.org/tip/b3f207855f57b9c8f43a547a801340bb5cbc59e5
Author:     Pawel Moll <pawel.moll@arm.com>
AuthorDate: Fri, 13 Jun 2014 16:03:32 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 20 Aug 2014 09:42:13 +0200

perf: Handle compat ioctl

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
---
 kernel/events/core.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 1cf24b3..f9c1ed0 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -41,6 +41,7 @@
 #include <linux/cgroup.h>
 #include <linux/module.h>
 #include <linux/mman.h>
+#include <linux/compat.h>
 
 #include "internal.h"
 
@@ -3717,6 +3718,26 @@ static long perf_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
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
@@ -4222,7 +4243,7 @@ static const struct file_operations perf_fops = {
 	.read			= perf_read,
 	.poll			= perf_poll,
 	.unlocked_ioctl		= perf_ioctl,
-	.compat_ioctl		= perf_ioctl,
+	.compat_ioctl		= perf_compat_ioctl,
 	.mmap			= perf_mmap,
 	.fasync			= perf_fasync,
 };
