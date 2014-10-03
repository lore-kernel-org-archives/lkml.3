Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932427AbaJCWeS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 18:34:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47800 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755439AbaJCWeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:34:06 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Aleksei Besogonov <alex.besogonov@gmail.com>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Li Zefan <lizefan@huawei.com>
Subject: [PATCH 3.10 143/143] vm_is_stack: use for_each_thread() rather then buggy while_each_thread()
Date: Fri,  3 Oct 2014 14:35:38 -0700
Message-Id: <20141003213318.758273746@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003213314.470709810@linuxfoundation.org>
References: <20141003213314.470709810@linuxfoundation.org>
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
Cc: Li Zefan <lizefan@huawei.com>
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


