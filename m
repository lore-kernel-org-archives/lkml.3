Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752484Ab3HFFOr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 01:14:47 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:56815 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681Ab3HFFOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 01:14:44 -0400
X-AuditID: 9c93017e-b7b62ae000000eeb-cc-52008642c0e2
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Pekka Enberg <penberg@kernel.org>, Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 1/4] perf ui/gtk: Fix segmentation fault on perf_hpp__for_each_format loop
Date: Tue,  6 Aug 2013 14:14:13 +0900
Message-Id: <1375766056-19377-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1375766056-19377-1-git-send-email-namhyung@kernel.org>
References: <1375766056-19377-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The commit 2b8bfa6bb8a7 ("perf tools: Centralize default columns init
in perf_hpp__init") moves initialization of common overhead column to
perf_hpp__init() but forgot about the gtk code.

So the gtk code added the same column to the list twice causing
infinite loop when iterating it by perf_hpp__for_each_format loop.
When I run perf report --gtk, I can see following messages
indefinitely.

  (perf:11687): Gtk-CRITICAL **: IA__gtk_main_quit: assertion 'main_loops != NULL' failed
  perf: Segmentation fault

Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/gtk/hists.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/tools/perf/ui/gtk/hists.c b/tools/perf/ui/gtk/hists.c
index cb2ed1980147..2ca66cc1160f 100644
--- a/tools/perf/ui/gtk/hists.c
+++ b/tools/perf/ui/gtk/hists.c
@@ -109,8 +109,6 @@ __HPP_COLOR_PERCENT_FN(overhead_guest_us, period_guest_us)
 
 void perf_gtk__init_hpp(void)
 {
-	perf_hpp__column_enable(PERF_HPP__OVERHEAD);
-
 	perf_hpp__init();
 
 	perf_hpp__format[PERF_HPP__OVERHEAD].color =
-- 
1.7.11.7

