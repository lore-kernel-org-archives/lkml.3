Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755827AbaBTRjS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 12:39:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59234 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755807AbaBTRjP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 12:39:15 -0500
Date: Thu, 20 Feb 2014 18:39:08 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        Lennart Poettering <lpoetter@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Michal Schmidt <mschmidt@redhat.com>,
        Roland McGrath <roland@hack.frob.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] wait: completely ignore the EXIT_DEAD tasks
Message-ID: <20140220173908.GA21863@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140220173838.GA21825@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that EXIT_DEAD is the terminal state it doesn't make sense
to call eligible_child() or security_task_wait() if the task is
really dead.

Tested-by: Michal Schmidt <mschmidt@redhat.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/exit.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index aaad08d..3d6f247 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1331,7 +1331,12 @@ static int wait_task_continued(struct wait_opts *wo, struct task_struct *p)
 static int wait_consider_task(struct wait_opts *wo, int ptrace,
 				struct task_struct *p)
 {
-	int ret = eligible_child(wo, p);
+	int ret;
+
+	if (unlikely(p->exit_state == EXIT_DEAD))
+		return 0;
+
+	ret = eligible_child(wo, p);
 	if (!ret)
 		return ret;
 
@@ -1349,10 +1354,6 @@ static int wait_consider_task(struct wait_opts *wo, int ptrace,
 		return 0;
 	}
 
-	/* dead body doesn't have much to contribute */
-	if (unlikely(p->exit_state == EXIT_DEAD))
-		return 0;
-
 	if (unlikely(p->exit_state == EXIT_TRACE)) {
 		/*
 		 * ptrace == 0 means we are the natural parent. In this case
-- 
1.5.5.1

