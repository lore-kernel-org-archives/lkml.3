Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759551Ab3GRTuk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 15:50:40 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41748 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759524Ab3GRTug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 15:50:36 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Andi Kleen <ak@linux.intel.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 72/76] perf session: Use session->fd instead of passing fd as argument
Date: Thu, 18 Jul 2013 16:49:59 -0300
Message-Id: <1374177003-3706-73-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1374177003-3706-1-git-send-email-acme@infradead.org>
References: <1374177003-3706-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Using session->fd instead of passing fd as argument because it's always
session->fd that's passed as fd argument.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1374083403-14591-2-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/header.c  | 11 +++++------
 tools/perf/util/header.h  |  2 +-
 tools/perf/util/session.c |  4 ++--
 3 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index b28a65e..b3f253f 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -2619,19 +2619,17 @@ static int perf_file_header__read_pipe(struct perf_pipe_file_header *header,
 	return 0;
 }
 
-static int perf_header__read_pipe(struct perf_session *session, int fd)
+static int perf_header__read_pipe(struct perf_session *session)
 {
 	struct perf_header *header = &session->header;
 	struct perf_pipe_file_header f_header;
 
-	if (perf_file_header__read_pipe(&f_header, header, fd,
+	if (perf_file_header__read_pipe(&f_header, header, session->fd,
 					session->repipe) < 0) {
 		pr_debug("incompatible file format\n");
 		return -EINVAL;
 	}
 
-	session->fd = fd;
-
 	return 0;
 }
 
@@ -2725,20 +2723,21 @@ static int perf_evlist__prepare_tracepoint_events(struct perf_evlist *evlist,
 	return 0;
 }
 
-int perf_session__read_header(struct perf_session *session, int fd)
+int perf_session__read_header(struct perf_session *session)
 {
 	struct perf_header *header = &session->header;
 	struct perf_file_header	f_header;
 	struct perf_file_attr	f_attr;
 	u64			f_id;
 	int nr_attrs, nr_ids, i, j;
+	int fd = session->fd;
 
 	session->evlist = perf_evlist__new();
 	if (session->evlist == NULL)
 		return -ENOMEM;
 
 	if (session->fd_pipe)
-		return perf_header__read_pipe(session, fd);
+		return perf_header__read_pipe(session);
 
 	if (perf_file_header__read(&f_header, header, fd) < 0)
 		return -EINVAL;
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index 669fda5..0bacb2d 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -96,7 +96,7 @@ struct perf_header {
 struct perf_evlist;
 struct perf_session;
 
-int perf_session__read_header(struct perf_session *session, int fd);
+int perf_session__read_header(struct perf_session *session);
 int perf_session__write_header(struct perf_session *session,
 			       struct perf_evlist *evlist,
 			       int fd, bool at_exit);
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index d0d9f94..272c9cf 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -24,7 +24,7 @@ static int perf_session__open(struct perf_session *self, bool force)
 		self->fd_pipe = true;
 		self->fd = STDIN_FILENO;
 
-		if (perf_session__read_header(self, self->fd) < 0)
+		if (perf_session__read_header(self) < 0)
 			pr_err("incompatible file format (rerun with -v to learn more)");
 
 		return 0;
@@ -56,7 +56,7 @@ static int perf_session__open(struct perf_session *self, bool force)
 		goto out_close;
 	}
 
-	if (perf_session__read_header(self, self->fd) < 0) {
+	if (perf_session__read_header(self) < 0) {
 		pr_err("incompatible file format (rerun with -v to learn more)");
 		goto out_close;
 	}
-- 
1.8.1.4

