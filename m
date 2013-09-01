Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757553Ab3IAKjB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 06:39:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60494 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757471Ab3IAKiC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 06:38:02 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 25/25] perf tools: Have the process properly sythesized in subsequent data files
Date: Sun,  1 Sep 2013 12:36:36 +0200
Message-Id: <1378031796-17892-26-git-send-email-jolsa@redhat.com>
In-Reply-To: <1378031796-17892-1-git-send-email-jolsa@redhat.com>
References: <1378031796-17892-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the target so the sythesizing routine would think
it needs to synthesized whole process, because there's no
exec COMM event for subsequent data files.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: David Ahern <dsahern@gmail.com>
---
 tools/perf/builtin-record.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index b0c5937..0dbf9a3 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -516,6 +516,8 @@ static int multi_file_finish(struct perf_record *rec)
 static int multi_file_init(struct perf_record *rec)
 {
 	struct perf_data_file *file = rec->file;
+	struct perf_record_opts *opts = &rec->opts;
+	static bool target_change;
 	int err;
 
 	if (multi_file_name(rec->file, rec->multi_idx++))
@@ -529,6 +531,15 @@ static int multi_file_init(struct perf_record *rec)
 	if (err)
 		goto out_close;
 
+	/*
+	 * XXX HACK - Make the target looks like we have pid
+	 * so we get the process fully synthetised.
+	 */
+	if (perf_target__none(&opts->target) && !target_change) {
+		target_change = true;
+		opts->target.pid = "multi";
+	}
+
 	err = synthesize_record_file(rec);
 	if (err)
 		goto out_close;
-- 
1.7.11.7

