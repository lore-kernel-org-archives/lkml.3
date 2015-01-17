Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400AbbAQKN2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 05:13:28 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44342 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186AbbAQKNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 05:13:25 -0500
Date: Sat, 17 Jan 2015 02:13:08 -0800
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-813ccd15452ed34e97aa526ffc70d6d8e6c466c5@git.kernel.org>
Cc: tglx@linutronix.de, jolsa@redhat.com, dsahern@gmail.com, mingo@kernel.org,
        namhyung@kernel.org, acme@redhat.com, hpa@zytor.com,
        masami.hiramatsu.pt@hitachi.com, a.p.zijlstra@chello.nl,
        linux-kernel@vger.kernel.org
Reply-To: masami.hiramatsu.pt@hitachi.com, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, dsahern@gmail.com, jolsa@redhat.com,
        mingo@kernel.org, namhyung@kernel.org
In-Reply-To: <1421234288-22758-1-git-send-email-namhyung@kernel.org>
References: <1421234288-22758-1-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools:
  Fix segfault for symbol annotation on TUI
Git-Commit-ID: 813ccd15452ed34e97aa526ffc70d6d8e6c466c5
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

Commit-ID:  813ccd15452ed34e97aa526ffc70d6d8e6c466c5
Gitweb:     http://git.kernel.org/tip/813ccd15452ed34e97aa526ffc70d6d8e6c466c5
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Wed, 14 Jan 2015 20:18:05 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 16 Jan 2015 17:49:29 -0300

perf tools: Fix segfault for symbol annotation on TUI

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
index 0784a94..cadbdc9 100644
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
