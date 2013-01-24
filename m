Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754366Ab3AXTCf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 14:02:35 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33116 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822Ab3AXTCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 14:02:32 -0500
Date: Thu, 24 Jan 2013 11:02:02 -0800
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-tjhs9v6nqpofmxv3gs5lnu2c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf test:
  Fixup error reporting in basic mmap test
Git-Commit-ID: c5d3d50da2e32441d65d63ac27a67197998668c5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 24 Jan 2013 11:02:08 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c5d3d50da2e32441d65d63ac27a67197998668c5
Gitweb:     http://git.kernel.org/tip/c5d3d50da2e32441d65d63ac27a67197998668c5
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 10 Dec 2012 14:58:42 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 10 Dec 2012 14:58:42 -0300

perf test: Fixup error reporting in basic mmap test

In two cases this test could detect an error, bail out but return zero.
Fix it by reporting -1 for failure.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-tjhs9v6nqpofmxv3gs5lnu2c@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/tests/mmap-basic.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/perf/tests/mmap-basic.c b/tools/perf/tests/mmap-basic.c
index e174681..8682ecf 100644
--- a/tools/perf/tests/mmap-basic.c
+++ b/tools/perf/tests/mmap-basic.c
@@ -128,6 +128,7 @@ int test__basic_mmap(void)
 			goto out_munmap;
 		}
 
+		err = -1;
 		evsel = perf_evlist__id2evsel(evlist, sample.id);
 		if (evsel == NULL) {
 			pr_debug("event with id %" PRIu64
@@ -137,16 +138,17 @@ int test__basic_mmap(void)
 		nr_events[evsel->idx]++;
 	}
 
+	err = 0;
 	list_for_each_entry(evsel, &evlist->entries, node) {
 		if (nr_events[evsel->idx] != expected_nr_events[evsel->idx]) {
 			pr_debug("expected %d %s events, got %d\n",
 				 expected_nr_events[evsel->idx],
 				 perf_evsel__name(evsel), nr_events[evsel->idx]);
+			err = -1;
 			goto out_munmap;
 		}
 	}
 
-	err = 0;
 out_munmap:
 	perf_evlist__munmap(evlist);
 out_close_fd:
