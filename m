Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756893AbaIZK2G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 06:28:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33056 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754781AbaIZJqE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:46:04 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 030/142] vm_is_stack: use for_each_thread() rather then buggy while_each_thread()
Date: Fri, 26 Sep 2014 11:44:01 +0200
Message-Id: <d9cd4a157bb0068a044552015bdf0020d21bbfd4.1411724723.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
References: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
In-Reply-To: <cover.1411724723.git.jslaby@suse.cz>
References: <cover.1411724723.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 mm/util.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/mm/util.c b/mm/util.c
index 96da2d7c076c..de943ec0a4c8 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -272,17 +272,14 @@ pid_t vm_is_stack(struct task_struct *task,
 
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
2.1.0

