Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763AbaFMPED (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 11:04:03 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:46422 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750901AbaFMPEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 11:04:02 -0400
From: Pawel Moll <pawel.moll@arm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: linux-kernel@vger.kernel.org, Drew Richardson <drew.richardson@arm.com>,
        Pawel Moll <pawel.moll@arm.com>
Subject: [PATCH] perf: Handle compat ioctl
Date: Fri, 13 Jun 2014 16:03:32 +0100
Message-Id: <1402671812-9078-1-git-send-email-pawel.moll@arm.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 kernel/events/core.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 24d35cc..967af2c 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3700,6 +3700,26 @@ static long perf_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
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
+#define perf_compat_ioctl NULL
+#endif
+
 int perf_event_task_enable(void)
 {
 	struct perf_event *event;
@@ -4205,7 +4225,7 @@ static const struct file_operations perf_fops = {
 	.read			= perf_read,
 	.poll			= perf_poll,
 	.unlocked_ioctl		= perf_ioctl,
-	.compat_ioctl		= perf_ioctl,
+	.compat_ioctl		= perf_compat_ioctl,
 	.mmap			= perf_mmap,
 	.fasync			= perf_fasync,
 };
-- 
1.9.1

