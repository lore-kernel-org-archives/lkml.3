Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932085AbaBTRjW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 12:39:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39884 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755807AbaBTRjT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 12:39:19 -0500
Date: Thu, 20 Feb 2014 18:39:11 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        Lennart Poettering <lpoetter@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Michal Schmidt <mschmidt@redhat.com>,
        Roland McGrath <roland@hack.frob.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] wait: swap EXIT_ZOMBIE and EXIT_DEAD to hide
	EXIT_TRACE from user-space
Message-ID: <20140220173911.GA21866@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140220173838.GA21825@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get_task_state() uses the most significant bit to report the state
to user-space, this means that EXIT_ZOMBIE->EXIT_TRACE->EXIT_DEAD
transition can be noticed via /proc as Z -> X -> Z change. Note
that this was possible even before EXIT_TRACE was introduced.

This is not really bad but imho it make sense to hide EXIT_TRACE
from user-space completely. So the patch simply swaps EXIT_ZOMBIE
and EXIT_DEAD, this way EXIT_TRACE will be seen as EXIT_ZOMBIE by
user-space.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/proc/array.c       |    4 ++--
 include/linux/sched.h |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/proc/array.c b/fs/proc/array.c
index 656e401..64db2bc 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -138,8 +138,8 @@ static const char * const task_state_array[] = {
 	"D (disk sleep)",	/*   2 */
 	"T (stopped)",		/*   4 */
 	"t (tracing stop)",	/*   8 */
-	"Z (zombie)",		/*  16 */
-	"X (dead)",		/*  32 */
+	"X (dead)",		/*  16 */
+	"Z (zombie)",		/*  32 */
 };
 
 static inline const char *get_task_state(struct task_struct *tsk)
diff --git a/include/linux/sched.h b/include/linux/sched.h
index b3593ac..53f9136 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -204,8 +204,8 @@ print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq);
 #define __TASK_STOPPED		4
 #define __TASK_TRACED		8
 /* in tsk->exit_state */
-#define EXIT_ZOMBIE		16
-#define EXIT_DEAD		32
+#define EXIT_DEAD		16
+#define EXIT_ZOMBIE		32
 #define EXIT_TRACE		(EXIT_ZOMBIE | EXIT_DEAD)
 /* in tsk->state again */
 #define TASK_DEAD		64
-- 
1.5.5.1

