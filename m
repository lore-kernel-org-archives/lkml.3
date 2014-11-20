Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756722AbaKTHiP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 02:38:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43826 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756678AbaKTHiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 02:38:12 -0500
Date: Wed, 19 Nov 2014 23:37:41 -0800
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-ee205503f2333d639550eaed37abb455733510a3@git.kernel.org>
Cc: dsahern@gmail.com, tglx@linutronix.de, peterz@infradead.org,
        adrian.hunter@intel.com, jolsa@redhat.com, mingo@kernel.org,
        eranian@google.com, hpa@zytor.com, fweisbec@gmail.com,
        paulus@samba.org, linux-kernel@vger.kernel.org, acme@redhat.com,
        namhyung@gmail.com
Reply-To: eranian@google.com, fweisbec@gmail.com, hpa@zytor.com,
        paulus@samba.org, linux-kernel@vger.kernel.org, acme@redhat.com,
        namhyung@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        peterz@infradead.org, adrian.hunter@intel.com, jolsa@redhat.com,
        mingo@kernel.org
In-Reply-To: <1415700294-30816-1-git-send-email-adrian.hunter@intel.com>
References: <1415700294-30816-1-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Fix annotation with kcore
Git-Commit-ID: ee205503f2333d639550eaed37abb455733510a3
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

Commit-ID:  ee205503f2333d639550eaed37abb455733510a3
Gitweb:     http://git.kernel.org/tip/ee205503f2333d639550eaed37abb455733510a3
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Tue, 11 Nov 2014 12:04:54 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 19 Nov 2014 12:33:47 -0300

perf tools: Fix annotation with kcore

Patch "perf tools: Fix build-id matching on vmlinux" breaks annotation
with kcore.  The problem is that symbol__annotate() first gets the
filename based on the build-id which was previously not set.

This patch provides a quick fix, however there should probably be only
one way to determine the filename. e.g.  symbol__annotate() should use
the same way as dso__data_fd().

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1415700294-30816-1-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/annotate.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 7dabde1..873c877 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -915,6 +915,8 @@ int symbol__annotate(struct symbol *sym, struct map *map, size_t privsize)
 			return -ENOMEM;
 		}
 		goto fallback;
+	} else if (dso__is_kcore(dso)) {
+		goto fallback;
 	} else if (readlink(symfs_filename, command, sizeof(command)) < 0 ||
 		   strstr(command, "[kernel.kallsyms]") ||
 		   access(symfs_filename, R_OK)) {
