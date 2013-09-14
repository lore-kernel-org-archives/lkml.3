Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180Ab3INHct (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 03:32:49 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:61098 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404Ab3INHcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 03:32:48 -0400
X-Nat-Received: from [202.181.97.72]:49871 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1379143954.21010
To: viro@zeniv.linux.org.uk
Cc: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com,
        akpm@linux-foundation.org, oleg@redhat.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] argv_split: Return NULL if argument contains no non-whitespace.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Message-Id: <201309141632.GHD86439.VLOOOFQFJtSMFH@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sat, 14 Sep 2013 16:32:19 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 14092013 #11051289, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 210f917f3b535bc0d4dcbb20ca4395709e913104 Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Sat, 14 Sep 2013 16:24:07 +0900
Subject: [PATCH] argv_split: Return NULL if argument contains no non-whitespace.

I tried

  # echo '|' > /proc/sys/kernel/core_pattern

and got

  BUG: unable to handle kernel NULL pointer dereference at   (null)

upon core dump because helper_argv[0] == NULL at

  helper_argv = argv_split(GFP_KERNEL, cn.corename, NULL);
  call_usermodehelper_setup(helper_argv[0], ...);

if cn.corename == "".

How to check this bug:

  # echo '|' > /proc/sys/kernel/core_pattern
  $ echo 'int main(int argc, char *argv[]) { return *(char *) 0; }' | gcc -x c - -o die
  $ ulimit -c unlimited
  $ ./die

This bug seems to exist since 2.6.19 (the version which core dump to pipe was
added). Depending on kernel version and config, some side effect might follow
immediately after this oops (e.g. kernel panic with 2.6.32-358.18.1.el6).

Assuming that nobody is expecting that argv_split() returns an array with
argv[0] == NULL, this patch fixes this bug by changing argv_split() to return
NULL if argument contains no non-whitespace.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 lib/argv_split.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/lib/argv_split.c b/lib/argv_split.c
index e927ed0..5b828d9 100644
--- a/lib/argv_split.c
+++ b/lib/argv_split.c
@@ -50,7 +50,7 @@ EXPORT_SYMBOL(argv_free);
  * quote processing is performed.  Multiple whitespace characters are
  * considered to be a single argument separator.  The returned array
  * is always NULL-terminated.  Returns NULL on memory allocation
- * failure.
+ * failure or @str being empty or @str containing only white-space.
  *
  * The source string at `str' may be undergoing concurrent alteration via
  * userspace sysctl activity (at least).  The argv_split() implementation
@@ -68,6 +68,10 @@ char **argv_split(gfp_t gfp, const char *str, int *argcp)
 		return NULL;
 
 	argc = count_argc(argv_str);
+	if (!argc) {
+		kfree(argv_str);
+		return NULL;
+	}
 	argv = kmalloc(sizeof(*argv) * (argc + 2), gfp);
 	if (!argv) {
 		kfree(argv_str);
-- 
1.7.1
