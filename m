Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395AbaHNGBx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 02:01:53 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:60596 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218AbaHNGBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 02:01:51 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Andi Kleen <andi@firstfloor.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Arun Sharma <asharma@fb.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>
Subject: [PATCH 2/3] perf tools: Put callers above callee when callchain order is caller
Date: Thu, 14 Aug 2014 15:01:39 +0900
Message-Id: <1407996100-6359-3-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1407996100-6359-1-git-send-email-namhyung@kernel.org>
References: <1407996100-6359-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The perf report/top shows callers above their callees, but if user
gives a callchain param to caller it's inverted.  Fix it.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/hist.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index b5fa7019d2e2..eacbb561af78 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -197,14 +197,16 @@ static int __hpp__sort_acc(struct hist_entry *a, struct hist_entry *b,
 	s64 ret = 0;
 
 	if (symbol_conf.cumulate_callchain) {
-		/*
-		 * Put caller above callee when they have equal period.
-		 */
 		ret = field_cmp(get_field(a), get_field(b));
 		if (ret)
 			return ret;
 
+		/*
+		 * Put caller above callee when they have equal period.
+		 */
 		ret = b->callchain->max_depth - a->callchain->max_depth;
+		if (callchain_param.order == ORDER_CALLER)
+			ret = -ret;
 	}
 	return ret;
 }
-- 
2.0.0

