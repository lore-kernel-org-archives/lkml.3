Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750861Ab3EJEPy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 00:15:54 -0400
Received: from mail-gh0-f181.google.com ([209.85.160.181]:45839 "EHLO
	mail-gh0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711Ab3EJEPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 00:15:53 -0400
From: Lucas De Marchi <lucas.de.marchi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lucas De Marchi <lucas.de.marchi@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/3] argv_split(): Allow extra params
Date: Fri, 10 May 2013 01:15:14 -0300
Message-Id: <1368159316-31744-1-git-send-email-lucas.de.marchi@gmail.com>
X-Mailer: git-send-email 1.8.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an argument allowing argv_split to leave room for parameters to be
filled by the caller. This is useful in situations we want to split the
command and add a options as the last arguments.

Signed-off-by: Lucas De Marchi <lucas.de.marchi@gmail.com>
---
 fs/coredump.c                      |  2 +-
 include/linux/string.h             |  3 ++-
 kernel/sys.c                       |  2 +-
 kernel/trace/trace_events_filter.c |  2 +-
 kernel/trace/trace_probe.c         |  2 +-
 lib/argv_split.c                   | 13 +++++++------
 6 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/fs/coredump.c b/fs/coredump.c
index d52f6bd..08697cf 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -565,7 +565,7 @@ void do_coredump(siginfo_t *siginfo)
 			goto fail_dropcount;
 		}
 
-		helper_argv = argv_split(GFP_KERNEL, cn.corename+1, NULL);
+		helper_argv = argv_split(GFP_KERNEL, cn.corename+1, NULL, 0);
 		if (!helper_argv) {
 			printk(KERN_WARNING "%s failed to allocate memory\n",
 			       __func__);
diff --git a/include/linux/string.h b/include/linux/string.h
index ac889c5..e2245e5 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -116,7 +116,8 @@ extern char *kstrdup(const char *s, gfp_t gfp);
 extern char *kstrndup(const char *s, size_t len, gfp_t gfp);
 extern void *kmemdup(const void *src, size_t len, gfp_t gfp);
 
-extern char **argv_split(gfp_t gfp, const char *str, int *argcp);
+extern char **argv_split(gfp_t gfp, const char *str, int *argcp,
+			 unsigned int extra);
 extern void argv_free(char **argv);
 
 extern bool sysfs_streq(const char *s1, const char *s2);
diff --git a/kernel/sys.c b/kernel/sys.c
index 0da73cf..d363325 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -2196,7 +2196,7 @@ static int __orderly_poweroff(bool force)
 	};
 	int ret;
 
-	argv = argv_split(GFP_KERNEL, poweroff_cmd, NULL);
+	argv = argv_split(GFP_KERNEL, poweroff_cmd, NULL, 0);
 	if (argv) {
 		ret = call_usermodehelper(argv[0], argv, envp, UMH_WAIT_EXEC);
 		argv_free(argv);
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index e5b0ca8..3c107b2 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -1981,7 +1981,7 @@ ftrace_function_filter_re(char *buf, int len, int *count)
 	while ((sep = strchr(str, ',')))
 		*sep = ' ';
 
-	re = argv_split(GFP_KERNEL, str, count);
+	re = argv_split(GFP_KERNEL, str, count, 0);
 	kfree(str);
 	return re;
 }
diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
index 412e959..29128dd 100644
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -770,7 +770,7 @@ int traceprobe_command(const char *buf, int (*createfn)(int, char **))
 
 	argc = 0;
 	ret = 0;
-	argv = argv_split(GFP_KERNEL, buf, &argc);
+	argv = argv_split(GFP_KERNEL, buf, &argc, 0);
 	if (!argv)
 		return -ENOMEM;
 
diff --git a/lib/argv_split.c b/lib/argv_split.c
index e927ed0..9ebcbb0 100644
--- a/lib/argv_split.c
+++ b/lib/argv_split.c
@@ -43,20 +43,21 @@ EXPORT_SYMBOL(argv_free);
  * argv_split - split a string at whitespace, returning an argv
  * @gfp: the GFP mask used to allocate memory
  * @str: the string to be split
- * @argcp: returned argument count
+ * @argcp: returned argument count without counting extras
+ * @extra: room left for extra arguments to be filled by caller
  *
  * Returns an array of pointers to strings which are split out from
  * @str.  This is performed by strictly splitting on white-space; no
  * quote processing is performed.  Multiple whitespace characters are
  * considered to be a single argument separator.  The returned array
- * is always NULL-terminated.  Returns NULL on memory allocation
- * failure.
+ * is always NULL-terminated, after any possible extra argument.
+ * Returns NULL on memory allocation failure.
  *
  * The source string at `str' may be undergoing concurrent alteration via
  * userspace sysctl activity (at least).  The argv_split() implementation
  * attempts to handle this gracefully by taking a local copy to work on.
  */
-char **argv_split(gfp_t gfp, const char *str, int *argcp)
+char **argv_split(gfp_t gfp, const char *str, int *argcp, unsigned int extra)
 {
 	char *argv_str;
 	bool was_space;
@@ -68,7 +69,7 @@ char **argv_split(gfp_t gfp, const char *str, int *argcp)
 		return NULL;
 
 	argc = count_argc(argv_str);
-	argv = kmalloc(sizeof(*argv) * (argc + 2), gfp);
+	argv = kmalloc(sizeof(*argv) * (argc + 2 + extra), gfp);
 	if (!argv) {
 		kfree(argv_str);
 		return NULL;
@@ -85,7 +86,7 @@ char **argv_split(gfp_t gfp, const char *str, int *argcp)
 			*argv++ = argv_str;
 		}
 	}
-	*argv = NULL;
+	argv[extra] = NULL;
 
 	if (argcp)
 		*argcp = argc;
-- 
1.8.2.2

