Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362AbaKGUOi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 15:14:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45847 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753202AbaKGUOh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 15:14:37 -0500
Date: Fri, 7 Nov 2014 21:14:46 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Aaron Tomlin <atomlin@redhat.com>, Alexey Dobriyan <adobriyan@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Sterling Alexander <stalexan@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] proc: task_state: read cred->group_info outside of
	task_lock()
Message-ID: <20141107201446.GA22233@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141107201424.GA22209@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

task_state() reads cred->group_info under task_lock() because a long
ago it was task_struct->group_info and it was actually protected by
task->alloc_lock. Today this task_unlock() after rcu_read_unlock()
just adds the confusion, move task_unlock() up.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/proc/array.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/proc/array.c b/fs/proc/array.c
index cd3653e..b5810c2 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -201,11 +201,10 @@ static inline void task_state(struct seq_file *m, struct pid_namespace *ns,
 		"FDSize:\t%d\n"
 		"Groups:\t",
 		fdt ? fdt->max_fds : 0);
+	task_unlock(p);
 	rcu_read_unlock();
 
 	group_info = cred->group_info;
-	task_unlock(p);
-
 	for (g = 0; g < group_info->ngroups; g++)
 		seq_printf(m, "%d ",
 			   from_kgid_munged(user_ns, GROUP_AT(group_info, g)));
-- 
1.5.5.1

