Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980Ab3HVRQA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 13:16:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28103 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753750Ab3HVRPx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 13:15:53 -0400
Date: Thu, 22 Aug 2013 19:10:01 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Brad Spengler <spender@grsecurity.net>,
        Colin Walters <walters@redhat.com>,
        Pavel Emelyanov <xemul@parallels.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] pidns: kill the unnecessary CLONE_NEWPID in
	copy_process()
Message-ID: <20130822171001.GA20321@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130822170939.GA20296@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

8382fcac "pidns: Outlaw thread creation after unshare(CLONE_NEWPID)"
nacks CLONE_NEWPID if the forking process unshared pid_ns. This is
correct but unnecessary, copy_pid_ns() does the same check.

Test-case (needs root or CLONE_NEWUSER should be added):

	static int child(void *arg)
	{
		return 0;
	}

	static char stack[16 * 1024];

	int main(void)
	{
		pid_t pid;

		assert(unshare(CLONE_NEWPID) == 0);

		pid = clone(child, stack + sizeof(stack) / 2,
				CLONE_NEWPID | SIGCHLD, NULL);
		assert(pid < 0 && errno == EINVAL);

		return 0;
	}

clone(CLONE_NEWPID) correctly fails with or without this change.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/fork.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 86f5376..8d56338 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1176,7 +1176,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	 * If the new process will be in a different pid namespace don't
 	 * allow the creation of threads, or share the signal handlers.
 	 */
-	if ((clone_flags & (CLONE_SIGHAND | CLONE_NEWPID)) &&
+	if ((clone_flags & CLONE_SIGHAND) &&
 	    (task_active_pid_ns(current) != current->nsproxy->pid_ns))
 		return ERR_PTR(-EINVAL);
 
-- 
1.5.5.1

