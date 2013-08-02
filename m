Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758788Ab3HBKGt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 06:06:49 -0400
Received: from mga01.intel.com ([192.55.52.88]:52042 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758730Ab3HBKFV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 06:05:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,800,1367996400"; 
   d="scan'208";a="380030385"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH V3 05/10] perf tools: avoid SyS kernel syscall aliases
Date: Fri,  2 Aug 2013 13:10:47 +0300
Message-Id: <1375438252-24776-6-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1375438252-24776-1-git-send-email-adrian.hunter@intel.com>
References: <1375438252-24776-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When removing duplicate symbols, prefer to remove
syscall aliases starting with SyS or compat_SyS.

A side-effect of that is that it results in slightly
improved results for the "vmlinux symtab matches kallsyms"
test.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/symbol.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index b407c53..04300dd 100644
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
1.7.11.7

