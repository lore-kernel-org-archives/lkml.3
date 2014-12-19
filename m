Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529AbaLSNPg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 08:15:36 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45332 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752288AbaLSNPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 08:15:34 -0500
Date: Fri, 19 Dec 2014 04:13:23 -0800
From: tip-bot for Wang Nan <tipbot@zytor.com>
Message-ID: <tip-ac931f87a647ca156f65a4c00e7297165e4fa2d8@git.kernel.org>
Cc: mingo@kernel.org, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, paulus@samba.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, wangnan0@huawei.com, acme@kernel.org,
        lizefan@huawei.com, hpa@zytor.com
Reply-To: paulus@samba.org, a.p.zijlstra@chello.nl, namhyung@kernel.org,
        mingo@kernel.org, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@zytor.com, lizefan@huawei.com,
        wangnan0@huawei.com, acme@kernel.org
In-Reply-To: <1418710746-35943-1-git-send-email-wangnan0@huawei.com>
References: <1418710746-35943-1-git-send-email-wangnan0@huawei.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf: Fix building warning on ARM 32
Git-Commit-ID: ac931f87a647ca156f65a4c00e7297165e4fa2d8
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

Commit-ID:  ac931f87a647ca156f65a4c00e7297165e4fa2d8
Gitweb:     http://git.kernel.org/tip/ac931f87a647ca156f65a4c00e7297165e4fa2d8
Author:     Wang Nan <wangnan0@huawei.com>
AuthorDate: Tue, 16 Dec 2014 14:19:06 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 19 Dec 2014 13:09:43 +0100

perf: Fix building warning on ARM 32

Commit 85c116a6cb91 ("perf callchain: Make get_srcline fall back to sym+offset")
introduces asprintf() call and matches '%ld' to a u64 argument, which is
incorrect on ARM:

   CC       /home/wn/util/srcline.o
 util/srcline.c: In function 'get_srcline':
 util/srcline.c:297:6: error: format '%ld' expects argument of type 'long int', but argument 4 has type 'u64' [-Werror=format]
 cc1: all warnings being treated as errors
 make[1]: *** [/home/wn/util/srcline.o] Error 1

In addition, all users of get_srcline() use u64 addr, and libbfd
also use 64 bit bfd_vma as address. This patch also fix
prototype of get_srcline() and addr2line() to use u64 addr
instead of unsigned long.

Signed-off-by: Wang Nan <wangnan0@huawei.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: <lizefan@huawei.com>
Cc: <a.p.zijlstra@chello.nl>
Cc: <paulus@samba.org>
Cc: <acme@kernel.org>
Cc: <ak@linux.intel.com>
Link: http://lkml.kernel.org/r/1418710746-35943-1-git-send-email-wangnan0@huawei.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
index be198ac..027a515 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -310,7 +310,7 @@ static inline int path__join3(char *bf, size_t size,
 struct dso;
 struct symbol;
 
-char *get_srcline(struct dso *dso, unsigned long addr, struct symbol *sym,
+char *get_srcline(struct dso *dso, u64 addr, struct symbol *sym,
 		  bool show_sym);
 void free_srcline(char *srcline);
 
