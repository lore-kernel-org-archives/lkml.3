Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758460AbaDVVSt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 17:18:49 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36200 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757383AbaDVUP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 16:15:28 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Oleg Nesterov <oleg@redhat.com>, ebiederm@xmission.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 115/133] pid_namespace: pidns_get() should check task_active_pid_ns() != NULL
Date: Tue, 22 Apr 2014 13:14:13 -0700
Message-Id: <1398197671-12786-116-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398197671-12786-1-git-send-email-kamal@canonical.com>
References: <1398197671-12786-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.22 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

commit d23082257d83e4bc89727d5aedee197e907999d2 upstream.

pidns_get()->get_pid_ns() can hit ns == NULL. This task_struct can't
go away, but task_active_pid_ns(task) is NULL if release_task(task)
was already called. Alternatively we could change get_pid_ns(ns) to
check ns != NULL, but it seems that other callers are fine.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Eric W. Biederman ebiederm@xmission.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 kernel/pid_namespace.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
index bea15bd..7d40b94 100644
--- a/kernel/pid_namespace.c
+++ b/kernel/pid_namespace.c
@@ -314,7 +314,9 @@ static void *pidns_get(struct task_struct *task)
 	struct pid_namespace *ns;
 
 	rcu_read_lock();
-	ns = get_pid_ns(task_active_pid_ns(task));
+	ns = task_active_pid_ns(task);
+	if (ns)
+		get_pid_ns(ns);
 	rcu_read_unlock();
 
 	return ns;
-- 
1.9.1

