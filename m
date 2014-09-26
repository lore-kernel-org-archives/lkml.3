Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374AbaIZJV1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 05:21:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57097 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754298AbaIZJVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:21:23 -0400
Date: Fri, 26 Sep 2014 02:20:08 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-24omlq5asrfg4uo3muuzn2bl@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de, dzickus@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, adrian.hunter@intel.com,
        tglx@linutronix.de, dzickus@redhat.com
In-Reply-To: <20140908151016.GH17728@krava.brq.redhat.com>
References: <20140908151016.GH17728@krava.brq.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evlist:
  We need to poll all event file descriptors
Git-Commit-ID: 033fa713db66b96d5779e6a93d50ff821bc1abd2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  033fa713db66b96d5779e6a93d50ff821bc1abd2
Gitweb:     http://git.kernel.org/tip/033fa713db66b96d5779e6a93d50ff821bc1abd2
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 8 Sep 2014 12:55:12 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 25 Sep 2014 16:46:54 -0300

perf evlist: We need to poll all event file descriptors

Because we want to notice when they get POLLHUP'ed, so that we can
figure out when all threads exited in a workload being monitored.

We can't just monitor the fds that were mmaped, we need to notice when
all the fds that were PERF_EVENT_IOC_SET_OUTPUT'ed too, because the mmap
stays even after the fd that originally was used to do the mmap call
went away, its only when all the set-output fds for a mmap are gone that
the mmap is.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/20140908151016.GH17728@krava.brq.redhat.com
Link: http://lkml.kernel.org/n/tip-24omlq5asrfg4uo3muuzn2bl@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evlist.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 502cd11..6b13bfa 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -717,8 +717,6 @@ static int __perf_evlist__mmap(struct perf_evlist *evlist, int idx,
 		evlist->mmap[idx].base = NULL;
 		return -1;
 	}
-
-	perf_evlist__add_pollfd(evlist, fd);
 	return 0;
 }
 
@@ -745,6 +743,8 @@ static int perf_evlist__mmap_per_evsel(struct perf_evlist *evlist, int idx,
 				return -1;
 		}
 
+		perf_evlist__add_pollfd(evlist, fd);
+
 		if ((evsel->attr.read_format & PERF_FORMAT_ID) &&
 		    perf_evlist__id_add_fd(evlist, evsel, cpu, thread, fd) < 0)
 			return -1;
