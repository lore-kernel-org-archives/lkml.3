Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893AbaKXUGo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 15:06:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43598 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754353AbaKXUGm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 15:06:42 -0500
Date: Mon, 24 Nov 2014 21:06:29 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Aaron Tomlin <atomlin@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        Sterling Alexander <stalexan@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] exit: pidns: alloc_pid() leaks pid_namespace if
	child_reaper is exiting
Message-ID: <20141124200629.GA21009@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141124200602.GA20575@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

alloc_pid() does get_pid_ns() beforehand but forgets to put_pid_ns()
if it fails because disable_pid_allocation() was called by the exiting
child_reaper. We can move get_pid_ns() down to successful return.

While at it, simplify/cleanup the "goto out" mess, no need to confuse
the success/error return paths.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/pid.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/kernel/pid.c b/kernel/pid.c
index 9b9a266..dfc2f3b 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -320,7 +320,6 @@ struct pid *alloc_pid(struct pid_namespace *ns)
 			goto out_free;
 	}
 
-	get_pid_ns(ns);
 	atomic_set(&pid->count, 1);
 	for (type = 0; type < PIDTYPE_MAX; ++type)
 		INIT_HLIST_HEAD(&pid->tasks[type]);
@@ -336,7 +335,7 @@ struct pid *alloc_pid(struct pid_namespace *ns)
 	}
 	spin_unlock_irq(&pidmap_lock);
 
-out:
+	get_pid_ns(ns);
 	return pid;
 
 out_unlock:
@@ -346,8 +345,8 @@ out_free:
 		free_pidmap(pid->numbers + i);
 
 	kmem_cache_free(ns->pid_cachep, pid);
-	pid = NULL;
-	goto out;
+out:
+	return NULL;
 }
 
 void disable_pid_allocation(struct pid_namespace *ns)
-- 
1.5.5.1

