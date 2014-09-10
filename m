Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752400AbaIJOKu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 10:10:50 -0400
Received: from mail.kernel.org ([198.145.19.201]:38723 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752366AbaIJOKq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 10:10:46 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>, Borislav Petkov <bp@suse.de>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 13/14] tools lib fd array: Allow associating an integer cookie with each entry
Date: Wed, 10 Sep 2014 11:08:48 -0300
Message-Id: <1410358129-9965-14-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1410358129-9965-1-git-send-email-acme@kernel.org>
References: <1410358129-9965-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

We will use this in perf's evlist class so that it can, at
fdarray__filter() time, to unmap the associated ring buffer.

We may need to have further info associated with each fdarray entry, in
that case we'll make that int array a 'union fdarray_priv' one and put a
pointer there so that users can stash whatever they want there. For now,
an int is enough tho.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-ugusyqex32mc86hqh7cjdy3i@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/api/fd/array.c | 28 ++++++++++++++++++++++++----
 tools/lib/api/fd/array.h |  4 +++-
 tools/perf/util/evlist.c |  2 +-
 3 files changed, 28 insertions(+), 6 deletions(-)

diff --git a/tools/lib/api/fd/array.c b/tools/lib/api/fd/array.c
index bd923d41b450..3f6d1a03d195 100644
--- a/tools/lib/api/fd/array.c
+++ b/tools/lib/api/fd/array.c
@@ -13,21 +13,31 @@
 void fdarray__init(struct fdarray *fda, int nr_autogrow)
 {
 	fda->entries	 = NULL;
+	fda->priv	 = NULL;
 	fda->nr		 = fda->nr_alloc = 0;
 	fda->nr_autogrow = nr_autogrow;
 }
 
 int fdarray__grow(struct fdarray *fda, int nr)
 {
+	void *priv;
 	int nr_alloc = fda->nr_alloc + nr;
+	size_t psize = sizeof(fda->priv[0]) * nr_alloc;
 	size_t size  = sizeof(struct pollfd) * nr_alloc;
 	struct pollfd *entries = realloc(fda->entries, size);
 
 	if (entries == NULL)
 		return -ENOMEM;
 
+	priv = realloc(fda->priv, psize);
+	if (priv == NULL) {
+		free(entries);
+		return -ENOMEM;
+	}
+
 	fda->nr_alloc = nr_alloc;
 	fda->entries  = entries;
+	fda->priv     = priv;
 	return 0;
 }
 
@@ -50,6 +60,7 @@ struct fdarray *fdarray__new(int nr_alloc, int nr_autogrow)
 void fdarray__exit(struct fdarray *fda)
 {
 	free(fda->entries);
+	free(fda->priv);
 	fdarray__init(fda, 0);
 }
 
@@ -61,6 +72,8 @@ void fdarray__delete(struct fdarray *fda)
 
 int fdarray__add(struct fdarray *fda, int fd, short revents)
 {
+	int pos = fda->nr;
+
 	if (fda->nr == fda->nr_alloc &&
 	    fdarray__grow(fda, fda->nr_autogrow) < 0)
 		return -ENOMEM;
@@ -69,10 +82,11 @@ int fdarray__add(struct fdarray *fda, int fd, short revents)
 	fda->entries[fda->nr].fd     = fd;
 	fda->entries[fda->nr].events = revents;
 	fda->nr++;
-	return 0;
+	return pos;
 }
 
-int fdarray__filter(struct fdarray *fda, short revents)
+int fdarray__filter(struct fdarray *fda, short revents,
+		    void (*entry_destructor)(struct fdarray *fda, int fd))
 {
 	int fd, nr = 0;
 
@@ -80,11 +94,17 @@ int fdarray__filter(struct fdarray *fda, short revents)
 		return 0;
 
 	for (fd = 0; fd < fda->nr; ++fd) {
-		if (fda->entries[fd].revents & revents)
+		if (fda->entries[fd].revents & revents) {
+			if (entry_destructor)
+				entry_destructor(fda, fd);
+
 			continue;
+		}
 
-		if (fd != nr)
+		if (fd != nr) {
 			fda->entries[nr] = fda->entries[fd];
+			fda->priv[nr]	 = fda->priv[fd];
+		}
 
 		++nr;
 	}
diff --git a/tools/lib/api/fd/array.h b/tools/lib/api/fd/array.h
index de38361ba69e..7b2870a96898 100644
--- a/tools/lib/api/fd/array.h
+++ b/tools/lib/api/fd/array.h
@@ -10,6 +10,7 @@ struct fdarray {
 	int	       nr_alloc;
 	int	       nr_autogrow;
 	struct pollfd *entries;
+	int	      *priv;
 };
 
 void fdarray__init(struct fdarray *fda, int nr_autogrow);
@@ -20,7 +21,8 @@ void fdarray__delete(struct fdarray *fda);
 
 int fdarray__add(struct fdarray *fda, int fd, short revents);
 int fdarray__poll(struct fdarray *fda, int timeout);
-int fdarray__filter(struct fdarray *fda, short revents);
+int fdarray__filter(struct fdarray *fda, short revents,
+		    void (*entry_destructor)(struct fdarray *fda, int fd));
 int fdarray__grow(struct fdarray *fda, int extra);
 int fdarray__fprintf(struct fdarray *fda, FILE *fp);
 
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 662057a44126..6d2499cfd789 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -431,7 +431,7 @@ int perf_evlist__add_pollfd(struct perf_evlist *evlist, int fd)
 
 int perf_evlist__filter_pollfd(struct perf_evlist *evlist, short revents_and_mask)
 {
-	return fdarray__filter(&evlist->pollfd, revents_and_mask);
+	return fdarray__filter(&evlist->pollfd, revents_and_mask, NULL);
 }
 
 int perf_evlist__poll(struct perf_evlist *evlist, int timeout)
-- 
1.9.3

