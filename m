Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754465AbaCRIaY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 04:30:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45627 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754203AbaCRIaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 04:30:18 -0400
Date: Tue, 18 Mar 2014 01:29:40 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-9b0d2fb86d4737b2cda39bc9c9a8e368cec38960@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1393809254-4480-2-git-send-email-namhyung@kernel.org>
References: <1393809254-4480-2-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf ui/stdio:
  Fix invalid output on event group report
Git-Commit-ID: 9b0d2fb86d4737b2cda39bc9c9a8e368cec38960
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

Commit-ID:  9b0d2fb86d4737b2cda39bc9c9a8e368cec38960
Gitweb:     http://git.kernel.org/tip/9b0d2fb86d4737b2cda39bc9c9a8e368cec38960
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Mon, 3 Mar 2014 10:14:02 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 14 Mar 2014 18:08:37 -0300

perf ui/stdio: Fix invalid output on event group report

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
index 78f4c92..6094562 100644
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
