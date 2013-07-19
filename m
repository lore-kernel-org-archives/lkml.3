Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030303Ab3GSHyk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 03:54:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35944 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030239Ab3GSHyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 03:54:35 -0400
Date: Fri, 19 Jul 2013 00:54:11 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-d4339569a6f8bb1e703337175dcd4fd4bcd5d891@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        ak@linux.intel.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, ak@linux.intel.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1374083403-14591-2-git-send-email-jolsa@redhat.com>
References: <1374083403-14591-2-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf session: Use session->
 fd instead of passing fd as argument
Git-Commit-ID: d4339569a6f8bb1e703337175dcd4fd4bcd5d891
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 19 Jul 2013 00:54:18 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d4339569a6f8bb1e703337175dcd4fd4bcd5d891
Gitweb:     http://git.kernel.org/tip/d4339569a6f8bb1e703337175dcd4fd4bcd5d891
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Wed, 17 Jul 2013 19:49:41 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 17 Jul 2013 16:46:07 -0300

perf session: Use session->fd instead of passing fd as argument

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
