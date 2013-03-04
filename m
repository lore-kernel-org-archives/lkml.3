Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755835Ab3CDDnA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 22:43:00 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60858 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755588Ab3CDDmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:42:49 -0500
Message-Id: <20130304033721.999775251@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 04 Mar 2013 03:39:34 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Oleg Nesterov <oleg@redhat.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 147/153] kmod: introduce call_modprobe() helper
In-Reply-To: <20130304033707.648729212@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

commit 3e63a93b987685f02421e18b2aa452d20553a88b upstream.

No functional changes.  Move the call_usermodehelper code from
__request_module() into the new simple helper, call_modprobe().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Tejun Heo <tj@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/kmod.c |   24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -58,6 +58,21 @@ static DEFINE_SPINLOCK(umh_sysctl_lock);
 */
 char modprobe_path[KMOD_PATH_LEN] = "/sbin/modprobe";
 
+static int call_modprobe(char *module_name, int wait)
+{
+	static char *envp[] = {
+		"HOME=/",
+		"TERM=linux",
+		"PATH=/sbin:/usr/sbin:/bin:/usr/bin",
+		NULL
+	};
+
+	char *argv[] = { modprobe_path, "-q", "--", module_name, NULL };
+
+	return call_usermodehelper_fns(modprobe_path, argv, envp,
+					wait, NULL, NULL, NULL);
+}
+
 /**
  * __request_module - try to load a kernel module
  * @wait: wait (or not) for the operation to complete
@@ -79,11 +94,6 @@ int __request_module(bool wait, const ch
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
@@ -126,9 +136,7 @@ int __request_module(bool wait, const ch
 
 	trace_module_request(module_name, wait, _RET_IP_);
 
-	ret = call_usermodehelper_fns(modprobe_path, argv, envp,
-			wait ? UMH_WAIT_PROC : UMH_WAIT_EXEC,
-			NULL, NULL, NULL);
+	ret = call_modprobe(module_name, wait ? UMH_WAIT_PROC : UMH_WAIT_EXEC);
 
 	atomic_dec(&kmod_concurrent);
 	return ret;


