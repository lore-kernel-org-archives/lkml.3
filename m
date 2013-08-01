Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757288Ab3HATKi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 15:10:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24498 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756997Ab3HATKg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 15:10:36 -0400
Date: Thu, 1 Aug 2013 21:05:14 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Zach Levis <zml@linux.vnet.ibm.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Evgeniy Polyakov <zbr@ioremap.net>,
        Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] exec: kill "int depth" in search_binary_handler()
Message-ID: <20130801190514.GA3216@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130801190455.GA3194@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nobody except search_binary_handler() should touch ->recursion_depth,
"int depth" buys nothing but complicates the code, kill it.

Probably we should also kill "fn" and the !NULL check, ->load_binary
should be always defined. And it can not go away after read_unlock()
or this code is buggy anyway.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/exec.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index a9ae4f2..f32079c 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1370,12 +1370,11 @@ EXPORT_SYMBOL(remove_arg_zero);
  */
 int search_binary_handler(struct linux_binprm *bprm)
 {
-	unsigned int depth = bprm->recursion_depth;
-	int try,retval;
+	int try, retval;
 	struct linux_binfmt *fmt;
 
 	/* This allows 4 levels of binfmt rewrites before failing hard. */
-	if (depth > 5)
+	if (bprm->recursion_depth > 5)
 		return -ELOOP;
 
 	retval = security_bprm_check(bprm);
@@ -1396,9 +1395,9 @@ int search_binary_handler(struct linux_binprm *bprm)
 			if (!try_module_get(fmt->module))
 				continue;
 			read_unlock(&binfmt_lock);
-			bprm->recursion_depth = depth + 1;
+			bprm->recursion_depth++;
 			retval = fn(bprm);
-			bprm->recursion_depth = depth;
+			bprm->recursion_depth--;
 			if (retval >= 0) {
 				put_binfmt(fmt);
 				allow_write_access(bprm->file);
-- 
1.5.5.1

