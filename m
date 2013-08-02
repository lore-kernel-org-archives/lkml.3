Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877Ab3HBTdA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 15:33:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52496 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755698Ab3HBTc6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 15:32:58 -0400
Date: Fri, 2 Aug 2013 21:27:34 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Zach Levis <zml@linux.vnet.ibm.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Evgeniy Polyakov <zbr@ioremap.net>,
        Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] exec: move allow_write_access/fput to exec_binprm()
Message-ID: <20130802192734.GA9565@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130802192713.GA9543@redhat.com>
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
---
 fs/exec.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index ad7d624..ef70320 100644
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
@@ -1455,6 +1451,11 @@ static int exec_binprm(struct linux_binprm *bprm)
 		ptrace_event(PTRACE_EVENT_EXEC, old_vpid);
 		current->did_exec = 1;
 		proc_exec_connector(current);
+
+		if (bprm->file) {
+			allow_write_access(bprm->file);
+			fput(bprm->file);
+		}
 	}
 
 	return ret;
-- 
1.5.5.1

