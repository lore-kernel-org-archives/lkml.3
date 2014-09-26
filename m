Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821AbaIZJUX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 05:20:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57005 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753124AbaIZJUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:20:20 -0400
Date: Fri, 26 Sep 2014 02:19:16 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-y2sca7z3wicvvy40a50lozwm@git.kernel.org>
Cc: eranian@google.com, acme@redhat.com, mingo@kernel.org, jolsa@kernel.org,
        peterz@infradead.org, efault@gmx.de, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        dzickus@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, namhyung@kernel.org,
        adrian.hunter@intel.com
Reply-To: mingo@kernel.org, acme@redhat.com, eranian@google.com,
        jolsa@kernel.org, efault@gmx.de, peterz@infradead.org,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de, dzickus@redhat.com, hpa@zytor.com,
        paulus@samba.org, linux-kernel@vger.kernel.org, namhyung@kernel.org,
        adrian.hunter@intel.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evlist:
  Introduce perf_evlist__filter_pollfd method
Git-Commit-ID: 1ddec7f0d0ab5b71cf2cc5a782441c20e7afbcfb
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

Commit-ID:  1ddec7f0d0ab5b71cf2cc5a782441c20e7afbcfb
Gitweb:     http://git.kernel.org/tip/1ddec7f0d0ab5b71cf2cc5a782441c20e7afbcfb
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 12 Aug 2014 23:04:11 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 25 Sep 2014 16:46:53 -0300

perf evlist: Introduce perf_evlist__filter_pollfd method

To remove all entries in evlist->pollfd[] that have revents matching at
least one of the bits in the specified mask.

It'll adjust evlist->nr_fds to the number of unfiltered fds and will
return this value, as a convenience and to avoid requiring direct access
to internal state of perf_evlist objects.

This will be used after polling the evlist fds so that we remove fds
that were closed by the kernel.

Acked-by: Jiri Olsa <jolsa@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-y2sca7z3wicvvy40a50lozwm@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evlist.c | 21 +++++++++++++++++++++
 tools/perf/util/evlist.h |  2 ++
 2 files changed, 23 insertions(+)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index a3e28b4..023bc38 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -428,6 +428,27 @@ void perf_evlist__add_pollfd(struct perf_evlist *evlist, int fd)
 	evlist->nr_fds++;
 }
 
+int perf_evlist__filter_pollfd(struct perf_evlist *evlist, short revents_and_mask)
+{
+	int fd, nr_fds = 0;
+
+	if (evlist->nr_fds == 0)
+		return 0;
+
+	for (fd = 0; fd < evlist->nr_fds; ++fd) {
+		if (evlist->pollfd[fd].revents & revents_and_mask)
+			continue;
+
+		if (fd != nr_fds)
+			evlist->pollfd[nr_fds] = evlist->pollfd[fd];
+
+		++nr_fds;
+	}
+
+	evlist->nr_fds = nr_fds;
+	return nr_fds;
+}
+
 static void perf_evlist__id_hash(struct perf_evlist *evlist,
 				 struct perf_evsel *evsel,
 				 int cpu, int thread, u64 id)
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 106de53..1082420 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -84,6 +84,8 @@ void perf_evlist__id_add(struct perf_evlist *evlist, struct perf_evsel *evsel,
 
 void perf_evlist__add_pollfd(struct perf_evlist *evlist, int fd);
 
+int perf_evlist__filter_pollfd(struct perf_evlist *evlist, short revents_and_mask);
+
 struct perf_evsel *perf_evlist__id2evsel(struct perf_evlist *evlist, u64 id);
 
 struct perf_sample_id *perf_evlist__id2sid(struct perf_evlist *evlist, u64 id);
