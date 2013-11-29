Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705Ab3K2Lqi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 06:46:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8377 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751440Ab3K2Lp5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 06:45:57 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 6/6] perf tools: Use perf_evlist__strerror in kvm/record/top/trace commands
Date: Fri, 29 Nov 2013 12:45:10 +0100
Message-Id: <1385725510-20118-7-git-send-email-jolsa@redhat.com>
In-Reply-To: <1385725510-20118-1-git-send-email-jolsa@redhat.com>
References: <1385725510-20118-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using perf_evlist__strerror in kvm/record/top/trace commands
to handle perf_evlist__mmap failures.

Examples with kernel not supporting event ID ioctl:

  * record session before:

    $ perf.old record -e '{cycles,cache-misses}:S' ls
    failed to mmap with 25 (Inappropriate ioctl for device)
    ls: Terminated

  * record session now:

    $ perf record -e '{cycles,cache-misses}:S' ls
    Cannot read event group on this kernel.
    Please consider kernel update (v3.12+).
    ls: Terminated

Examples with session allocating ring buffer with the
size over the allowed threshold.

  * record session before:

    $ perf record -m 10M ls
    rounding mmap pages size to 16777216 bytes (4096 pages)
    Permission error mapping pages.
    Consider increasing /proc/sys/kernel/perf_event_mlock_kb,
    or try again with a smaller value of -m/--mmap_pages.
    (current size: 16781312B)
    ls: Terminated

  * record session now:

    $ perf record -m 10M ls
    rounding mmap pages size to 16777216 bytes (4096 pages)
    Permission error mapping pages.
    Consider increasing /proc/sys/kernel/perf_event_mlock_kb,
    or try again with a smaller value of -m/--mmap_pages.
    (current value: 4096)
    ls: Terminated

  * top session, before:

    $ perf top -m 100M --stdio
    rounding mmap pages size to 134217728 bytes (32768 pages)
    Error:
    Failed to mmap with 1 (Operation not permitted)

  * top session, now:

    $ perf top -m 100M --stdio
    rounding mmap pages size to 134217728 bytes (32768 pages)
    Error:
    Permission error mapping pages.
    Consider increasing /proc/sys/kernel/perf_event_mlock_kb,
    or try again with a smaller value of -m/--mmap_pages.
    (current size: 134221824B)

  * trace session, before:

    $ perf trace -m 100M ./ex
    rounding mmap pages size to 16777216 bytes (4096 pages)
    Permission error mapping pages.
    Consider increasing /proc/sys/kernel/perf_event_mlock_kb,
    or try again with a smaller value of -m/--mmap_pages.
    (current value: 4096)
    ls: Terminated

  * trace session, now:

    $ perf trace -m 100M ./ex
    rounding mmap pages size to 134217728 bytes (32768 pages)
    Permission error mapping pages.
    Consider increasing /proc/sys/kernel/perf_event_mlock_kb,
    or try again with a smaller value of -m/--mmap_pages.
    (current size: 134221824B)

  * kvm stat live session, before:

    $ perf kvm stat live -m 10000M
    rounding mmap pages size to 17179869184 bytes (4194304 pages)
    Error:
    Failed to mmap the events: Cannot allocate memory

  * kvm stat live session, now:

    $ perf kvm stat live -m 10000M
    rounding mmap pages size to 17179869184 bytes (4194304 pages)
    Error:
    Failed to mmap events with error 12 (Cannot allocate memory)

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>
---
 tools/perf/builtin-kvm.c    |  2 +-
 tools/perf/builtin-record.c | 13 ++-----------
 tools/perf/builtin-top.c    |  3 +--
 tools/perf/builtin-trace.c  |  2 +-
 4 files changed, 5 insertions(+), 15 deletions(-)

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index f8bf5f2..131781f 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -1210,7 +1210,7 @@ static int kvm_live_open_events(struct perf_kvm_stat *kvm)
 	}
 
 	if (perf_evlist__mmap(evlist, kvm->opts.mmap_pages, false) < 0) {
-		ui__error("Failed to mmap the events: %s\n", strerror(errno));
+		ui__error("%s", perf_evlist__strerror(evlist));
 		perf_evlist__close(evlist);
 		goto out;
 	}
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index d93e2ee..f697362 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -219,17 +219,8 @@ try_again:
 	}
 
 	if (perf_evlist__mmap(evlist, opts->mmap_pages, false) < 0) {
-		if (errno == EPERM) {
-			pr_err("Permission error mapping pages.\n"
-			       "Consider increasing "
-			       "/proc/sys/kernel/perf_event_mlock_kb,\n"
-			       "or try again with a smaller value of -m/--mmap_pages.\n"
-			       "(current value: %d)\n", opts->mmap_pages);
-			rc = -errno;
-		} else {
-			pr_err("failed to mmap with %d (%s)\n", errno, strerror(errno));
-			rc = -errno;
-		}
+		pr_err("%s", perf_evlist__strerror(evlist));
+		rc = -errno;
 		goto out;
 	}
 
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 03d37a7..3825495 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -879,8 +879,7 @@ try_again:
 	}
 
 	if (perf_evlist__mmap(evlist, opts->mmap_pages, false) < 0) {
-		ui__error("Failed to mmap with %d (%s)\n",
-			    errno, strerror(errno));
+		ui__error("%s", perf_evlist__strerror(evlist));
 		goto out_err;
 	}
 
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index f2886c7..2fed70b 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -1898,7 +1898,7 @@ static int trace__run(struct trace *trace, int argc, const char **argv)
 
 	err = perf_evlist__mmap(evlist, trace->opts.mmap_pages, false);
 	if (err < 0) {
-		fprintf(trace->output, "Couldn't mmap the events: %s\n", strerror(errno));
+		fprintf(trace->output, "%s", perf_evlist__strerror(evlist));
 		goto out_close_evlist;
 	}
 
-- 
1.8.3.1

