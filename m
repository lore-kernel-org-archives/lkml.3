Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933586Ab3HGVRr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 17:17:47 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47073 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933407Ab3HGVLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 17:11:30 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 24/47] perf symbols: avoid SyS kernel syscall aliases
Date: Wed,  7 Aug 2013 18:10:51 -0300
Message-Id: <1375909874-22073-25-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1375909874-22073-1-git-send-email-acme@infradead.org>
References: <1375909874-22073-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

When removing duplicate symbols, prefer to remove syscall aliases
starting with SyS or compat_SyS.

A side-effect of that is that it results in slightly improved results
for the "vmlinux symtab matches kallsyms" test.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1375875537-4509-6-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 02718e7..ea62ecd 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -87,6 +87,7 @@ static int choose_best_symbol(struct symbol *syma, struct symbol *symb)
 {
 	s64 a;
 	s64 b;
+	size_t na, nb;
 
 	/* Prefer a symbol with non zero length */
 	a = syma->end - syma->start;
@@ -120,11 +121,21 @@ static int choose_best_symbol(struct symbol *syma, struct symbol *symb)
 	else if (a > b)
 		return SYMBOL_B;
 
-	/* If all else fails, choose the symbol with the longest name */
-	if (strlen(syma->name) >= strlen(symb->name))
+	/* Choose the symbol with the longest name */
+	na = strlen(syma->name);
+	nb = strlen(symb->name);
+	if (na > nb)
 		return SYMBOL_A;
-	else
+	else if (na < nb)
+		return SYMBOL_B;
+
+	/* Avoid "SyS" kernel syscall aliases */
+	if (na >= 3 && !strncmp(syma->name, "SyS", 3))
 		return SYMBOL_B;
+	if (na >= 10 && !strncmp(syma->name, "compat_SyS", 10))
+		return SYMBOL_B;
+
+	return SYMBOL_A;
 }
 
 void symbols__fixup_duplicate(struct rb_root *symbols)
-- 
1.8.1.4

