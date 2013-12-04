Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932744Ab3LDPlF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 10:41:05 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58262 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932398Ab3LDPlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 10:41:02 -0500
Date: Wed, 4 Dec 2013 07:40:03 -0800
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-6233dd5efdf9e2c2da1b003cfb70307b7b2028e8@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, efault@gmx.de,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        adrian.hunter@intel.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, efault@gmx.de, peterz@infradead.org,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, adrian.hunter@intel.com, tglx@linutronix.de
In-Reply-To: <1385634619-8129-2-git-send-email-jolsa@redhat.com>
References: <1385634619-8129-2-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf record:
  Unify data output code into perf_record__write function
Git-Commit-ID: 6233dd5efdf9e2c2da1b003cfb70307b7b2028e8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 04 Dec 2013 07:40:10 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6233dd5efdf9e2c2da1b003cfb70307b7b2028e8
Gitweb:     http://git.kernel.org/tip/6233dd5efdf9e2c2da1b003cfb70307b7b2028e8
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Thu, 28 Nov 2013 11:30:13 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 2 Dec 2013 09:22:45 -0300

perf record: Unify data output code into perf_record__write function

Unifying current 2 data output functions do_write_output and
write_output into single one perf_record__write.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1385634619-8129-2-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c | 20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 65615a8..d93e2ee 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -76,7 +76,7 @@ struct perf_record {
 	long			samples;
 };
 
-static int do_write_output(struct perf_record *rec, void *buf, size_t size)
+static int perf_record__write(struct perf_record *rec, void *buf, size_t size)
 {
 	struct perf_data_file *file = &rec->file;
 
@@ -97,21 +97,13 @@ static int do_write_output(struct perf_record *rec, void *buf, size_t size)
 	return 0;
 }
 
-static int write_output(struct perf_record *rec, void *buf, size_t size)
-{
-	return do_write_output(rec, buf, size);
-}
-
 static int process_synthesized_event(struct perf_tool *tool,
 				     union perf_event *event,
 				     struct perf_sample *sample __maybe_unused,
 				     struct machine *machine __maybe_unused)
 {
 	struct perf_record *rec = container_of(tool, struct perf_record, tool);
-	if (write_output(rec, event, event->header.size) < 0)
-		return -1;
-
-	return 0;
+	return perf_record__write(rec, event, event->header.size);
 }
 
 static int perf_record__mmap_read(struct perf_record *rec,
@@ -136,7 +128,7 @@ static int perf_record__mmap_read(struct perf_record *rec,
 		size = md->mask + 1 - (old & md->mask);
 		old += size;
 
-		if (write_output(rec, buf, size) < 0) {
+		if (perf_record__write(rec, buf, size) < 0) {
 			rc = -1;
 			goto out;
 		}
@@ -146,7 +138,7 @@ static int perf_record__mmap_read(struct perf_record *rec,
 	size = head - old;
 	old += size;
 
-	if (write_output(rec, buf, size) < 0) {
+	if (perf_record__write(rec, buf, size) < 0) {
 		rc = -1;
 		goto out;
 	}
@@ -335,8 +327,8 @@ static int perf_record__mmap_read_all(struct perf_record *rec)
 	}
 
 	if (perf_header__has_feat(&rec->session->header, HEADER_TRACING_DATA))
-		rc = write_output(rec, &finished_round_event,
-				  sizeof(finished_round_event));
+		rc = perf_record__write(rec, &finished_round_event,
+					sizeof(finished_round_event));
 
 out:
 	return rc;
