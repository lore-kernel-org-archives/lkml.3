Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966123Ab3GSHwh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 03:52:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35804 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965772Ab3GSHwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 03:52:33 -0400
Date: Fri, 19 Jul 2013 00:52:15 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-tr6su3wfm20k2m5npjggyvtw@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf diff:
  Update perf diff documentation for multiple data comparison
Git-Commit-ID: 3a3beae81dae4960cac99fb6deeaca371f0790eb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 19 Jul 2013 00:52:21 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3a3beae81dae4960cac99fb6deeaca371f0790eb
Gitweb:     http://git.kernel.org/tip/3a3beae81dae4960cac99fb6deeaca371f0790eb
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Wed, 24 Oct 2012 14:56:51 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 12 Jul 2013 13:54:13 -0300

perf diff: Update perf diff documentation for multiple data comparison

Updating perf diff documentation to include multiple perf data files
comparison.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Reviewed-by: Namhyung Kim <namhyung@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-tr6su3wfm20k2m5npjggyvtw@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-diff.txt | 73 +++++++++++++++++++++++++++++-----
 1 file changed, 64 insertions(+), 9 deletions(-)

diff --git a/tools/perf/Documentation/perf-diff.txt b/tools/perf/Documentation/perf-diff.txt
index 5b3123d..2d134f3 100644
--- a/tools/perf/Documentation/perf-diff.txt
+++ b/tools/perf/Documentation/perf-diff.txt
@@ -3,17 +3,17 @@ perf-diff(1)
 
 NAME
 ----
-perf-diff - Read two perf.data files and display the differential profile
+perf-diff - Read perf.data files and display the differential profile
 
 SYNOPSIS
 --------
 [verse]
-'perf diff' [oldfile] [newfile]
+'perf diff' [baseline file] [data file1] [[data file2] ... ]
 
 DESCRIPTION
 -----------
-This command displays the performance difference amongst two perf.data files
-captured via perf record.
+This command displays the performance difference amongst two or more perf.data
+files captured via perf record.
 
 If no parameters are passed it will assume perf.data.old and perf.data.
 
@@ -87,6 +87,59 @@ OPTIONS
 --formula::
         Show formula for given computation.
 
+COMPARISON
+----------
+The comparison is governed by the baseline file. The baseline perf.data
+file is iterated for samples. All other perf.data files specified on
+the command line are searched for the baseline sample pair. If the pair
+is found, specified computation is made and result is displayed.
+
+All samples from non-baseline perf.data files, that do not match any
+baseline entry, are displayed with empty space within baseline column
+and possible computation results (delta) in their related column.
+
+Example files samples:
+- file A with samples f1, f2, f3, f4,    f6
+- file B with samples     f2,     f4, f5
+- file C with samples f1, f2,         f5
+
+Example output:
+  x - computation takes place for pair
+  b - baseline sample percentage
+
+- perf diff A B C
+
+  baseline/A compute/B compute/C  samples
+  ---------------------------------------
+  b                    x          f1
+  b          x         x          f2
+  b                               f3
+  b          x                    f4
+  b                               f6
+             x         x          f5
+
+- perf diff B A C
+
+  baseline/B compute/A compute/C  samples
+  ---------------------------------------
+  b          x         x          f2
+  b          x                    f4
+  b                    x          f5
+             x         x          f1
+             x                    f3
+             x                    f6
+
+- perf diff C B A
+
+  baseline/C compute/B compute/A  samples
+  ---------------------------------------
+  b                    x          f1
+  b          x         x          f2
+  b          x                    f5
+                       x          f3
+             x         x          f4
+                       x          f6
+
 COMPARISON METHODS
 ------------------
 delta
@@ -96,7 +149,7 @@ If specified the 'Delta' column is displayed with value 'd' computed as:
   d = A->period_percent - B->period_percent
 
 with:
-  - A/B being matching hist entry from first/second file specified
+  - A/B being matching hist entry from data/baseline file specified
     (or perf.data/perf.data.old) respectively.
 
   - period_percent being the % of the hist entry period value within
@@ -109,24 +162,26 @@ If specified the 'Ratio' column is displayed with value 'r' computed as:
   r = A->period / B->period
 
 with:
-  - A/B being matching hist entry from first/second file specified
+  - A/B being matching hist entry from data/baseline file specified
     (or perf.data/perf.data.old) respectively.
 
   - period being the hist entry period value
 
-wdiff
-~~~~~
+wdiff:WEIGHT-B,WEIGHT-A
+~~~~~~~~~~~~~~~~~~~~~~~
 If specified the 'Weighted diff' column is displayed with value 'd' computed as:
 
    d = B->period * WEIGHT-A - A->period * WEIGHT-B
 
-  - A/B being matching hist entry from first/second file specified
+  - A/B being matching hist entry from data/baseline file specified
     (or perf.data/perf.data.old) respectively.
 
   - period being the hist entry period value
 
   - WEIGHT-A/WEIGHT-B being user suplied weights in the the '-c' option
     behind ':' separator like '-c wdiff:1,2'.
+    - WIEGHT-A being the weight of the data file
+    - WIEGHT-B being the weight of the baseline data file
 
 SEE ALSO
 --------
