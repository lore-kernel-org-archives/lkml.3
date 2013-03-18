Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175Ab3CRLIN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 07:08:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34152 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752932Ab3CRLIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 07:08:06 -0400
Date: Mon, 18 Mar 2013 04:06:41 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-778141e3cf0bf29f91cd3cb5c314ea477b9402a7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, acme@ghostprotocols.net, namhyung.kim@lge.com,
        namhyung@kernel.org, jolsa@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, acme@ghostprotocols.net, namhyung.kim@lge.com,
        tglx@linutronix.de, namhyung@kernel.org, jolsa@redhat.com
In-Reply-To: <1363574507-18808-1-git-send-email-namhyung@kernel.org>
References: <1363574507-18808-1-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf: Reset hwc->last_period on sw clock events
Git-Commit-ID: 778141e3cf0bf29f91cd3cb5c314ea477b9402a7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 18 Mar 2013 04:06:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  778141e3cf0bf29f91cd3cb5c314ea477b9402a7
Gitweb:     http://git.kernel.org/tip/778141e3cf0bf29f91cd3cb5c314ea477b9402a7
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Mon, 18 Mar 2013 11:41:46 +0900
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 18 Mar 2013 09:15:18 +0100

perf: Reset hwc->last_period on sw clock events

When cpu/task clock events are initialized, their sampling
frequencies are converted to have a fixed value.  However it
missed to update the hwc->last_period which was set to 1 for
initial sampling frequency calibration.

Because this hwc->last_period value is used as a period in
perf_swevent_ hrtime(), every recorded sample will have an
incorrected period of 1.

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

Note that it doesn't affect the non-sampling event so that the
perf stat still gets correct value with or without this patch.

  $ perf stat -e task-clock noploop 1

   Performance counter stats for 'noploop 1':

         1000.272525 task-clock                #    1.000 CPUs utilized

         1.000560605 seconds time elapsed

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1363574507-18808-1-git-send-email-namhyung@kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index b0cd865..fa79c37 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5647,6 +5647,7 @@ static void perf_swevent_init_hrtimer(struct perf_event *event)
 		event->attr.sample_period = NSEC_PER_SEC / freq;
 		hwc->sample_period = event->attr.sample_period;
 		local64_set(&hwc->period_left, hwc->sample_period);
+		hwc->last_period = hwc->sample_period;
 		event->attr.freq = 0;
 	}
 }
