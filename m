Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932239Ab3BFWPd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 17:15:33 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37498 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932113Ab3BFWPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 17:15:30 -0500
Date: Wed, 6 Feb 2013 14:15:09 -0800
From: tip-bot for Paul Gortmaker <paul.gortmaker@windriver.com>
Message-ID: <tip-91b988048bea24eae386da3141d247ccea795a81@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org, joe@perches.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de,
        paul.gortmaker@windriver.com
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, joe@perches.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de,
        paul.gortmaker@windriver.com
In-Reply-To: <1359594349-25912-1-git-send-email-paul.gortmaker@windriver.com>
References: <1359594349-25912-1-git-send-email-paul.gortmaker@windriver.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Fix calloc argument ordering
Git-Commit-ID: 91b988048bea24eae386da3141d247ccea795a81
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 06 Feb 2013 14:15:15 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  91b988048bea24eae386da3141d247ccea795a81
Gitweb:     http://git.kernel.org/tip/91b988048bea24eae386da3141d247ccea795a81
Author:     Paul Gortmaker <paul.gortmaker@windriver.com>
AuthorDate: Wed, 30 Jan 2013 20:05:49 -0500
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 6 Feb 2013 18:09:28 -0300

perf tools: Fix calloc argument ordering

A sweep of the kernel for regex "kcalloc(sizeof" turned up 2 reversed
args, fixed in commit d3d09e18203dba16a9dbdb2b4cc673d90748cdd1 ("EDAC:
Fix kcalloc argument order") and also fixed in the networking commit
a1b1add07fa794974573d93483d68e373edfe7bd ("gro: Fix kcalloc argument
order").

I know that was the regex used, because on seeing the 1st of these
changes, I wondered "how many other instances of this are there" and I
happened to just use "calloc(sizeof" as a regex and it in turn found
these additional reversed args instances in the perf code.

In the kcalloc cases, the changes are cosmetic, since the numbers are
simply multiplied.  I had no desire to go data mining in userspace to
see if the same thing held true there, however.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Joe Perches <joe@perches.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1359594349-25912-1-git-send-email-paul.gortmaker@windriver.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/callchain.c | 2 +-
 tools/perf/util/header.c    | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index d3b3f5d..42b6a63 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -444,7 +444,7 @@ int callchain_cursor_append(struct callchain_cursor *cursor,
 	struct callchain_cursor_node *node = *cursor->last;
 
 	if (!node) {
-		node = calloc(sizeof(*node), 1);
+		node = calloc(1, sizeof(*node));
 		if (!node)
 			return -ENOMEM;
 
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 8022b52..f4bfd79 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -2253,7 +2253,7 @@ static int perf_header__adds_write(struct perf_header *header,
 	if (!nr_sections)
 		return 0;
 
-	feat_sec = p = calloc(sizeof(*feat_sec), nr_sections);
+	feat_sec = p = calloc(nr_sections, sizeof(*feat_sec));
 	if (feat_sec == NULL)
 		return -ENOMEM;
 
@@ -2425,7 +2425,7 @@ int perf_header__process_sections(struct perf_header *header, int fd,
 	if (!nr_sections)
 		return 0;
 
-	feat_sec = sec = calloc(sizeof(*feat_sec), nr_sections);
+	feat_sec = sec = calloc(nr_sections, sizeof(*feat_sec));
 	if (!feat_sec)
 		return -1;
 
