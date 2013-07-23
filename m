Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755725Ab3GWHsk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 03:48:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56294 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755683Ab3GWHsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 03:48:36 -0400
Date: Tue, 23 Jul 2013 00:48:20 -0700
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-f9ea55d0ddf66ed030b2a478625cd5792d30df16@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, namhyung.kim@lge.com, jolsa@redhat.com,
        ak@linux.intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, namhyung.kim@lge.com, jolsa@redhat.com,
        ak@linux.intel.com, tglx@linutronix.de
In-Reply-To: <1374188333-17899-1-git-send-email-andi@firstfloor.org>
References: <1374188333-17899-1-git-send-email-andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Move weight back to common sort keys
Git-Commit-ID: f9ea55d0ddf66ed030b2a478625cd5792d30df16
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 23 Jul 2013 00:48:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f9ea55d0ddf66ed030b2a478625cd5792d30df16
Gitweb:     http://git.kernel.org/tip/f9ea55d0ddf66ed030b2a478625cd5792d30df16
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Thu, 18 Jul 2013 15:58:53 -0700
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 22 Jul 2013 16:58:28 -0300

perf tools: Move weight back to common sort keys

This is a partial revert of Namhyung's patch

 afab87b91f3f331d55664172dad8e476e6ffca9d
 perf sort: Separate out memory-specific sort keys

He wrote

 For global/local weights, I'm not entirely sure to place them into the
 memory dimension.  But it's the only user at this time.

Well TSX is another (in fact the original) user of the flags, and it
needs them to be common. So move local/global weight back to the common
sort keys.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Link: http://lkml.kernel.org/r/1374188333-17899-1-git-send-email-andi@firstfloor.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/sort.c | 4 ++--
 tools/perf/util/sort.h | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index cb2b108..5f118a0 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -874,6 +874,8 @@ static struct sort_dimension common_sort_dimensions[] = {
 	DIM(SORT_PARENT, "parent", sort_parent),
 	DIM(SORT_CPU, "cpu", sort_cpu),
 	DIM(SORT_SRCLINE, "srcline", sort_srcline),
+	DIM(SORT_LOCAL_WEIGHT, "local_weight", sort_local_weight),
+	DIM(SORT_GLOBAL_WEIGHT, "weight", sort_global_weight),
 };
 
 #undef DIM
@@ -893,8 +895,6 @@ static struct sort_dimension bstack_sort_dimensions[] = {
 #define DIM(d, n, func) [d - __SORT_MEMORY_MODE] = { .name = n, .entry = &(func) }
 
 static struct sort_dimension memory_sort_dimensions[] = {
-	DIM(SORT_LOCAL_WEIGHT, "local_weight", sort_local_weight),
-	DIM(SORT_GLOBAL_WEIGHT, "weight", sort_global_weight),
 	DIM(SORT_MEM_DADDR_SYMBOL, "symbol_daddr", sort_mem_daddr_sym),
 	DIM(SORT_MEM_DADDR_DSO, "dso_daddr", sort_mem_daddr_dso),
 	DIM(SORT_MEM_LOCKED, "locked", sort_mem_locked),
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index 586022d..4e80dbd 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -143,6 +143,8 @@ enum sort_type {
 	SORT_PARENT,
 	SORT_CPU,
 	SORT_SRCLINE,
+	SORT_LOCAL_WEIGHT,
+	SORT_GLOBAL_WEIGHT,
 
 	/* branch stack specific sort keys */
 	__SORT_BRANCH_STACK,
@@ -154,9 +156,7 @@ enum sort_type {
 
 	/* memory mode specific sort keys */
 	__SORT_MEMORY_MODE,
-	SORT_LOCAL_WEIGHT = __SORT_MEMORY_MODE,
-	SORT_GLOBAL_WEIGHT,
-	SORT_MEM_DADDR_SYMBOL,
+	SORT_MEM_DADDR_SYMBOL = __SORT_MEMORY_MODE,
 	SORT_MEM_DADDR_DSO,
 	SORT_MEM_LOCKED,
 	SORT_MEM_TLB,
