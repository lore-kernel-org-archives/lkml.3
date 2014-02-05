Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799AbaBEUGH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:06:07 -0500
Received: from mail.windriver.com ([147.11.1.11]:54791 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507AbaBEUFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:05:40 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Oleg Nesterov <oleg@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 087/213] ptrace: ptrace_resume() shouldn't wake up !TASK_TRACED thread
Date: Wed, 5 Feb 2014 15:00:42 -0500
Message-ID: <1391630568-49251-88-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 0666fb51b1483f27506e212cc7f7b2645b5c7acc upstream.

It is not clear why ptrace_resume() does wake_up_process(). Unless the
caller is PTRACE_KILL the tracee should be TASK_TRACED so we can use
wake_up_state(__TASK_TRACED). If sys_ptrace() races with SIGKILL we do
not need the extra and potentionally spurious wakeup.

If the caller is PTRACE_KILL, wake_up_process() is even more wrong.
The tracee can sleep in any state in any place, and if we have a buggy
code which doesn't handle a spurious wakeup correctly PTRACE_KILL can
be used to exploit it. For example:

	int main(void)
	{
		int child, status;

		child = fork();
		if (!child) {
			int ret;

			assert(ptrace(PTRACE_TRACEME, 0,0,0) == 0);

			ret = pause();
			printf("pause: %d %m\n", ret);

			return 0x23;
		}

		sleep(1);
		assert(ptrace(PTRACE_KILL, child, 0,0) == 0);

		assert(child == wait(&status));
		printf("wait: %x\n", status);

		return 0;
	}

prints "pause: -1 Unknown error 514", -ERESTARTNOHAND leaks to the
userland. In this case sys_pause() is buggy as well and should be
fixed.

I do not know what was the original rationality behind PTRACE_KILL.
The man page is simply wrong and afaics it was always wrong. Imho
it should be deprecated, or may be it should do send_sig(SIGKILL)
as Denys suggests, but in any case I do not think that the current
behaviour was intentional.

Note: there is another problem, ptrace_resume() changes ->exit_code
and this can race with SIGKILL too. Eventually we should change ptrace
to not use ->exit_code.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 kernel/ptrace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index b7b491e6c25b..9450ec22e5a6 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -507,7 +507,7 @@ static int ptrace_resume(struct task_struct *child, long request, long data)
 	}
 
 	child->exit_code = data;
-	wake_up_process(child);
+	wake_up_state(child, __TASK_TRACED);
 
 	return 0;
 }
-- 
1.8.5.2

