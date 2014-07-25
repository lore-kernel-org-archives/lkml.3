Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758818AbaGYBcD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 21:32:03 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:44394 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758296AbaGYBcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 21:32:00 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Minchan Kim <minchan@kernel.org>
Subject: [PATCH 2/2] perf tools: Check validity of --symfs value
Date: Fri, 25 Jul 2014 10:31:48 +0900
Message-Id: <1406251908-8195-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1406251908-8195-1-git-send-email-namhyung@kernel.org>
References: <1406251908-8195-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a symfs is given by user, it needs to be checked before applying.
Currently, it just uses it even if realpath() failed.

I guess it's because it needed to handle empty symfs which is the
default value.  But now it's only called when it's not empty so it'd
be better to check before using it and warn users if failed.

Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/symbol.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 90723a12e947..95186185c1d5 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1864,8 +1864,11 @@ int symbol__init(void)
 
 	if (*symbol_conf.symfs) {
 		symfs = realpath(symbol_conf.symfs, NULL);
-		if (symfs == NULL)
-			symfs = (char *)symbol_conf.symfs;
+		if (symfs == NULL) {
+			pr_err("cannot apply symfs: %s: %s\n",
+			       symbol_conf.symfs, strerror(errno));
+			return -1;
+		}
 
 		/*
 		 * A path to symbols of "/" is identical to ""
-- 
2.0.0

