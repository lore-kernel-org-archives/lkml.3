Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754296AbaJHHX6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 03:23:58 -0400
Received: from casper.infradead.org ([85.118.1.10]:59700 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460AbaJHHX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 03:23:57 -0400
Date: Wed, 8 Oct 2014 09:23:55 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@kernel.org>
Subject: Re: PERF_EVENT_IOC_SET_FILTER has different values based on bitness
Message-ID: <20141008072355.GA10832@worktop.programming.kicks-ass.net>
References: <54347238.2060908@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54347238.2060908@gmail.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2014 at 05:07:36PM -0600, David Ahern wrote:
> 
> 32-bit perf binaries are not able to set filters on 64-bit kernels.
> 
>    $ perf record -e  net:netif_receive_skb --filter 'name == "eth1"
>    Error: failed to set filter with 25 (Inappropriate ioctl for device)
> 
> The reason is that the definition of PERF_EVENT_IOC_SET_FILTER contains a
> pointer:
> 
> #define PERF_EVENT_IOC_SET_FILTER       _IOW('$', 6, char *)
> 
> the size of which of course differs for 32-bit and 64-bit. This has been
> there since the original commit (6fb2915df7f07) back in 2009.
> 

Should be fixed for a while now

---
commit b3f207855f57b9c8f43a547a801340bb5cbc59e5
Author: Pawel Moll <pawel.moll@arm.com>
Date:   Fri Jun 13 16:03:32 2014 +0100

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

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 1cf24b3e42ec..f9c1ed002dbc 100644
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
