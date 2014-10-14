Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932338AbaJNOCW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 10:02:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31192 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755288AbaJNOCV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 10:02:21 -0400
Date: Tue, 14 Oct 2014 16:02:04 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: "Liang, Kan" <kan.liang@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "acme@kernel.org" <acme@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH] perf tools: Do not call pevent_free_format when deleting
 tracepoint
Message-ID: <20141014140204.GA1639@krava.redhat.com>
References: <1412694532-23391-1-git-send-email-kan.liang@intel.com>
 <37D7C6CF3E00A74B8858931C1DB2F077016237E7@SHSMSX103.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37D7C6CF3E00A74B8858931C1DB2F077016237E7@SHSMSX103.ccr.corp.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 13, 2014 at 03:43:18PM +0000, Liang, Kan wrote:
> Hi Jolsa,
> 
> Does the new patch set work on your machine?
> I tested the V8 patch set on haswell, ivybridge and Romley platform,
> I cannot reproduce the issue you mentioned.
> Could you please try the latest V8 patch? 

actually it still does, but it looks like another issue,
I think we need patch below.. I'll now check rest of your
patches.

Steven,
does the patch below make sense to you? I dont think we want
to allow freeing of the event_format that pevent keeps in
the array.

jirka


---
The libtraceevent library's main handle 'struct pevent' holds
pointers of every event that was added to it via functions:
  pevent_parse_format
  pevent_parse_event

All added events are released within the handle cleanup
in pevent_free.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evsel.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index e0868a901c4a..f5cc101428be 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -824,8 +824,6 @@ void perf_evsel__delete(struct perf_evsel *evsel)
 	perf_evsel__exit(evsel);
 	close_cgroup(evsel->cgrp);
 	zfree(&evsel->group_name);
-	if (evsel->tp_format)
-		pevent_free_format(evsel->tp_format);
 	zfree(&evsel->name);
 	free(evsel);
 }
-- 
1.9.3


