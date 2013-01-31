Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224Ab3AaKtn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 05:49:43 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36148 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886Ab3AaKtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 05:49:41 -0500
Date: Thu, 31 Jan 2013 02:49:00 -0800
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-t3181qy15avffdacqjcxfku2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tests: Fix leaks on PERF_RECORD_* test
Git-Commit-ID: ec13abc37f71c89189350dce491189fb5b659184
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 31 Jan 2013 02:49:06 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ec13abc37f71c89189350dce491189fb5b659184
Gitweb:     http://git.kernel.org/tip/ec13abc37f71c89189350dce491189fb5b659184
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 25 Jan 2013 13:10:00 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 30 Jan 2013 10:35:02 -0300

perf tests: Fix leaks on PERF_RECORD_* test

This test:

 7: Validate PERF_RECORD_* events & perf_sample fields

needs to call perf_evlist__delete_maps().

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-t3181qy15avffdacqjcxfku2@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/tests/perf-record.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/tools/perf/tests/perf-record.c b/tools/perf/tests/perf-record.c
index 6ea66cf..1e8e512 100644
--- a/tools/perf/tests/perf-record.c
+++ b/tools/perf/tests/perf-record.c
@@ -96,7 +96,7 @@ int test__PERF_RECORD(void)
 	err = perf_evlist__prepare_workload(evlist, &opts, argv);
 	if (err < 0) {
 		pr_debug("Couldn't run the workload!\n");
-		goto out_delete_evlist;
+		goto out_delete_maps;
 	}
 
 	/*
@@ -111,7 +111,7 @@ int test__PERF_RECORD(void)
 	err = sched__get_first_possible_cpu(evlist->workload.pid, &cpu_mask);
 	if (err < 0) {
 		pr_debug("sched__get_first_possible_cpu: %s\n", strerror(errno));
-		goto out_delete_evlist;
+		goto out_delete_maps;
 	}
 
 	cpu = err;
@@ -121,7 +121,7 @@ int test__PERF_RECORD(void)
 	 */
 	if (sched_setaffinity(evlist->workload.pid, cpu_mask_size, &cpu_mask) < 0) {
 		pr_debug("sched_setaffinity: %s\n", strerror(errno));
-		goto out_delete_evlist;
+		goto out_delete_maps;
 	}
 
 	/*
@@ -131,7 +131,7 @@ int test__PERF_RECORD(void)
 	err = perf_evlist__open(evlist);
 	if (err < 0) {
 		pr_debug("perf_evlist__open: %s\n", strerror(errno));
-		goto out_delete_evlist;
+		goto out_delete_maps;
 	}
 
 	/*
@@ -142,7 +142,7 @@ int test__PERF_RECORD(void)
 	err = perf_evlist__mmap(evlist, opts.mmap_pages, false);
 	if (err < 0) {
 		pr_debug("perf_evlist__mmap: %s\n", strerror(errno));
-		goto out_delete_evlist;
+		goto out_delete_maps;
 	}
 
 	/*
@@ -305,6 +305,8 @@ found_exit:
 	}
 out_err:
 	perf_evlist__munmap(evlist);
+out_delete_maps:
+	perf_evlist__delete_maps(evlist);
 out_delete_evlist:
 	perf_evlist__delete(evlist);
 out:
