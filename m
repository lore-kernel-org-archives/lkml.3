Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681AbaKTHiM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 02:38:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43821 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756537AbaKTHiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 02:38:07 -0500
Date: Wed, 19 Nov 2014 23:37:57 -0800
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-37592b8afb7151994e760d1727c264329d9c13c8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, ak@linux.intel.com, mingo@kernel.org,
        hpa@zytor.com, namhyung@kernel.org, tglx@linutronix.de,
        acme@redhat.com, jolsa@redhat.com
Reply-To: jolsa@redhat.com, acme@redhat.com, tglx@linutronix.de,
        namhyung@kernel.org, hpa@zytor.com, ak@linux.intel.com,
        mingo@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1415844328-4884-2-git-send-email-andi@firstfloor.org>
References: <1415844328-4884-2-git-send-email-andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf callchain:
  Factor out adding new call chain entries
Git-Commit-ID: 37592b8afb7151994e760d1727c264329d9c13c8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  37592b8afb7151994e760d1727c264329d9c13c8
Gitweb:     http://git.kernel.org/tip/37592b8afb7151994e760d1727c264329d9c13c8
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Wed, 12 Nov 2014 18:05:19 -0800
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 19 Nov 2014 12:33:47 -0300

perf callchain: Factor out adding new call chain entries

Move the code to resolve and add a new callchain entry into a new
add_callchain_ip function. This will be used in the next patches to add
LBRs too.

No change in behavior.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/1415844328-4884-2-git-send-email-andi@firstfloor.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/machine.c | 51 +++++++++++++++++++++++++++++------------------
 1 file changed, 32 insertions(+), 19 deletions(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 52e9490..84390ee 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1381,6 +1381,34 @@ struct mem_info *sample__resolve_mem(struct perf_sample *sample,
 	return mi;
 }
 
+static int add_callchain_ip(struct thread *thread,
+			    struct symbol **parent,
+			    struct addr_location *root_al,
+			    int cpumode,
+			    u64 ip)
+{
+	struct addr_location al;
+
+	al.filtered = 0;
+	al.sym = NULL;
+	thread__find_addr_location(thread, cpumode, MAP__FUNCTION,
+				   ip, &al);
+	if (al.sym != NULL) {
+		if (sort__has_parent && !*parent &&
+		    symbol__match_regex(al.sym, &parent_regex))
+			*parent = al.sym;
+		else if (have_ignore_callees && root_al &&
+		  symbol__match_regex(al.sym, &ignore_callees_regex)) {
+			/* Treat this symbol as the root,
+			   forgetting its callees. */
+			*root_al = al;
+			callchain_cursor_reset(&callchain_cursor);
+		}
+	}
+
+	return callchain_cursor_append(&callchain_cursor, ip, al.map, al.sym);
+}
+
 struct branch_info *sample__resolve_bstack(struct perf_sample *sample,
 					   struct addr_location *al)
 {
@@ -1427,7 +1455,6 @@ static int thread__resolve_callchain_sample(struct thread *thread,
 
 	for (i = 0; i < chain_nr; i++) {
 		u64 ip;
-		struct addr_location al;
 
 		if (callchain_param.order == ORDER_CALLEE)
 			j = i;
@@ -1464,24 +1491,10 @@ static int thread__resolve_callchain_sample(struct thread *thread,
 			continue;
 		}
 
-		al.filtered = 0;
-		thread__find_addr_location(thread, cpumode,
-					   MAP__FUNCTION, ip, &al);
-		if (al.sym != NULL) {
-			if (sort__has_parent && !*parent &&
-			    symbol__match_regex(al.sym, &parent_regex))
-				*parent = al.sym;
-			else if (have_ignore_callees && root_al &&
-			  symbol__match_regex(al.sym, &ignore_callees_regex)) {
-				/* Treat this symbol as the root,
-				   forgetting its callees. */
-				*root_al = al;
-				callchain_cursor_reset(&callchain_cursor);
-			}
-		}
-
-		err = callchain_cursor_append(&callchain_cursor,
-					      ip, al.map, al.sym);
+		err = add_callchain_ip(thread, parent, root_al,
+				       cpumode, ip);
+		if (err == -EINVAL)
+			break;
 		if (err)
 			return err;
 	}
