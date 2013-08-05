Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157Ab3HENrJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 09:47:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25574 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753066Ab3HENrF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 09:47:05 -0400
Date: Mon, 5 Aug 2013 15:41:38 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Evgeniy Polyakov <zbr@ioremap.net>,
        Kees Cook <keescook@chromium.org>, Zach Levis <zml@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/8] exec: move allow_write_access/fput to exec_binprm()
Message-ID: <20130805134138.GA15635@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130805134113.GA15603@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When search_binary_handler() succeeds it does allow_write_access()
and fput(), then it clears bprm->file to ensure the caller will not
do the same.

We can simply move this code to exec_binprm() which is called only
once. In fact we could move this to free_bprm() and remove the same
code in do_execve_common's error path.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Kees Cook <keescook@chromium.org>
---
 fs/exec.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index ad7d624..577e98b 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1400,10 +1400,6 @@ int search_binary_handler(struct linux_binprm *bprm)
 			bprm->recursion_depth--;
 			if (retval >= 0) {
 				put_binfmt(fmt);
-				allow_write_access(bprm->file);
-				if (bprm->file)
-					fput(bprm->file);
-				bprm->file = NULL;
 				return retval;
 			}
 			read_lock(&binfmt_lock);
@@ -1455,6 +1451,12 @@ static int exec_binprm(struct linux_binprm *bprm)
 		ptrace_event(PTRACE_EVENT_EXEC, old_vpid);
 		current->did_exec = 1;
 		proc_exec_connector(current);
+
+		if (bprm->file) {
+			allow_write_access(bprm->file);
+			fput(bprm->file);
+			bprm->file = NULL; /* to catch use-after-free */
+		}
 	}
 
 	return ret;
-- 
1.5.5.1

