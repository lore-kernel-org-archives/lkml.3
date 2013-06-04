Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767Ab3FDXWR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 19:22:17 -0400
Received: from 1wt.eu ([62.212.114.60]:35249 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752463Ab3FDWl1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:41:27 -0400
Message-Id: <20130604172130.885441884@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:21:44 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Oleg Nesterov <oleg@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
        Tejun Heo <tj@kernel.org>, David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 014/184] kmod: make __request_module() killable
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

commit 1cc684ab75123efe7ff446eb821d44375ba8fa30 upstream

As Tetsuo Handa pointed out, request_module() can stress the system
while the oom-killed caller sleeps in TASK_UNINTERRUPTIBLE.

The task T uses "almost all" memory, then it does something which
triggers request_module().  Say, it can simply call sys_socket().  This
in turn needs more memory and leads to OOM.  oom-killer correctly
chooses T and kills it, but this can't help because it sleeps in
TASK_UNINTERRUPTIBLE and after that oom-killer becomes "disabled" by the
TIF_MEMDIE task T.

Make __request_module() killable.  The only necessary change is that
call_modprobe() should kmalloc argv and module_name, they can't live in
the stack if we use UMH_KILLABLE.  This memory is freed via
call_usermodehelper_freeinfo()->cleanup.

Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Tejun Heo <tj@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[dannf, bwh: backported to Debian's 2.6.32]
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 kernel/kmod.c | 36 ++++++++++++++++++++++++++++++++++--
 1 file changed, 34 insertions(+), 2 deletions(-)

diff --git a/kernel/kmod.c b/kernel/kmod.c
index 1088a8f..8ecc509 100644
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -53,16 +53,48 @@ static DECLARE_RWSEM(umhelper_sem);
 */
 char modprobe_path[KMOD_PATH_LEN] = "/sbin/modprobe";
 
+static void free_modprobe_argv(char **argv, char **envp)
+{
+	kfree(argv[3]); /* check call_modprobe() */
+	kfree(argv);
+}
+
 static int call_modprobe(char *module_name, int wait)
 {
 	static char *envp[] = { "HOME=/",
 				"TERM=linux",
 				"PATH=/sbin:/usr/sbin:/bin:/usr/bin",
 				NULL };
+	struct subprocess_info *info;
+
+	char **argv = kmalloc(sizeof(char *[5]), GFP_KERNEL);
+	if (!argv)
+		goto out;
 
-	char *argv[] = { modprobe_path, "-q", "--", module_name, NULL };
+	module_name = kstrdup(module_name, GFP_KERNEL);
+	if (!module_name)
+		goto free_argv;
 
-	return call_usermodehelper(modprobe_path, argv, envp, wait);
+	argv[0] = modprobe_path;
+	argv[1] = "-q";
+	argv[2] = "--";
+	argv[3] = module_name;	/* check free_modprobe_argv() */
+	argv[4] = NULL;
+
+	info = call_usermodehelper_setup(argv[0], argv, envp, GFP_ATOMIC);
+	if (!info)
+		goto free_module_name;
+
+	call_usermodehelper_setcleanup(info, free_modprobe_argv);
+
+	return call_usermodehelper_exec(info, wait | UMH_KILLABLE);
+
+free_module_name:
+	kfree(module_name);
+free_argv:
+	kfree(argv);
+out:
+	return -ENOMEM;
 }
 
 /**
-- 
1.7.12.2.21.g234cd45.dirty



