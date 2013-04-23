Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756532Ab3DWWIJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 18:08:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34202 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757646Ab3DWVyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 17:54:12 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Emese Revfy <re.emese@gmail.com>, PaX Team <pageexec@freemail.hu>,
        Kees Cook <keescook@chromium.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 05/26] kernel/signal.c: stop info leak via the tkill and the tgkill syscalls
Date: Tue, 23 Apr 2013 14:53:45 -0700
Message-Id: <20130423215333.914159050@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130423215333.344045754@linuxfoundation.org>
References: <20130423215333.344045754@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/signal.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2867,7 +2867,7 @@ do_send_specific(pid_t tgid, pid_t pid,
 
 static int do_tkill(pid_t tgid, pid_t pid, int sig)
 {
-	struct siginfo info;
+	struct siginfo info = {};
 
 	info.si_signo = sig;
 	info.si_errno = 0;


