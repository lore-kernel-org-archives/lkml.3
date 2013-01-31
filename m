Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639Ab3AaBIF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 20:08:05 -0500
Received: from mail.windriver.com ([147.11.1.11]:52585 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756251Ab3AaBID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 20:08:03 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Joe Perches <joe@perches.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH] perf: fix calloc argument ordering
Date: Wed, 30 Jan 2013 20:05:49 -0500
Message-Id: <1359594349-25912-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A sweep of the kernel for regex "kcalloc(sizeof" turned up 2 reversed
args, fixed in commit d3d09e18203dba16a9dbdb2b4cc673d90748cdd1 ("EDAC:
Fix kcalloc argument order") and also fixed in the networking commit
a1b1add07fa794974573d93483d68e373edfe7bd ("gro: Fix kcalloc argument
order").

I know that was the regex used, because on seeing the 1st of these
changes, I wondered "how many other instances of this are there" and I
happened to just use "calloc(sizeof" as a regex and it in turn found
these additional reversed args instances in the perf code.

In the kcalloc cases, the changes are cosmetic, since the numbers are
simply multiplied.  I had no desire to go data mining in userspace
to see if the same thing held true there, however.

Cc: Joe Perches <joe@perches.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 tools/perf/util/callchain.c | 2 +-
 tools/perf/util/header.c    | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index d3b3f5d..42b6a63 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -444,7 +444,7 @@ int callchain_cursor_append(struct callchain_cursor *cursor,
 	struct callchain_cursor_node *node = *cursor->last;
 
 	if (!node) {
-		node = calloc(sizeof(*node), 1);
+		node = calloc(1, sizeof(*node));
 		if (!node)
 			return -ENOMEM;
 
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index b7da463..4f0ce89 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -2077,7 +2077,7 @@ static int perf_header__adds_write(struct perf_header *header,
 	if (!nr_sections)
 		return 0;
 
-	feat_sec = p = calloc(sizeof(*feat_sec), nr_sections);
+	feat_sec = p = calloc(nr_sections, sizeof(*feat_sec));
 	if (feat_sec == NULL)
 		return -ENOMEM;
 
@@ -2249,7 +2249,7 @@ int perf_header__process_sections(struct perf_header *header, int fd,
 	if (!nr_sections)
 		return 0;
 
-	feat_sec = sec = calloc(sizeof(*feat_sec), nr_sections);
+	feat_sec = sec = calloc(nr_sections, sizeof(*feat_sec));
 	if (!feat_sec)
 		return -1;
 
-- 
1.8.1.2

