Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756462AbaCNRYQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 13:24:16 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48282 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756365AbaCNRYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 13:24:11 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Patrick Palka <patrick@parcs.ath.cx>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 2/2] perf bench: Fix NULL pointer dereference in "perf bench all"
Date: Fri, 14 Mar 2014 14:23:59 -0300
Message-Id: <1394817839-26310-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1394817839-26310-1-git-send-email-acme@infradead.org>
References: <1394817839-26310-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrick Palka <patrick@parcs.ath.cx>

The for_each_bench() macro must check that the "benchmarks" field of a
collection is not NULL before dereferencing it because the "all"
collection in particular has a NULL "benchmarks" field (signifying that
it has no benchmarks to iterate over).

This fixes this NULL pointer dereference when running "perf bench all":

  [root@ssdandy ~]# perf bench all
  <SNIP>

  # Running mem/memset benchmark...
  # Copying 1MB Bytes ...

         2.453675 GB/Sec
        12.056327 GB/Sec (with prefault)

  Segmentation fault (core dumped)
  [root@ssdandy ~]#

Signed-off-by: Patrick Palka <patrick@parcs.ath.cx>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1394664051-6037-1-git-send-email-patrick@parcs.ath.cx
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-bench.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-bench.c b/tools/perf/builtin-bench.c
index e47f90cc7b98..8a987d252780 100644
--- a/tools/perf/builtin-bench.c
+++ b/tools/perf/builtin-bench.c
@@ -76,7 +76,7 @@ static struct collection collections[] = {
 
 /* Iterate over all benchmarks within a collection: */
 #define for_each_bench(coll, bench) \
-	for (bench = coll->benchmarks; bench->name; bench++)
+	for (bench = coll->benchmarks; bench && bench->name; bench++)
 
 static void dump_benchmarks(struct collection *coll)
 {
-- 
1.8.1.4

