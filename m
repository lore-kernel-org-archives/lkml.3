Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707AbaBMHB1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 02:01:27 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:59743 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141AbaBMHBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 02:01:25 -0500
From: Steven Noonan <steven@uplinklabs.net>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Steven Noonan <steven@uplinklabs.net>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>, stable@vger.kernel.org
Subject: [PATCH v2] compiler/gcc4: make quirk for asm_volatile_goto unconditional
Date: Wed, 12 Feb 2014 23:01:07 -0800
Message-Id: <1392274867-15236-1-git-send-email-steven@uplinklabs.net>
X-Mailer: git-send-email 1.8.5.4
In-Reply-To: <1392274106.28471.2.camel@marge.simpson.net>
References: <1392274106.28471.2.camel@marge.simpson.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I started noticing problems with KVM guest destruction on Linux 3.12+, where
guest memory wasn't being cleaned up. I bisected it down to the commit
introducing the new 'asm goto'-based atomics, and found this quirk was later
applied to those.

Unfortunately, even with GCC 4.8.2 (which ostensibly fixed the known 'asm goto'
bug) I am still getting some kind of miscompilation. If I enable the
asm_volatile_goto quirk for my compiler, KVM guests are destroyed correctly and
the memory is cleaned up.

[1] http://gcc.gnu.org/bugzilla/show_bug.cgi?id=58670
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: stable@vger.kernel.org
Signed-off-by: Steven Noonan <steven@uplinklabs.net>
---

v2: Adding stable@vger.kernel.org to Cc.

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
-- 
1.8.5.4

