Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522AbaJOKFZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 06:05:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54411 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061AbaJOKFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 06:05:21 -0400
Date: Wed, 15 Oct 2014 03:04:43 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-jvlz2f264e7kpmhjmwltikqw@git.kernel.org>
Cc: paulus@samba.org, bp@suse.de, efault@gmx.de, jolsa@redhat.com,
        hpa@zytor.com, namhyung@kernel.org, linux-kernel@vger.kernel.org,
        mingo@kernel.org, dsahern@gmail.com, eranian@google.com,
        acme@redhat.com, fweisbec@gmail.com, jean.pihet@linaro.org,
        tglx@linutronix.de, adrian.hunter@intel.com, peterz@infradead.org,
        dzickus@redhat.com
Reply-To: eranian@google.com, dsahern@gmail.com, mingo@kernel.org, bp@suse.de,
        namhyung@kernel.org, linux-kernel@vger.kernel.org, efault@gmx.de,
        hpa@zytor.com, jolsa@redhat.com, paulus@samba.org, dzickus@redhat.com,
        adrian.hunter@intel.com, peterz@infradead.org, tglx@linutronix.de,
        acme@redhat.com, jean.pihet@linaro.org, fweisbec@gmail.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf evlist:
  Check that there is a thread_map when preparing a workload
Git-Commit-ID: 1aaf63b1ee912abd7675681f9d6ffaaf2ffc0451
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

Commit-ID:  1aaf63b1ee912abd7675681f9d6ffaaf2ffc0451
Gitweb:     http://git.kernel.org/tip/1aaf63b1ee912abd7675681f9d6ffaaf2ffc0451
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 10 Oct 2014 14:29:49 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 14 Oct 2014 17:32:53 -0300

perf evlist: Check that there is a thread_map when preparing a workload

The perf_evlist__prepare_workload expects a thread map to be in place
so that it can store the pid of the workload being started, so check it
and tell the developer about it instead of segfaulting.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: David Ahern <dsahern@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-jvlz2f264e7kpmhjmwltikqw@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evlist.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 3cebc9a..5fc7bd4 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -1276,8 +1276,14 @@ int perf_evlist__prepare_workload(struct perf_evlist *evlist, struct target *tar
 		sigaction(SIGUSR1, &act, NULL);
 	}
 
-	if (target__none(target))
+	if (target__none(target)) {
+		if (evlist->threads == NULL) {
+			fprintf(stderr, "FATAL: evlist->threads need to be set at this point (%s:%d).\n",
+				__func__, __LINE__);
+			goto out_close_pipes;
+		}
 		evlist->threads->map[0] = evlist->workload.pid;
+	}
 
 	close(child_ready_pipe[1]);
 	close(go_pipe[0]);
