Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752091Ab3CREp3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 00:45:29 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33488 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751748Ab3CREaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 00:30:25 -0400
Message-Id: <20130318042150.572567427@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 18 Mar 2013 04:22:49 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Kees Cook <keescook@chromium.org>,
        Emese Revfy <re.emese@gmail.com>, PaX Team <pageexec@freemail.hu>,
        Al Viro <viro@zeniv.linux.org.uk>, Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Julien Tinnes <jln@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 65/82] signal: always clear sa_restorer on execve
In-Reply-To: <20130318042144.234468645@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d98f:da4e:f620:7bea
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

commit 2ca39528c01a933f6689cd6505ce65bd6d68a530 upstream.

When the new signal handlers are set up, the location of sa_restorer is
not cleared, leaking a parent process's address space location to
children.  This allows for a potential bypass of the parent's ASLR by
examining the sa_restorer value returned when calling sigaction().

Based on what should be considered "secret" about addresses, it only
matters across the exec not the fork (since the VMAs haven't changed
until the exec).  But since exec sets SIG_DFL and keeps sa_restorer,
this is where it should be fixed.

Given the few uses of sa_restorer, a "set" function was not written
since this would be the only use.  Instead, we use
__ARCH_HAS_SA_RESTORER, as already done in other places.

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

[akpm@linux-foundation.org: use SA_RESTORER for backportability]
Signed-off-by: Kees Cook <keescook@chromium.org>
Reported-by: Emese Revfy <re.emese@gmail.com>
Cc: Emese Revfy <re.emese@gmail.com>
Cc: PaX Team <pageexec@freemail.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Cc: Julien Tinnes <jln@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/signal.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -481,6 +481,9 @@ flush_signal_handlers(struct task_struct
 		if (force_default || ka->sa.sa_handler != SIG_IGN)
 			ka->sa.sa_handler = SIG_DFL;
 		ka->sa.sa_flags = 0;
+#ifdef SA_RESTORER
+		ka->sa.sa_restorer = NULL;
+#endif
 		sigemptyset(&ka->sa.sa_mask);
 		ka++;
 	}


