Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756854Ab3JOCCB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 22:02:01 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:62654 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755326Ab3JOCB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 22:01:59 -0400
X-AuditID: 9c93017d-b7b2eae000005519-98-525ca216f4eb
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 1/2] perf tools: Compare dso's also when comparing symbols
Date: Tue, 15 Oct 2013 11:01:56 +0900
Message-Id: <1381802517-18812-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Linus reported that sometimes 'perf report -s symbol' exits without
any message on TUI.  David and Jiri found that it's because it failed
to add a hist entry due to an invalid symbol length.

It turns out that sorting by symbol (address) was broken since it only
compares symbol addresses.  The symbol address is a relative address
within a dso thus just checking its address can result in merging
unrelated symbols together.  Fix it by checking dso before comparing
symbol address.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/sort.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 32c56377e008..1f9821db9e77 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -182,9 +182,19 @@ static int64_t _sort__sym_cmp(struct symbol *sym_l, struct symbol *sym_r)
 static int64_t
 sort__sym_cmp(struct hist_entry *left, struct hist_entry *right)
 {
+	int64_t ret;
+
 	if (!left->ms.sym && !right->ms.sym)
 		return right->level - left->level;
 
+	/*
+	 * comparing symbol address alone is not enough since it's a
+	 * relative address within a dso.
+	 */
+	ret = sort__dso_cmp(left, right);
+	if (ret != 0)
+		return ret;
+
 	return _sort__sym_cmp(left->ms.sym, right->ms.sym);
 }
 
-- 
1.7.11.7

