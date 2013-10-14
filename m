Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757811Ab3JNUjR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:39:17 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38780 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757601Ab3JNUDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:03:00 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 091/161] perf sort: Fix a memory leak on srcline
Date: Mon, 14 Oct 2013 17:01:20 -0300
Message-Id: <1381780950-25642-92-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

In the hist_entry__srcline_snprintf(), path and self->srcline are
pointing the same memory region, but they are doubly allocated.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Reviewed-by: Jiri Olsa <jolsa@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1378876173-13363-2-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/sort.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index b4ecc0e4c908..97cf3ef4417c 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -269,10 +269,7 @@ static int hist_entry__srcline_snprintf(struct hist_entry *self, char *bf,
 	if (!fp)
 		goto out_ip;
 
-	if (getline(&path, &line_len, fp) < 0 || !line_len)
-		goto out_ip;
-	self->srcline = strdup(path);
-	if (self->srcline == NULL)
+	if (getline(&self->srcline, &line_len, fp) < 0 || !line_len)
 		goto out_ip;
 
 	nl = strchr(self->srcline, '\n');
-- 
1.8.1.4

