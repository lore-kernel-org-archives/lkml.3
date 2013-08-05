Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281Ab3HENsk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 09:48:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24172 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753001Ab3HENrD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 09:47:03 -0400
Date: Mon, 5 Aug 2013 15:41:35 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Evgeniy Polyakov <zbr@ioremap.net>,
        Kees Cook <keescook@chromium.org>, Zach Levis <zml@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/8] exec: proc_exec_connector() should be called only
	once
Message-ID: <20130805134135.GA15632@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130805134113.GA15603@redhat.com>
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
Acked-by: Kees Cook <keescook@chromium.org>
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

