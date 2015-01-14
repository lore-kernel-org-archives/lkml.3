Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048AbbANLSV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 06:18:21 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:33470 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbbANLSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 06:18:20 -0500
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH v2 1/4] perf tools: Fix segfault for symbol annotation on TUI
Date: Wed, 14 Jan 2015 20:18:05 +0900
Message-Id: <1421234288-22758-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the symbol structure is allocated with symbol_conf.priv_size
to carry sideband information like annotation, map browser on TUI and
sort-by-name tree node.  So retrieving these information from symbol
needs to care about the details of such placement.

However the annotation code just assumes that the symbol is placed after
the struct annotation.  But actually there's other info between them.
So accessing those struct will lead to an undefined behavior (usually a
crash) after they write their info to the same location.

To reproduce the problem, please follow the steps below:

  1. run perf report (TUI of course) with -v option
  2. open map browser (by pressing right arrow key for any entry)
  3. search any function (by pressing '/' key and input whatever..)
  4. return to the hist browser (by pressing 'q' or left arrow key)
  5. open annotation window for the same entry (by pressing 'a' key)

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/annotate.h | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/tools/perf/util/annotate.h b/tools/perf/util/annotate.h
index 0784a9420528..cadbdc90a5cb 100644
--- a/tools/perf/util/annotate.h
+++ b/tools/perf/util/annotate.h
@@ -116,11 +116,6 @@ struct annotation {
 	struct annotated_source *src;
 };
 
-struct sannotation {
-	struct annotation annotation;
-	struct symbol	  symbol;
-};
-
 static inline struct sym_hist *annotation__histogram(struct annotation *notes, int idx)
 {
 	return (((void *)&notes->src->histograms) +
@@ -129,8 +124,7 @@ static inline struct sym_hist *annotation__histogram(struct annotation *notes, i
 
 static inline struct annotation *symbol__annotation(struct symbol *sym)
 {
-	struct sannotation *a = container_of(sym, struct sannotation, symbol);
-	return &a->annotation;
+	return (void *)sym - symbol_conf.priv_size;
 }
 
 int addr_map_symbol__inc_samples(struct addr_map_symbol *ams, int evidx);
-- 
2.2.1

