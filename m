Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756658Ab3IKRUi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 13:20:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31813 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756232Ab3IKRUg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 13:20:36 -0400
Date: Wed, 11 Sep 2013 19:14:03 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Brad Spengler <spender@grsecurity.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>, Willy Tarreau <w@1wt.eu>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/1] proc: make proc_fd_permission() thread-friendly
Message-ID: <20130911171403.GA15381@redhat.com>
References: <20130911171341.GA15371@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130911171341.GA15371@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

proc_fd_permission() says "process can still access /proc/self/fd
after it has executed a setuid()", but the "task_pid() = proc_pid()
check only helps if the task is group leader, /proc/self points to
/proc/<leader-pid>.

Change this check to use task_tgid() so that the whole thread group
can access its /proc/self/fd or /proc/<tid-of-sub-thread>/fd.

Notes:
	- CLONE_THREAD does not require CLONE_FILES so task->files
	  can differ, but I don't think this can lead to any security
	  problem. And this matches same_thread_group() in
	  __ptrace_may_access().

	- /proc/self should probably point to /proc/<thread-tid>, but
	  it is too late to change the rules. Perhaps it makes sense
	  to add /proc/thread though.


Test-case:

	void *tfunc(void *arg)
	{
		assert(opendir("/proc/self/fd"));
		return NULL;
	}

	int main(void)
	{
		pthread_t t;
		pthread_create(&t, NULL, tfunc, NULL);
		pthread_join(t, NULL);
		return 0;
	}

fails if, say, this executable is not readable and suid_dumpable = 0.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/proc/fd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/proc/fd.c b/fs/proc/fd.c
index 0ff80f9..985ea88 100644
--- a/fs/proc/fd.c
+++ b/fs/proc/fd.c
@@ -286,7 +286,7 @@ int proc_fd_permission(struct inode *inode, int mask)
 	int rv = generic_permission(inode, mask);
 	if (rv == 0)
 		return 0;
-	if (task_pid(current) == proc_pid(inode))
+	if (task_tgid(current) == proc_pid(inode))
 		rv = 0;
 	return rv;
 }
-- 
1.5.5.1


