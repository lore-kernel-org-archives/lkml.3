Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750993AbaLPGX3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 01:23:29 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:26753 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbaLPGX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 01:23:28 -0500
From: Wang Nan <wangnan0@huawei.com>
To: <a.p.zijlstra@chello.nl>, <paulus@samba.org>, <mingo@redhat.com>,
        <acme@kernel.org>, <ak@linux.intel.com>, <namhyung@kernel.org>
CC: <lizefan@huawei.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] perf: fix building warning on ARM 32.
Date: Tue, 16 Dec 2014 14:19:06 +0800
Message-ID: <1418710746-35943-1-git-send-email-wangnan0@huawei.com>
X-Mailer: git-send-email 1.8.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 85c116a6c introduces asprintf() call and matches '%ld' to a u64
argument, which is incorrect on ARM:

   CC       /home/wn/util/srcline.o
 util/srcline.c: In function 'get_srcline':
 util/srcline.c:297:6: error: format '%ld' expects argument of type 'long int', but argument 4 has type 'u64' [-Werror=format]
 cc1: all warnings being treated as errors
 make[1]: *** [/home/wn/util/srcline.o] Error 1

In addition, all users of get_srcline() use u64 addr, and libbfd
also use 64 bit bfd_vma as address. This patch also fix prototype
of get_srcline() and addr2line() to use u64 addr instead of
unsigned long.

Signed-off-by: Wang Nan <wangnan0@huawei.com>
---
 tools/perf/util/srcline.c | 12 ++++++------
 tools/perf/util/util.h    |  2 +-
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/tools/perf/util/srcline.c b/tools/perf/util/srcline.c
index e73b6a5..c93fb0c 100644
--- a/tools/perf/util/srcline.c
+++ b/tools/perf/util/srcline.c
@@ -20,7 +20,7 @@
 
 struct a2l_data {
 	const char 	*input;
-	unsigned long 	addr;
+	u64	 	addr;
 
 	bool 		found;
 	const char 	*filename;
@@ -147,7 +147,7 @@ static void addr2line_cleanup(struct a2l_data *a2l)
 	free(a2l);
 }
 
-static int addr2line(const char *dso_name, unsigned long addr,
+static int addr2line(const char *dso_name, u64 addr,
 		     char **file, unsigned int *line, struct dso *dso)
 {
 	int ret = 0;
@@ -193,7 +193,7 @@ void dso__free_a2l(struct dso *dso)
 
 #else /* HAVE_LIBBFD_SUPPORT */
 
-static int addr2line(const char *dso_name, unsigned long addr,
+static int addr2line(const char *dso_name, u64 addr,
 		     char **file, unsigned int *line_nr,
 		     struct dso *dso __maybe_unused)
 {
@@ -252,7 +252,7 @@ void dso__free_a2l(struct dso *dso __maybe_unused)
  */
 #define A2L_FAIL_LIMIT 123
 
-char *get_srcline(struct dso *dso, unsigned long addr, struct symbol *sym,
+char *get_srcline(struct dso *dso, u64 addr, struct symbol *sym,
 		  bool show_sym)
 {
 	char *file = NULL;
@@ -293,10 +293,10 @@ out:
 		dso__free_a2l(dso);
 	}
 	if (sym) {
-		if (asprintf(&srcline, "%s+%ld", show_sym ? sym->name : "",
+		if (asprintf(&srcline, "%s+%" PRIu64, show_sym ? sym->name : "",
 					addr - sym->start) < 0)
 			return SRCLINE_UNKNOWN;
-	} else if (asprintf(&srcline, "%s[%lx]", dso->short_name, addr) < 0)
+	} else if (asprintf(&srcline, "%s[%" PRIx64 "]", dso->short_name, addr) < 0)
 		return SRCLINE_UNKNOWN;
 	return srcline;
 }
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index 419bee0..a70ab0c 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -339,7 +339,7 @@ static inline int path__join3(char *bf, size_t size,
 struct dso;
 struct symbol;
 
-char *get_srcline(struct dso *dso, unsigned long addr, struct symbol *sym,
+char *get_srcline(struct dso *dso, u64 addr, struct symbol *sym,
 		  bool show_sym);
 void free_srcline(char *srcline);
 
-- 
1.8.4

