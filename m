Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934113Ab3GQRzy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 13:55:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61084 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933991Ab3GQRut (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 13:50:49 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 01/23] perf tools: Use session->fd instead of passing fd as argument
Date: Wed, 17 Jul 2013 19:49:41 +0200
Message-Id: <1374083403-14591-2-git-send-email-jolsa@redhat.com>
In-Reply-To: <1374083403-14591-1-git-send-email-jolsa@redhat.com>
References: <1374083403-14591-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using session->fd instead of passing fd as argument because it's
always session->fd that's passed as fd argument.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: David Ahern <dsahern@gmail.com>
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
1.7.11.7

