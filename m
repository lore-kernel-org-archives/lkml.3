Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760692Ab3HOH6p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 03:58:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54049 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754179Ab3HOH6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 03:58:42 -0400
Date: Thu, 15 Aug 2013 00:57:51 -0700
From: tip-bot for Stephane Eranian <tipbot@zytor.com>
Message-ID: <tip-c5885749e4ebe568cca969d43488a233e69e6454@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        namhyung.kim@lge.com, jolsa@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        namhyung.kim@lge.com, jolsa@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20130814100426.GA3444@quad>
References: <20130814100426.GA3444@quad>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Improve robustness of topology parsing code
Git-Commit-ID: c5885749e4ebe568cca969d43488a233e69e6454
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 15 Aug 2013 00:57:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c5885749e4ebe568cca969d43488a233e69e6454
Gitweb:     http://git.kernel.org/tip/c5885749e4ebe568cca969d43488a233e69e6454
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Wed, 14 Aug 2013 12:04:26 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 14 Aug 2013 11:42:53 -0300

perf tools: Improve robustness of topology parsing code

This patch improves the robustness of the build_cpu_topo() routine by
allowing either the CPU parsing or the thread parsing to fail and yet
get perf to produce some topology data which could be useful for the
analysis.

Without this patch, if the cpu parsing fails, the thread parsing is not
attempted vice-versa.

Signed-off-by: Stephane Eranian <eranian@google.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20130814100426.GA3444@quad
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/header.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index f558f83..a33197a 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -716,18 +716,19 @@ static int build_cpu_topo(struct cpu_topo *tp, int cpu)
 	char filename[MAXPATHLEN];
 	char *buf = NULL, *p;
 	size_t len = 0;
+	ssize_t sret;
 	u32 i = 0;
 	int ret = -1;
 
 	sprintf(filename, CORE_SIB_FMT, cpu);
 	fp = fopen(filename, "r");
 	if (!fp)
-		return -1;
-
-	if (getline(&buf, &len, fp) <= 0)
-		goto done;
+		goto try_threads;
 
+	sret = getline(&buf, &len, fp);
 	fclose(fp);
+	if (sret <= 0)
+		goto try_threads;
 
 	p = strchr(buf, '\n');
 	if (p)
@@ -743,7 +744,9 @@ static int build_cpu_topo(struct cpu_topo *tp, int cpu)
 		buf = NULL;
 		len = 0;
 	}
+	ret = 0;
 
+try_threads:
 	sprintf(filename, THRD_SIB_FMT, cpu);
 	fp = fopen(filename, "r");
 	if (!fp)
