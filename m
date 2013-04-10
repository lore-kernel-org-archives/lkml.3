Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937076Ab3DJWrK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 18:47:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56040 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937027Ab3DJWrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 18:47:07 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David Daney <david.daney@cavium.com>,
        Jim Quinlan <jim2101024@gmail.com>, Ralf Baechle <ralf@linux-mips.org>,
        linux-mips@linux-mips.org
Subject: [ 06/64] MIPS: Fix logic errors in bitops.c
Date: Wed, 10 Apr 2013 15:46:03 -0700
Message-Id: <20130410224334.584076940@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130410224333.114387235@linuxfoundation.org>
References: <20130410224333.114387235@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Daney <david.daney@cavium.com>

commit 0c81157b46c533139d6be721d41617020c59a2c3 upstream.

commit 92d11594f6 (MIPS: Remove irqflags.h dependency from bitops.h)
factored some of the bitops code out into a separate file
(arch/mips/lib/bitops.c).  Unfortunately the logic converting a bit
mask into a boolean result was lost in some of the functions.  We had:

   int res;
   unsigned long shifted_result_bit;
   .
   .
   .
   res = shifted_result_bit;
   return res;

Which truncates off the high 32 bits (thus yielding an incorrect
value) on 64-bit systems.

The manifestation of this is that a non-SMP 64-bit kernel will not
boot as the bitmap operations in bootmem.c are all screwed up.

Signed-off-by: David Daney <david.daney@cavium.com>
Cc:  linux-mips@linux-mips.org
Cc: Jim Quinlan <jim2101024@gmail.com>
Patchwork: https://patchwork.linux-mips.org/patch/4965/
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/lib/bitops.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/arch/mips/lib/bitops.c
+++ b/arch/mips/lib/bitops.c
@@ -90,12 +90,12 @@ int __mips_test_and_set_bit(unsigned lon
 	unsigned bit = nr & SZLONG_MASK;
 	unsigned long mask;
 	unsigned long flags;
-	unsigned long res;
+	int res;
 
 	a += nr >> SZLONG_LOG;
 	mask = 1UL << bit;
 	raw_local_irq_save(flags);
-	res = (mask & *a);
+	res = (mask & *a) != 0;
 	*a |= mask;
 	raw_local_irq_restore(flags);
 	return res;
@@ -116,12 +116,12 @@ int __mips_test_and_set_bit_lock(unsigne
 	unsigned bit = nr & SZLONG_MASK;
 	unsigned long mask;
 	unsigned long flags;
-	unsigned long res;
+	int res;
 
 	a += nr >> SZLONG_LOG;
 	mask = 1UL << bit;
 	raw_local_irq_save(flags);
-	res = (mask & *a);
+	res = (mask & *a) != 0;
 	*a |= mask;
 	raw_local_irq_restore(flags);
 	return res;
@@ -141,12 +141,12 @@ int __mips_test_and_clear_bit(unsigned l
 	unsigned bit = nr & SZLONG_MASK;
 	unsigned long mask;
 	unsigned long flags;
-	unsigned long res;
+	int res;
 
 	a += nr >> SZLONG_LOG;
 	mask = 1UL << bit;
 	raw_local_irq_save(flags);
-	res = (mask & *a);
+	res = (mask & *a) != 0;
 	*a &= ~mask;
 	raw_local_irq_restore(flags);
 	return res;
@@ -166,12 +166,12 @@ int __mips_test_and_change_bit(unsigned
 	unsigned bit = nr & SZLONG_MASK;
 	unsigned long mask;
 	unsigned long flags;
-	unsigned long res;
+	int res;
 
 	a += nr >> SZLONG_LOG;
 	mask = 1UL << bit;
 	raw_local_irq_save(flags);
-	res = (mask & *a);
+	res = (mask & *a) != 0;
 	*a ^= mask;
 	raw_local_irq_restore(flags);
 	return res;


