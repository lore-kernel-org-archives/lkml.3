Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889Ab3FDWmI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 18:42:08 -0400
Received: from 1wt.eu ([62.212.114.60]:35360 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752839Ab3FDWmE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:42:04 -0400
Message-Id: <20130604172130.843687185@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:21:43 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Oleg Nesterov <oleg@redhat.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 013/184] kmod: introduce call_modprobe() helper
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

commit 3e63a93b987685f02421e18b2aa452d20553a88b upstream

No functional changes.  Move the call_usermodehelper code from
__request_module() into the new simple helper, call_modprobe().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Tejun Heo <tj@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[dannf: backported to Debian's 2.6.32]
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 kernel/kmod.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/kernel/kmod.c b/kernel/kmod.c
index f12d883..1088a8f 100644
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -53,6 +53,18 @@ static DECLARE_RWSEM(umhelper_sem);
 */
 char modprobe_path[KMOD_PATH_LEN] = "/sbin/modprobe";
 
+static int call_modprobe(char *module_name, int wait)
+{
+	static char *envp[] = { "HOME=/",
+				"TERM=linux",
+				"PATH=/sbin:/usr/sbin:/bin:/usr/bin",
+				NULL };
+
+	char *argv[] = { modprobe_path, "-q", "--", module_name, NULL };
+
+	return call_usermodehelper(modprobe_path, argv, envp, wait);
+}
+
 /**
  * __request_module - try to load a kernel module
  * @wait: wait (or not) for the operation to complete
@@ -74,11 +86,6 @@ int __request_module(bool wait, const char *fmt, ...)
 	char module_name[MODULE_NAME_LEN];
 	unsigned int max_modprobes;
 	int ret;
-	char *argv[] = { modprobe_path, "-q", "--", module_name, NULL };
-	static char *envp[] = { "HOME=/",
-				"TERM=linux",
-				"PATH=/sbin:/usr/sbin:/bin:/usr/bin",
-				NULL };
 	static atomic_t kmod_concurrent = ATOMIC_INIT(0);
 #define MAX_KMOD_CONCURRENT 50	/* Completely arbitrary value - KAO */
 	static int kmod_loop_msg;
@@ -121,8 +128,8 @@ int __request_module(bool wait, const char *fmt, ...)
 
 	trace_module_request(module_name, wait, _RET_IP_);
 
-	ret = call_usermodehelper(modprobe_path, argv, envp,
-			wait ? UMH_WAIT_PROC : UMH_WAIT_EXEC);
+	ret = call_modprobe(module_name, wait ? UMH_WAIT_PROC : UMH_WAIT_EXEC);
+
 	atomic_dec(&kmod_concurrent);
 	return ret;
 }
-- 
1.7.12.2.21.g234cd45.dirty



