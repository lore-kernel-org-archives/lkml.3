Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786Ab3HACzr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 22:55:47 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:59615 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083Ab3HACzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 22:55:45 -0400
X-AuditID: 9c930197-b7bfbae000000e88-bd-51f9ce3047d0
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 0/9] perf tools: Enhance and correct srcline behavior
Date: Thu,  1 Aug 2013 11:55:35 +0900
Message-Id: <1375325744-26613-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patchset tries to fix and enhance current srcline behavior.

Firstly it doesn't actually sort by srcline info but by ip.  I suspect
it was because of a performance reason to run external addr2line
utility.  It showed the srcline info after hist entries were
collapsed.  Thanks to Roberto, we now have internal implementation of
addr2line using libbfd so can sort/compare by srcline of entries.

Second problem for me was it sometimes printed "??:0" and sometimes
printed a raw ip value for unknown srcline info.  I changed to print
the former consistently.

While at it, I found some bugs/leaks in srcline handling.  Patch 1-3
are fixes for those and can be merged separately.

You can get this series on my 'perf/srcline-v1' branch in my tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git

Any comments are welcome, thanks.
Namhyung


Namhyung Kim (8):
  perf sort: Fix a memory leak on srcline
  perf annotate: Reuse path from the result of addr2line
  perf hists: Free srcline when freeing hist_entry
  perf tools: Factor out get/free_srcline()
  perf tools: Do not try to call addr2line for non-binary files
  perf tools: Pass dso instead of dso_name to get_srcline()
  perf tools: Save failed result of get_srcline()
  perf tools: Fix srcline sort key behavior

Roberto Vitillo (1):
  perf tools: Implement addr2line directly using libbfd

 tools/perf/Makefile        |   1 +
 tools/perf/config/Makefile |   4 +
 tools/perf/util/annotate.c |  33 +-----
 tools/perf/util/dso.c      |   1 +
 tools/perf/util/dso.h      |   2 +
 tools/perf/util/hist.c     |   1 +
 tools/perf/util/sort.c     |  58 ++++------
 tools/perf/util/srcline.c  | 265 +++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/util.h     |   8 ++
 9 files changed, 308 insertions(+), 65 deletions(-)
 create mode 100644 tools/perf/util/srcline.c

-- 
1.7.11.7

