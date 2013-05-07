Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752611Ab3EGOQu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 10:16:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42136 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932550Ab3EGNks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:40:48 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Emese Revfy <re.emese@gmail.com>, Kees Cook <keescook@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 009/118] kernel/signal.c: stop info leak via the tkill and the tgkill syscalls
Date: Tue,  7 May 2013 14:37:35 +0100
Message-Id: <1367933964-1564-10-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
References: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emese Revfy <re.emese@gmail.com>

commit b9e146d8eb3b9ecae5086d373b50fa0c1f3e7f0f upstream.

This fixes a kernel memory contents leak via the tkill and tgkill syscalls
for compat processes.

This is visible in the siginfo_t->_sifields._rt.si_sigval.sival_ptr field
when handling signals delivered from tkill.

The place of the infoleak:

int copy_siginfo_to_user32(compat_siginfo_t __user *to, siginfo_t *from)
{
        ...
        put_user_ex(ptr_to_compat(from->si_ptr), &to->si_ptr);
        ...
}

Signed-off-by: Emese Revfy <re.emese@gmail.com>
Reviewed-by: PaX Team <pageexec@freemail.hu>
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/signal.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 0e9b729..c0356f9 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2885,7 +2885,7 @@ do_send_specific(pid_t tgid, pid_t pid, int sig, struct siginfo *info)
 
 static int do_tkill(pid_t tgid, pid_t pid, int sig)
 {
-	struct siginfo info;
+	struct siginfo info = {};
 
 	info.si_signo = sig;
 	info.si_errno = 0;
-- 
1.8.1.2

