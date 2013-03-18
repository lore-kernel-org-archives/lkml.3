Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205Ab3CRQ0J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 12:26:09 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36454 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886Ab3CRQZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 12:25:59 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 48/54] perf record: Fixup return path of cmd_record()
Date: Mon, 18 Mar 2013 13:25:33 -0300
Message-Id: <1363623939-10748-49-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1363623939-10748-1-git-send-email-acme@infradead.org>
References: <1363623939-10748-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The error path of calling perf_target__parse_uid wrongly went to
out_free_fd.  Also add missing evlist cleanup routines.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1363326533-3310-4-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 80cc3ea..9f2344a 100644
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
1.7.1

