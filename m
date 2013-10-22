Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002Ab3JVOf4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 10:35:56 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53858 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753432Ab3JVO2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 10:28:49 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 21/26] perf tools: Compare dso's also when comparing symbols
Date: Tue, 22 Oct 2013 11:28:29 -0300
Message-Id: <1382452114-1243-22-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1382452114-1243-1-git-send-email-acme@infradead.org>
References: <1382452114-1243-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Linus reported that sometimes 'perf report -s symbol' exits without any
message on TUI.  David and Jiri found that it's because it failed to add
a hist entry due to an invalid symbol length.

It turns out that sorting by symbol (address) was broken since it only
compares symbol addresses.  The symbol address is a relative address
within a dso thus just checking its address can result in merging
unrelated symbols together.  Fix it by checking dso before comparing
symbol address.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1381802517-18812-1-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
1.8.1.4

