Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756800Ab3JHKle (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 06:41:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37601 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754095Ab3JHKlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 06:41:31 -0400
Date: Tue, 8 Oct 2013 03:41:10 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-b314e5cfd11fd78545ce6c2be42646254390c1aa@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        dsahern@gmail.com, tglx@linutronix.de, sonnyrao@chromium.org
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        dsahern@gmail.com, tglx@linutronix.de, sonnyrao@chromium.org
In-Reply-To: <1380529188-27193-1-git-send-email-namhyung@kernel.org>
References: <1380529188-27193-1-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf session:
  Fix infinite loop on invalid perf.data file
Git-Commit-ID: b314e5cfd11fd78545ce6c2be42646254390c1aa
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 08 Oct 2013 03:41:17 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b314e5cfd11fd78545ce6c2be42646254390c1aa
Gitweb:     http://git.kernel.org/tip/b314e5cfd11fd78545ce6c2be42646254390c1aa
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Mon, 30 Sep 2013 17:19:48 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 4 Oct 2013 15:17:46 -0300

perf session: Fix infinite loop on invalid perf.data file

perf-record updates the header in the perf.data file at termination.
Without this update perf-report (and other processing built-ins) it
caused an infinite loop when perf report (or something like) called.

This is because the algorithm in __perf_session__process_events()
depends on the data_size which is read from file header.  Use file size
directly instead in this case to do the best-effort processing.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Tested-by: David Ahern <dsahern@gmail.com>
Tested-by: Sonny Rao <sonnyrao@chromium.org>
Acked-by: Ingo Molnar <mingo@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Sonny Rao <sonnyrao@chromium.org>
Link: http://lkml.kernel.org/r/1380529188-27193-1-git-send-email-namhyung@kernel.org
Signed-off-by: David Ahern <dsahern@gmail.com>
[ Reworded warning as per Ingo Molnar suggestion, replaces 'perf.data'
  with session->filename, to precisely identify the data file involved ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/header.c  | 12 ++++++++++++
 tools/perf/util/session.c |  2 +-
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index ce69901..c3e5a3b 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -2768,6 +2768,18 @@ int perf_session__read_header(struct perf_session *session)
 	if (perf_file_header__read(&f_header, header, fd) < 0)
 		return -EINVAL;
 
+	/*
+	 * Sanity check that perf.data was written cleanly; data size is
+	 * initialized to 0 and updated only if the on_exit function is run.
+	 * If data size is still 0 then the file contains only partial
+	 * information.  Just warn user and process it as much as it can.
+	 */
+	if (f_header.data.size == 0) {
+		pr_warning("WARNING: The %s file's data size field is 0 which is unexpected.\n"
+			   "Was the 'perf record' command properly terminated?\n",
+			   session->filename);
+	}
+
 	nr_attrs = f_header.attrs.size / f_header.attr_size;
 	lseek(fd, f_header.attrs.offset, SEEK_SET);
 
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 37c4718..568b750 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1312,7 +1312,7 @@ int __perf_session__process_events(struct perf_session *session,
 	file_offset = page_offset;
 	head = data_offset - page_offset;
 
-	if (data_offset + data_size < file_size)
+	if (data_size && (data_offset + data_size < file_size))
 		file_size = data_offset + data_size;
 
 	progress_next = file_size / 16;
