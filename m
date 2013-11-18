Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632Ab3KRU2Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 15:28:24 -0500
Received: from merlin.infradead.org ([205.233.59.134]:50610 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536Ab3KRU2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 15:28:19 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 09/16] perf header: Fix bogus group name
Date: Mon, 18 Nov 2013 17:27:57 -0300
Message-Id: <1384806484-29869-10-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1384806484-29869-1-git-send-email-acme@infradead.org>
References: <1384806484-29869-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

When processing event group descriptor in perf file header, we reuse an
allocated group name but forgot to prevent it from freeing.

Reported-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1384741244-7271-1-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/header.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 369c03648f88..559c516f1cec 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -2078,8 +2078,10 @@ static int process_group_desc(struct perf_file_section *section __maybe_unused,
 		if (evsel->idx == (int) desc[i].leader_idx) {
 			evsel->leader = evsel;
 			/* {anon_group} is a dummy name */
-			if (strcmp(desc[i].name, "{anon_group}"))
+			if (strcmp(desc[i].name, "{anon_group}")) {
 				evsel->group_name = desc[i].name;
+				desc[i].name = NULL;
+			}
 			evsel->nr_members = desc[i].nr_members;
 
 			if (i >= nr_groups || nr > 0) {
-- 
1.8.1.4

