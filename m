Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932254AbaAWRFT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 12:05:19 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55663 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932176AbaAWRFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 12:05:14 -0500
Date: Thu, 23 Jan 2014 09:04:27 -0800
From: tip-bot for Stephane Eranian <tipbot@zytor.com>
Message-ID: <tip-8ad9219e08af12a5652892e273336dbd31b25b03@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1389972846-6566-3-git-send-email-eranian@google.com>
References: <1389972846-6566-3-git-send-email-eranian@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf stat:
  Fix memory corruption of xyarray when cpumask is used
Git-Commit-ID: 8ad9219e08af12a5652892e273336dbd31b25b03
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 23 Jan 2014 09:04:33 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8ad9219e08af12a5652892e273336dbd31b25b03
Gitweb:     http://git.kernel.org/tip/8ad9219e08af12a5652892e273336dbd31b25b03
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Fri, 17 Jan 2014 16:34:06 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 20 Jan 2014 16:19:09 -0300

perf stat: Fix memory corruption of xyarray when cpumask is used

This patch fixes a memory corruption problem with the xyarray when the
evsel fds get closed at the end of the run_perf_stat() call.

It could be triggered with:

 # perf stat -a -e power/energy-cores/ ls

When cpumask are used by events (.e.g, RAPL or uncores) then the evsel
fds are allocated based on the actual number of CPUs monitored. That
number can be smaller than the total number of CPUs on the system.

The problem arises at the end by perf stat closes the fds twice. When
fds are closed, their entry in the xyarray are set to -1.

The first close() on the evsel is made from __run_perf_stat() and it
uses the actual number of CPUS for the event which is how the xyarray
was allocated for.

The second is from perf_evlist_close() but that one is on the total
number of CPUs in the system, so it assume the xyarray was allocated to
cover it. However it was not, and some writes corrupt memory.

The fix is in perf_evlist_close() is to first try with the evsel->cpus
if present, if not use the evlist->cpus. That fixes the problem.

Signed-off-by: Stephane Eranian <eranian@google.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1389972846-6566-3-git-send-email-eranian@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evlist.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 40bd2c0..59ef280 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -1003,9 +1003,12 @@ void perf_evlist__close(struct perf_evlist *evlist)
 	struct perf_evsel *evsel;
 	int ncpus = cpu_map__nr(evlist->cpus);
 	int nthreads = thread_map__nr(evlist->threads);
+	int n;
 
-	evlist__for_each_reverse(evlist, evsel)
-		perf_evsel__close(evsel, ncpus, nthreads);
+	evlist__for_each_reverse(evlist, evsel) {
+		n = evsel->cpus ? evsel->cpus->nr : ncpus;
+		perf_evsel__close(evsel, n, nthreads);
+	}
 }
 
 int perf_evlist__open(struct perf_evlist *evlist)
