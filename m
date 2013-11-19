Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282Ab3KSUm4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 15:42:56 -0500
Received: from merlin.infradead.org ([205.233.59.134]:48626 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978Ab3KSUmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 15:42:07 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 3/5] perf header: Fix possible memory leaks in process_group_desc()
Date: Tue, 19 Nov 2013 17:41:56 -0300
Message-Id: <1384893718-18762-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1384893718-18762-1-git-send-email-acme@infradead.org>
References: <1384893718-18762-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

After processing all group descriptors or encountering an error, it
frees all descriptors.  However, current logic can leak memory since it
might not traverse all descriptors.

Note that the 'i' can have different value than nr_groups when an error
occurred and it's safe to call free(desc[i].name) for every desc since
we already make it NULL when it's reused for group names.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1384741244-7271-2-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/header.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 559c516f1cec..1cd035708931 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -2107,7 +2107,7 @@ static int process_group_desc(struct perf_file_section *section __maybe_unused,
 
 	ret = 0;
 out_free:
-	while ((int) --i >= 0)
+	for (i = 0; i < nr_groups; i++)
 		free(desc[i].name);
 	free(desc);
 
-- 
1.8.1.4

