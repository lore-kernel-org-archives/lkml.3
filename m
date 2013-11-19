Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853Ab3KSTUd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 14:20:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24102 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753088Ab3KSTU3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 14:20:29 -0500
Date: Tue, 19 Nov 2013 20:21:45 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] x86: make DR6_RESERVED/DR_CONTROL_RESERVED unsigned long
Message-ID: <20131119192145.GA8604@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DR6_RESERVED and DR_CONTROL_RESERVED are used to clear the unwanted
bits in the "unsigned long" data, but "ulong &= ~int" also clears the
upper bits that are not specified in mask.

This is actually fine, dr6[32:63] are reserved, but this is not clear
so it would be better to make them "unsigned long" to cleanup the code.

However, depending on sizeof(long), DR6_RESERVED should be either
0xFFFF0FF0 or 0xFFFFFFFF_FFFF0FF0, so this patch redefines them as
(~ 32_bit_mask UL) to avoid ifdef's.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Suggested-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 arch/x86/include/uapi/asm/debugreg.h |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/uapi/asm/debugreg.h b/arch/x86/include/uapi/asm/debugreg.h
index 3c0874d..4ff5d05 100644
--- a/arch/x86/include/uapi/asm/debugreg.h
+++ b/arch/x86/include/uapi/asm/debugreg.h
@@ -15,7 +15,7 @@
    are either reserved or not of interest to us. */
 
 /* Define reserved bits in DR6 which are always set to 1 */
-#define DR6_RESERVED	(0xFFFF0FF0)
+#define DR6_RESERVED	(~0xF00FUL)
 
 #define DR_TRAP0	(0x1)		/* db0 */
 #define DR_TRAP1	(0x2)		/* db1 */
@@ -64,11 +64,7 @@
    We can slow the instruction pipeline for instructions coming via the
    gdt or the ldt if we want to.  I am not sure why this is an advantage */
 
-#ifdef __i386__
-#define DR_CONTROL_RESERVED (0xFC00) /* Reserved by Intel */
-#else
-#define DR_CONTROL_RESERVED (0xFFFFFFFF0000FC00UL) /* Reserved */
-#endif
+#define DR_CONTROL_RESERVED (~0xFFFF03FFUL) /* Reserved by Intel */
 
 #define DR_LOCAL_SLOWDOWN (0x100)   /* Local slow the pipeline */
 #define DR_GLOBAL_SLOWDOWN (0x200)  /* Global slow the pipeline */
-- 
1.5.5.1


