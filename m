Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437AbaATNxF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 08:53:05 -0500
Received: from mail-ea0-f172.google.com ([209.85.215.172]:37684 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013AbaATNxC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 08:53:02 -0500
Date: Mon, 20 Jan 2014 14:52:58 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/asm changes for v3.14
Message-ID: <20140120135258.GA12476@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-asm-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-asm-for-linus

   # HEAD: a740576a4abf933de8f50787f24f24456cebd761 x86: Slightly tweak the access_ok() C variant for better code

Misc optimizations.

 Thanks,

	Ingo

------------------>
Fenghua Yu (1):
      x86-64, copy_user: Remove zero byte check before copy user buffer.

H. Peter Anvin (2):
      x86-64, copy_user: Use leal to produce 32-bit results
      x86: Slightly tweak the access_ok() C variant for better code

Linus Torvalds (1):
      x86: Replace assembly access_ok() with a C variant


 arch/x86/include/asm/uaccess.h | 32 ++++++++++++++++++++------------
 arch/x86/lib/copy_user_64.S    | 12 ++++--------
 2 files changed, 24 insertions(+), 20 deletions(-)

diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index 8ec57c0..6f1bb74 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -40,22 +40,30 @@
 /*
  * Test whether a block of memory is a valid user space address.
  * Returns 0 if the range is valid, nonzero otherwise.
- *
- * This is equivalent to the following test:
- * (u33)addr + (u33)size > (u33)current->addr_limit.seg (u65 for x86_64)
- *
- * This needs 33-bit (65-bit for x86_64) arithmetic. We have a carry...
  */
+static inline bool __chk_range_not_ok(unsigned long addr, unsigned long size, unsigned long limit)
+{
+	/*
+	 * If we have used "sizeof()" for the size,
+	 * we know it won't overflow the limit (but
+	 * it might overflow the 'addr', so it's
+	 * important to subtract the size from the
+	 * limit, not add it to the address).
+	 */
+	if (__builtin_constant_p(size))
+		return addr > limit - size;
+
+	/* Arbitrary sizes? Be careful about overflow */
+	addr += size;
+	if (addr < size)
+		return true;
+	return addr > limit;
+}
 
 #define __range_not_ok(addr, size, limit)				\
 ({									\
-	unsigned long flag, roksum;					\
 	__chk_user_ptr(addr);						\
-	asm("add %3,%1 ; sbb %0,%0 ; cmp %1,%4 ; sbb $0,%0"		\
-	    : "=&r" (flag), "=r" (roksum)				\
-	    : "1" (addr), "g" ((long)(size)),				\
-	      "rm" (limit));						\
-	flag;								\
+	__chk_range_not_ok((unsigned long __force)(addr), size, limit); \
 })
 
 /**
@@ -78,7 +86,7 @@
  * this function, memory access functions may still return -EFAULT.
  */
 #define access_ok(type, addr, size) \
-	(likely(__range_not_ok(addr, size, user_addr_max()) == 0))
+	likely(!__range_not_ok(addr, size, user_addr_max()))
 
 /*
  * The exception table consists of pairs of addresses relative to the
diff --git a/arch/x86/lib/copy_user_64.S b/arch/x86/lib/copy_user_64.S
index a30ca15..dee945d 100644
--- a/arch/x86/lib/copy_user_64.S
+++ b/arch/x86/lib/copy_user_64.S
@@ -186,7 +186,7 @@ ENTRY(copy_user_generic_unrolled)
 30:	shll $6,%ecx
 	addl %ecx,%edx
 	jmp 60f
-40:	lea (%rdx,%rcx,8),%rdx
+40:	leal (%rdx,%rcx,8),%edx
 	jmp 60f
 50:	movl %ecx,%edx
 60:	jmp copy_user_handle_tail /* ecx is zerorest also */
@@ -236,8 +236,6 @@ ENDPROC(copy_user_generic_unrolled)
 ENTRY(copy_user_generic_string)
 	CFI_STARTPROC
 	ASM_STAC
-	andl %edx,%edx
-	jz 4f
 	cmpl $8,%edx
 	jb 2f		/* less than 8 bytes, go to byte copy loop */
 	ALIGN_DESTINATION
@@ -249,12 +247,12 @@ ENTRY(copy_user_generic_string)
 2:	movl %edx,%ecx
 3:	rep
 	movsb
-4:	xorl %eax,%eax
+	xorl %eax,%eax
 	ASM_CLAC
 	ret
 
 	.section .fixup,"ax"
-11:	lea (%rdx,%rcx,8),%rcx
+11:	leal (%rdx,%rcx,8),%ecx
 12:	movl %ecx,%edx		/* ecx is zerorest also */
 	jmp copy_user_handle_tail
 	.previous
@@ -279,12 +277,10 @@ ENDPROC(copy_user_generic_string)
 ENTRY(copy_user_enhanced_fast_string)
 	CFI_STARTPROC
 	ASM_STAC
-	andl %edx,%edx
-	jz 2f
 	movl %edx,%ecx
 1:	rep
 	movsb
-2:	xorl %eax,%eax
+	xorl %eax,%eax
 	ASM_CLAC
 	ret
 
