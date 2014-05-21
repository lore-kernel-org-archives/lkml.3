Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751980AbaEUJiQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 05:38:16 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:40092 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbaEUJiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 05:38:15 -0400
Subject: [PATCH] tools/vm/page-types.c: catch sigbus if raced with truncate
From: Konstantin Khlebnikov <koct9i@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Date: Wed, 21 May 2014 13:38:07 +0400
Message-ID: <20140521093807.24256.22521.stgit@zurg>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recently added page-cache dumping is known to be a little bit racy.
But after race with truncate it just dies due to unhandled SIGBUS
when it tries to poke pages beyond the new end of file.
This patch adds handler for SIGBUS which skips the rest of the file.

Signed-off-by: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
---
 tools/vm/page-types.c |   35 ++++++++++++++++++++++++++++++++---
 1 file changed, 32 insertions(+), 3 deletions(-)

diff --git a/tools/vm/page-types.c b/tools/vm/page-types.c
index 05654f5..c4d6d2e 100644
--- a/tools/vm/page-types.c
+++ b/tools/vm/page-types.c
@@ -32,6 +32,8 @@
 #include <assert.h>
 #include <ftw.h>
 #include <time.h>
+#include <setjmp.h>
+#include <signal.h>
 #include <sys/types.h>
 #include <sys/errno.h>
 #include <sys/fcntl.h>
@@ -824,21 +826,38 @@ static void show_file(const char *name, const struct stat *st)
 			atime, now - st->st_atime);
 }
 
+static sigjmp_buf sigbus_jmp;
+
+static void * volatile sigbus_addr;
+
+static void sigbus_handler(int sig, siginfo_t *info, void *ucontex)
+{
+	(void)sig;
+	(void)ucontex;
+	sigbus_addr = info ? info->si_addr : NULL;
+	siglongjmp(sigbus_jmp, 1);
+}
+
+static struct sigaction sigbus_action = {
+	.sa_sigaction = sigbus_handler,
+	.sa_flags = SA_SIGINFO,
+};
+
 static void walk_file(const char *name, const struct stat *st)
 {
 	uint8_t vec[PAGEMAP_BATCH];
 	uint64_t buf[PAGEMAP_BATCH], flags;
 	unsigned long nr_pages, pfn, i;
+	off_t off, end = st->st_size;
 	int fd;
-	off_t off;
 	ssize_t len;
 	void *ptr;
 	int first = 1;
 
 	fd = checked_open(name, O_RDONLY|O_NOATIME|O_NOFOLLOW);
 
-	for (off = 0; off < st->st_size; off += len) {
-		nr_pages = (st->st_size - off + page_size - 1) / page_size;
+	for (off = 0; off < end; off += len) {
+		nr_pages = (end - off + page_size - 1) / page_size;
 		if (nr_pages > PAGEMAP_BATCH)
 			nr_pages = PAGEMAP_BATCH;
 		len = nr_pages * page_size;
@@ -855,11 +874,19 @@ static void walk_file(const char *name, const struct stat *st)
 		if (madvise(ptr, len, MADV_RANDOM))
 			fatal("madvice failed: %s", name);
 
+		if (sigsetjmp(sigbus_jmp, 1)) {
+			end = off + sigbus_addr ? sigbus_addr - ptr : 0;
+			fprintf(stderr, "got sigbus at offset %lld: %s\n",
+					(long long)end, name);
+			goto got_sigbus;
+		}
+
 		/* populate ptes */
 		for (i = 0; i < nr_pages ; i++) {
 			if (vec[i] & 1)
 				(void)*(volatile int *)(ptr + i * page_size);
 		}
+got_sigbus:
 
 		/* turn off harvesting reference bits */
 		if (madvise(ptr, len, MADV_SEQUENTIAL))
@@ -910,6 +937,7 @@ static void walk_page_cache(void)
 
 	kpageflags_fd = checked_open(PROC_KPAGEFLAGS, O_RDONLY);
 	pagemap_fd = checked_open("/proc/self/pagemap", O_RDONLY);
+	sigaction(SIGBUS, &sigbus_action, NULL);
 
 	if (stat(opt_file, &st))
 		fatal("stat failed: %s\n", opt_file);
@@ -925,6 +953,7 @@ static void walk_page_cache(void)
 
 	close(kpageflags_fd);
 	close(pagemap_fd);
+	signal(SIGBUS, SIG_DFL);
 }
 
 static void parse_file(const char *name)

