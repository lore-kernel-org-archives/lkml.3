Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752150AbaDUQHB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 12:07:01 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:61192 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbaDUQG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 12:06:59 -0400
Date: Mon, 21 Apr 2014 18:06:55 +0200
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: acme@redhat.com, jolsa@redhat.com, peterz@infradead.org, mingo@elte.hu,
        namhyung@kernel.org, dsahern@gmail.com
Subject: [PATCH] perf tools: fix processing of pid/tid for mmap records
Message-ID: <20140421160655.GA4201@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

perf tools: fix processing of pid/tid for mmap records
    
Mmaps are global to a process (always). Processing them
per-thread was causing some serious issues in case mmaps
would overlap. The overlap fixups would only occur in the
context of the thread which generated the overlapping
mmap. But that was cause issues later on when a sample
from another thread would fall into that overlapping
mmap.

The solution to the problem is to handle ALL mmaps as
occurring in the master thread (pid = tid) and then to
lookup for thread map using pid as the tid argument.
This is how samples are looking up for the thread map
already (notice pid passed twice):
    
int perf_event__preprocess_sample(const union perf_event *event,
                                  struct machine *machine,
                                  struct addr_location *al,
                                  struct perf_sample *sample)
{
        struct thread *thread = machine__findnew_thread(machine, sample->pid,
                                                        sample->pid);
}
    
Without this fix, some samples in overlapping regions
may not be symbolized.
    
Signed-off-by: Stephane Eranian <eranian@google.com>

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index a53cd0b..43cdc0a 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1025,9 +1025,9 @@ int machine__process_mmap2_event(struct machine *machine,
 			goto out_problem;
 		return 0;
 	}
-
+	/* only look by pid for mmap events */
 	thread = machine__findnew_thread(machine, event->mmap2.pid,
-					event->mmap2.tid);
+					event->mmap2.pid);
 	if (thread == NULL)
 		goto out_problem;
 
@@ -1073,9 +1073,9 @@ int machine__process_mmap_event(struct machine *machine, union perf_event *event
 			goto out_problem;
 		return 0;
 	}
-
+	/* only look by pid for mmap events */
 	thread = machine__findnew_thread(machine, event->mmap.pid,
-					 event->mmap.tid);
+					 event->mmap.pid);
 	if (thread == NULL)
 		goto out_problem;
 
