Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756252Ab3H2KHw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 06:07:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34976 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753467Ab3H2KHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 06:07:49 -0400
Date: Thu, 29 Aug 2013 03:07:32 -0700
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-bec196720431db2fd6a9b03cbd77eb336e6f52de@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, ak@linux.intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, ak@linux.intel.com, tglx@linutronix.de
In-Reply-To: <1375670486-15480-1-git-send-email-andi@firstfloor.org>
References: <1375670486-15480-1-git-send-email-andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Try to increase the file descriptor limits on EMFILE
Git-Commit-ID: bec196720431db2fd6a9b03cbd77eb336e6f52de
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 29 Aug 2013 03:07:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bec196720431db2fd6a9b03cbd77eb336e6f52de
Gitweb:     http://git.kernel.org/tip/bec196720431db2fd6a9b03cbd77eb336e6f52de
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Sun, 4 Aug 2013 19:41:26 -0700
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 16 Aug 2013 17:17:57 -0300

perf tools: Try to increase the file descriptor limits on EMFILE

perf stat -a needs 10 open file descriptors per logical CPU
perf stat -a -dddd needs 20 open fds for each.

This implies that stat -a doesn't work on any system with the default
ulimit -n 1024 which has more than ~100 CPUs and stat -a -dddd doesn't
work on anything with more than 46 CPUs.

Longer term there needs to be probably some way to lower the file
descriptor requirements. This would need some changes in the kernel/user
interface.

But short term this patch just tries to increase the file descriptor
limit in perf itself, when it runs into a EMFILE.

It first sets it to the hard limit, and then tries to increase the hard
limit.

On Fedora systems the default seems to be soft limit 1024 and hard limit
4*1024. So even non root can support 409 or 186 CPUs respectively. root
can go far higher.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Link: http://lkml.kernel.org/r/1375670486-15480-1-git-send-email-andi@firstfloor.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evsel.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 960394e..a29c8d0 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -13,6 +13,7 @@
 #include <traceevent/event-parse.h>
 #include <linux/hw_breakpoint.h>
 #include <linux/perf_event.h>
+#include <sys/resource.h>
 #include "asm/bug.h"
 #include "evsel.h"
 #include "evlist.h"
@@ -867,6 +868,7 @@ static int __perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
 	int cpu, thread;
 	unsigned long flags = 0;
 	int pid = -1, err;
+	enum { NO_CHANGE, SET_TO_MAX, INCREASED_MAX } set_rlimit = NO_CHANGE;
 
 	if (evsel->fd == NULL &&
 	    perf_evsel__alloc_fd(evsel, cpus->nr, threads->nr) < 0)
@@ -894,6 +896,7 @@ retry_sample_id:
 
 			group_fd = get_group_fd(evsel, cpu, thread);
 
+retry_open:
 			FD(evsel, cpu, thread) = sys_perf_event_open(&evsel->attr,
 								     pid,
 								     cpus->map[cpu],
@@ -902,12 +905,37 @@ retry_sample_id:
 				err = -errno;
 				goto try_fallback;
 			}
+			set_rlimit = NO_CHANGE;
 		}
 	}
 
 	return 0;
 
 try_fallback:
+	/*
+	 * perf stat needs between 5 and 22 fds per CPU. When we run out
+	 * of them try to increase the limits.
+	 */
+	if (err == -EMFILE && set_rlimit < INCREASED_MAX) {
+		struct rlimit l;
+		int old_errno = errno;
+
+		if (getrlimit(RLIMIT_NOFILE, &l) == 0) {
+			if (set_rlimit == NO_CHANGE)
+				l.rlim_cur = l.rlim_max;
+			else {
+				l.rlim_cur = l.rlim_max + 1000;
+				l.rlim_max = l.rlim_cur;
+			}
+			if (setrlimit(RLIMIT_NOFILE, &l) == 0) {
+				set_rlimit++;
+				errno = old_errno;
+				goto retry_open;
+			}
+		}
+		errno = old_errno;
+	}
+
 	if (err != -EINVAL || cpu > 0 || thread > 0)
 		goto out_close;
 
