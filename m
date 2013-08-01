Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757349Ab3HATKq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 15:10:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25581 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756907Ab3HATKo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 15:10:44 -0400
Date: Thu, 1 Aug 2013 21:05:16 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Zach Levis <zml@linux.vnet.ibm.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Evgeniy Polyakov <zbr@ioremap.net>,
        Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] exec: proc_exec_connector() should be called only once
Message-ID: <20130801190516.GA3223@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130801190455.GA3194@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A separate one-liner with the minor fix.

PROC_EVENT_EXEC reports the "exec" event, but this message
is sent at least twice if search_binary_handler() is called
by ->load_binary() recursively, say, load_script().

Move it to exec_binprm(), this is "depth == 0" code too.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/exec.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index f32079c..ad7d624 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1404,7 +1404,6 @@ int search_binary_handler(struct linux_binprm *bprm)
 				if (bprm->file)
 					fput(bprm->file);
 				bprm->file = NULL;
-				proc_exec_connector(current);
 				return retval;
 			}
 			read_lock(&binfmt_lock);
@@ -1455,6 +1454,7 @@ static int exec_binprm(struct linux_binprm *bprm)
 		trace_sched_process_exec(current, old_pid, bprm);
 		ptrace_event(PTRACE_EVENT_EXEC, old_vpid);
 		current->did_exec = 1;
+		proc_exec_connector(current);
 	}
 
 	return ret;
-- 
1.5.5.1

