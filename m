Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751646AbaGTV4X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 17:56:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26867 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750801AbaGTV4V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 17:56:21 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Olsa <jolsa@kernel.org>
Subject: [PATCHv3 00/19] perf tools: Factor ordered samples queue
Date: Sun, 20 Jul 2014 23:55:44 +0200
Message-Id: <1405893363-21967-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
this patchset factors session's ordered samples queue,
and allows to limit the size of this queue.

v3 changes:
  - rebased to latest tip/perf/core
  - add comment for WARN in patch 8 (David)
  - added ordered-events debug variable (David)
  - renamed ordered_events_(get|put) to ordered_events_(new|delete)
  - renamed struct ordered_events_queue to struct ordered_events

v2 changes:
  - several small changes for review comments (Namhyung)


The report command queues events till any of following
conditions is reached:
  - PERF_RECORD_FINISHED_ROUND event is processed
  - end of the file is reached

Any of above conditions will force the queue to flush some
events while keeping all allocated memory for next events.

If PERF_RECORD_FINISHED_ROUND is missing the queue will
allocate memory for every single event in the perf.data.
This could lead to enormous memory consuption and speed
degradation of report command for huge perf.data files.

With the quue allocation limit of 100 MB, I've got around
15% speedup on reporting of ~10GB perf.data file.

current code:
 Performance counter stats for './perf.old report --stdio -i perf-test.data' (3 runs):

   621,685,704,665      cycles                    ( +-  0.52% )
   873,397,467,969      instructions              ( +-  0.00% )

     286.133268732 seconds time elapsed           ( +-  1.13% )

with patches:
 Performance counter stats for './perf report --stdio -i perf-test.data' (3 runs):

   603,933,987,185      cycles                    ( +-  0.45% )
   869,139,445,070      instructions              ( +-  0.00% )

     245.337510637 seconds time elapsed           ( +-  0.49% )


The speed up seems to be mainly in less cycles spent in servicing
page faults:

current code:
     4.44%     0.01%  perf.old  [kernel.kallsyms]   [k] page_fault                                   

with patches:
     1.45%     0.00%      perf  [kernel.kallsyms]   [k] page_fault                                   

current code (faults event):
         6,643,807      faults                    ( +-  0.36% )

with patches (faults event):
         2,214,756      faults                    ( +-  3.03% )


Also now we have one of our big memory spender under control
and the ordered events queue code is put in separated object
with clear interface ready to be used by another command
like script.

Also reachable in here:
  git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
  perf/core_ordered_events

thanks,
jirka


Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
