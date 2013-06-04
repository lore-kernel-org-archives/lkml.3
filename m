Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752375Ab3FDWlR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 18:41:17 -0400
Received: from 1wt.eu ([62.212.114.60]:35166 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751811Ab3FDWku (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:40:50 -0400
Message-Id: <20130604172131.053503073@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:21:48 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Oleg Nesterov <oleg@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>,
        Colin King <colin.king@canonical.com>,
        Tim Gardner <tim.gardner@canonical.com>, Willy Tarreau <w@1wt.eu>
Subject: [ 018/184] ptrace: ptrace_resume() shouldnt wake up
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------
 !TASK_TRACED thread

From: Oleg Nesterov <oleg@redhat.com>

ptrace: ptrace_resume() shouldn't wake up !TASK_TRACED thread

CVE-2013-0871

BugLink: http://bugs.launchpad.net/bugs/1129192

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
(cherry picked from commit 0666fb51b1483f27506e212cc7f7b2645b5c7acc)

Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
Acked-by: Colin King <colin.king@canonical.com>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 kernel/ptrace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 05625f6..d8184b5 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -506,7 +506,7 @@ static int ptrace_resume(struct task_struct *child, long request, long data)
 	}
 
 	child->exit_code = data;
-	wake_up_process(child);
+	wake_up_state(child, __TASK_TRACED);
 
 	return 0;
 }
-- 
1.7.12.2.21.g234cd45.dirty



