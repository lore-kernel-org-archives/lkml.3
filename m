Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755235AbaHGTtS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 15:49:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44127 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755104AbaHGTtR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 15:49:17 -0400
Date: Thu, 7 Aug 2014 21:47:21 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Aleksei Besogonov <alex.besogonov@gmail.com>,
        David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] vm_is_stack: use for_each_thread() rather then buggy
	while_each_thread()
Message-ID: <20140807194721.GA5741@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Aleksei hit the soft lockup during reading /proc/PID/smaps.
David investigated the problem and suggested the right fix.

while_each_thread() is racy and should die, this patch updates
vm_is_stack().

Reported-and-tested-by: Aleksei Besogonov <alex.besogonov@gmail.com>
Suggested-by: David Rientjes <rientjes@google.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: stable@vger.kernel.org
---
 mm/util.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/mm/util.c b/mm/util.c
index d5ea733..33e9f44 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -277,17 +277,14 @@ pid_t vm_is_stack(struct task_struct *task,
 
 	if (in_group) {
 		struct task_struct *t;
-		rcu_read_lock();
-		if (!pid_alive(task))
-			goto done;
 
-		t = task;
-		do {
+		rcu_read_lock();
+		for_each_thread(task, t) {
 			if (vm_is_stack_for_task(t, vma)) {
 				ret = t->pid;
 				goto done;
 			}
-		} while_each_thread(task, t);
+		}
 done:
 		rcu_read_unlock();
 	}
-- 
1.5.5.1


