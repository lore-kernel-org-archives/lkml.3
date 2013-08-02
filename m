Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755709Ab3HBTdK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 15:33:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6907 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755992Ab3HBTdH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 15:33:07 -0400
Date: Fri, 2 Aug 2013 21:27:44 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Zach Levis <zml@linux.vnet.ibm.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Evgeniy Polyakov <zbr@ioremap.net>,
        Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] exec: cleanup the error handling in
	search_binary_handler()
Message-ID: <20130802192744.GA9582@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130802192713.GA9543@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The error hanling and ret-from-loop look confusing and inconsistent.

- "retval >= 0" simply returns

- "!bprm->file" returns too but with read_unlock() because
   binfmt_lock was already re-acquired

- "retval != -ENOEXEC || bprm->mm == NULL" does "break" and
  relies on the same check after the main loop

Consolidate these checks into a single if/return statement.

need_retry still checks "retval == -ENOEXEC", but this and -ENOENT
before the main loop are not needed. This is only for pathological
and impossible list_empty(&formats) case.

It is not clear why do we check "bprm->mm == NULL", probably this
should be removed.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/exec.c |   11 +++--------
 1 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index d9fd32c..7ab2120 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1399,22 +1399,17 @@ int search_binary_handler(struct linux_binprm *bprm)
 		bprm->recursion_depth++;
 		retval = fmt->load_binary(bprm);
 		bprm->recursion_depth--;
-		if (retval >= 0) {
+		if (retval >= 0 || retval != -ENOEXEC ||
+		    bprm->mm == NULL || bprm->file == NULL) {
 			put_binfmt(fmt);
 			return retval;
 		}
 		read_lock(&binfmt_lock);
 		put_binfmt(fmt);
-		if (retval != -ENOEXEC || bprm->mm == NULL)
-			break;
-		if (!bprm->file) {
-			read_unlock(&binfmt_lock);
-			return retval;
-		}
 	}
 	read_unlock(&binfmt_lock);
 
-	if (need_retry && retval == -ENOEXEC && bprm->mm) {
+	if (need_retry && retval == -ENOEXEC) {
 		if (printable(bprm->buf[0]) && printable(bprm->buf[1]) &&
 		    printable(bprm->buf[2]) && printable(bprm->buf[3]))
 			return retval;
-- 
1.5.5.1

