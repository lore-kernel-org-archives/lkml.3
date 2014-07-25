Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757994AbaGYBbw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 21:31:52 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:44313 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186AbaGYBbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 21:31:51 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Minchan Kim <minchan@kernel.org>
Subject: [PATCH 1/2] perf tools: Ensure --symfs ends with '/'
Date: Fri, 25 Jul 2014 10:31:47 +0900
Message-Id: <1406251908-8195-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Minchan reported that perf failed to load vmlinux if --symfs argument
doesn't end with '/' character.  So make sure that the symfs always
ends with the '/'.

Reported-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/symbol.c | 41 +++++++++++++++++++++++++++++------------
 1 file changed, 29 insertions(+), 12 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index eb06746b06b2..90723a12e947 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1829,7 +1829,7 @@ static bool symbol__read_kptr_restrict(void)
 
 int symbol__init(void)
 {
-	const char *symfs;
+	char *symfs;
 
 	if (symbol_conf.initialized)
 		return 0;
@@ -1862,23 +1862,40 @@ int symbol__init(void)
 		       symbol_conf.sym_list_str, "symbol") < 0)
 		goto out_free_comm_list;
 
-	/*
-	 * A path to symbols of "/" is identical to ""
-	 * reset here for simplicity.
-	 */
-	symfs = realpath(symbol_conf.symfs, NULL);
-	if (symfs == NULL)
-		symfs = symbol_conf.symfs;
-	if (strcmp(symfs, "/") == 0)
-		symbol_conf.symfs = "";
-	if (symfs != symbol_conf.symfs)
-		free((void *)symfs);
+	if (*symbol_conf.symfs) {
+		symfs = realpath(symbol_conf.symfs, NULL);
+		if (symfs == NULL)
+			symfs = (char *)symbol_conf.symfs;
+
+		/*
+		 * A path to symbols of "/" is identical to ""
+		 * reset here for simplicity.
+		 */
+		if (strcmp(symfs, "/") == 0)
+			symbol_conf.symfs = "";
+
+		/* ensure symfs ends with '/' */
+		if (symfs[strlen(symfs)-1] != '/') {
+			char *tmp = realloc(symfs, strlen(symfs) + 2);
+			if (tmp == NULL)
+				goto out_free;
+
+			tmp[strlen(tmp)+1] = '\0';
+			tmp[strlen(tmp)] = '/';
+
+			symbol_conf.symfs = tmp;
+		} else {
+			free(symfs);
+		}
+	}
 
 	symbol_conf.kptr_restrict = symbol__read_kptr_restrict();
 
 	symbol_conf.initialized = true;
 	return 0;
 
+out_free:
+	free(symfs);
 out_free_comm_list:
 	strlist__delete(symbol_conf.comm_list);
 out_free_dso_list:
-- 
2.0.0

