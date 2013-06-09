Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751602Ab3FIRE1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 13:04:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56249 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751203Ab3FIREY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 13:04:24 -0400
Date: Sun, 9 Jun 2013 19:00:23 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Michal Hocko <mhocko@suse.cz>,
        Pavel Emelyanov <xemul@parallels.com>,
        Sergey Dyasly <dserrg@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] de_thread: use change_pid() rather than
	detach_pid/attach_pid
Message-ID: <20130609170023.GA5233@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130609170007.GA5215@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

de_thread() can use change_pid() instead of detach + attach.
This looks better and this ensures that, say, next_thread()
can never see a task with ->pid == NULL.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/exec.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 6430195..00eaba7 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -945,9 +945,8 @@ static int de_thread(struct task_struct *tsk)
 		 * Note: The old leader also uses this pid until release_task
 		 *       is called.  Odd but simple and correct.
 		 */
-		detach_pid(tsk, PIDTYPE_PID);
 		tsk->pid = leader->pid;
-		attach_pid(tsk, PIDTYPE_PID,  task_pid(leader));
+		change_pid(tsk, PIDTYPE_PID, task_pid(leader));
 		transfer_pid(leader, tsk, PIDTYPE_PGID);
 		transfer_pid(leader, tsk, PIDTYPE_SID);
 
-- 
1.5.5.1

