Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308AbaBTBdr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 20:33:47 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:58001 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752935AbaBTBdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 20:33:04 -0500
X-AuditID: 9c93016f-b7c65ae000004a2a-50-53055b4b2123
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH 2/4] perf tools: Destroy unused symsrcs
Date: Thu, 20 Feb 2014 10:32:54 +0900
Message-Id: <1392859976-32760-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1392859976-32760-1-git-send-email-namhyung@kernel.org>
References: <1392859976-32760-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephane reported that perf report and annotate failed to process data
using lots of (> 500) shared libraries.  It was because of the limit
on number of open files (ulimit -n).

Currently when perf loads dso, it'll look for normal and dynamic
symbol tables.  And if it failed to find out both tables, it'll
iterate all of possible symtab types.  But many of them are useless
since they have no additional information and the problem is that it's
not close those files even though they're not used.  Fix it.

Reported-by: Stephane Eranian <eranian@google.com>
Cc: Cody P Schafer <cody@linux.vnet.ibm.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/symbol.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 46e2ede12c51..c3b014712fce 100644
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
1.7.11.7

