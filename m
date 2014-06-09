Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464AbaFIUDA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 16:03:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50214 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754392AbaFIUCz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 16:02:55 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 05/15] perf tools: Fix pipe check regression in attr event callback
Date: Mon,  9 Jun 2014 22:02:20 +0200
Message-Id: <1402344150-14860-6-git-send-email-jolsa@kernel.org>
In-Reply-To: <1402344150-14860-1-git-send-email-jolsa@kernel.org>
References: <1402344150-14860-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The file factoring in builtin-inject.c object introduced regression
in attr event callback. The commit is:
  3406912 perf inject: Handle output file via perf_data_file object

Following hunk reversed the logic:
  -       if (!inject->pipe_output)
  +       if (&inject->output.is_pipe)

putting it back, following example now works:
  $ perf record -o - kill | perf inject -b | perf report -i -

Plus removing extra '&' (kudos to Arnaldo)

Reported-by: Stephane Eranian <eranian@google.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20140605204117.GA1771@krava.redhat.com
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/builtin-inject.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index 6a3af00..16c7c11 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -72,7 +72,7 @@ static int perf_event__repipe_attr(struct perf_tool *tool,
 	if (ret)
 		return ret;
 
-	if (&inject->output.is_pipe)
+	if (!inject->output.is_pipe)
 		return 0;
 
 	return perf_event__repipe_synth(tool, event);
-- 
1.8.3.1

