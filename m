Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608AbaIZJWQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 05:22:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57167 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753529AbaIZJWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:22:13 -0400
Date: Fri, 26 Sep 2014 02:21:48 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-0p00bn83quck3fio3kcs9vca@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
        hpa@zytor.com, mingo@kernel.org, jolsa@kernel.org,
        a.p.zijlstra@chello.nl, jean.pihet@linaro.org, namhyung@kernel.org,
        fweisbec@gmail.com, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de, bp@suse.de, cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, jolsa@kernel.org, a.p.zijlstra@chello.nl,
        jean.pihet@linaro.org, namhyung@kernel.org, fweisbec@gmail.com,
        dsahern@gmail.com, adrian.hunter@intel.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, bp@suse.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib fd array:
  Allow associating an integer cookie with each entry
Git-Commit-ID: 2171a9256862ec139a042832a9ae737b942ca882
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

Commit-ID:  2171a9256862ec139a042832a9ae737b942ca882
Gitweb:     http://git.kernel.org/tip/2171a9256862ec139a042832a9ae737b942ca882
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 8 Sep 2014 11:24:01 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 25 Sep 2014 16:46:55 -0300

tools lib fd array: Allow associating an integer cookie with each entry

We will use this in perf's evlist class so that it can, at
fdarray__filter() time, to unmap the associated ring buffer.

We may need to have further info associated with each fdarray entry, in
that case we'll make that int array a 'union fdarray_priv' one and put a
pointer there so that users can stash whatever they want there. For now,
an int is enough tho.

v2: Add clarification to the per array entry priv area, as well as make
    it a union, which makes usage a bit longer, but if/when we make it
    use more space by allowing per entry pointers existing users source
    code will not have to be changed, just rebuilt.

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
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

Link: http://lkml.kernel.org/n/tip-0p00bn83quck3fio3kcs9vca@git.kernel.org
---
 tools/lib/api/fd/array.c   | 28 ++++++++++++++++++++++++----
 tools/lib/api/fd/array.h   | 16 +++++++++++++++-
 tools/perf/tests/fdarray.c |  8 ++++----
 tools/perf/util/evlist.c   |  2 +-
 4 files changed, 44 insertions(+), 10 deletions(-)

diff --git a/tools/lib/api/fd/array.c b/tools/lib/api/fd/array.c
index 4889c7d..0e636c4 100644
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
@@ -68,10 +81,11 @@ int fdarray__add(struct fdarray *fda, int fd, short revents)
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
 
@@ -79,11 +93,17 @@ int fdarray__filter(struct fdarray *fda, short revents)
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
index de38361..45db018 100644
--- a/tools/lib/api/fd/array.h
+++ b/tools/lib/api/fd/array.h
@@ -5,11 +5,24 @@
 
 struct pollfd;
 
+/**
+ * struct fdarray: Array of file descriptors
+ *
+ * @priv: Per array entry priv area, users should access just its contents,
+ *	  not set it to anything, as it is kept in synch with @entries, being
+ *	  realloc'ed, * for instance, in fdarray__{grow,filter}.
+ *
+ *	  I.e. using 'fda->priv[N].idx = * value' where N < fda->nr is ok,
+ *	  but doing 'fda->priv = malloc(M)' is not allowed.
+ */
 struct fdarray {
 	int	       nr;
 	int	       nr_alloc;
 	int	       nr_autogrow;
 	struct pollfd *entries;
+	union {
+		int    idx;
+	} *priv;
 };
 
 void fdarray__init(struct fdarray *fda, int nr_autogrow);
@@ -20,7 +33,8 @@ void fdarray__delete(struct fdarray *fda);
 
 int fdarray__add(struct fdarray *fda, int fd, short revents);
 int fdarray__poll(struct fdarray *fda, int timeout);
-int fdarray__filter(struct fdarray *fda, short revents);
+int fdarray__filter(struct fdarray *fda, short revents,
+		    void (*entry_destructor)(struct fdarray *fda, int fd));
 int fdarray__grow(struct fdarray *fda, int extra);
 int fdarray__fprintf(struct fdarray *fda, FILE *fp);
 
diff --git a/tools/perf/tests/fdarray.c b/tools/perf/tests/fdarray.c
index a0fea62..d24b837 100644
--- a/tools/perf/tests/fdarray.c
+++ b/tools/perf/tests/fdarray.c
@@ -36,7 +36,7 @@ int test__fdarray__filter(void)
 	}
 
 	fdarray__init_revents(fda, POLLIN);
-	nr_fds = fdarray__filter(fda, POLLHUP);
+	nr_fds = fdarray__filter(fda, POLLHUP, NULL);
 	if (nr_fds != fda->nr_alloc) {
 		pr_debug("\nfdarray__filter()=%d != %d shouldn't have filtered anything",
 			 nr_fds, fda->nr_alloc);
@@ -44,7 +44,7 @@ int test__fdarray__filter(void)
 	}
 
 	fdarray__init_revents(fda, POLLHUP);
-	nr_fds = fdarray__filter(fda, POLLHUP);
+	nr_fds = fdarray__filter(fda, POLLHUP, NULL);
 	if (nr_fds != 0) {
 		pr_debug("\nfdarray__filter()=%d != %d, should have filtered all fds",
 			 nr_fds, fda->nr_alloc);
@@ -57,7 +57,7 @@ int test__fdarray__filter(void)
 
 	pr_debug("\nfiltering all but fda->entries[2]:");
 	fdarray__fprintf_prefix(fda, "before", stderr);
-	nr_fds = fdarray__filter(fda, POLLHUP);
+	nr_fds = fdarray__filter(fda, POLLHUP, NULL);
 	fdarray__fprintf_prefix(fda, " after", stderr);
 	if (nr_fds != 1) {
 		pr_debug("\nfdarray__filter()=%d != 1, should have left just one event", nr_fds);
@@ -78,7 +78,7 @@ int test__fdarray__filter(void)
 
 	pr_debug("\nfiltering all but (fda->entries[0], fda->entries[3]):");
 	fdarray__fprintf_prefix(fda, "before", stderr);
-	nr_fds = fdarray__filter(fda, POLLHUP);
+	nr_fds = fdarray__filter(fda, POLLHUP, NULL);
 	fdarray__fprintf_prefix(fda, " after", stderr);
 	if (nr_fds != 2) {
 		pr_debug("\nfdarray__filter()=%d != 2, should have left just two events",
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index efddee5..61d18dc 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -435,7 +435,7 @@ int perf_evlist__add_pollfd(struct perf_evlist *evlist, int fd)
 
 int perf_evlist__filter_pollfd(struct perf_evlist *evlist, short revents_and_mask)
 {
-	return fdarray__filter(&evlist->pollfd, revents_and_mask);
+	return fdarray__filter(&evlist->pollfd, revents_and_mask, NULL);
 }
 
 int perf_evlist__poll(struct perf_evlist *evlist, int timeout)
