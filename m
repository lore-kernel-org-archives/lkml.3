Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763620Ab3IEJPN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 05:15:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39444 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763266Ab3IEJPI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 05:15:08 -0400
Date: Thu, 5 Sep 2013 11:14:50 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCHv2] perf tools: Separate progress bar update when processing
 events
Message-ID: <20130905091449.GC1100@krava.brq.redhat.com>
References: <1378312077-28374-1-git-send-email-jolsa@redhat.com>
 <5227641A.40500@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5227641A.40500@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 04, 2013 at 10:47:22AM -0600, David Ahern wrote:
> On 9/4/13 10:27 AM, Jiri Olsa wrote:

SNIP

> >index 1fc0c62..4df449c 100644
> >--- a/tools/perf/util/session.c
> >+++ b/tools/perf/util/session.c
> >@@ -495,7 +495,7 @@ static int perf_session_deliver_event(struct perf_session *session,
> >  				      u64 file_offset);
> >
> >  static int flush_sample_queue(struct perf_session *s,
> >-		       struct perf_tool *tool)
> >+		       struct perf_tool *tool, bool final)
> 
> Why not base it on next_flush = ULLONG_MAX? Then you don't need the
> extra arg.

ok, v2 attached

thanks,
jirka

---
Currently when processing events in __perf_session__process_events
function we we update progress based on the file_size. During the
same processing we update progress bar from within flush_sample_queue
which is based on number of samples count.

Having 2 different based updates is causing the progress bar to
jump heavily back and forth giving not much usefull info.

Fixing this byt keeping only __perf_session__process_events
based progress bar update. And turning on flush_sample_queue
progress bar update only for final flushing.

This reduces the number of time the progress bar update
function is called and it significantly reduces the loading
time for TUI, where the progress bar update takes quite a lot
of time.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
---
 tools/perf/util/session.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 1fc0c62..476caa1 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -504,6 +504,7 @@ static int flush_sample_queue(struct perf_session *s,
 	u64 limit = os->next_flush;
 	u64 last_ts = os->last_sample ? os->last_sample->timestamp : 0ULL;
 	unsigned idx = 0, progress_next = os->nr_samples / 16;
+	bool show_progress = limit == ULLONG_MAX;
 	int ret;
 
 	if (!tool->ordered_samples || !limit)
@@ -526,7 +527,7 @@ static int flush_sample_queue(struct perf_session *s,
 		os->last_flush = iter->timestamp;
 		list_del(&iter->list);
 		list_add(&iter->list, &os->sample_cache);
-		if (++idx >= progress_next) {
+		if (show_progress && (++idx >= progress_next)) {
 			progress_next += os->nr_samples / 16;
 			ui_progress__update(idx, os->nr_samples,
 					    "Processing time ordered events...");
-- 
1.7.11.7

