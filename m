Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779Ab3LPP2D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 10:28:03 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47640 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754754Ab3LPP14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 10:27:56 -0500
Date: Mon, 16 Dec 2013 07:27:33 -0800
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-a025e4f0d8a92b38539d39b495b530015296b4d9@git.kernel.org>
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
In-Reply-To: <1386765443-26966-24-git-send-email-alexander.shishkin@linux.intel.com>
References: <1386765443-26966-24-git-send-email-alexander.shishkin@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evlist: Add perf_evlist__to_front()
Git-Commit-ID: a025e4f0d8a92b38539d39b495b530015296b4d9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 16 Dec 2013 07:27:39 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a025e4f0d8a92b38539d39b495b530015296b4d9
Gitweb:     http://git.kernel.org/tip/a025e4f0d8a92b38539d39b495b530015296b4d9
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Wed, 11 Dec 2013 14:36:35 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 13 Dec 2013 10:30:21 -0300

perf evlist: Add perf_evlist__to_front()

Add a function to move a selected event to the
front of the list.

This is needed because it is not possible
to use the PERF_EVENT_IOC_SET_OUTPUT IOCTL
from an Instruction Tracing event to a
non-Instruction Tracing event.  Thus the
Instruction Tracing event must come first.

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
Link: http://lkml.kernel.org/r/1386765443-26966-24-git-send-email-alexander.shishkin@linux.intel.com
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evlist.c | 17 +++++++++++++++++
 tools/perf/util/evlist.h |  3 +++
 2 files changed, 20 insertions(+)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 2eb7378..0b31cee 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -1212,3 +1212,20 @@ int perf_evlist__strerror_open(struct perf_evlist *evlist __maybe_unused,
 
 	return 0;
 }
+
+void perf_evlist__to_front(struct perf_evlist *evlist,
+			   struct perf_evsel *move_evsel)
+{
+	struct perf_evsel *evsel, *n;
+	LIST_HEAD(move);
+
+	if (move_evsel == perf_evlist__first(evlist))
+		return;
+
+	list_for_each_entry_safe(evsel, n, &evlist->entries, node) {
+		if (evsel->leader == move_evsel->leader)
+			list_move_tail(&evsel->node, &move);
+	}
+
+	list_splice(&move, &evlist->entries);
+}
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 8a04aae..9f64ede 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -194,5 +194,8 @@ static inline void perf_mmap__write_tail(struct perf_mmap *md,
 }
 
 bool perf_evlist__can_select_event(struct perf_evlist *evlist, const char *str);
+void perf_evlist__to_front(struct perf_evlist *evlist,
+			   struct perf_evsel *move_evsel);
+
 
 #endif /* __PERF_EVLIST_H */
