Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228AbaHNCWe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 22:22:34 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:51955 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908AbaHNCWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 22:22:32 -0400
X-AuditID: 85900ec0-d3b2cb9000001514-b1-53ec1d65202c
Subject: [PATCH 00/13] perf: Replace strerror with strerror_r for
 thread-safety
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Naohiro Aota <naota@elisp.net>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung@kernel.org>
Date: Thu, 14 Aug 2014 02:22:28 +0000
Message-ID: <20140814022228.3545.90481.stgit@kbuild-fedora.novalocal>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

(sorry, ignore the previous series, this is complete one)

Here is a series to get rid of thread-unsafe strerror() from
perf tools. Of course, there maybe other thread-unsafe functions,
so this goes just one step forward. :)

This introduces STRERR_BUFSIZE(=128) macro for allocating local
buffer, but some strerror_r()s don't use that. If there are
already a local buffer on the stack, and if it is bigger than
STRERR_BUFSIZE, I chose it for strerror_r()'s buffer.

By the way, while doing this cleanup, I've found some confusions
on the code. Currently perf has 3 ways to output messages except
for standard (f)printf, pr_XXX, ui__XXX and warning/error functions.
Is there any differences among those APIs? What is the expected
use cases for them?
For example, a pure printf is in kvm_live_open_events@builtin-kvm.c
but it seems to be ui__error, because the error output next to it
uses that. However, other parts use pr_XXX too. It seems inconsistent.

Thank you,

---

Masami Hiramatsu (13):
      perf probe: Don't use strerror if strlist__add failed
      perf: Use strerror_r instead of strerror
      perf probe: Make error messages thread-safe
      perf/util: Replace strerror with strerror_r for thread-safety
      perf top: Use strerror_r instead of strerror
      perf trace: Use strerror_r instead of strerror
      perf record: Use strerror_r instead of strerror
      perf test: Use strerror_r instead of strerror
      perf sched: Use strerror_r instead of strerror
      perf buildid-cache: Use strerror_r instead of strerror
      perf kvm: Use strerror_r instead of strerror
      perf help: Use strerror_r instead of strerror
      perf stat: Use strerror_r instead of strerror


 tools/perf/builtin-buildid-cache.c        |    7 +++---
 tools/perf/builtin-help.c                 |   20 ++++++++++++++---
 tools/perf/builtin-kvm.c                  |    7 ++++--
 tools/perf/builtin-probe.c                |    5 +++-
 tools/perf/builtin-record.c               |    7 +++---
 tools/perf/builtin-sched.c                |    4 +++
 tools/perf/builtin-stat.c                 |    2 +-
 tools/perf/builtin-top.c                  |    2 +-
 tools/perf/builtin-trace.c                |    6 +++--
 tools/perf/perf.c                         |   10 ++++++---
 tools/perf/tests/builtin-test.c           |    4 +++
 tools/perf/tests/mmap-basic.c             |    7 +++---
 tools/perf/tests/open-syscall-all-cpus.c  |    5 +++-
 tools/perf/tests/open-syscall-tp-fields.c |    7 ++++--
 tools/perf/tests/open-syscall.c           |    3 ++-
 tools/perf/tests/perf-record.c            |   13 ++++++++---
 tools/perf/tests/rdpmc.c                  |    6 +++--
 tools/perf/tests/sw-clock.c               |    6 +++--
 tools/perf/tests/task-exit.c              |    6 +++--
 tools/perf/util/cloexec.c                 |    6 +++--
 tools/perf/util/data.c                    |    8 +++++--
 tools/perf/util/debug.h                   |    3 +++
 tools/perf/util/dso.c                     |    8 +++++--
 tools/perf/util/evlist.c                  |    2 +-
 tools/perf/util/evsel.c                   |    7 ++++--
 tools/perf/util/parse-events.c            |    5 +++-
 tools/perf/util/probe-event.c             |   34 ++++++++++++++++-------------
 tools/perf/util/probe-finder.c            |    7 ++++--
 tools/perf/util/run-command.c             |    9 ++++++--
 tools/perf/util/util.c                    |    5 +++-
 30 files changed, 150 insertions(+), 71 deletions(-)

--
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com

