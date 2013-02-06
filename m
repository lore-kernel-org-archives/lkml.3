Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758036Ab3BFToQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 14:44:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48139 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755031Ab3BFToP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 14:44:15 -0500
Date: Wed, 6 Feb 2013 20:42:58 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Anton Arapov <anton@redhat.com>, Frank Eigler <fche@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Josh Stone <jistone@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "Suzuki K. Poulose" <suzuki@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] perf/tools: Fix "perf record -C... workload" behaviour
Message-ID: <20130206194258.GB11998@redhat.com>
References: <20130204190225.GA10840@redhat.com> <20130206181044.GA3752@redhat.com> <20130206194218.GA11998@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130206194218.GA11998@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Test-case:

	# perf record -e probe_libc:syscall -C0 true
	true: Terminated

The child process is killed by perf_record__sig_exit(). This is because
perf_evlist__prepare_workload() doesn't initialize threads->map[] and
then perf_event__synthesize_mmap_events() (silently!) fails. This patch
seems to fix the problem, but perhaps we should also move
'pr_err("Couldn't run the workload!\n")' down to 'out_delete_session:',
so that the problems like this would be more understandable.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 tools/perf/util/evlist.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 7052934..8b3f6ef 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -783,7 +783,7 @@ int perf_evlist__prepare_workload(struct perf_evlist *evlist,
 		exit(-1);
 	}
 
-	if (perf_target__none(&opts->target))
+	if (!perf_target__has_task(&opts->target))
 		evlist->threads->map[0] = evlist->workload.pid;
 
 	close(child_ready_pipe[1]);
-- 
1.5.5.1


