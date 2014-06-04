Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752065AbaFDOhT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 10:37:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14387 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750933AbaFDOhQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 10:37:16 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Olsa <jolsa@kernel.org>
Subject: [PATCHv4 00/13] perf tools: Speedup DWARF unwind
Date: Wed,  4 Jun 2014 16:36:49 +0200
Message-Id: <1401892622-30848-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
trying to speedup DWARF unwind report code by factoring
related code:
  - caching sample's registers access
  - keep dso data file descriptor open for the
    life of the dso object
  - replace dso cache code by mapping dso data file
    directly for the life of the dso object

The speedup is mainly for libunwind unwind. The libdw will benefit
mainly from cached registers access, because it handles dso data
accesses by itself.. and anyway it's still faster ;-).

On ~11GB perf data file with dwarf unwind data I've got
around 30% speed up.

I've also got possitive test feedback from Jean Pihet:
  https://wiki.linaro.org/LEG/Engineering/TOOLS/perf-callstack-unwinding#Speed_improvement

v4 changes:
  - fixed changelog for patch 6 (David Ahern)
  - added Reviewed-by from David Ahern for some patches
  - other minor fixies pointed by David Ahern

v3 changes:
  - moved the cache logic into dso__data_fd (Namhyung Kim)
  - omited test_dso_data__fd_limit variable,
    dso data cache test changed accordingly (Namhyung Kim)
  - several small fixies from review (Namhyung Kim)

v2 changes:
  - adding limit for open dso objects with sort of LRU
    mechanism to pick up and close dso objects if we
    are over the limit
  - file mmaping changes are omitted, because I couldn't prove
    the improvement exactly, will resubmit later
  - added dso close logic in case of no memory
  - added tests


Also reachable in here:
  git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
  perf/core_unwind_speedup

thanks,
jirka

Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
Jiri Olsa (13):
      perf tools: Cache register accesses for unwind processing
      perf tools: Separate dso data related variables
      perf tools: Add data_fd into dso object
      perf tools: Add global list of opened dso objects
      perf tools: Add global count of opened dso objects
      perf tools: Cache dso data file descriptor
      perf tools: Add file size check and factor dso__data_read_offset
      perf tools: Allow to close dso fd in case of open failure
      perf tools: Add dso__data_* interface descriptons
      perf tests: Spawn child for each test
      perf tests: Allow reuse of test_file function
      perf tests: Add test for caching dso file descriptors
      perf tests: Add test for closing dso objects on EMFILE error

 tools/perf/tests/builtin-test.c    |  42 ++++++++++++++-
 tools/perf/tests/dso-data.c        | 214 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 tools/perf/tests/tests.h           |   2 +
 tools/perf/util/dso.c              | 279 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---------
 tools/perf/util/dso.h              |  50 +++++++++++++++++-
 tools/perf/util/event.h            |   5 ++
 tools/perf/util/perf_regs.c        |  10 +++-
 tools/perf/util/perf_regs.h        |   4 +-
 tools/perf/util/unwind-libunwind.c |   2 -
 9 files changed, 572 insertions(+), 36 deletions(-)
