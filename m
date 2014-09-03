Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933056AbaICWAV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 18:00:21 -0400
Received: from mail.kernel.org ([198.145.19.201]:59401 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932084AbaICWAR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 18:00:17 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>, Borislav Petkov <bp@suse.de>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [RFC 00/10] perf pollfd series v2
Date: Wed,  3 Sep 2014 18:59:54 -0300
Message-Id: <1409781604-16778-1-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
mc: Paul Mackerras <paulus@samba.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

   	This is an alternative series to the one Jiri Olsa posted to use the
fixes he made to the kernel side to allow tooling to notice that a thread had
exited by looking at the pollfd.revents looking for POLLHUP notifications.

        Once all event file descriptors are removed from the evlist pollfd array,
tools can make a decision about exiting or telling the user about what happened,
asking to guidance on what to do next.

        The main difference in this approach is that a new class, which Jiri
called 'poller' and I called 'fdarray', grew up from what was in evlist->pollfd
and associated operations, while Jiri first introduced a new class and then
made tooling use it.

        The details of the implementation should be clear on the changelog
comments, please let me know if you see any problems, and if I can have your
acked-by/tested-by/whatever-else tags to get this moving forward.

        Ah, there is still one missing thing which is to make the hists browser
in live mode be notified that all monitored events are POLLHUP'ed, will get
to that in followup patches.

        The kernel bits were sent together with my latest pull req to Ingo,
this series is on top of that branch and is available at:

 git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git perf/fdarray

--------------------------------------------------------------------

v2: The kernel bits were already merged by Ingo, this is should address the
comments made for the first RFC, and has a hopefully improved/clearer
fdarray__filter() method, with changes made from thinking about comments made
by Adrian.

I made fdarray__init() receive the fdarray__add() autogrow hint, as suggested
by Namhyung.

It also makes fdarray__add() receive the revents mask instead of using what
makes sense to perf_evlist__add_pollfd(), also suggested by Namhyung.

I renamed the fd/poll.[ch] files to fd/array.[ch], from the discussion had
about naming with Jiri.

I added some Acked-by and Reviewed-by tags, please let me know if i should
stick some more, I really appreciate those tags!

Ah, in this branch there are some more patches, as it was made on top of my
perf/core branch, below are the stats for just the changesets related to this
RFC.

Thanks!

- Arnaldo

Arnaldo Carvalho de Melo (10):
  perf evlist: Introduce perf_evlist__filter_pollfd method
  perf tests: Add test for perf_evlist__filter_pollfd()
  perf evlist: Monitor POLLERR and POLLHUP events too
  perf record: Filter out POLLHUP'ed file descriptors
  perf trace: Filter out POLLHUP'ed file descriptors
  perf evlist: Allow growing pollfd on add method
  perf tests: Add pollfd growing test
  perf kvm stat live: Use perf_evlist__add_pollfd() instead of local
    equivalent
  perf evlist: Introduce poll method for common code idiom
  tools lib api: Adopt fdarray class from perf's evlist

 tools/lib/api/Makefile                    |   7 +-
 tools/lib/api/fd/array.c                  | 108 +++++++++++++++
 tools/lib/api/fd/array.h                  |  32 +++++
 tools/perf/Makefile.perf                  |   1 +
 tools/perf/builtin-kvm.c                  |  24 ++--
 tools/perf/builtin-record.c               |   5 +-
 tools/perf/builtin-top.c                  |   4 +-
 tools/perf/builtin-trace.c                |   3 +-
 tools/perf/tests/builtin-test.c           |   8 ++
 tools/perf/tests/evlist.c                 | 217 ++++++++++++++++++++++++++++++
 tools/perf/tests/open-syscall-tp-fields.c |   2 +-
 tools/perf/tests/perf-record.c            |   2 +-
 tools/perf/tests/task-exit.c              |   2 +-
 tools/perf/tests/tests.h                  |   2 +
 tools/perf/util/evlist.c                  |  37 +++--
 tools/perf/util/evlist.h                  |  10 +-
 tools/perf/util/python.c                  |   6 +-
 17 files changed, 431 insertions(+), 39 deletions(-)
 create mode 100644 tools/lib/api/fd/array.c
 create mode 100644 tools/lib/api/fd/array.h
 create mode 100644 tools/perf/tests/evlist.c

-- 
1.9.3
