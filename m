Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751380AbaLPQ5i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 11:57:38 -0500
Received: from mail.kernel.org ([198.145.19.201]:46693 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751214AbaLPQ5g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 11:57:36 -0500
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
Subject: [PATCH 01/18] perf evlist: Fixup brown paper bag on "hint" for --mmap-pages cmdline arg
Date: Tue, 16 Dec 2014 13:57:03 -0300
Message-Id: <1418749040-31807-2-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1418749040-31807-1-git-send-email-acme@kernel.org>
References: <1418749040-31807-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

When failing due to asking for a number of mmap pages that is more than
the max, it was suggesting that an even bigger number of mmap pages
should be specified, doh, au contraire!

Before:

  [acme@ssdandy linux]$ trace -m 128 usleep 1
  Error:	Operation not permitted.
  Hint:	Check /proc/sys/kernel/perf_event_mlock_kb (516 kB) setting.
  Hint:	Tried using 516 kB.
  Hint:	Try using a bigger -m/--mmap-pages value.
  [acme@ssdandy linux]$

After:

  [acme@ssdandy linux]$ trace -m 128 usleep 1
  Error:	Operation not permitted.
  Hint:	Check /proc/sys/kernel/perf_event_mlock_kb (516 kB) setting.
  Hint:	Tried using 516 kB.
  Hint:	Try using a smaller -m/--mmap-pages value.
  [acme@ssdandy linux]$

And to (really) clarify what happens above, when what the user requests
is <= max and even then it fails, a changeset is being made to tell that
this is a per user limit, not per process (in the above example there
was another 'perf trace' running for this user, which was using all the
pages it could use).

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
Link: http://lkml.kernel.org/n/tip-8qope8lxb898narnq5kmu2gf@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evlist.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index bb5dfc5d1e75..de7515dd683a 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -1495,7 +1495,7 @@ int perf_evlist__strerror_mmap(struct perf_evlist *evlist, int err, char *buf, s
 		scnprintf(buf, size, "Error:\t%s.\n"
 				     "Hint:\tCheck /proc/sys/kernel/perf_event_mlock_kb (%d kB) setting.\n"
 				     "Hint:\tTried using %zd kB.\n"
-				     "Hint:\tTry using a bigger -m/--mmap-pages value.",
+				     "Hint:\tTry using a smaller -m/--mmap-pages value.",
 				     emsg, value, evlist->mmap_len / 1024);
 		break;
 	default:
-- 
1.9.3

