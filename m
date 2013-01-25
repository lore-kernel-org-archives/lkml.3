Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756965Ab3AYLHz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 06:07:55 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41300 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753657Ab3AYLHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 06:07:50 -0500
Date: Fri, 25 Jan 2013 03:07:17 -0800
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-x65vsxgzg4dvo3zqohtrrb9o@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf record: Don'
 t pass host machine to guest synthesizer
Git-Commit-ID: 7e383de42565ecb2cf641fff11946f9bc45e8235
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 25 Jan 2013 03:07:23 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7e383de42565ecb2cf641fff11946f9bc45e8235
Gitweb:     http://git.kernel.org/tip/7e383de42565ecb2cf641fff11946f9bc45e8235
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 18 Dec 2012 15:49:27 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 24 Jan 2013 16:40:11 -0300

perf record: Don't pass host machine to guest synthesizer

We were calling perf_session__process_machines(), that would first pass
the struct machine associated with the host to the provided callback,
perf_event__synthesize_guest_os() that would test if it was the host and
if so wouldn't do anything.

Ditch this contraption, just call directly machines__process with the
list of guests.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-x65vsxgzg4dvo3zqohtrrb9o@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c | 11 ++++-------
 tools/perf/util/session.h   |  9 ---------
 2 files changed, 4 insertions(+), 16 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index de60dd4..69e2895 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -328,10 +328,6 @@ static void perf_event__synthesize_guest_os(struct machine *machine, void *data)
 {
 	int err;
 	struct perf_tool *tool = data;
-
-	if (machine__is_host(machine))
-		return;
-
 	/*
 	 *As for guest kernel when processing subcommand record&report,
 	 *we arrange module mmap prior to guest kernel mmap and trigger
@@ -574,9 +570,10 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 		       "Symbol resolution may be skewed if relocation was used (e.g. kexec).\n"
 		       "Check /proc/modules permission or run as root.\n");
 
-	if (perf_guest)
-		perf_session__process_machines(session, tool,
-					       perf_event__synthesize_guest_os);
+	if (perf_guest) {
+		machines__process(&session->machines,
+				  perf_event__synthesize_guest_os, tool);
+	}
 
 	if (!opts->target.system_wide)
 		err = perf_event__synthesize_thread_map(tool, evsel_list->threads,
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 8c23025..426ca0c 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -101,15 +101,6 @@ struct machine *perf_session__findnew_machine(struct perf_session *self, pid_t p
 	return machines__findnew(&self->machines, pid);
 }
 
-static inline
-void perf_session__process_machines(struct perf_session *self,
-				    struct perf_tool *tool,
-				    machine__process_t process)
-{
-	process(&self->host_machine, tool);
-	return machines__process(&self->machines, process, tool);
-}
-
 struct thread *perf_session__findnew(struct perf_session *self, pid_t pid);
 size_t perf_session__fprintf(struct perf_session *self, FILE *fp);
 
