Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755043AbaEORYI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 13:24:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15994 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753105AbaEORYE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 13:24:04 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 06/14] perf tools: Cache dso data file descriptor
Date: Thu, 15 May 2014 19:23:27 +0200
Message-Id: <1400174615-2121-7-git-send-email-jolsa@kernel.org>
In-Reply-To: <1400174615-2121-1-git-send-email-jolsa@kernel.org>
References: <1400174615-2121-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changing the dso__data_close to keep the dso data file
descriptor open if possible.

We keep dsos data file descriptors open until their
count reaches the half of the current fd open limit
(RLIMIT_NOFILE). In this case we close file descriptor
of the first opened dso object.

We've got speed up in dso__data_fd function.

Output from report over 10 GB data with DWARF unwind stacks:
(TODO fix perf diff)

  current code:
   0.16%     perf  perf                       [.] dso__data_fd
  change:
   no record of dso__data_fd

And we got some noticable overall speed up:
(perf perf stat -e '{cycles,instructions}:u' ...)

  current code:
   291,315,329,878      cycles                     ( +-  0.22% )
   391,763,485,304      instructions               ( +-  0.03% )

     180.742249687 seconds time elapsed            ( +-  0.64% )

  change:
   228,948,088,958      cycles                     ( +-  0.20% )
   324,936,504,336      instructions               ( +-  0.02% )

     133.789677792 seconds time elapsed            ( +-  0.76% )

Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/util/dso.c | 62 ++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 59 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index 76e5c13..316e087 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -1,4 +1,6 @@
 #include <asm/bug.h>
+#include <sys/time.h>
+#include <sys/resource.h>
 #include "symbol.h"
 #include "dso.h"
 #include "machine.h"
@@ -204,11 +206,60 @@ static void close_dso(struct dso *dso)
 	close_data_fd(dso);
 }
 
-void dso__data_close(struct dso *dso)
+static void close_first_dso(void)
 {
+	struct dso *dso;
+
+	dso = list_first_entry(&dso__data_open, struct dso, data.open_entry);
 	close_dso(dso);
 }
 
+static rlim_t get_fd_limit(void)
+{
+	struct rlimit l;
+	rlim_t limit = 0;
+
+	/* Allow half of the current open fd limit. */
+	if (getrlimit(RLIMIT_NOFILE, &l) == 0) {
+		if (l.rlim_cur == RLIM_INFINITY)
+			limit = l.rlim_cur;
+		else
+			limit = l.rlim_cur / 2;
+	} else {
+		pr_err("failed to get fd limit\n");
+		limit = 1;
+	}
+
+	return limit;
+}
+
+static bool may_cache_fd(void)
+{
+	static rlim_t limit;
+
+	if (!limit)
+		limit = get_fd_limit();
+
+	if (limit == RLIM_INFINITY)
+		return true;
+
+	return limit > (rlim_t) dso__data_open_cnt;
+}
+
+static void data_close(void)
+{
+	bool cache_fd = may_cache_fd();
+
+	if (!cache_fd)
+		close_first_dso();
+}
+
+void dso__data_close(struct dso *dso)
+{
+	if (dso->data.fd >= 0)
+		data_close();
+}
+
 int dso__data_fd(struct dso *dso, struct machine *machine)
 {
 	enum dso_binary_type binary_type_data[] = {
@@ -318,6 +369,7 @@ static ssize_t
 dso_cache__read(struct dso *dso, struct machine *machine,
 		 u64 offset, u8 *data, ssize_t size)
 {
+	bool new_fd = dso->data.fd == -1;
 	struct dso_cache *cache;
 	ssize_t ret;
 	int fd;
@@ -356,7 +408,10 @@ dso_cache__read(struct dso *dso, struct machine *machine,
 	if (ret <= 0)
 		free(cache);
 
-	dso__data_close(dso);
+	/* Check the cache only if we just added new fd. */
+	if (new_fd)
+		data_close();
+
 	return ret;
 }
 
@@ -563,7 +618,8 @@ void dso__delete(struct dso *dso)
 		dso->long_name_allocated = false;
 	}
 
-	dso__data_close(dso);
+	if (dso->data.fd != -1)
+		close_dso(dso);
 	dso_cache__free(&dso->data.cache);
 	dso__free_a2l(dso);
 	zfree(&dso->symsrc_filename);
-- 
1.8.3.1

