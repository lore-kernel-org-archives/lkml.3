Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754441AbaBMLiP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 06:38:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35986 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156AbaBMLiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 06:38:13 -0500
Date: Thu, 13 Feb 2014 03:37:08 -0800
From: tip-bot for Steven Noonan <tipbot@zytor.com>
Message-ID: <tip-a9f180345f5378ac87d80ed0bea55ba421d83859@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        stable@vger.kernel.org, steven@uplinklabs.net,
        akpm@linux-foundation.org, rostedt@goodmis.org, jakub@redhat.com,
        oleg@redhat.com, tglx@linutronix.de, rth@twiddle.net
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        stable@vger.kernel.org, steven@uplinklabs.net, jakub@redhat.com,
        rostedt@goodmis.org, akpm@linux-foundation.org, tglx@linutronix.de,
        oleg@redhat.com, rth@twiddle.net
In-Reply-To: <1392274867-15236-1-git-send-email-steven@uplinklabs.net>
References: <1392274867-15236-1-git-send-email-steven@uplinklabs.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] compiler/gcc4: Make quirk for asm_volatile_goto(
 ) unconditional
Git-Commit-ID: a9f180345f5378ac87d80ed0bea55ba421d83859
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 13 Feb 2014 03:37:15 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a9f180345f5378ac87d80ed0bea55ba421d83859
Gitweb:     http://git.kernel.org/tip/a9f180345f5378ac87d80ed0bea55ba421d83859
Author:     Steven Noonan <steven@uplinklabs.net>
AuthorDate: Wed, 12 Feb 2014 23:01:07 -0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 13 Feb 2014 12:34:05 +0100

compiler/gcc4: Make quirk for asm_volatile_goto() unconditional

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
Cc: <stable@vger.kernel.org>
Link: http://lkml.kernel.org/r/1392274867-15236-1-git-send-email-steven@uplinklabs.net
Link: http://gcc.gnu.org/bugzilla/show_bug.cgi?id=58670
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/compiler-gcc4.h | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/include/linux/compiler-gcc4.h b/include/linux/compiler-gcc4.h
index ded4299..2507fd2 100644
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
