Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756908AbaBUAvZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 19:51:25 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45524 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755152AbaBTXv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 18:51:29 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Noonan <steven@uplinklabs.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Jakub Jelinek <jakub@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 3.10 53/66] compiler/gcc4: Make quirk for asm_volatile_goto() unconditional
Date: Thu, 20 Feb 2014 15:51:52 -0800
Message-Id: <20140220234911.002709648@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140220234909.482516304@linuxfoundation.org>
References: <20140220234909.482516304@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Noonan <steven@uplinklabs.net>

commit a9f180345f5378ac87d80ed0bea55ba421d83859 upstream.

I started noticing problems with KVM guest destruction on Linux
3.12+, where guest memory wasn't being cleaned up. I bisected it
down to the commit introducing the new 'asm goto'-based atomics,
and found this quirk was later applied to those.

Unfortunately, even with GCC 4.8.2 (which ostensibly fixed the
known 'asm goto' bug) I am still getting some kind of
miscompilation. If I enable the asm_volatile_goto quirk for my
compiler, KVM guests are destroyed correctly and the memory is
cleaned up.

So make the quirk unconditional for now, until bug is found
and fixed.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Steven Noonan <steven@uplinklabs.net>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Jakub Jelinek <jakub@redhat.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Link: http://lkml.kernel.org/r/1392274867-15236-1-git-send-email-steven@uplinklabs.net
Link: http://gcc.gnu.org/bugzilla/show_bug.cgi?id=58670
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/compiler-gcc4.h |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/include/linux/compiler-gcc4.h
+++ b/include/linux/compiler-gcc4.h
@@ -75,11 +75,7 @@
  *
  * (asm goto is automatically volatile - the naming reflects this.)
  */
-#if GCC_VERSION <= 40801
-# define asm_volatile_goto(x...)	do { asm goto(x); asm (""); } while (0)
-#else
-# define asm_volatile_goto(x...)	do { asm goto(x); } while (0)
-#endif
+#define asm_volatile_goto(x...)	do { asm goto(x); asm (""); } while (0)
 
 #ifdef CONFIG_ARCH_USE_BUILTIN_BSWAP
 #if GCC_VERSION >= 40400


