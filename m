Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932597Ab3KLWBa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 17:01:30 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40168 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932335Ab3KLV41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 16:56:27 -0500
Date: Tue, 12 Nov 2013 13:55:47 -0800
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-6qy8ljkn0e9hm7bh7keo5z68@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, jolsa@redhat.com, fweisbec@gmail.com,
        adrian.hunter@intel.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, adrian.hunter@intel.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tests:
  Check return of perf_evlist__open sw clock event period test
Git-Commit-ID: d0b849e9bced36cf279881294c07c43b0b9dce86
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 12 Nov 2013 13:55:52 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d0b849e9bced36cf279881294c07c43b0b9dce86
Gitweb:     http://git.kernel.org/tip/d0b849e9bced36cf279881294c07c43b0b9dce86
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 11 Nov 2013 16:28:42 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 11 Nov 2013 16:28:42 -0300

perf tests: Check return of perf_evlist__open sw clock event period test

We were not checking if we successfully opened the counters, i.e. if
sys_perf_event_open worked, when it doesn't in this test, we were
continuing anyway and then segfaulting when trying to access the file
descriptor array, that at that point had been freed in perf_evlist__open
error path:

[root@ssdandy ~]# perf test -v 19
19: Test software clock events have valid period values    :
--- start ---
Segmentation fault (core dumped)
[root@ssdandy ~]#

Do the check and bail out instead.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-6qy8ljkn0e9hm7bh7keo5z68@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/tests/sw-clock.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/tools/perf/tests/sw-clock.c b/tools/perf/tests/sw-clock.c
index 73c5c37..ed77772 100644
--- a/tools/perf/tests/sw-clock.c
+++ b/tools/perf/tests/sw-clock.c
@@ -57,7 +57,11 @@ static int __test__sw_clock_freq(enum perf_sw_ids clock_id)
 		goto out_delete_maps;
 	}
 
-	perf_evlist__open(evlist);
+	if (perf_evlist__open(evlist)) {
+		err = -errno;
+		pr_debug("Couldn't open evlist: %s\n", strerror(errno));
+		goto out_delete_maps;
+	}
 
 	err = perf_evlist__mmap(evlist, 128, true);
 	if (err < 0) {
