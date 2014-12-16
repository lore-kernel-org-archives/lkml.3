Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195AbaLPQ65 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 11:58:57 -0500
Received: from mail.kernel.org ([198.145.19.201]:47110 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751576AbaLPQ6y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 11:58:54 -0500
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>, Borislav Petkov <bp@suse.de>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 15/18] perf tools: Make the mmap length autotuning more robust
Date: Tue, 16 Dec 2014 13:57:17 -0300
Message-Id: <1418749040-31807-16-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1418749040-31807-1-git-send-email-acme@kernel.org>
References: <1418749040-31807-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

If /proc/sys/kernel/perf_event_mlock_kb is not (power of 2 + PAGE_SIZE_in_kb)
and we let the perf tools do mmap length autosizing based on that, then, for
non-CAP_IPC_LOCK users when /proc/sys/kernel/perf_event_paranoid is > -1, then
we get an -EINVAL that ends up in:

  [acme@ssdandy linux]$ trace usleep 1
  Invalid argument
  [acme@ssdandy linux]$ perf record usleep 1
  failed to mmap with 22 (Invalid argument)

After this fix:

  [acme@ssdandy linux]$ trace usleep 1
  <SNIP>
   0.806 ( 0.006 ms): munmap(addr: 0x7f7e4740a000, len: 66467) = 0
   0.869 ( 0.002 ms): brk(                                   ) = 0x7bb000
   0.873 ( 0.003 ms): brk(brk: 0x7dc000                      ) = 0x7dc000
   0.877 ( 0.001 ms): brk(                                   ) = 0x7dc000
   0.953 ( 0.058 ms): nanosleep(rqtp: 0x7fff26ab9420         ) = 0
   0.959 ( 0.000 ms): exit_group(
  [acme@ssdandy linux]$ perf record usleep 1
  [ perf record: Woken up 1 times to write data ]
  [ perf record: Captured and wrote 0.017 MB perf.data (~759 samples) ]
  [acme@ssdandy linux]$

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: David Ahern <dsahern@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-6p6l5ou6jev6o7ymc4nn1n2a@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evlist.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 8eb92cf5d552..7d88327d94a9 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -909,6 +909,8 @@ static size_t perf_evlist__mmap_size(unsigned long pages)
 		}
 
 		pages = (max * 1024) / page_size;
+		if (!is_power_of_2(pages))
+			pages = rounddown_pow_of_two(pages);
 	} else if (!is_power_of_2(pages))
 		return 0;
 
-- 
1.9.3

