Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752617AbaJOKF4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 06:05:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54464 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037AbaJOKFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 06:05:54 -0400
Date: Wed, 15 Oct 2014 03:04:56 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-poovolkigu72brx4783uq4cf@git.kernel.org>
Cc: jolsa@redhat.com, tglx@linutronix.de, namhyung@kernel.org,
        linux-kernel@vger.kernel.org, eranian@google.com, fweisbec@gmail.com,
        dzickus@redhat.com, dsahern@gmail.com, jean.pihet@linaro.org,
        adrian.hunter@intel.com, acme@redhat.com, bp@suse.de,
        peterz@infradead.org, mingo@kernel.org, paulus@samba.org,
        efault@gmx.de, hpa@zytor.com
Reply-To: hpa@zytor.com, efault@gmx.de, paulus@samba.org, mingo@kernel.org,
        bp@suse.de, peterz@infradead.org, acme@redhat.com,
        adrian.hunter@intel.com, jean.pihet@linaro.org, dsahern@gmail.com,
        dzickus@redhat.com, fweisbec@gmail.com, eranian@google.com,
        linux-kernel@vger.kernel.org, namhyung@kernel.org, tglx@linutronix.de,
        jolsa@redhat.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf evlist:
  Default to syswide target when no thread/cpu maps set
Git-Commit-ID: 4112eb1899c0e711b2ab1491f51215359cf94d74
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

Commit-ID:  4112eb1899c0e711b2ab1491f51215359cf94d74
Gitweb:     http://git.kernel.org/tip/4112eb1899c0e711b2ab1491f51215359cf94d74
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 10 Oct 2014 15:55:15 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 14 Oct 2014 17:32:53 -0300

perf evlist: Default to syswide target when no thread/cpu maps set

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
index 5fc7bd4..b4b54d8 100644
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
