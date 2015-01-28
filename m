Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760677AbbA2JJN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:09:13 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44944 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757941AbbA2JJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:09:05 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 026/176] x86_64, vdso: Fix the vdso address randomization algorithm
Date: Wed, 28 Jan 2015 15:27:36 +0100
Message-Id: <0c9312164d6e069707dd96a001849f4b853c546d.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Lutomirski <luto@amacapital.net>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 394f56fe480140877304d342dec46d50dc823d46 upstream.

The theory behind vdso randomization is that it's mapped at a random
offset above the top of the stack.  To avoid wasting a page of
memory for an extra page table, the vdso isn't supposed to extend
past the lowest PMD into which it can fit.  Other than that, the
address should be a uniformly distributed address that meets all of
the alignment requirements.

The current algorithm is buggy: the vdso has about a 50% probability
of being at the very end of a PMD.  The current algorithm also has a
decent chance of failing outright due to incorrect handling of the
case where the top of the stack is near the top of its PMD.

This fixes the implementation.  The paxtest estimate of vdso
"randomisation" improves from 11 bits to 18 bits.  (Disclaimer: I
don't know what the paxtest code is actually calculating.)

It's worth noting that this algorithm is inherently biased: the vdso
is more likely to end up near the end of its PMD than near the
beginning.  Ideally we would either nix the PMD sharing requirement
or jointly randomize the vdso and the stack to reduce the bias.

In the mean time, this is a considerable improvement with basically
no risk of compatibility issues, since the allowed outputs of the
algorithm are unchanged.

As an easy test, doing this:

for i in `seq 10000`
  do grep -P vdso /proc/self/maps |cut -d- -f1
done |sort |uniq -d

used to produce lots of output (1445 lines on my most recent run).
A tiny subset looks like this:

7fffdfffe000
7fffe01fe000
7fffe05fe000
7fffe07fe000
7fffe09fe000
7fffe0bfe000
7fffe0dfe000

Note the suspicious fe000 endings.  With the fix, I get a much more
palatable 76 repeated addresses.

Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/x86/vdso/vma.c | 43 +++++++++++++++++++++++++++++--------------
 1 file changed, 29 insertions(+), 14 deletions(-)

diff --git a/arch/x86/vdso/vma.c b/arch/x86/vdso/vma.c
index 431e87544411..ab6ba35a9357 100644
--- a/arch/x86/vdso/vma.c
+++ b/arch/x86/vdso/vma.c
@@ -117,30 +117,45 @@ subsys_initcall(init_vdso);
 
 struct linux_binprm;
 
-/* Put the vdso above the (randomized) stack with another randomized offset.
-   This way there is no hole in the middle of address space.
-   To save memory make sure it is still in the same PTE as the stack top.
-   This doesn't give that many random bits */
+/*
+ * Put the vdso above the (randomized) stack with another randomized
+ * offset.  This way there is no hole in the middle of address space.
+ * To save memory make sure it is still in the same PTE as the stack
+ * top.  This doesn't give that many random bits.
+ *
+ * Note that this algorithm is imperfect: the distribution of the vdso
+ * start address within a PMD is biased toward the end.
+ *
+ * Only used for the 64-bit and x32 vdsos.
+ */
 static unsigned long vdso_addr(unsigned long start, unsigned len)
 {
 	unsigned long addr, end;
 	unsigned offset;
-	end = (start + PMD_SIZE - 1) & PMD_MASK;
+
+	/*
+	 * Round up the start address.  It can start out unaligned as a result
+	 * of stack start randomization.
+	 */
+	start = PAGE_ALIGN(start);
+
+	/* Round the lowest possible end address up to a PMD boundary. */
+	end = (start + len + PMD_SIZE - 1) & PMD_MASK;
 	if (end >= TASK_SIZE_MAX)
 		end = TASK_SIZE_MAX;
 	end -= len;
-	/* This loses some more bits than a modulo, but is cheaper */
-	offset = get_random_int() & (PTRS_PER_PTE - 1);
-	addr = start + (offset << PAGE_SHIFT);
-	if (addr >= end)
-		addr = end;
+
+	if (end > start) {
+		offset = get_random_int() % (((end - start) >> PAGE_SHIFT) + 1);
+		addr = start + (offset << PAGE_SHIFT);
+	} else {
+		addr = start;
+	}
 
 	/*
-	 * page-align it here so that get_unmapped_area doesn't
-	 * align it wrongfully again to the next page. addr can come in 4K
-	 * unaligned here as a result of stack start randomization.
+	 * Forcibly align the final address in case we have a hardware
+	 * issue that requires alignment for performance reasons.
 	 */
-	addr = PAGE_ALIGN(addr);
 	addr = align_vdso_addr(addr);
 
 	return addr;
-- 
2.2.2

