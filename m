Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056Ab3HBTdx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 15:33:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59646 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755255Ab3HBTdG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 15:33:06 -0400
Date: Fri, 2 Aug 2013 21:27:39 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Zach Levis <zml@linux.vnet.ibm.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Evgeniy Polyakov <zbr@ioremap.net>,
        Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] exec: cleanup the CONFIG_MODULES logic
Message-ID: <20130802192739.GA9572@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130802192713.GA9543@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

search_binary_handler() uses "for (try=0; try<2; try++)" to avoid
"goto" but the code looks too complicated and horrible imho. We
still need to check "try == 0" before request_module() and add the
additional "break" for !CONFIG_MODULES case.

Kill this loop and use a simple "bool need_retry" + "goto retry".
The code looks much simpler and we do not even need ifdef's, gcc
can optimize out the "if (need_retry)" block if !IS_ENABLED().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/exec.c |   68 +++++++++++++++++++++++++++---------------------------------
 1 files changed, 31 insertions(+), 37 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 9f41e7d..48344a2 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1367,13 +1367,15 @@ out:
 }
 EXPORT_SYMBOL(remove_arg_zero);
 
+#define printable(c) (((c)=='\t') || ((c)=='\n') || (0x20<=(c) && (c)<=0x7e))
 /*
  * cycle the list of binary formats handler, until one recognizes the image
  */
 int search_binary_handler(struct linux_binprm *bprm)
 {
-	int try, retval;
+	bool need_retry = IS_ENABLED(CONFIG_MODULES);
 	struct linux_binfmt *fmt;
+	int retval;
 
 	/* This allows 4 levels of binfmt rewrites before failing hard. */
 	if (bprm->recursion_depth > 5)
@@ -1388,47 +1390,39 @@ int search_binary_handler(struct linux_binprm *bprm)
 		return retval;
 
 	retval = -ENOENT;
-	for (try=0; try<2; try++) {
-		read_lock(&binfmt_lock);
-		list_for_each_entry(fmt, &formats, lh) {
-			if (!try_module_get(fmt->module))
-				continue;
-			read_unlock(&binfmt_lock);
-			bprm->recursion_depth++;
-			retval = fmt->load_binary(bprm);
-			bprm->recursion_depth--;
-			if (retval >= 0) {
-				put_binfmt(fmt);
-				return retval;
-			}
-			read_lock(&binfmt_lock);
+ retry:
+	read_lock(&binfmt_lock);
+	list_for_each_entry(fmt, &formats, lh) {
+		if (!try_module_get(fmt->module))
+			continue;
+		read_unlock(&binfmt_lock);
+		bprm->recursion_depth++;
+		retval = fmt->load_binary(bprm);
+		bprm->recursion_depth--;
+		if (retval >= 0) {
 			put_binfmt(fmt);
-			if (retval != -ENOEXEC || bprm->mm == NULL)
-				break;
-			if (!bprm->file) {
-				read_unlock(&binfmt_lock);
-				return retval;
-			}
+			return retval;
 		}
-		read_unlock(&binfmt_lock);
-#ifdef CONFIG_MODULES
-		if (retval != -ENOEXEC || bprm->mm == NULL) {
+		read_lock(&binfmt_lock);
+		put_binfmt(fmt);
+		if (retval != -ENOEXEC || bprm->mm == NULL)
 			break;
-		} else {
-#define printable(c) (((c)=='\t') || ((c)=='\n') || (0x20<=(c) && (c)<=0x7e))
-			if (printable(bprm->buf[0]) &&
-			    printable(bprm->buf[1]) &&
-			    printable(bprm->buf[2]) &&
-			    printable(bprm->buf[3]))
-				break; /* -ENOEXEC */
-			if (try)
-				break; /* -ENOEXEC */
-			request_module("binfmt-%04x", *(unsigned short *)(&bprm->buf[2]));
+		if (!bprm->file) {
+			read_unlock(&binfmt_lock);
+			return retval;
 		}
-#else
-		break;
-#endif
 	}
+	read_unlock(&binfmt_lock);
+
+	if (need_retry && retval == -ENOEXEC && bprm->mm) {
+		if (printable(bprm->buf[0]) && printable(bprm->buf[1]) &&
+		    printable(bprm->buf[2]) && printable(bprm->buf[3]))
+			return retval;
+		request_module("binfmt-%04x", *(ushort *)(bprm->buf + 2));
+		need_retry = false;
+		goto retry;
+	}
+
 	return retval;
 }
 EXPORT_SYMBOL(search_binary_handler);
-- 
1.5.5.1

