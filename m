Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204Ab3CKHn1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 03:43:27 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:42341 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305Ab3CKHnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 03:43:25 -0400
X-AuditID: 9c930179-b7c78ae000000e4b-52-513d8b1833de
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, David Ahern <dsahern@gmail.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 2/7] perf evlist: Use cpu_map__nr() helper
Date: Mon, 11 Mar 2013 16:43:13 +0900
Message-Id: <1362987798-24969-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1362987798-24969-1-git-send-email-namhyung@kernel.org>
References: <1362987798-24969-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Use the cpu_map__nr() helper to protect a possible NULL cpu map
dereference.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/evlist.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index a199f1887bef..a482547495b6 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -228,7 +228,7 @@ void perf_evlist__disable(struct perf_evlist *evlist)
 	int cpu, thread;
 	struct perf_evsel *pos;
 
-	for (cpu = 0; cpu < evlist->cpus->nr; cpu++) {
+	for (cpu = 0; cpu < cpu_map__nr(evlist->cpus); cpu++) {
 		list_for_each_entry(pos, &evlist->entries, node) {
 			if (!perf_evsel__is_group_leader(pos))
 				continue;
@@ -443,7 +443,7 @@ static int perf_evlist__mmap_per_cpu(struct perf_evlist *evlist, int prot, int m
 	struct perf_evsel *evsel;
 	int cpu, thread;
 
-	for (cpu = 0; cpu < evlist->cpus->nr; cpu++) {
+	for (cpu = 0; cpu < cpu_map__nr(evlist->cpus); cpu++) {
 		int output = -1;
 
 		for (thread = 0; thread < evlist->threads->nr; thread++) {
@@ -470,7 +470,7 @@ static int perf_evlist__mmap_per_cpu(struct perf_evlist *evlist, int prot, int m
 	return 0;
 
 out_unmap:
-	for (cpu = 0; cpu < evlist->cpus->nr; cpu++) {
+	for (cpu = 0; cpu < cpu_map__nr(evlist->cpus); cpu++) {
 		if (evlist->mmap[cpu].base != NULL) {
 			munmap(evlist->mmap[cpu].base, evlist->mmap_len);
 			evlist->mmap[cpu].base = NULL;
@@ -725,7 +725,7 @@ int perf_evlist__open(struct perf_evlist *evlist)
 
 	return 0;
 out_err:
-	ncpus = evlist->cpus ? evlist->cpus->nr : 1;
+	ncpus = cpu_map__nr(evlist->cpus);
 	nthreads = evlist->threads ? evlist->threads->nr : 1;
 
 	list_for_each_entry_reverse(evsel, &evlist->entries, node)
-- 
1.7.11.7

