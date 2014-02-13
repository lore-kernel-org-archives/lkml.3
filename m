Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753115AbaBMITy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 03:19:54 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:65126 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482AbaBMITx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 03:19:53 -0500
X-AuditID: 9c93017d-b7c89ae000006ae1-fe-52fc8026f644
From: Namhyung Kim <namhyung@kernel.org>
To: Anton Blanchard <anton@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Michael Ellerman <michaele@au1.ibm.com>
Subject: Re: [PATCH 06/35] perf hists: Leave symbol addr hist bucket auto alloc to symbol layer
References: <1387566550-3524-1-git-send-email-acme@infradead.org>
	<1387566550-3524-7-git-send-email-acme@infradead.org>
	<20140212182316.44a10ca6@kryten>
	<20140212141837.GB7116@ghostprotocols.net>
	<20140213015017.12393bd4@kryten> <20140213040913.1c59cc45@kryten>
Date: Thu, 13 Feb 2014 17:19:50 +0900
In-Reply-To: <20140213040913.1c59cc45@kryten> (Anton Blanchard's message of
	"Thu, 13 Feb 2014 04:09:13 +1100")
Message-ID: <87fvnnzaop.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anton,

On Thu, 13 Feb 2014 04:09:13 +1100, Anton Blanchard wrote:
> Hi,
>
>> > Can you try the following patch?
>> > 
>> > It should fix another problem, i.e. we were allocating, but
>> > annotation would fail in the !TUI case, as it would return at
>> > symbol__inc_addr_samples when use_browser != 1, now it will allocate
>> > and mark the right bucket.
>> > 
>> > I'll have this in perf/urgent and will do the optimization of not
>> > allocating those buckets in the report case when not doing
>> > integrated annotation, i.e. report --stdio doesn't provide a way to
>> > go to the annotation --stdio, so no point on allocating the
>> > buckets. Just on 'annotate --stdio' we should allocate it, etc.
>> 
>> This fixes the issue, thanks!
>
> After some more testing, perf report can SEGV with this patch:

I think we need to separate the check for annotate and report.  The
check was for the report case only and annotate always needs to increate
sample info.  Does patch below fix your problem?


diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index d882b6f96411..bab762bdeb0d 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -75,6 +75,11 @@ static int report__config(const char *var, const char *value, void *cb)
 	return perf_default_config(var, value, cb);
 }
 
+static bool report_needs_annotate(void)
+{
+	return use_browser == 1 && sort__has_sym;
+}
+
 static int report__add_mem_hist_entry(struct report *rep, struct addr_location *al,
 				      struct perf_sample *sample, struct perf_evsel *evsel)
 {
@@ -110,14 +115,16 @@ static int report__add_mem_hist_entry(struct report *rep, struct addr_location *
 	if (!he)
 		return -ENOMEM;
 
-	err = hist_entry__inc_addr_samples(he, evsel->idx, al->addr);
-	if (err)
-		goto out;
+	if (report_needs_annotate()) {
+		err = hist_entry__inc_addr_samples(he, evsel->idx, al->addr);
+		if (err)
+			goto out;
 
-	mx = he->mem_info;
-	err = addr_map_symbol__inc_samples(&mx->daddr, evsel->idx);
-	if (err)
-		goto out;
+		mx = he->mem_info;
+		err = addr_map_symbol__inc_samples(&mx->daddr, evsel->idx);
+		if (err)
+			goto out;
+	}
 
 	evsel->hists.stats.total_period += cost;
 	hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
@@ -159,14 +166,18 @@ static int report__add_branch_hist_entry(struct report *rep, struct addr_locatio
 		he = __hists__add_entry(&evsel->hists, al, parent, &bi[i], NULL,
 					1, 1, 0);
 		if (he) {
-			bx = he->branch_info;
-			err = addr_map_symbol__inc_samples(&bx->from, evsel->idx);
-			if (err)
-				goto out;
-
-			err = addr_map_symbol__inc_samples(&bx->to, evsel->idx);
-			if (err)
-				goto out;
+			if (report_needs_annotate()) {
+				bx = he->branch_info;
+				err = addr_map_symbol__inc_samples(&bx->from,
+								   evsel->idx);
+				if (err)
+					goto out;
+
+				err = addr_map_symbol__inc_samples(&bx->to,
+								   evsel->idx);
+				if (err)
+					goto out;
+			}
 
 			evsel->hists.stats.total_period += 1;
 			hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
@@ -199,7 +210,9 @@ static int report__add_hist_entry(struct report *rep, struct perf_evsel *evsel,
 	if (err)
 		goto out;
 
-	err = hist_entry__inc_addr_samples(he, evsel->idx, al->addr);
+	if (report_needs_annotate())
+		err = hist_entry__inc_addr_samples(he, evsel->idx, al->addr);
+
 	evsel->hists.stats.total_period += sample->period;
 	hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
 out:
diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 469eb679fb9d..6fcada625c86 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -489,7 +489,7 @@ static int symbol__inc_addr_samples(struct symbol *sym, struct map *map,
 {
 	struct annotation *notes;
 
-	if (sym == NULL || use_browser != 1 || !sort__has_sym)
+	if (sym == NULL)
 		return 0;
 
 	notes = symbol__annotation(sym);
