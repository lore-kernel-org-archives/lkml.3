Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750920AbaHGEBh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 00:01:37 -0400
Received: from mail-yh0-f65.google.com ([209.85.213.65]:52387 "EHLO
	mail-yh0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731AbaHGEBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 00:01:36 -0400
From: Nick Krause <xerofoiify@gmail.com>
To: Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        "GitAuthor: Nick Krause" <xerofoiify@gmail.com>,
        linux-cris-kernel@axis.com (open list:CRIS PORT),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] cris: bug: add unreachable() to silence warnings
Date: Thu,  7 Aug 2014 06:01:14 +0200
Message-Id: <1407384076-20060-1-git-send-email-xerofoiify@gmail.com>
X-Mailer: git-send-email 2.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cris BUG() have warnings like

drivers/memstick/core/ms_block.c:677:1: warning: control reaches end of non-void function 
drivers/memstick/core/ms_block.c:720:1: warning: control reaches end of non-void function 
drivers/memstick/core/ms_block.c:654:1: warning: control reaches end of non-void function 
drivers/memstick/core/ms_block.c:465:1: warning: control reaches end of non-void function 
drivers/memstick/core/mspro_block.c:663:1: warning: control reaches end of non-void function 

Other BUG() implementations
have added unreachable() at end becuase of which I guess
it does not showthese errors. We can silence them using unreachable().

Signed-off-by: Nick Krause <xerofoify@gmail.com>
---
 arch/cris/include/arch-v10/arch/bug.h | 5 ++++-
 arch/cris/include/arch-v32/arch/bug.h | 5 ++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/cris/include/arch-v10/arch/bug.h b/arch/cris/include/arch-v10/arch/bug.h
index 3485d6b..40e65ad 100644
--- a/arch/cris/include/arch-v10/arch/bug.h
+++ b/arch/cris/include/arch-v10/arch/bug.h
@@ -43,12 +43,15 @@ struct bug_frame {
  * not be used like this with newer versions of gcc.
  */
 #define BUG()								\
+do {									\
 	__asm__ __volatile__ ("clear.d [" __stringify(BUG_MAGIC) "]\n\t"\
 			      "movu.w " __stringify(__LINE__) ",$r0\n\t"\
 			      "jump 0f\n\t"				\
 			      ".section .rodata\n"			\
 			      "0:\t.string \"" __FILE__ "\"\n\t"	\
-			      ".previous")
+			      ".previous");				\
+	unreachable();							\
+} while (0)
 #endif
 
 #else
diff --git a/arch/cris/include/arch-v32/arch/bug.h b/arch/cris/include/arch-v32/arch/bug.h
index 0f211e1..55350a3 100644
--- a/arch/cris/include/arch-v32/arch/bug.h
+++ b/arch/cris/include/arch-v32/arch/bug.h
@@ -10,6 +10,7 @@
  * All other stuff is done out-of-band with exception handlers.
  */
 #define BUG()								\
+do {									\
 	__asm__ __volatile__ ("0: break 14\n\t"				\
 			      ".section .fixup,\"ax\"\n"		\
 			      "1:\n\t"					\
@@ -21,7 +22,9 @@
 			      ".section __ex_table,\"a\"\n\t"		\
 			      ".dword 0b, 1b\n\t"			\
 			      ".previous\n\t"				\
-			      : : "ri" (__FILE__), "i" (__LINE__))
+			      : : "ri" (__FILE__), "i" (__LINE__));	\
+	unreachable();
+} while (0)
 #else
 #define BUG() __asm__ __volatile__ ("break 14\n\t")
 #endif
-- 
2.0.1

