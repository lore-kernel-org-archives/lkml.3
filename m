Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753093Ab3ILLLU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 07:11:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34408 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613Ab3ILLLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 07:11:17 -0400
Date: Thu, 12 Sep 2013 04:10:46 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-e71aa28312b208a14cd87fa61e941ac8c85072f4@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, efault@gmx.de, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, adrian.hunter@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, efault@gmx.de, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de
In-Reply-To: <1378496412-2424-3-git-send-email-adrian.hunter@intel.com>
References: <1378496412-2424-3-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf kvm: Fix sample_type manipulation
Git-Commit-ID: e71aa28312b208a14cd87fa61e941ac8c85072f4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 12 Sep 2013 04:10:52 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e71aa28312b208a14cd87fa61e941ac8c85072f4
Gitweb:     http://git.kernel.org/tip/e71aa28312b208a14cd87fa61e941ac8c85072f4
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Fri, 6 Sep 2013 22:40:12 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 9 Sep 2013 16:13:11 -0300

perf kvm: Fix sample_type manipulation

Manipulating the sample_type of an evsel requires the use of:

	perf_evsel__set_sample_bit()
and	perf_evsel__reset_sample_bit()

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Tested-by: David Ahern <dsahern@gmail.com>
Acked-by: David Ahern <dsahern@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1378496412-2424-3-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-kvm.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 47b3540..935d522 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -1165,16 +1165,16 @@ static int kvm_live_open_events(struct perf_kvm_stat *kvm)
 		struct perf_event_attr *attr = &pos->attr;
 
 		/* make sure these *are* set */
-		attr->sample_type |= PERF_SAMPLE_TID;
-		attr->sample_type |= PERF_SAMPLE_TIME;
-		attr->sample_type |= PERF_SAMPLE_CPU;
-		attr->sample_type |= PERF_SAMPLE_RAW;
+		perf_evsel__set_sample_bit(pos, TID);
+		perf_evsel__set_sample_bit(pos, TIME);
+		perf_evsel__set_sample_bit(pos, CPU);
+		perf_evsel__set_sample_bit(pos, RAW);
 		/* make sure these are *not*; want as small a sample as possible */
-		attr->sample_type &= ~PERF_SAMPLE_PERIOD;
-		attr->sample_type &= ~PERF_SAMPLE_IP;
-		attr->sample_type &= ~PERF_SAMPLE_CALLCHAIN;
-		attr->sample_type &= ~PERF_SAMPLE_ADDR;
-		attr->sample_type &= ~PERF_SAMPLE_READ;
+		perf_evsel__reset_sample_bit(pos, PERIOD);
+		perf_evsel__reset_sample_bit(pos, IP);
+		perf_evsel__reset_sample_bit(pos, CALLCHAIN);
+		perf_evsel__reset_sample_bit(pos, ADDR);
+		perf_evsel__reset_sample_bit(pos, READ);
 		attr->mmap = 0;
 		attr->comm = 0;
 		attr->task = 0;
