Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932410AbaJNVFw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 17:05:52 -0400
Received: from mail.kernel.org ([198.145.19.201]:44767 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755858AbaJNVFu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 17:05:50 -0400
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
Subject: [PATCH 12/24] perf evsel: Subclassing
Date: Tue, 14 Oct 2014 18:04:21 -0300
Message-Id: <1413320673-5784-13-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1413320673-5784-1-git-send-email-acme@kernel.org>
References: <1413320673-5784-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

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
index e0868a901c4a..0580b13df2e6 100644
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
index ff72ce058724..d6325106c8fd 100644
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
-- 
1.9.3

