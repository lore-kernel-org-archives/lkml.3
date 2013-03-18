Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751252Ab3CRCmJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 22:42:09 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:47854 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930Ab3CRCmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 22:42:03 -0400
X-AuditID: 9c93016f-b7bfaae000003db8-e7-51467ef88f85
From: Namhyung Kim <namhyung@kernel.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 1/2] perf: Reset hwc->last_period on sw clock events
Date: Mon, 18 Mar 2013 11:41:46 +0900
Message-Id: <1363574507-18808-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

When cpu/task clock events are initialized, their sampling frequencies
are converted to have a fixed value.  However it missed to update the
hwc->last_period which was set to 1 for initial sampling frequency
calibration.

Because this hwc->last_period value is used as a period in perf_swevent_
hrtime(), every recorded sample will have an incorrected period of 1.

  $ perf record -e task-clock noploop 1
  [ perf record: Woken up 1 times to write data ]
  [ perf record: Captured and wrote 0.158 MB perf.data (~6919 samples) ]

  $ perf report -n --show-total-period  --stdio
  # Samples: 4K of event 'task-clock'
  # Event count (approx.): 4000
  #
  # Overhead       Samples        Period  Command  Shared Object              Symbol
  # ........  ............  ............  .......  .............  ..................
  #
      99.95%          3998          3998  noploop  noploop        [.] main
       0.03%             1             1  noploop  libc-2.15.so   [.] init_cacheinfo
       0.03%             1             1  noploop  ld-2.15.so     [.] open_verify

Note that it doesn't affect the non-sampling event so that the perf
stat still gets correct value with or without this patch.

  $ perf stat -e task-clock noploop 1

   Performance counter stats for 'noploop 1':

         1000.272525 task-clock                #    1.000 CPUs utilized

         1.000560605 seconds time elapsed

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 kernel/events/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index c38feef0d683..ac418e88b8a9 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5659,6 +5659,7 @@ static void perf_swevent_init_hrtimer(struct perf_event *event)
 		event->attr.sample_period = NSEC_PER_SEC / freq;
 		hwc->sample_period = event->attr.sample_period;
 		local64_set(&hwc->period_left, hwc->sample_period);
+		hwc->last_period = hwc->sample_period;
 		event->attr.freq = 0;
 	}
 }
-- 
1.7.11.7

