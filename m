Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754451Ab3JUIxD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 04:53:03 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39825 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754393Ab3JUIw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:52:58 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
        "Salman Qazi" <sqazi@google.com>, "Ingo Molnar" <mingo@kernel.org>,
        "Tejun Heo" <tj@kernel.org>
Date: Mon, 21 Oct 2013 09:46:28 +0100
Message-ID: <lsq.1382345188.736524846@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 121/149] perf: Use css_tryget() to avoid propping up
 css refcount
In-Reply-To: <lsq.1382345187.199780875@decadent.org.uk>
X-SA-Exim-Connect-IP: 212.20.242.100
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.52-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Salman Qazi <sqazi@google.com>

commit 9c5da09d266ca9b32eb16cf940f8161d949c2fe5 upstream.

An rmdir pushes css's ref count to zero.  However, if the associated
directory is open at the time, the dentry ref count is non-zero.  If
the fd for this directory is then passed into perf_event_open, it
does a css_get().  This bounces the ref count back up from zero.  This
is a problem by itself.  But what makes it turn into a crash is the
fact that we end up doing an extra dput, since we perform a dput
when css_put sees the ref count go down to zero.

css_tryget() does not fall into that trap. So, we use that instead.

Reproduction test-case for the bug:

 #include <unistd.h>
 #include <sys/types.h>
 #include <sys/stat.h>
 #include <fcntl.h>
 #include <linux/unistd.h>
 #include <linux/perf_event.h>
 #include <string.h>
 #include <errno.h>
 #include <stdio.h>

 #define PERF_FLAG_PID_CGROUP    (1U << 2)

 int perf_event_open(struct perf_event_attr *hw_event_uptr,
                     pid_t pid, int cpu, int group_fd, unsigned long flags) {
         return syscall(__NR_perf_event_open,hw_event_uptr, pid, cpu,
                 group_fd, flags);
 }

 /*
  * Directly poke at the perf_event bug, since it's proving hard to repro
  * depending on where in the kernel tree.  what moved?
  */
 int main(int argc, char **argv)
 {
        int fd;
        struct perf_event_attr attr;
        memset(&attr, 0, sizeof(attr));
        attr.exclude_kernel = 1;
        attr.size = sizeof(attr);
        mkdir("/dev/cgroup/perf_event/blah", 0777);
        fd = open("/dev/cgroup/perf_event/blah", O_RDONLY);
        perror("open");
        rmdir("/dev/cgroup/perf_event/blah");
        sleep(2);
        perf_event_open(&attr, fd, 0, -1,  PERF_FLAG_PID_CGROUP);
        perror("perf_event_open");
        close(fd);
        return 0;
 }

Signed-off-by: Salman Qazi <sqazi@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Tejun Heo <tj@kernel.org>
Link: http://lkml.kernel.org/r/20120614223108.1025.2503.stgit@dungbeetle.mtv.corp.google.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/events/core.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -242,9 +242,9 @@ perf_cgroup_match(struct perf_event *eve
 	return !event->cgrp || event->cgrp == cpuctx->cgrp;
 }
 
-static inline void perf_get_cgroup(struct perf_event *event)
+static inline bool perf_tryget_cgroup(struct perf_event *event)
 {
-	css_get(&event->cgrp->css);
+	return css_tryget(&event->cgrp->css);
 }
 
 static inline void perf_put_cgroup(struct perf_event *event)
@@ -473,7 +473,11 @@ static inline int perf_cgroup_connect(in
 	event->cgrp = cgrp;
 
 	/* must be done before we fput() the file */
-	perf_get_cgroup(event);
+	if (!perf_tryget_cgroup(event)) {
+		event->cgrp = NULL;
+		ret = -ENOENT;
+		goto out;
+	}
 
 	/*
 	 * all events in a group must monitor

