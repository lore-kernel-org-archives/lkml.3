Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183AbaBXTLK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 14:11:10 -0500
Received: from merlin.infradead.org ([205.233.59.134]:48054 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021AbaBXTLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 14:11:04 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 2/2] perf symbols: Destroy unused symsrcs
Date: Mon, 24 Feb 2014 16:10:45 -0300
Message-Id: <1393269045-11572-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1393269045-11572-1-git-send-email-acme@infradead.org>
References: <1393269045-11572-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

Stephane reported that perf report and annotate failed to process data
using lots of (> 500) shared libraries.  It was because of the limit on
number of open files (ulimit -n).

Currently when perf loads a DSO, it'll look for normal and dynamic
symbol tables.  And if it fails to find out both tables, it'll iterate
all of possible symtab types.  But many of them are useless since they
have no additional information and the problem is that it's not closing
those files even though they're not used.  Fix it.

Reported-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1392859976-32760-2-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index a9d758a3b371..e89afc097d8a 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1336,6 +1336,8 @@ int dso__load(struct dso *dso, struct map *map, symbol_filter_t filter)
 
 			if (syms_ss && runtime_ss)
 				break;
+		} else {
+			symsrc__destroy(ss);
 		}
 
 	}
-- 
1.8.1.4

