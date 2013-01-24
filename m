Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346Ab3AXS4L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 13:56:11 -0500
Received: from terminus.zytor.com ([198.137.202.10]:32989 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975Ab3AXS4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 13:56:07 -0500
Date: Thu, 24 Jan 2013 10:55:38 -0800
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-3ktgyg83fwpqyfpoj0t2ezp0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        robert.richter@amd.com, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, robert.richter@amd.com, dsahern@gmail.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf buildid-list:
  We need to check if a file is ELF first
Git-Commit-ID: f0bf9107679f3670e5fbd52a934b7816256007f7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 24 Jan 2013 10:55:43 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f0bf9107679f3670e5fbd52a934b7816256007f7
Gitweb:     http://git.kernel.org/tip/f0bf9107679f3670e5fbd52a934b7816256007f7
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 5 Dec 2012 16:24:05 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Sun, 9 Dec 2012 08:46:07 -0300

perf buildid-list: We need to check if a file is ELF first

I.e. before we try to use it as a perf.data file by calling
perf_session__new, otherwise we lose the feature that shows the
build id for the given ELF file, this one:

[root@sandy redhat-perfdata-mtech-15]# perf buildid-list -i /root/.debug/.build-id/97/54896de655b6ac088ec2bf5113b35c06f72709
9754896de655b6ac088ec2bf5113b35c06f72709
[root@sandy redhat-perfdata-mtech-15]# perf buildid-list -i /lib/libc-2.12.so
38adaeff4f7c21899b13b28c1a2e6c199ca4c744
[root@sandy redhat-perfdata-mtech-15]#

Regression introduced in:

efad1415 "perf report: Accept fifos as input file"

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-3ktgyg83fwpqyfpoj0t2ezp0@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-buildid-list.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/tools/perf/builtin-buildid-list.c b/tools/perf/builtin-buildid-list.c
index a82d99f..4c770d2 100644
--- a/tools/perf/builtin-buildid-list.c
+++ b/tools/perf/builtin-buildid-list.c
@@ -49,18 +49,16 @@ static int perf_session__list_build_ids(bool force, bool with_hits)
 	struct perf_session *session;
 
 	symbol__elf_init();
-
-	session = perf_session__new(input_name, O_RDONLY, force, false,
-				    &build_id__mark_dso_hit_ops);
-	if (session == NULL)
-		return -1;
-
 	/*
 	 * See if this is an ELF file first:
 	 */
-	if (filename__fprintf_build_id(session->filename, stdout))
+	if (filename__fprintf_build_id(input_name, stdout))
 		goto out;
 
+	session = perf_session__new(input_name, O_RDONLY, force, false,
+				    &build_id__mark_dso_hit_ops);
+	if (session == NULL)
+		return -1;
 	/*
 	 * in pipe-mode, the only way to get the buildids is to parse
 	 * the record stream. Buildids are stored as RECORD_HEADER_BUILD_ID
@@ -69,8 +67,8 @@ static int perf_session__list_build_ids(bool force, bool with_hits)
 		perf_session__process_events(session, &build_id__mark_dso_hit_ops);
 
 	perf_session__fprintf_dsos_buildid(session, stdout, with_hits);
-out:
 	perf_session__delete(session);
+out:
 	return 0;
 }
 
