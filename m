Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679Ab3IJIYX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 04:24:23 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:45991 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754364Ab3IJIYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 04:24:20 -0400
X-AuditID: 9c93017e-b7c76ae000003897-8d-522ed732815d
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 0/3] perf tools: Fix scalability problem on callchain merging
Date: Tue, 10 Sep 2013 17:24:15 +0900
Message-Id: <1378801458-2515-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Linus reported that perf report was stuck in after "processing time
ordered events".  It turned out that merging/collapsing the callchain
takes most of time to look up a matching callchain.  Since it did a
linear search for the lookup, it took more than 95% of time during the
processing huge file that contains callchains.

This patchset tries to fix the problem by

 1. converting children list to a rbtree
 2. add UI progress window to inform user

With this patch, processing time of 400MB perf.data file went down
from 380s to 20s.

Thanks,
Namhyung


Namhyung Kim (3):
  perf callchain: Convert children list to rbtree
  perf ui/progress: Add new helper functions for progress bar
  perf tools: Show progress on histogram collapsing

 tools/perf/builtin-annotate.c |   2 +-
 tools/perf/builtin-diff.c     |   2 +-
 tools/perf/builtin-report.c   |  10 ++-
 tools/perf/builtin-top.c      |   4 +-
 tools/perf/tests/hists_link.c |   2 +-
 tools/perf/ui/progress.c      |  18 +++++
 tools/perf/ui/progress.h      |  10 +++
 tools/perf/util/callchain.c   | 151 ++++++++++++++++++++++++++++++++----------
 tools/perf/util/callchain.h   |   5 +-
 tools/perf/util/hist.c        |   5 +-
 tools/perf/util/hist.h        |   3 +-
 tools/perf/util/session.c     |  22 +++---
 12 files changed, 173 insertions(+), 61 deletions(-)

-- 
1.7.11.7

