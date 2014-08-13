Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751478AbaHMFN6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 01:13:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44733 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751AbaHMFN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 01:13:56 -0400
Date: Tue, 12 Aug 2014 22:13:23 -0700
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-8affc2b8c27bfc2d6e70827b746f490b62c44eaa@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, ak@linux.intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, ak@linux.intel.com, tglx@linutronix.de
In-Reply-To: <1406789104-25863-10-git-send-email-zheng.z.yan@intel.com>
References: <1406789104-25863-10-git-send-email-zheng.z.yan@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf record: Honour --no-time command line option
Git-Commit-ID: 8affc2b8c27bfc2d6e70827b746f490b62c44eaa
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8affc2b8c27bfc2d6e70827b746f490b62c44eaa
Gitweb:     http://git.kernel.org/tip/8affc2b8c27bfc2d6e70827b746f490b62c44eaa
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Thu, 31 Jul 2014 14:45:04 +0800
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 12 Aug 2014 12:00:03 -0300

perf record: Honour --no-time command line option

Time stamps are always implicitely enabled for record currently.  The
old --time/-T option is a nop.

Allow the user to disable timestamps by using --no-time, honouring the
existing option.

The defaults are unchanged.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1406789104-25863-10-git-send-email-zheng.z.yan@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c | 1 +
 tools/perf/util/evsel.c     | 9 ++++++---
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 4869050..ca0251e 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -781,6 +781,7 @@ static const char * const record_usage[] = {
  */
 static struct record record = {
 	.opts = {
+		.sample_time	     = true,
 		.mmap_pages	     = UINT_MAX,
 		.user_freq	     = UINT_MAX,
 		.user_interval	     = ULLONG_MAX,
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 21a373e..92e5235 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -633,9 +633,12 @@ void perf_evsel__config(struct perf_evsel *evsel, struct record_opts *opts)
 	if (opts->period)
 		perf_evsel__set_sample_bit(evsel, PERIOD);
 
-	if (!perf_missing_features.sample_id_all &&
-	    (opts->sample_time || !opts->no_inherit ||
-	     target__has_cpu(&opts->target) || per_cpu))
+	/*
+	 * When the user explicitely disabled time don't force it here.
+	 */
+	if (opts->sample_time &&
+	    (!perf_missing_features.sample_id_all &&
+	    (!opts->no_inherit || target__has_cpu(&opts->target) || per_cpu)))
 		perf_evsel__set_sample_bit(evsel, TIME);
 
 	if (opts->raw_samples && !evsel->no_aux_samples) {
