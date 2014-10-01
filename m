Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752959AbaJAQBN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 12:01:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5700 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751547AbaJAQBI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 12:01:08 -0400
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
Subject: [PATCH 3/5] perf kvm stat live: Fix perf_evlist__add_pollfd error handling
Date: Wed,  1 Oct 2014 18:00:27 +0200
Message-Id: <1412179229-19466-3-git-send-email-jolsa@kernel.org>
In-Reply-To: <1412179229-19466-1-git-send-email-jolsa@kernel.org>
References: <1412179229-19466-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the interface changed in following commit:
  2171a9256862 tools lib fd array: Allow associating an integer cookie with each entry
the perf_evlist__add_pollfd function now returns the fd
position in the pollfd array.

We need to change this function's error check condition.

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
index d8bf2271f4ea..663d6eda0822 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -928,12 +928,12 @@ static int kvm_events_live_report(struct perf_kvm_stat *kvm)
 		goto out;
 	}
 
-	if (perf_evlist__add_pollfd(kvm->evlist, kvm->timerfd))
+	if (perf_evlist__add_pollfd(kvm->evlist, kvm->timerfd) < 0)
 		goto out;
 
 	nr_fds++;
 
-	if (perf_evlist__add_pollfd(kvm->evlist, fileno(stdin)))
+	if (perf_evlist__add_pollfd(kvm->evlist, fileno(stdin)) < 0)
 		goto out;
 
 	nr_stdin = nr_fds;
-- 
1.9.3

