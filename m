Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932118Ab3HWSFE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 14:05:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39174 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932087Ab3HWSFA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 14:05:00 -0400
Date: Fri, 23 Aug 2013 19:59:06 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Brad Spengler <spender@grsecurity.net>,
        Colin Walters <walters@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/3] pidns: kill the unnecessary CLONE_NEWPID in
	copy_process()
Message-ID: <20130823175906.GA30226@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130823175846.GA30201@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

8382fcac "pidns: Outlaw thread creation after unshare(CLONE_NEWPID)"
nacks CLONE_NEWPID if the forking process unshared pid_ns. This is
correct but unnecessary, copy_pid_ns() does the same check.

Remove the CLONE_NEWPID check to cleanup the code and prepare for
the next change.

Test-case:

	static int child(void *arg)
	{
		return 0;
	}

	static char stack[16 * 1024];

	int main(void)
	{
		pid_t pid;

		assert(unshare(CLONE_NEWUSER | CLONE_NEWPID) == 0);

		pid = clone(child, stack + sizeof(stack) / 2,
				CLONE_NEWPID | SIGCHLD, NULL);
		assert(pid < 0 && errno == EINVAL);

		return 0;
	}

clone(CLONE_NEWPID) correctly fails with or without this change.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Andy Lutomirski <luto@amacapital.net>
---
 kernel/fork.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 29c9f6b..27b5918 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1177,7 +1177,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	 * allow it to share a thread group or signal handlers with the
 	 * forking task.
 	 */
-	if ((clone_flags & (CLONE_SIGHAND | CLONE_NEWPID)) &&
+	if ((clone_flags & CLONE_SIGHAND) &&
 	    (task_active_pid_ns(current) != current->nsproxy->pid_ns))
 		return ERR_PTR(-EINVAL);
 
-- 
1.5.5.1

