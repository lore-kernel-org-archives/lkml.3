Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934388Ab3BNL41 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 06:56:27 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:41588 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757475Ab3BNL4Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 06:56:25 -0500
From: Glauber Costa <glommer@parallels.com>
To: <linux-kernel@vger.kernel.org>
Cc: <containers@lists.linux-foundation.org>,
        Glauber Costa <glommer@parallels.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] kernel: allow reboots from user_ns
Date: Thu, 14 Feb 2013 15:56:40 +0400
Message-Id: <1360843000-31228-1-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reboot support for pid namespaces is already implemented and it works
well. However, in most containers the tasks will join all namespaces,
including the now supported user namespace. In that situation, we will
fail the "capable" test and won't be able to reboot.

The proposed solution is to allow reboots for CAP_SYS_BOOT processes
in the user namespace that owns the pid namespace.

Signed-off-by: Glauber Costa <glommer@parallels.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 kernel/sys.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/sys.c b/kernel/sys.c
index 265b376..3b0958e 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -435,9 +435,10 @@ SYSCALL_DEFINE4(reboot, int, magic1, int, magic2, unsigned int, cmd,
 {
 	char buffer[256];
 	int ret = 0;
+	struct pid_namespace *curr_pidns = task_active_pid_ns(current);
 
 	/* We only trust the superuser with rebooting the system. */
-	if (!capable(CAP_SYS_BOOT))
+	if (!ns_capable(curr_pidns->user_ns, CAP_SYS_BOOT))
 		return -EPERM;
 
 	/* For safety, we require "magic" arguments. */
@@ -453,7 +454,7 @@ SYSCALL_DEFINE4(reboot, int, magic1, int, magic2, unsigned int, cmd,
 	 * pid_namespace, the command is handled by reboot_pid_ns() which will
 	 * call do_exit().
 	 */
-	ret = reboot_pid_ns(task_active_pid_ns(current), cmd);
+	ret = reboot_pid_ns(curr_pidns, cmd);
 	if (ret)
 		return ret;
 
-- 
1.8.1.2

