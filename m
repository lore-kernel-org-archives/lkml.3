Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756625Ab3IKFJj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 01:09:39 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:55155 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753026Ab3IKFJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 01:09:35 -0400
X-AuditID: 9c93017e-b7c00ae000002eb6-67-522ffb0e289e
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 1/9] perf sort: Fix a memory leak on srcline
Date: Wed, 11 Sep 2013 14:09:25 +0900
Message-Id: <1378876173-13363-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1378876173-13363-1-git-send-email-namhyung@kernel.org>
References: <1378876173-13363-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

In the hist_entry__srcline_snprintf(), path and self->srcline are
pointing the same memory region, but they are doubly allocated.

Reviewed-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/sort.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 5f118a089519..5ba29fc679c5 100644
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
1.7.11.7

