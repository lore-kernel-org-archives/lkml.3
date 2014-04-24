Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753077AbaDXIzP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 04:55:15 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46819 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970AbaDXIy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:54:58 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Oleg Nesterov <oleg@redhat.com>, ebiederm@xmission.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 117/182] pid_namespace: pidns_get() should check task_active_pid_ns() != NULL
Date: Thu, 24 Apr 2014 09:50:42 +0100
Message-Id: <1398329507-5911-118-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
References: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.9 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/pid_namespace.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
index 601bb36..2a953de 100644
--- a/kernel/pid_namespace.c
+++ b/kernel/pid_namespace.c
@@ -312,7 +312,9 @@ static void *pidns_get(struct task_struct *task)
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

