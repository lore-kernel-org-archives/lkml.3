Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638Ab3AXUam (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 15:30:42 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:54067
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755872Ab3AXUIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 15:08:43 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 17/74] perf record: Don't pass host machine to guest synthesizer
Date: Thu, 24 Jan 2013 17:07:26 -0300
Message-Id: <1359058103-31645-18-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1359058103-31645-1-git-send-email-acme@infradead.org>
References: <1359058103-31645-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

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
 
-- 
1.8.1.1.361.gec3ae6e

