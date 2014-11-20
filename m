Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757941AbaKTSed (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 13:34:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33021 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757698AbaKTSea (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 13:34:30 -0500
Date: Thu, 20 Nov 2014 19:34:28 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Aaron Tomlin <atomlin@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Sterling Alexander <stalexan@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH -mm 3/3] exit: exit_notify: re-use "dead" list to autoreap
	current
Message-ID: <20141120183428.GA10280@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141120183400.GA9622@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After the previous change we can add just the exiting EXIT_DEAD task
to the "dead" list and remove another release_task(tsk).

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/exit.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index ccf27cb..43394f7 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -632,6 +632,8 @@ static void exit_notify(struct task_struct *tsk, int group_dead)
 	}
 
 	tsk->exit_state = autoreap ? EXIT_DEAD : EXIT_ZOMBIE;
+	if (tsk->exit_state == EXIT_DEAD)
+		list_add(&tsk->ptrace_entry, &dead);
 
 	/* mt-exec, de_thread() is waiting for group leader */
 	if (unlikely(tsk->signal->notify_count < 0))
@@ -642,10 +644,6 @@ static void exit_notify(struct task_struct *tsk, int group_dead)
 		list_del_init(&p->ptrace_entry);
 		release_task(p);
 	}
-
-	/* If the process is dead, release it - nobody will wait for it */
-	if (autoreap)
-		release_task(tsk);
 }
 
 #ifdef CONFIG_DEBUG_STACK_USAGE
-- 
1.5.5.1

