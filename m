Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030285Ab3GSHxp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 03:53:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35889 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966134Ab3GSHxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 03:53:32 -0400
Date: Fri, 19 Jul 2013 00:53:13 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-44b3c57802b7557d0e2d8c3bd39bce942e9324cc@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
In-Reply-To: <1373556513-3000-4-git-send-email-jolsa@redhat.com>
References: <1373556513-3000-4-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Remove event types from perf data file
Git-Commit-ID: 44b3c57802b7557d0e2d8c3bd39bce942e9324cc
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 19 Jul 2013 00:53:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  44b3c57802b7557d0e2d8c3bd39bce942e9324cc
Gitweb:     http://git.kernel.org/tip/44b3c57802b7557d0e2d8c3bd39bce942e9324cc
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Thu, 11 Jul 2013 17:28:31 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 15 Jul 2013 16:28:10 -0300

perf tools: Remove event types from perf data file

Removing event types data storing/reading to/from perf data file as it's
no longer needed. The only user of this data 'perf timechart' was
switched to use tracepoints handler callbacks.

The event_types offset and size stay in the perf data file header but
are ignored from now on.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1373556513-3000-4-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/header.c | 28 +---------------------------
 tools/perf/util/header.h |  3 +--
 2 files changed, 2 insertions(+), 29 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index d12d79c..8862667 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -2334,16 +2334,6 @@ int perf_session__write_header(struct perf_session *session,
 		}
 	}
 
-	header->event_offset = lseek(fd, 0, SEEK_CUR);
-	header->event_size = trace_event_count * sizeof(struct perf_trace_event_type);
-	if (trace_events) {
-		err = do_write(fd, trace_events, header->event_size);
-		if (err < 0) {
-			pr_debug("failed to write perf header events\n");
-			return err;
-		}
-	}
-
 	header->data_offset = lseek(fd, 0, SEEK_CUR);
 
 	if (at_exit) {
@@ -2364,10 +2354,7 @@ int perf_session__write_header(struct perf_session *session,
 			.offset = header->data_offset,
 			.size	= header->data_size,
 		},
-		.event_types = {
-			.offset = header->event_offset,
-			.size	= header->event_size,
-		},
+		/* event_types is ignored, store zeros */
 	};
 
 	memcpy(&f_header.adds_features, &header->adds_features, sizeof(header->adds_features));
@@ -2614,8 +2601,6 @@ int perf_file_header__read(struct perf_file_header *header,
 	memcpy(&ph->adds_features, &header->adds_features,
 	       sizeof(ph->adds_features));
 
-	ph->event_offset = header->event_types.offset;
-	ph->event_size   = header->event_types.size;
 	ph->data_offset  = header->data.offset;
 	ph->data_size	 = header->data.size;
 	return 0;
@@ -2839,17 +2824,6 @@ int perf_session__read_header(struct perf_session *session, int fd)
 
 	symbol_conf.nr_events = nr_attrs;
 
-	if (f_header.event_types.size) {
-		lseek(fd, f_header.event_types.offset, SEEK_SET);
-		trace_events = malloc(f_header.event_types.size);
-		if (trace_events == NULL)
-			return -ENOMEM;
-		if (perf_header__getbuffer64(header, fd, trace_events,
-					     f_header.event_types.size))
-			goto out_errno;
-		trace_event_count =  f_header.event_types.size / sizeof(struct perf_trace_event_type);
-	}
-
 	perf_header__process_sections(header, fd, &session->pevent,
 				      perf_file_section__process);
 
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index 2d1ca7d..298982f 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -45,6 +45,7 @@ struct perf_file_header {
 	u64				attr_size;
 	struct perf_file_section	attrs;
 	struct perf_file_section	data;
+	/* event_types is ignored */
 	struct perf_file_section	event_types;
 	DECLARE_BITMAP(adds_features, HEADER_FEAT_BITS);
 };
@@ -88,8 +89,6 @@ struct perf_header {
 	s64			attr_offset;
 	u64			data_offset;
 	u64			data_size;
-	u64			event_offset;
-	u64			event_size;
 	DECLARE_BITMAP(adds_features, HEADER_FEAT_BITS);
 	struct perf_session_env env;
 };
