Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160Ab3CRQj4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 12:39:56 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:49366
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752604Ab3CRQZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 12:25:56 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 15/54] perf evlist: Use cpu_map__nr() helper
Date: Mon, 18 Mar 2013 13:25:00 -0300
Message-Id: <1363623939-10748-16-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1363623939-10748-1-git-send-email-acme@infradead.org>
References: <1363623939-10748-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Use the cpu_map__nr() helper to protect a possible NULL cpu map
dereference.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1362987798-24969-2-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evlist.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index a199f18..a482547 100644
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
1.7.1

