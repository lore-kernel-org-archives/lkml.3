Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752486AbaJOKE5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 06:04:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54350 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456AbaJOKEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 06:04:55 -0400
Date: Wed, 15 Oct 2014 03:03:49 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-7t8cay0ieryox4gqosie85ek@git.kernel.org>
Cc: dsahern@gmail.com, paulus@samba.org, tglx@linutronix.de,
        adrian.hunter@intel.com, mingo@kernel.org, namhyung@kernel.org,
        peterz@infradead.org, acme@redhat.com, fweisbec@gmail.com, bp@suse.de,
        jean.pihet@linaro.org, hpa@zytor.com, jolsa@redhat.com,
        linux-kernel@vger.kernel.org, eranian@google.com, dzickus@redhat.com,
        efault@gmx.de
Reply-To: efault@gmx.de, dzickus@redhat.com, eranian@google.com,
        linux-kernel@vger.kernel.org, hpa@zytor.com, jolsa@redhat.com,
        jean.pihet@linaro.org, bp@suse.de, acme@redhat.com, fweisbec@gmail.com,
        peterz@infradead.org, namhyung@kernel.org, adrian.hunter@intel.com,
        mingo@kernel.org, tglx@linutronix.de, paulus@samba.org,
        dsahern@gmail.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf evsel: Subclassing
Git-Commit-ID: ce8ccff5dd6b87dfe3495c7e9c5d56169bbacf58
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

Commit-ID:  ce8ccff5dd6b87dfe3495c7e9c5d56169bbacf58
Gitweb:     http://git.kernel.org/tip/ce8ccff5dd6b87dfe3495c7e9c5d56169bbacf58
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 9 Oct 2014 15:29:51 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 14 Oct 2014 17:32:03 -0300

perf evsel: Subclassing

Provide a method to be called at tool start to config the perf_evsel
instance size, together with optional constructor and destructor.

This will be used so that perf_evsel doesn't always include a struct
hists, tools that works with hists/hist_entries, like report, top and
annotate, will, at start, tell the evsel class the size they need per
instance.

v2: Don't use exit as a name of a member of function parameter, as this
    breaks the build on at least fedora14 and rhel6.

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
Link: http://lkml.kernel.org/n/tip-7t8cay0ieryox4gqosie85ek@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evsel.c | 48 ++++++++++++++++++++++++++++++++++++++++++++++--
 tools/perf/util/evsel.h |  4 ++++
 2 files changed, 50 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index e0868a9..0580b13 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -32,6 +32,48 @@ static struct {
 	bool cloexec;
 } perf_missing_features;
 
+static int perf_evsel__no_extra_init(struct perf_evsel *evsel __maybe_unused)
+{
+	return 0;
+}
+
+static void perf_evsel__no_extra_fini(struct perf_evsel *evsel __maybe_unused)
+{
+}
+
+static struct {
+	size_t	size;
+	int	(*init)(struct perf_evsel *evsel);
+	void	(*fini)(struct perf_evsel *evsel);
+} perf_evsel__object = {
+	.size = sizeof(struct perf_evsel),
+	.init = perf_evsel__no_extra_init,
+	.fini = perf_evsel__no_extra_fini,
+};
+
+int perf_evsel__object_config(size_t object_size,
+			      int (*init)(struct perf_evsel *evsel),
+			      void (*fini)(struct perf_evsel *evsel))
+{
+
+	if (object_size == 0)
+		goto set_methods;
+
+	if (perf_evsel__object.size > object_size)
+		return -EINVAL;
+
+	perf_evsel__object.size = object_size;
+
+set_methods:
+	if (init != NULL)
+		perf_evsel__object.init = init;
+
+	if (fini != NULL)
+		perf_evsel__object.fini = fini;
+
+	return 0;
+}
+
 #define FD(e, x, y) (*(int *)xyarray__entry(e->fd, x, y))
 
 int __perf_evsel__sample_size(u64 sample_type)
@@ -169,13 +211,14 @@ void perf_evsel__init(struct perf_evsel *evsel,
 	evsel->scale	   = 1.0;
 	INIT_LIST_HEAD(&evsel->node);
 	hists__init(&evsel->hists);
+	perf_evsel__object.init(evsel);
 	evsel->sample_size = __perf_evsel__sample_size(attr->sample_type);
 	perf_evsel__calc_id_pos(evsel);
 }
 
 struct perf_evsel *perf_evsel__new_idx(struct perf_event_attr *attr, int idx)
 {
-	struct perf_evsel *evsel = zalloc(sizeof(*evsel));
+	struct perf_evsel *evsel = zalloc(perf_evsel__object.size);
 
 	if (evsel != NULL)
 		perf_evsel__init(evsel, attr, idx);
@@ -185,7 +228,7 @@ struct perf_evsel *perf_evsel__new_idx(struct perf_event_attr *attr, int idx)
 
 struct perf_evsel *perf_evsel__newtp_idx(const char *sys, const char *name, int idx)
 {
-	struct perf_evsel *evsel = zalloc(sizeof(*evsel));
+	struct perf_evsel *evsel = zalloc(perf_evsel__object.size);
 
 	if (evsel != NULL) {
 		struct perf_event_attr attr = {
@@ -817,6 +860,7 @@ void perf_evsel__exit(struct perf_evsel *evsel)
 	assert(list_empty(&evsel->node));
 	perf_evsel__free_fd(evsel);
 	perf_evsel__free_id(evsel);
+	perf_evsel__object.fini(evsel);
 }
 
 void perf_evsel__delete(struct perf_evsel *evsel)
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index ff72ce0..d632510 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -112,6 +112,10 @@ struct thread_map;
 struct perf_evlist;
 struct record_opts;
 
+int perf_evsel__object_config(size_t object_size,
+			      int (*init)(struct perf_evsel *evsel),
+			      void (*fini)(struct perf_evsel *evsel));
+
 struct perf_evsel *perf_evsel__new_idx(struct perf_event_attr *attr, int idx);
 
 static inline struct perf_evsel *perf_evsel__new(struct perf_event_attr *attr)
