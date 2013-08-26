Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699Ab3HZSBL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 14:01:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20550 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752022Ab3HZSBJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 14:01:09 -0400
Date: Mon, 26 Aug 2013 19:54:41 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Willy Tarreau <w@1wt.eu>, Al Viro <viro@zeniv.linux.org.uk>,
        Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Brad Spengler <spender@grsecurity.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH] proc: make proc_fd_permission() thread-friendly
Message-ID: <20130826175441.GA28856@redhat.com>
References: <20130822201530.GL31117@1wt.eu> <20130824182939.GA23630@redhat.com> <20130824212432.GA9299@1wt.eu> <20130825052317.GZ27005@ZenIV.linux.org.uk> <20130825065039.GB9299@1wt.eu> <CA+55aFwFeCRcwn4qo570Y15mKrN3jEdN757PcZhrXs7QYi8MYA@mail.gmail.com> <20130825194844.GA16717@redhat.com> <CA+55aFzbY3zYD1i5x02Z-6K3nHKzJj6227ZBYRLqij9y0eXRqQ@mail.gmail.com> <20130826153301.GA15890@redhat.com> <20130826163704.GA21763@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130826163704.GA21763@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

proc_fd_permission() says "process can still access /proc/self/fd
after it has executed a setuid()", but the "task_pid() = proc_pid()
check only helps if the task is group leader, /proc/self points to
/proc/leader-pid.

Change this check to use task_tgid() so that the whole process can
access /proc/self/fd.

Note: CLONE_THREAD doesn't require CLONE_FILES so task->files can
differ, but I don't think this can lead to any security problem.

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


