Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945Ab3KVRxh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 12:53:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37792 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755828Ab3KVRxf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 12:53:35 -0500
Date: Fri, 22 Nov 2013 18:54:45 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Kees Cook <keescook@chromium.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Sameer Nanda <snanda@chromium.org>,
        Sergey Dyasly <dserrg@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] exec: move the final allow_write_access/fput into
	free_bprm()
Message-ID: <20131122175445.GA31456@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131122175424.GA31432@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both success/failure paths cleanup bprm->file, we can move this
code into free_bprm() to simlify and cleanup this logic.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/exec.c |   20 +++++---------------
 1 files changed, 5 insertions(+), 15 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 60eb5c5..9944bbf 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1140,9 +1140,7 @@ void setup_new_exec(struct linux_binprm * bprm)
 
 	/* An exec changes our domain. We are no longer part of the thread
 	   group */
-
 	current->self_exec_id++;
-			
 	flush_signal_handlers(current, 0);
 	do_close_on_exec(current->files);
 }
@@ -1174,6 +1172,10 @@ void free_bprm(struct linux_binprm *bprm)
 		mutex_unlock(&current->signal->cred_guard_mutex);
 		abort_creds(bprm->cred);
 	}
+	if (bprm->file) {
+		allow_write_access(bprm->file);
+		fput(bprm->file);
+	}
 	/* If a binfmt changed the interp, free it. */
 	if (bprm->interp != bprm->filename)
 		kfree(bprm->interp);
@@ -1432,12 +1434,6 @@ static int exec_binprm(struct linux_binprm *bprm)
 		ptrace_event(PTRACE_EVENT_EXEC, old_vpid);
 		current->did_exec = 1;
 		proc_exec_connector(current);
-
-		if (bprm->file) {
-			allow_write_access(bprm->file);
-			fput(bprm->file);
-			bprm->file = NULL; /* to catch use-after-free */
-		}
 	}
 
 	return ret;
@@ -1500,7 +1496,7 @@ static int do_execve_common(const char *filename,
 
 	retval = bprm_mm_init(bprm);
 	if (retval)
-		goto out_file;
+		goto out_unmark;
 
 	bprm->argc = count(argv, MAX_ARG_STRINGS);
 	if ((retval = bprm->argc) < 0)
@@ -1546,12 +1542,6 @@ out:
 		mmput(bprm->mm);
 	}
 
-out_file:
-	if (bprm->file) {
-		allow_write_access(bprm->file);
-		fput(bprm->file);
-	}
-
 out_unmark:
 	current->fs->in_exec = 0;
 	current->in_execve = 0;
-- 
1.5.5.1

