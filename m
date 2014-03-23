Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064AbaCWTjL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 15:39:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63007 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751740AbaCWTjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 15:39:08 -0400
Date: Sun, 23 Mar 2014 20:38:12 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, David Woodhouse <dwmw2@infradead.org>,
        Richard Weinberger <richard@nod.at>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 11/11] signals: change wait_for_helper() to use
	kernel_sigaction()
Message-ID: <20140323193812.GA10530@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140323193730.GA10464@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we have kernel_sigaction() we can change wait_for_helper()
to use it and cleanups the code a bit.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/kmod.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/kernel/kmod.c b/kernel/kmod.c
index 6b375af..c18c891 100644
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -285,10 +285,7 @@ static int wait_for_helper(void *data)
 	pid_t pid;
 
 	/* If SIGCLD is ignored sys_wait4 won't populate the status. */
-	spin_lock_irq(&current->sighand->siglock);
-	current->sighand->action[SIGCHLD-1].sa.sa_handler = SIG_DFL;
-	spin_unlock_irq(&current->sighand->siglock);
-
+	kernel_sigaction(SIGCHLD, SIG_DFL);
 	pid = kernel_thread(____call_usermodehelper, sub_info, SIGCHLD);
 	if (pid < 0) {
 		sub_info->retval = pid;
-- 
1.5.5.1

