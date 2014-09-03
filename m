Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933255AbaICWIe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 18:08:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45489 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933065AbaICWI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 18:08:29 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Aleksei Besogonov <alex.besogonov@gmail.com>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.10 55/55] vm_is_stack: use for_each_thread() rather then buggy while_each_thread()
Date: Wed,  3 Sep 2014 15:05:45 -0700
Message-Id: <20140903220502.640557931@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140903220453.653576908@linuxfoundation.org>
References: <20140903220453.653576908@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

commit 4449a51a7c281602d3a385044ab928322a122a02 upstream.

Aleksei hit the soft lockup during reading /proc/PID/smaps.  David
investigated the problem and suggested the right fix.

while_each_thread() is racy and should die, this patch updates
vm_is_stack().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reported-by: Aleksei Besogonov <alex.besogonov@gmail.com>
Tested-by: Aleksei Besogonov <alex.besogonov@gmail.com>
Suggested-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/util.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/mm/util.c
+++ b/mm/util.c
@@ -272,17 +272,14 @@ pid_t vm_is_stack(struct task_struct *ta
 
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


