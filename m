Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932962AbaKRVcA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 16:32:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50380 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932858AbaKRVaV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 16:30:21 -0500
Date: Tue, 18 Nov 2014 22:30:20 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Aaron Tomlin <atomlin@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Kay Sievers <kay@vrfy.org>,
        Lennart Poettering <lennart@poettering.net>,
        Sterling Alexander <stalexan@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/6] exit: reparent: s/while_each_thread/for_each_thread/
	in find_new_reaper()
Message-ID: <20141118213020.GA5020@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141118212952.GA4754@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change find_new_reaper() to use for_each_thread() instead of deprecated
while_each_thread(). We do not bother to check "thread != father" in the
1st loop, we can rely on PF_EXITING check.

Note: this means the minor behavioural change: for_each_thread() starts
from the group leader. But this should be fine, nobody should make any
assumption about do_wait(__WNOTHREAD) when it comes to reparented tasks.
And this can avoid the pointless reparenting to a short-living thread
While zombie leaders are not that common.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/exit.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 9ade2f5..ac7ba9b 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -473,8 +473,7 @@ static struct task_struct *find_new_reaper(struct task_struct *father)
 	struct pid_namespace *pid_ns = task_active_pid_ns(father);
 	struct task_struct *thread;
 
-	thread = father;
-	while_each_thread(father, thread) {
+	for_each_thread(father, thread) {
 		if (thread->flags & PF_EXITING)
 			continue;
 		if (unlikely(pid_ns->child_reaper == father))
@@ -511,11 +510,10 @@ static struct task_struct *find_new_reaper(struct task_struct *father)
 				break;
 			if (!reaper->signal->is_child_subreaper)
 				continue;
-			thread = reaper;
-			do {
+			for_each_thread(reaper, thread) {
 				if (!(thread->flags & PF_EXITING))
 					return thread;
-			} while_each_thread(reaper, thread);
+			}
 		}
 	}
 
-- 
1.5.5.1

