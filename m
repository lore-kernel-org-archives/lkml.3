Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964863Ab3GQRvh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 13:51:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63380 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964830Ab3GQRv0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 13:51:26 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 23/23] perf tools: Have the process properly sythesized in subsequent data files
Date: Wed, 17 Jul 2013 19:50:03 +0200
Message-Id: <1374083403-14591-24-git-send-email-jolsa@redhat.com>
In-Reply-To: <1374083403-14591-1-git-send-email-jolsa@redhat.com>
References: <1374083403-14591-1-git-send-email-jolsa@redhat.com>
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
index 920d69a..3740c5e 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -470,6 +470,8 @@ static int multi_file_finish(struct perf_record *rec)
 static int multi_file_init(struct perf_record *rec)
 {
 	struct perf_data_file *file = rec->file;
+	struct perf_record_opts *opts = &rec->opts;
+	static bool target_change;
 	int err;
 
 	if (multi_file_name(rec->file, rec->multi_idx++))
@@ -483,6 +485,15 @@ static int multi_file_init(struct perf_record *rec)
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

