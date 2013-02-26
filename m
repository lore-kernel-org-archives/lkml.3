Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760215Ab3BZJnu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 04:43:50 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:59657 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760058Ab3BZJns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 04:43:48 -0500
From: chenggang <chenggang.qin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: chenggang.qcg@taobao.com, David Ahern <dsahern@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Yanmin Zhang <yanmin.zhang@intel.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Mike Galbraith <efault@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v2 0/4] perf: Make the 'perf top -p $pid' can perceive the new forked threads.
Date: Tue, 26 Feb 2013 17:41:50 +0800
Message-Id: <1361871710-6251-5-git-send-email-chenggang.qin@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1361871710-6251-1-git-send-email-chenggang.qin@gmail.com>
References: <1361871710-6251-1-git-send-email-chenggang.qin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: chenggang.qcg@taobao.com

This patch set add a function that make the 'perf top -p $pid' is able to perceive
the new threads that is forked by target processes. 'perf top{record} -p $pid' can
perceive the threads are forked before we execute perf, but it cannot perceive the
new threads are forked after we started perf. This is perf's important defect, because
the applications who will fork new threads on-the-fly are very much.
For performance reasons, the event inherit mechanism is forbidden while we use per-task
counters. Some internal data structures, such as, thread_map, evlist->mmap, evsel->fd,
evsel->id, evsel->sample_id are implemented as arrays at the initialization phase.
Their size is fixed, and they cannot be extended or shrinked easily while we want to
adjust them for new forked threads and exit threads.

So, we have done the following work:
1) Transformed xyarray to linked list.
   Implementd the interfaces to extand and shrink a exist xyarray.
   The xyarray is a 2-dimensional structure. The row is still a array (because the
   number of CPU is fixed forever), the columns are linked list. 
2) Transformed evlist->mmap, evsel->fd, evsel->id and evsel->sample_id to list with the
   new xyarray.
   Implemented interfaces to expand and shrink these structures.
   The nodes in these structures can be referenced by some predefined macros, such as
   FD(cpu, thread), MMAP(cpu, thread), ID(cpu, thread), etc.
3) Transformed thread_map to linked list.
   Implemented the interfaces to extand and shrink a exist thread_map.
4) Added 2 callback functions to top->perf_tool, they are called while the PERF_RECORD_FORK
   & PERF_RECORD_EXIT events are got.
   While a PERF_RECORD_FORK event is got, all related data structures are expanded, a new
   fd and mmap are opened.
   While a PERF_RECORD_EXIT event is got, all nodes in the related data structures are
   removed, the fd and mmap are closed.

The linked list is flexible, list_add & list_del can be used easily. Additional, performance
penalty (especially the CPU utilization) is low.

This function has been already implemented for 'perf top -p $pid' in the patch
[4/4] of this patch set. Next step, the 'perf record -p $pid' should be modified
with the same method.

Thanks for David Ahern's suggestion.

Cc: David Ahern <dsahern@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Yanmin Zhang <yanmin.zhang@intel.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Signed-off-by: Chenggang Qin <chenggang.qcg@taobao.com>

chenggang (4):
  Transform xyarray to linked list.
  Transform thread_map to linked list.
  Transform mmap and other related structures to list with new xyarray.
  Add fork and exit callback functions into top->perf_tool.

 tools/perf/builtin-record.c               |    6 +-
 tools/perf/builtin-stat.c                 |    2 +-
 tools/perf/builtin-top.c                  |  100 ++++++++++++-
 tools/perf/tests/open-syscall-tp-fields.c |    2 +-
 tools/perf/util/event.c                   |   10 +-
 tools/perf/util/evlist.c                  |  171 +++++++++++++++++++---
 tools/perf/util/evlist.h                  |    6 +-
 tools/perf/util/evsel.c                   |   98 +++++++++++--
 tools/perf/util/evsel.h                   |    8 +-
 tools/perf/util/header.c                  |   31 ++--
 tools/perf/util/header.h                  |    3 +-
 tools/perf/util/python.c                  |    2 +-
 tools/perf/util/thread_map.c              |  223 +++++++++++++++++++----------
 tools/perf/util/thread_map.h              |   16 ++-
 tools/perf/util/xyarray.c                 |   85 ++++++++++-
 tools/perf/util/xyarray.h                 |   25 +++-
 16 files changed, 641 insertions(+), 147 deletions(-)

-- 
1.7.9.5

