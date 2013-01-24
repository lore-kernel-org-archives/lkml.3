Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246Ab3AXSuh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 13:50:37 -0500
Received: from terminus.zytor.com ([198.137.202.10]:32883 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975Ab3AXSud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 13:50:33 -0500
Date: Thu, 24 Jan 2013 10:48:09 -0800
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-2cfda562da7b0b1e0575507ef3efe782d4e218e4@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, acme@ghostprotocols.net, namhyung.kim@lge.com,
        namhyung@kernel.org, jolsa@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        andi@firstfloor.org, a.p.zijlstra@chello.nl, acme@ghostprotocols.net,
        namhyung.kim@lge.com, tglx@linutronix.de, namhyung@kernel.org,
        jolsa@redhat.com
In-Reply-To: <1354171126-14387-3-git-send-email-namhyung@kernel.org>
References: <1354171126-14387-3-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evsel: Set leader evsel's ->leader to itself
Git-Commit-ID: 2cfda562da7b0b1e0575507ef3efe782d4e218e4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 24 Jan 2013 10:48:15 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2cfda562da7b0b1e0575507ef3efe782d4e218e4
Gitweb:     http://git.kernel.org/tip/2cfda562da7b0b1e0575507ef3efe782d4e218e4
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Thu, 29 Nov 2012 15:38:29 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Sun, 9 Dec 2012 08:46:06 -0300

perf evsel: Set leader evsel's ->leader to itself

Currently only non-leader members are set ->leader to the leader evsel
of the group and the leader has set NULL.  Thus it requires special
casing for leader evsels.  Set ->leader to itself will remove this.

Suggested-by: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1354171126-14387-3-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evlist.c | 1 -
 tools/perf/util/evsel.c  | 1 +
 tools/perf/util/evsel.h  | 2 +-
 3 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 7052934..90db2a1 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -111,7 +111,6 @@ void __perf_evlist__set_leader(struct list_head *list)
 	struct perf_evsel *evsel, *leader;
 
 	leader = list_entry(list->next, struct perf_evsel, node);
-	leader->leader = NULL;
 
 	list_for_each_entry(evsel, list, node) {
 		if (evsel != leader)
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 1b16dd1..7e93418 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -55,6 +55,7 @@ void perf_evsel__init(struct perf_evsel *evsel,
 {
 	evsel->idx	   = idx;
 	evsel->attr	   = *attr;
+	evsel->leader	   = evsel;
 	INIT_LIST_HEAD(&evsel->node);
 	hists__init(&evsel->hists);
 	evsel->sample_size = __perf_evsel__sample_size(attr->sample_type);
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 3d2b801..cbf6d97 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -228,6 +228,6 @@ static inline struct perf_evsel *perf_evsel__next(struct perf_evsel *evsel)
 
 static inline bool perf_evsel__is_group_member(const struct perf_evsel *evsel)
 {
-	return evsel->leader != NULL;
+	return evsel->leader != evsel;
 }
 #endif /* __PERF_EVSEL_H */
