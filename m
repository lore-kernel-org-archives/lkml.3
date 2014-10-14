Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755909AbaJNVGZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 17:06:25 -0400
Received: from mail.kernel.org ([198.145.19.201]:44915 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932633AbaJNVGQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 17:06:16 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>, Borislav Petkov <bp@suse.de>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jean Pihet <jean.pihet@linaro.org>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 17/24] perf evlist: Default to syswide target when no thread/cpu maps set
Date: Tue, 14 Oct 2014 18:04:26 -0300
Message-Id: <1413320673-5784-18-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1413320673-5784-1-git-send-email-acme@kernel.org>
References: <1413320673-5784-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

If all a tool wants is to do system wide event monitoring, there is no
more the need to setup thread_map and cpu_map objects, just call
perf_evlist__open() and it will do create one fd per CPU monitoring all
threads.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: David Ahern <dsahern@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-poovolkigu72brx4783uq4cf@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evlist.c | 40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 5fc7bd42c803..b4b54d84e9b0 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -1175,11 +1175,51 @@ void perf_evlist__close(struct perf_evlist *evlist)
 	}
 }
 
+static int perf_evlist__create_syswide_maps(struct perf_evlist *evlist)
+{
+	int err = -ENOMEM;
+
+	/*
+	 * Try reading /sys/devices/system/cpu/online to get
+	 * an all cpus map.
+	 *
+	 * FIXME: -ENOMEM is the best we can do here, the cpu_map
+	 * code needs an overhaul to properly forward the
+	 * error, and we may not want to do that fallback to a
+	 * default cpu identity map :-\
+	 */
+	evlist->cpus = cpu_map__new(NULL);
+	if (evlist->cpus == NULL)
+		goto out;
+
+	evlist->threads = thread_map__new_dummy();
+	if (evlist->threads == NULL)
+		goto out_free_cpus;
+
+	err = 0;
+out:
+	return err;
+out_free_cpus:
+	cpu_map__delete(evlist->cpus);
+	evlist->cpus = NULL;
+	goto out;
+}
+
 int perf_evlist__open(struct perf_evlist *evlist)
 {
 	struct perf_evsel *evsel;
 	int err;
 
+	/*
+	 * Default: one fd per CPU, all threads, aka systemwide
+	 * as sys_perf_event_open(cpu = -1, thread = -1) is EINVAL
+	 */
+	if (evlist->threads == NULL && evlist->cpus == NULL) {
+		err = perf_evlist__create_syswide_maps(evlist);
+		if (err < 0)
+			goto out_err;
+	}
+
 	perf_evlist__update_id_pos(evlist);
 
 	evlist__for_each(evlist, evsel) {
-- 
1.9.3

