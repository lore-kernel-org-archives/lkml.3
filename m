Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753074Ab3COFto (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 01:49:44 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:61292 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530Ab3COFs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 01:48:58 -0400
X-AuditID: 9c930197-b7cc2ae000000eb7-e3-5142b6466c37
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 4/6] perf record: Fixup return path of cmd_record()
Date: Fri, 15 Mar 2013 14:48:51 +0900
Message-Id: <1363326533-3310-4-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1363326533-3310-1-git-send-email-namhyung@kernel.org>
References: <1363326533-3310-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The error path of calling perf_target__parse_uid wrongly went to
out_free_fd.  Also add missing evlist cleanup routines.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-record.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 80cc3ea07788..9f2344a2c506 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -1028,7 +1028,7 @@ int cmd_record(int argc, const char **argv, const char *prefix __maybe_unused)
 		ui__error("%s", errbuf);
 
 		err = -saved_errno;
-		goto out_free_fd;
+		goto out_symbol_exit;
 	}
 
 	err = -ENOMEM;
@@ -1059,6 +1059,9 @@ int cmd_record(int argc, const char **argv, const char *prefix __maybe_unused)
 	}
 
 	err = __cmd_record(&record, argc, argv);
+
+	perf_evlist__munmap(evsel_list);
+	perf_evlist__close(evsel_list);
 out_free_fd:
 	perf_evlist__delete_maps(evsel_list);
 out_symbol_exit:
-- 
1.7.11.7

