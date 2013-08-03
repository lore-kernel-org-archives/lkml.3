Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860Ab3HCTBD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Aug 2013 15:01:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58147 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752586Ab3HCTBB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Aug 2013 15:01:01 -0400
Date: Sat, 3 Aug 2013 20:55:34 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Zach Levis <zml@linux.vnet.ibm.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Evgeniy Polyakov <zbr@ioremap.net>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 2/3] exec: kill "int depth" in search_binary_handler()
Message-ID: <20130803185534.GA7452@redhat.com>
References: <20130801190455.GA3194@redhat.com> <20130801190514.GA3216@redhat.com> <CAGXu5j+=-n7S1VNyFR8oZ+bzh3iG8_cirUaNa48CGGh7DX805Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5j+=-n7S1VNyFR8oZ+bzh3iG8_cirUaNa48CGGh7DX805Q@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03, Kees Cook wrote:
>
> On Thu, Aug 1, 2013 at 12:05 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> > Nobody except search_binary_handler() should touch ->recursion_depth,
> > "int depth" buys nothing but complicates the code, kill it.
>
> I'd like to see a comment added to binfmts.h's recursion_depth field
> that reminds people that recursion_depth is for
> search_binary_handler()'s use only, and a binfmt loader shouldn't
> touch it.

And this comment probably makes sense even without this change

> Besides that, yeah, sensible clean up.

OK, thanks, please see v2. The only change is the comment in .h

------------------------------------------------------------------------------
Subject: [PATCH 1/1] exec: kill "int depth" in search_binary_handler()

Nobody except search_binary_handler() should touch ->recursion_depth,
"int depth" buys nothing but complicates the code, kill it.

Probably we should also kill "fn" and the !NULL check, ->load_binary
should be always defined. And it can not go away after read_unlock()
or this code is buggy anyway.

v2: add the comment about linux_binprm->recursion_depth

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/exec.c               |    9 ++++-----
 include/linux/binfmts.h |    2 +-
 2 files changed, 5 insertions(+), 6 deletions(-)

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
diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
index 70cf138..e8112ae 100644
--- a/include/linux/binfmts.h
+++ b/include/linux/binfmts.h
@@ -31,7 +31,7 @@ struct linux_binprm {
 #ifdef __alpha__
 	unsigned int taso:1;
 #endif
-	unsigned int recursion_depth;
+	unsigned int recursion_depth; /* only for search_binary_handler() */
 	struct file * file;
 	struct cred *cred;	/* new credentials */
 	int unsafe;		/* how unsafe this exec is (mask of LSM_UNSAFE_*) */
-- 
1.5.5.1


