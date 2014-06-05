Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136AbaFERAu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 13:00:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30018 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751419AbaFERAs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 13:00:48 -0400
Date: Thu, 5 Jun 2014 19:00:11 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>
Subject: [PATCH] perf tools: Fix pipe check regression in attr event callback
Message-ID: <20140605170011.GA13372@krava.brq.redhat.com>
References: <CABPqkBTz7dBFGKGE5Ng8LwB=HQV_VQfhGRyWDC0ofnSjx2r3Vw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBTz7dBFGKGE5Ng8LwB=HQV_VQfhGRyWDC0ofnSjx2r3Vw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 05, 2014 at 06:06:41PM +0200, Stephane Eranian wrote:
> Hi Jiri,
> 
> Somehow, I thought you had written a fix to avoid the problem below.
> But when I try with tip.git, the problem is still there.
> Could you push your fix ASAP.
> 
> Thanks.
> 
> $ perf record -o - noploop 2 |  perf inject -b |  perf report -i -
> # To display the perf.data header info, please use
> --header/--header-only options.
> #
> noploop for 2 seconds
> 0x1bd0 [0x28]: failed to process type: 9

hum, I remember fixing another issue.. this one is
separated one, please try attached patch.

thanks,
jirka


---
The file factoring in builtin-inject.c object introduced regression
in attr event callback. The commit is:
  3406912 perf inject: Handle output file via perf_data_file object

Following hunk reversed the logic:
  -       if (!inject->pipe_output)
  +       if (&inject->output.is_pipe)

putting it back, following example now works:
  $ perf record -o - kill | perf inject -b | perf report -i -

Reported-by: Stephane Eranian <eranian@google.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/builtin-inject.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index 6a3af00..664010b 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -72,7 +72,7 @@ static int perf_event__repipe_attr(struct perf_tool *tool,
 	if (ret)
 		return ret;
 
-	if (&inject->output.is_pipe)
+	if (!&inject->output.is_pipe)
 		return 0;
 
 	return perf_event__repipe_synth(tool, event);
-- 
1.8.3.1

