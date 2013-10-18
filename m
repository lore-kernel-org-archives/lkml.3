Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456Ab3JROkN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 10:40:13 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:9634 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949Ab3JROje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 10:39:34 -0400
From: Waiman Long <Waiman.Long@hp.com>
To: Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        linux-kernel@vger.kernel.org, Aswin Chandramouleeswaran <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>, Waiman Long <Waiman.Long@hp.com>
Subject: [PATCH v2 2/4] perf: streamline append_chain() function
Date: Fri, 18 Oct 2013 10:38:47 -0400
Message-Id: <1382107129-2010-3-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1382107129-2010-1-git-send-email-Waiman.Long@hp.com>
References: <1382107129-2010-1-git-send-email-Waiman.Long@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When callgraph is enabled, the append_chain() function consumes a major
portion of the total CPU time. This patch tries to streamline the
append_chain() function by removing unneeded conditional test as well as
using ?: statement which can be more efficient than the regular if
statement in some architectures.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 tools/perf/util/callchain.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index 482f680..1e79001 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -315,6 +315,7 @@ append_chain(struct callchain_node *root,
 	struct callchain_list *cnode;
 	u64 start = cursor->pos;
 	bool found = false;
+	bool func_mode = (callchain_param.key == CCKEY_FUNCTION);
 	u64 matches;
 
 	/*
@@ -331,17 +332,15 @@ append_chain(struct callchain_node *root,
 		if (!node)
 			break;
 
-		sym = node->sym;
+		sym = func_mode ? node->sym : NULL;
 
-		if (cnode->ms.sym && sym &&
-		    callchain_param.key == CCKEY_FUNCTION) {
+		if (cnode->ms.sym && sym) {
 			if (cnode->ms.sym->start != sym->start)
 				break;
 		} else if (cnode->ip != node->ip)
 			break;
 
-		if (!found)
-			found = true;
+		found = true;
 
 		callchain_cursor_advance(cursor);
 	}
-- 
1.7.1

