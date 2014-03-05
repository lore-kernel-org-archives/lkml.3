Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757616AbaCED6s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 22:58:48 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:42636 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757593AbaCED6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 22:58:43 -0500
Date: Tue, 4 Mar 2014 19:58:41 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Tejun Heo <tj@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Oleg Nesterov <oleg@redhat.com>,
        Rik van Riel <riel@redhat.com>, Jianguo Wu <wujianguo@huawei.com>,
        Tim Hockin <thockin@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org
Subject: [patch 01/11] fork: collapse copy_flags into copy_process
In-Reply-To: <alpine.DEB.2.02.1403041952170.8067@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.02.1403041953570.8067@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1403041952170.8067@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

copy_flags() does not use the clone_flags formal and can be collapsed
into copy_process() for cleaner code.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 kernel/fork.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1069,15 +1069,6 @@ static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
 	return 0;
 }
 
-static void copy_flags(unsigned long clone_flags, struct task_struct *p)
-{
-	unsigned long new_flags = p->flags;
-
-	new_flags &= ~(PF_SUPERPRIV | PF_WQ_WORKER);
-	new_flags |= PF_FORKNOEXEC;
-	p->flags = new_flags;
-}
-
 SYSCALL_DEFINE1(set_tid_address, int __user *, tidptr)
 {
 	current->clear_child_tid = tidptr;
@@ -1227,7 +1218,8 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 		goto bad_fork_cleanup_count;
 
 	delayacct_tsk_init(p);	/* Must remain after dup_task_struct() */
-	copy_flags(clone_flags, p);
+	p->flags &= ~(PF_SUPERPRIV | PF_WQ_WORKER);
+	p->flags |= PF_FORKNOEXEC;
 	INIT_LIST_HEAD(&p->children);
 	INIT_LIST_HEAD(&p->sibling);
 	rcu_copy_process(p);
