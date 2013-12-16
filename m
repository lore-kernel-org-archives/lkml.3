Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754444Ab3LPP1h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 10:27:37 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47603 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754667Ab3LPP1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 10:27:34 -0500
Date: Mon, 16 Dec 2013 07:27:05 -0800
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-c09ec622629eeb4b7877646a42852e7156363425@git.kernel.org>
Cc: acme@redhat.com, eranian@google.com, mingo@redhat.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, efault@gmx.de, jolsa@redhat.com,
        fweisbec@gmail.com, ak@linux.intel.com, dsahern@gmail.com,
        tglx@linutronix.de, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, namhyung@gmail.com,
        adrian.hunter@intel.com
Reply-To: mingo@kernel.org, mingo@redhat.com, eranian@google.com,
        acme@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        ak@linux.intel.com, tglx@linutronix.de, hpa@zytor.com,
        paulus@samba.org, linux-kernel@vger.kernel.org, namhyung@gmail.com,
        adrian.hunter@intel.com
In-Reply-To: <1386765443-26966-18-git-send-email-alexander.shishkin@linux.intel.com>
References: <1386765443-26966-18-git-send-email-alexander.shishkin@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evlist: Add can_select_event() method
Git-Commit-ID: c09ec622629eeb4b7877646a42852e7156363425
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 16 Dec 2013 07:27:11 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c09ec622629eeb4b7877646a42852e7156363425
Gitweb:     http://git.kernel.org/tip/c09ec622629eeb4b7877646a42852e7156363425
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Wed, 11 Dec 2013 14:36:29 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 13 Dec 2013 10:30:20 -0300

perf evlist: Add can_select_event() method

Add a function to determine whether an event can be selected.

This function is needed to allow a tool to automatically select
additional events, but only if they are available.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1386765443-26966-18-git-send-email-alexander.shishkin@linux.intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evlist.h |  2 ++
 tools/perf/util/record.c | 37 +++++++++++++++++++++++++++++++++++++
 2 files changed, 39 insertions(+)

diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 649d6ea..8a04aae 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -193,4 +193,6 @@ static inline void perf_mmap__write_tail(struct perf_mmap *md,
 	pc->data_tail = tail;
 }
 
+bool perf_evlist__can_select_event(struct perf_evlist *evlist, const char *str);
+
 #endif /* __PERF_EVLIST_H */
diff --git a/tools/perf/util/record.c b/tools/perf/util/record.c
index c8845b1..e510453 100644
--- a/tools/perf/util/record.c
+++ b/tools/perf/util/record.c
@@ -177,3 +177,40 @@ int perf_record_opts__config(struct perf_record_opts *opts)
 {
 	return perf_record_opts__config_freq(opts);
 }
+
+bool perf_evlist__can_select_event(struct perf_evlist *evlist, const char *str)
+{
+	struct perf_evlist *temp_evlist;
+	struct perf_evsel *evsel;
+	int err, fd, cpu;
+	bool ret = false;
+
+	temp_evlist = perf_evlist__new();
+	if (!temp_evlist)
+		return false;
+
+	err = parse_events(temp_evlist, str);
+	if (err)
+		goto out_delete;
+
+	evsel = perf_evlist__last(temp_evlist);
+
+	if (!evlist || cpu_map__empty(evlist->cpus)) {
+		struct cpu_map *cpus = cpu_map__new(NULL);
+
+		cpu =  cpus ? cpus->map[0] : 0;
+		cpu_map__delete(cpus);
+	} else {
+		cpu = evlist->cpus->map[0];
+	}
+
+	fd = sys_perf_event_open(&evsel->attr, -1, cpu, -1, 0);
+	if (fd >= 0) {
+		close(fd);
+		ret = true;
+	}
+
+out_delete:
+	perf_evlist__delete(temp_evlist);
+	return ret;
+}
