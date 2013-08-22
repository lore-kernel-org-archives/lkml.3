Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829Ab3HVRPy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 13:15:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18925 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753605Ab3HVRPw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 13:15:52 -0400
Date: Thu, 22 Aug 2013 19:09:58 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Brad Spengler <spender@grsecurity.net>,
        Colin Walters <walters@redhat.com>,
        Pavel Emelyanov <xemul@parallels.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] pidns: fix vfork() after unshare(CLONE_NEWPID)
Message-ID: <20130822170958.GA20314@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130822170939.GA20296@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

8382fcac "pidns: Outlaw thread creation after unshare(CLONE_NEWPID)"
nacks CLONE_VM if the forking process unshared pid_ns, this obviously
breaks vfork:

	int main(void)
	{
		assert(unshare(CLONE_NEWUSER | CLONE_NEWPID) == 0);
		assert(vfork() >= 0);
		_exit(0);
		return 0;
	}

fails without this patch.

Change this check to use CLONE_SIGHAND instead. This also forbids
CLONE_THREAD automatically, and this is what the comment implies.

We could probably even drop CLONE_SIGHAND and use CLONE_THREAD,
but it would be safer to not do this. The current check denies
CLONE_SIGHAND implicitely and there is no reason to change this.

Reported-by: Colin Walters <walters@redhat.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/fork.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index e23bb19..86f5376 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1173,10 +1173,10 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 		return ERR_PTR(-EINVAL);
 
 	/*
-	 * If the new process will be in a different pid namespace
-	 * don't allow the creation of threads.
+	 * If the new process will be in a different pid namespace don't
+	 * allow the creation of threads, or share the signal handlers.
 	 */
-	if ((clone_flags & (CLONE_VM|CLONE_NEWPID)) &&
+	if ((clone_flags & (CLONE_SIGHAND | CLONE_NEWPID)) &&
 	    (task_active_pid_ns(current) != current->nsproxy->pid_ns))
 		return ERR_PTR(-EINVAL);
 
-- 
1.5.5.1

