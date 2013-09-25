Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512Ab3IYMvM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 08:51:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36312 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755394Ab3IYMvI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 08:51:08 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 01/21] perf tools: Introduce perf_evlist__wait_workload function
Date: Wed, 25 Sep 2013 14:50:27 +0200
Message-Id: <1380113447-17144-2-git-send-email-jolsa@redhat.com>
In-Reply-To: <1380113447-17144-1-git-send-email-jolsa@redhat.com>
References: <1380113447-17144-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introducing perf_evlist__wait_workload function and adding it
to the tests that fork workload in order to properly wait the
child process. Otherwise other tests could wait wrong child
process and be wrongly synced.

Also restoring signals handlers properly for task exit test.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/tests/perf-record.c |  1 +
 tools/perf/tests/task-exit.c   |  5 +++++
 tools/perf/util/evlist.c       | 10 ++++++++++
 tools/perf/util/evlist.h       |  1 +
 4 files changed, 17 insertions(+)

diff --git a/tools/perf/tests/perf-record.c b/tools/perf/tests/perf-record.c
index 82ac715..b1fc1c0 100644
--- a/tools/perf/tests/perf-record.c
+++ b/tools/perf/tests/perf-record.c
@@ -308,6 +308,7 @@ out_close_evlist:
 out_delete_maps:
 	perf_evlist__delete_maps(evlist);
 out_delete_evlist:
+	perf_evlist__wait_workload(evlist);
 	perf_evlist__delete(evlist);
 out:
 	return (err < 0 || errs > 0) ? -1 : 0;
diff --git a/tools/perf/tests/task-exit.c b/tools/perf/tests/task-exit.c
index b07f8a1..d299565 100644
--- a/tools/perf/tests/task-exit.c
+++ b/tools/perf/tests/task-exit.c
@@ -103,11 +103,16 @@ retry:
 		err = -1;
 	}
 
+	/* Restore defaults and wait the child process. */
+	signal(SIGCHLD, SIG_DFL);
+	signal(SIGUSR1, SIG_DFL);
+
 	perf_evlist__munmap(evlist);
 out_close_evlist:
 	perf_evlist__close(evlist);
 out_delete_maps:
 	perf_evlist__delete_maps(evlist);
+	perf_evlist__wait_workload(evlist);
 	perf_evlist__delete(evlist);
 	return err;
 }
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index f0d71a9..c4d382d 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -1005,6 +1005,16 @@ out_err:
 	return err;
 }
 
+int perf_evlist__wait_workload(struct perf_evlist *evlist)
+{
+	int status, err = -1, pid = evlist->workload.pid;
+
+	if (pid > 0)
+		err = waitpid(pid, &status, 0);
+
+	return err ? err : status;
+}
+
 int perf_evlist__prepare_workload(struct perf_evlist *evlist,
 				  struct perf_target *target,
 				  const char *argv[], bool pipe_output,
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 871b55a..0dbd8f8 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -98,6 +98,7 @@ bool perf_can_sample_identifier(void);
 void perf_evlist__config(struct perf_evlist *evlist,
 			 struct perf_record_opts *opts);
 
+int perf_evlist__wait_workload(struct perf_evlist *evlist);
 int perf_evlist__prepare_workload(struct perf_evlist *evlist,
 				  struct perf_target *target,
 				  const char *argv[], bool pipe_output,
-- 
1.7.11.7

