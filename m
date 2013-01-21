Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511Ab3AUOJJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 09:09:09 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:56527 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923Ab3AUOJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 09:09:05 -0500
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, acme@redhat.com,
        jolsa@redhat.com, namhyung.kim@lge.com
Subject: [PATCH v5 0/2] perf stat: add interval counter printing
Date: Mon, 21 Jan 2013 15:06:52 +0100
Message-Id: <1358777214-14220-1-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This small patchset extends perf stat with the -I option.

The -I option enables interval printing. It expects
an interval duration in milliseconds. Minimum is
100ms. Once, activated perf stat prints events deltas
since last printout. All modes are supported.

$ perf stat -I 1000 -e cycles noploop 10
noploop for 10 seconds
 #           time             counts events
      1.000109853      2,388,560,546 cycles
      2.000262846      2,393,332,358 cycles
      3.000354131      2,393,176,537 cycles
      4.000439503      2,393,203,790 cycles
      5.000527075      2,393,167,675 cycles
      6.000609052      2,393,203,670 cycles
      7.000691082      2,393,175,678 cycles

The output format makes it easy to feed into a plotting program
such as gnuplot when the -I option is used in combination with the -x
option:

$ perf stat -x, -I 1000 -e cycles noploop 10
noploop for 10 seconds
1.000084113,2378775498,cycles
2.000245798,2391056897,cycles
3.000354445,2392089414,cycles
4.000459115,2390936603,cycles
5.000565341,2392108173,cycles

The first patch adds the code to keep previous counts. The second
is the actual extension of perf stat.

In v2, we changed the option from -T to -I based on feedback
from Andi Kleen (who is using -T in an upcoming patch).

In v3, added compute_deltas() to evsel.c to factorize
deltas computation based on Jiri's comments.

In v4, we made sure that counts are printed in case
the run is interrupted by CTRL-C based on Andi Kleen's
feedback.

In v5, we added the column headings printed every 25 lines.
Cleaned up the code some more based on Namhyung's comments.

Stephane Eranian (2):
  perf tools: add evsel prev_raw_count field
  perf stat: add interval printing

 tools/perf/Documentation/perf-stat.txt |    4 +
 tools/perf/builtin-stat.c              |  165 +++++++++++++++++++++++++++++---
 tools/perf/util/evsel.c                |   26 +++++
 tools/perf/util/evsel.h                |    1 +
 4 files changed, 181 insertions(+), 15 deletions(-)

-- 
1.7.9.5

