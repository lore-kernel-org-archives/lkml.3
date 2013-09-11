Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756544Ab3IKFLu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 01:11:50 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:55155 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755029Ab3IKFJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 01:09:37 -0400
X-AuditID: 9c93017e-b7c00ae000002eb6-6c-522ffb0e5b0d
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 5/9] perf tools: Do not try to call addr2line for non-binary files
Date: Wed, 11 Sep 2013 14:09:29 +0900
Message-Id: <1378876173-13363-6-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1378876173-13363-1-git-send-email-namhyung@kernel.org>
References: <1378876173-13363-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

No need to call addr2line since they don't have such information.

Reviewed-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/sort.c    |  3 ---
 tools/perf/util/srcline.c | 11 +++++++++--
 2 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 0d633a059df4..113aa92b1191 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -259,9 +259,6 @@ static int hist_entry__srcline_snprintf(struct hist_entry *self, char *bf,
 	if (!self->ms.map)
 		goto out_ip;
 
-	if (!strncmp(self->ms.map->dso->long_name, "/tmp/perf-", 10))
-		goto out_ip;
-
 	path = get_srcline(self->ms.map->dso->long_name, self->ip);
 	self->srcline = path;
 
diff --git a/tools/perf/util/srcline.c b/tools/perf/util/srcline.c
index 7e92cca6f502..777f91880cdb 100644
--- a/tools/perf/util/srcline.c
+++ b/tools/perf/util/srcline.c
@@ -57,11 +57,17 @@ char *get_srcline(const char *dso_name, unsigned long addr)
 {
 	char *file;
 	unsigned line;
-	char *srcline;
+	char *srcline = SRCLINE_UNKNOWN;
 	size_t size;
 
+	if (dso_name[0] == '[')
+		goto out;
+
+	if (!strncmp(dso_name, "/tmp/perf-", 10))
+		goto out;
+
 	if (!addr2line(dso_name, addr, &file, &line))
-		return SRCLINE_UNKNOWN;
+		goto out;
 
 	/* just calculate actual length */
 	size = snprintf(NULL, 0, "%s:%u", file, line) + 1;
@@ -73,6 +79,7 @@ char *get_srcline(const char *dso_name, unsigned long addr)
 		srcline = SRCLINE_UNKNOWN;
 
 	free(file);
+out:
 	return srcline;
 }
 
-- 
1.7.11.7

