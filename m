Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754326Ab3CKUN5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 16:13:57 -0400
Received: from smtp.outflux.net ([198.145.64.163]:59839 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753913Ab3CKUN4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 16:13:56 -0400
Date: Mon, 11 Mar 2013 13:13:42 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Emese Revfy <re.emese@gmail.com>, PaX Team <pageexec@freemail.hu>,
        jln@google.com
Subject: [PATCH v2] signal: always clear sa_restorer on execve
Message-ID: <20130311201342.GA19824@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the new signal handlers are set up, the location of sa_restorer
is not cleared, leaking a parent process's address space location to
children. This allows for a potential bypass of the parent's ASLR by
examining the sa_restorer value returned when calling sigaction().

Based on what should be considered "secret" about addresses, it only
matters across the exec not the fork (since the VMAs haven't changed
until the exec). But since exec sets SIG_DFL and keeps sa_restorer,
this is where it should be fixed.

Given the few uses of sa_restorer, a "set" function was not written
since this would be the only use. Instead, we use __ARCH_HAS_SA_RESTORER,
as already done in other places.

Example of the leak before applying this patch:

$ cat /proc/$$/maps
...
7fb9f3083000-7fb9f3238000 r-xp 00000000 fd:01 404469 .../libc-2.15.so
...
$ ./leak
...
7f278bc74000-7f278be29000 r-xp 00000000 fd:01 404469 .../libc-2.15.so
...
1 0 (nil) 0x7fb9f30b94a0
2 4000000 (nil) 0x7f278bcaa4a0
3 4000000 (nil) 0x7f278bcaa4a0
4 0 (nil) 0x7fb9f30b94a0
...

Signed-off-by: Kees Cook <keescook@chromium.org>
Reported-by: Emese Revfy <re.emese@gmail.com>
Cc: Emese Revfy <re.emese@gmail.com>
Cc: PaX Team <pageexec@freemail.hu>
Cc: stable@vger.kernel.org
---
v2:
 - clarify commit, explain use of #ifdef.
---
 kernel/signal.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/signal.c b/kernel/signal.c
index 2ec870a..8c8e3ca 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -485,6 +485,9 @@ flush_signal_handlers(struct task_struct *t, int force_default)
 		if (force_default || ka->sa.sa_handler != SIG_IGN)
 			ka->sa.sa_handler = SIG_DFL;
 		ka->sa.sa_flags = 0;
+#ifdef __ARCH_HAS_SA_RESTORER
+		ka->sa.sa_restorer = NULL;
+#endif
 		sigemptyset(&ka->sa.sa_mask);
 		ka++;
 	}
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
