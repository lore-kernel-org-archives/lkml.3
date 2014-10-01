Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753040AbaJAQBV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 12:01:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29716 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752973AbaJAQBT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 12:01:19 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Adrian Hunter <adrian.hunter@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Milian Wolff <mail@milianw.de>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 4/5] perf kvm stat live: Use perf_evlist__add_pollfd return fd position
Date: Wed,  1 Oct 2014 18:00:28 +0200
Message-Id: <1412179229-19466-4-git-send-email-jolsa@kernel.org>
In-Reply-To: <1412179229-19466-1-git-send-email-jolsa@kernel.org>
References: <1412179229-19466-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the interface changed in following commit:
  2171a9256862 tools lib fd array: Allow associating an integer cookie with each entry
the perf_evlist__add_pollfd function now returns the
fd position in the pollfd array.

Hence we no longer need to count the fd position, because
we get it as the return value.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Milian Wolff <mail@milianw.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/builtin-kvm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 663d6eda0822..dc7d704735bd 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -933,10 +933,10 @@ static int kvm_events_live_report(struct perf_kvm_stat *kvm)
 
 	nr_fds++;
 
-	if (perf_evlist__add_pollfd(kvm->evlist, fileno(stdin)) < 0)
+	nr_stdin = perf_evlist__add_pollfd(kvm->evlist, fileno(stdin));
+	if (nr_stdin < 0)
 		goto out;
 
-	nr_stdin = nr_fds;
 	nr_fds++;
 	if (fd_set_nonblock(fileno(stdin)) != 0)
 		goto out;
-- 
1.9.3

