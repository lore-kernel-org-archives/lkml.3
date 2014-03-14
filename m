Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756769AbaCNViW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 17:38:22 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54045 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756269AbaCNVac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 17:30:32 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Andi Kleen <andi@firstfloor.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 07/16] perf ui/stdio: Fix invalid output on event group report
Date: Fri, 14 Mar 2014 18:30:01 -0300
Message-Id: <1394832610-17818-8-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1394832610-17818-1-git-send-email-acme@infradead.org>
References: <1394832610-17818-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

When some of group member has 0 overhead, it printed previous percentage
instead of 0.00%.  It's because passing integer 0 as a percent rather
than double 0.0 so the remaining bits came from garbage.  The TUI and
GTK don't have this problem since they pass 0.0.

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
Cc: Andi Kleen <andi@firstfloor.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1393809254-4480-2-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
1.8.1.4

