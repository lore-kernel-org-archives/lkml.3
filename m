Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757165AbbAPVX2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 16:23:28 -0500
Received: from mail.kernel.org ([198.145.29.136]:54304 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756354AbbAPVX0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 16:23:26 -0500
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 09/10] perf tools: Fix segfault for symbol annotation on TUI
Date: Fri, 16 Jan 2015 18:22:41 -0300
Message-Id: <1421443362-10709-10-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1421443362-10709-1-git-send-email-acme@kernel.org>
References: <1421443362-10709-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

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
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1421234288-22758-1-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
1.9.3

