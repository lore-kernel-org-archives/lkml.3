Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756806Ab3CULH2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 07:07:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56228 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755358Ab3CULH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 07:07:26 -0400
Date: Thu, 21 Mar 2013 04:05:51 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-85397956de304106e2fdace2db8f69ab4e966bc5@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1362987798-24969-2-git-send-email-namhyung@kernel.org>
References: <1362987798-24969-2-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evlist: Use cpu_map__nr() helper
Git-Commit-ID: 85397956de304106e2fdace2db8f69ab4e966bc5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 21 Mar 2013 04:06:02 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  85397956de304106e2fdace2db8f69ab4e966bc5
Gitweb:     http://git.kernel.org/tip/85397956de304106e2fdace2db8f69ab4e966bc5
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Mon, 11 Mar 2013 16:43:13 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 15 Mar 2013 13:06:02 -0300

perf evlist: Use cpu_map__nr() helper

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
 tools/perf/util/evlist.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

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
