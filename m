Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753852AbaCCBRt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 20:17:49 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:60797 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646AbaCCBOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 20:14:20 -0500
X-AuditID: 9c93017d-b7c89ae000006ae1-9d-5313d76632ce
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 01/13] perf ui/stdio: Fix invalid output on event group report
Date: Mon,  3 Mar 2014 10:14:02 +0900
Message-Id: <1393809254-4480-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1393809254-4480-1-git-send-email-namhyung@kernel.org>
References: <1393809254-4480-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When some of group member has 0 overhead, it printed previous
percentage instead of 0.00%.  It's because passing integer 0 as a
percent rather than double 0.0 so the remaining bits came from
garbage.  The TUI and GTK don't have this problem since they pass 0.0.

Before:

  # Samples: 845  of event 'anon group { cycles, cache-references, cache-misses }'
  # Event count (approx.): 174775051
  #
  #                 Overhead                               Samples
  # ........................  ....................................
  #
      20.32%   8.58%  73.51%            45          30         138
       6.87%   6.87%   6.87%            21           0           0
       5.29%   0.31%   0.31%            10           1           0
       1.89%   1.89%   1.89%             6           0           0
       1.76%   1.76%   1.76%             2           0           0

After:

  #                 Overhead                               Samples
  # ........................  ....................................
  #
      20.32%   8.58%  73.51%            45          30         138
       6.87%   0.00%   0.00%            21           0           0
       5.29%   0.31%   0.00%            10           1           0
       1.89%   0.00%   0.00%             6           0           0
       1.76%   0.00%   0.00%             2           0           0

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/hist.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index 78f4c92e9b73..6094562c9523 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -52,8 +52,15 @@ static int __hpp__fmt(struct perf_hpp *hpp, struct hist_entry *he,
 				 * zero-fill group members in the middle which
 				 * have no sample
 				 */
-				ret += print_fn(hpp->buf + ret, hpp->size - ret,
-						fmt, 0);
+				if (fmt_percent) {
+					ret += print_fn(hpp->buf + ret,
+							hpp->size - ret,
+							fmt, 0.0);
+				} else {
+					ret += print_fn(hpp->buf + ret,
+							hpp->size - ret,
+							fmt, 0ULL);
+				}
 			}
 
 			if (fmt_percent)
@@ -72,8 +79,13 @@ static int __hpp__fmt(struct perf_hpp *hpp, struct hist_entry *he,
 			/*
 			 * zero-fill group members at last which have no sample
 			 */
-			ret += print_fn(hpp->buf + ret, hpp->size - ret,
-					fmt, 0);
+			if (fmt_percent) {
+				ret += print_fn(hpp->buf + ret, hpp->size - ret,
+						fmt, 0.0);
+			} else {
+				ret += print_fn(hpp->buf + ret, hpp->size - ret,
+						fmt, 0ULL);
+			}
 		}
 	}
 	return ret;
-- 
1.7.11.7

