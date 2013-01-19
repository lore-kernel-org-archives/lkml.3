Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752025Ab3ASQhK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2013 11:37:10 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:51791 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807Ab3ASQhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2013 11:37:09 -0500
From: Colin King <colin.king@canonical.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] perf evsel: fix NULL pointer deference when evsel->counts is NULL
Date: Sat, 19 Jan 2013 16:36:54 +0000
Message-Id: <1358613414-13005-1-git-send-email-colin.king@canonical.com>
X-Mailer: git-send-email 1.8.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

__perf_evsel__read_on_cpu() only bails out with -ENOMEM if
evsel->counts is NULL and perf_evsel__alloc_counts() has returned
an error.  If perf_evsel__alloc_counts() does not return an error
we get an NULL pointer deference on evsel->counts->cpu[cpu]
if evsel->counts is NULL.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 tools/perf/util/evsel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 1b16dd1..93acd06 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -640,7 +640,7 @@ int __perf_evsel__read_on_cpu(struct perf_evsel *evsel,
 	if (FD(evsel, cpu, thread) < 0)
 		return -EINVAL;
 
-	if (evsel->counts == NULL && perf_evsel__alloc_counts(evsel, cpu + 1) < 0)
+	if (evsel->counts == NULL || perf_evsel__alloc_counts(evsel, cpu + 1) < 0)
 		return -ENOMEM;
 
 	if (readn(FD(evsel, cpu, thread), &count, nv * sizeof(u64)) < 0)
-- 
1.8.0

