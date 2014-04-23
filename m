Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756918AbaDWO3p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 10:29:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27892 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754345AbaDWO3l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 10:29:41 -0400
Date: Wed, 23 Apr 2014 16:29:16 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 7/7] perf hists/tui: Count callchain rows separately
Message-ID: <20140423142915.GA27585@krava.brq.redhat.com>
References: <1398236408-8856-1-git-send-email-namhyung@kernel.org>
 <1398236408-8856-8-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398236408-8856-8-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 04:00:08PM +0900, Namhyung Kim wrote:
> When TUI hist browser expands/collapses callchains it accounted number
> of callchain nodes into total entries to show.  However this code
> ignores filtering so that it can make the cursor go to out of screen.

SNIP

hi,
I needed following patch, otherwise following test case would segfault

- record with -g
- report - unfold one symbol
- search for nonsense

the reason is that after unfolding the symbol the nr_callchain_rows
will get some number, which will cause the hist_browser__nr_entries
function return (entries != 0) actually (entries == nr_callchain_rows)
even if there's no entry passing the filter

fixing that by unfolding everything after the filter and reseting
the nr_callchain_rows number

feel free to merge this with your change if you agree ;-)

thanks,
jirka


---
diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 5b81c0d..1cf5f45 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -312,6 +312,8 @@ __hist_browser__set_folding(struct hist_browser *browser, bool unfold)
 	struct rb_node *nd;
 	struct hists *hists = browser->hists;
 
+	browser->nr_callchain_rows = 0;
+
 	for (nd = rb_first(&hists->entries);
 	     (nd = hists__filter_entries(nd, hists, browser->min_pcnt)) != NULL;
 	     nd = rb_next(nd)) {
@@ -323,7 +325,6 @@ __hist_browser__set_folding(struct hist_browser *browser, bool unfold)
 
 static void hist_browser__set_folding(struct hist_browser *browser, bool unfold)
 {
-	browser->nr_callchain_rows = 0;
 	__hist_browser__set_folding(browser, unfold);
 
 	browser->b.nr_entries = hist_browser__nr_entries(browser);
@@ -1507,6 +1508,7 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 					delay_secs * 2) == K_ENTER) {
 				hists->symbol_filter_str = *buf ? buf : NULL;
 				hists__filter_by_symbol(hists);
+				__hist_browser__set_folding(browser, false);
 				hist_browser__reset(browser);
 			}
 			continue;
