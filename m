Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752386AbaBVRzg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 12:55:36 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40704 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775AbaBVRzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 12:55:35 -0500
Date: Sat, 22 Feb 2014 09:54:57 -0800
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-f67697bd079f4bbcbe7d6d26765a06b18afe0630@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        eranian@google.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        paulus@samba.org, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1391524668-12546-1-git-send-email-jolsa@redhat.com>
References: <1391524668-12546-1-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Handle PERF_RECORD_HEADER_EVENT_TYPE properly
Git-Commit-ID: f67697bd079f4bbcbe7d6d26765a06b18afe0630
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

Commit-ID:  f67697bd079f4bbcbe7d6d26765a06b18afe0630
Gitweb:     http://git.kernel.org/tip/f67697bd079f4bbcbe7d6d26765a06b18afe0630
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Tue, 4 Feb 2014 15:37:48 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 10 Feb 2014 11:34:31 -0300

perf tools: Handle PERF_RECORD_HEADER_EVENT_TYPE properly

We removed event types from data file in following commits:

  6065210 perf tools: Remove event types framework completely
  44b3c57 perf tools: Remove event types from perf data file

We no longer need this information, because we can get it directly from
tracepoints.

But we still need to handle PERF_RECORD_HEADER_EVENT_TYPE event for the
sake of old perf data files created in pipe mode like:

  $ perf.3.4 record -o - foo >perf.data
  $ perf.312 report -i - < perf.data

Reported-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1391524668-12546-1-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/session.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 0b39a48..5da6ce7 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1008,6 +1008,12 @@ static int perf_session__process_user_event(struct perf_session *session, union
 		if (err == 0)
 			perf_session__set_id_hdr_size(session);
 		return err;
+	case PERF_RECORD_HEADER_EVENT_TYPE:
+		/*
+		 * Depreceated, but we need to handle it for sake
+		 * of old data files create in pipe mode.
+		 */
+		return 0;
 	case PERF_RECORD_HEADER_TRACING_DATA:
 		/* setup for reading amidst mmap */
 		lseek(fd, file_offset, SEEK_SET);
