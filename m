Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125Ab3FDWlG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 18:41:06 -0400
Received: from 1wt.eu ([62.212.114.60]:35136 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751750Ab3FDWkl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:40:41 -0400
Message-Id: <20130604172131.303348510@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:21:54 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>,
        Colin King <colin.king@canonical.com>,
        Tim Gardner <tim.gardner@canonical.com>, Willy Tarreau <w@1wt.eu>
Subject: [ 024/184] wake_up_process() should be never used to wakeup a
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------
 TASK_STOPPED/TRACED task

From: Oleg Nesterov <oleg@redhat.com>

wake_up_process() should be never used to wakeup a TASK_STOPPED/TRACED task

CVE-2013-0871

BugLink: http://bugs.launchpad.net/bugs/1129192

wake_up_process() should never wakeup a TASK_STOPPED/TRACED task.
Change it to use TASK_NORMAL and add the WARN_ON().

TASK_ALL has no other users, probably can be killed.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
(backported from commit 9067ac85d533651b98c2ff903182a20cbb361fcb)

Conflicts:
	kernel/sched/core.c

Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
Acked-by: Colin King <colin.king@canonical.com>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 kernel/sched.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 0591df8..42bf6a6 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2618,7 +2618,8 @@ out:
  */
 int wake_up_process(struct task_struct *p)
 {
-	return try_to_wake_up(p, TASK_ALL, 0);
+	WARN_ON(task_is_stopped_or_traced(p));
+	return try_to_wake_up(p, TASK_NORMAL, 0);
 }
 EXPORT_SYMBOL(wake_up_process);
 
-- 
1.7.12.2.21.g234cd45.dirty



