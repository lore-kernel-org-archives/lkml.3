Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933230Ab3DBWMc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 18:12:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:32985 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933080Ab3DBWMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:12:23 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Caj Larsson <caj@omnicloud.com>, Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [ 048/124] pid: Handle the exit of a multi-threaded init.
Date: Tue,  2 Apr 2013 15:10:30 -0700
Message-Id: <20130402221109.746528693@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130402221104.163133110@linuxfoundation.org>
References: <20130402221104.163133110@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Eric W. Biederman" <ebiederm@xmission.com>

commit 751c644b95bb48aaa8825f0c66abbcc184d92051 upstream.

When a multi-threaded init exits and the initial thread is not the
last thread to exit the initial thread hangs around as a zombie
until the last thread exits.  In that case zap_pid_ns_processes
needs to wait until there are only 2 hashed pids in the pid
namespace not one.

v2. Replace thread_pid_vnr(me) == 1 with the test thread_group_leader(me)
    as suggested by Oleg.

Reported-by: Caj Larsson <caj@omnicloud.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/pid_namespace.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/pid_namespace.c
+++ b/kernel/pid_namespace.c
@@ -181,6 +181,7 @@ void zap_pid_ns_processes(struct pid_nam
 	int nr;
 	int rc;
 	struct task_struct *task, *me = current;
+	int init_pids = thread_group_leader(me) ? 1 : 2;
 
 	/* Don't allow any more processes into the pid namespace */
 	disable_pid_allocation(pid_ns);
@@ -230,7 +231,7 @@ void zap_pid_ns_processes(struct pid_nam
 	 */
 	for (;;) {
 		set_current_state(TASK_UNINTERRUPTIBLE);
-		if (pid_ns->nr_hashed == 1)
+		if (pid_ns->nr_hashed == init_pids)
 			break;
 		schedule();
 	}


