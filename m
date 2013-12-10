Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834Ab3LJJQg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 04:16:36 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44024 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674Ab3LJJQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 04:16:22 -0500
Date: Tue, 10 Dec 2013 01:15:37 -0800
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-d88938ebc97df72320609b33aa0cf9a9a98accb1@git.kernel.org>
Cc: acme@redhat.com, eranian@google.com, mingo@redhat.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, efault@gmx.de, jolsa@redhat.com,
        fweisbec@gmail.com, ak@linux.intel.com, dsahern@gmail.com,
        tglx@linutronix.de, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, namhyung@gmail.com,
        adrian.hunter@intel.com
Reply-To: mingo@kernel.org, mingo@redhat.com, eranian@google.com,
        acme@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        ak@linux.intel.com, tglx@linutronix.de, hpa@zytor.com,
        paulus@samba.org, linux-kernel@vger.kernel.org, namhyung@gmail.com,
        adrian.hunter@intel.com
In-Reply-To: <1386055390-13757-4-git-send-email-adrian.hunter@intel.com>
References: <1386055390-13757-4-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Use asprintf instead of malloc plus snprintf
Git-Commit-ID: d88938ebc97df72320609b33aa0cf9a9a98accb1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 10 Dec 2013 01:15:45 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d88938ebc97df72320609b33aa0cf9a9a98accb1
Gitweb:     http://git.kernel.org/tip/d88938ebc97df72320609b33aa0cf9a9a98accb1
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Tue, 3 Dec 2013 09:23:06 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 4 Dec 2013 13:46:36 -0300

perf tools: Use asprintf instead of malloc plus snprintf

The asprintf library function is equivalent to malloc plus snprintf so
use it because it is simpler.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1386055390-13757-4-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/srcline.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/tools/perf/util/srcline.c b/tools/perf/util/srcline.c
index d11aefb..4c8e816 100644
--- a/tools/perf/util/srcline.c
+++ b/tools/perf/util/srcline.c
@@ -227,7 +227,6 @@ char *get_srcline(struct dso *dso, unsigned long addr)
 	unsigned line = 0;
 	char *srcline;
 	char *dso_name = dso->long_name;
-	size_t size;
 
 	if (!dso->has_srcline)
 		return SRCLINE_UNKNOWN;
@@ -241,13 +240,7 @@ char *get_srcline(struct dso *dso, unsigned long addr)
 	if (!addr2line(dso_name, addr, &file, &line))
 		goto out;
 
-	/* just calculate actual length */
-	size = snprintf(NULL, 0, "%s:%u", file, line) + 1;
-
-	srcline = malloc(size);
-	if (srcline)
-		snprintf(srcline, size, "%s:%u", file, line);
-	else
+	if (asprintf(&srcline, "%s:%u", file, line) < 0)
 		srcline = SRCLINE_UNKNOWN;
 
 	free(file);
