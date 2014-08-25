Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933047AbaHYPdX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 11:33:23 -0400
Received: from mail-qa0-f41.google.com ([209.85.216.41]:56170 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755979AbaHYPdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 11:33:08 -0400
Message-ID: <53FB5733.4010607@bluespec.com>
Date: Mon, 25 Aug 2014 11:33:07 -0400
From: Darius Rad <darius@bluespec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.7.0
MIME-Version: 1.0
To: linux-arch@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] include/asm-generic/cmpxchg-local.h: perform comparison in
 cmpxchg using appropriate size of data
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the generic implementation of cmpxchg, cast the parameters to the size
of the data prior to comparison.  Otherwise, it is possible for the
comparison to be done incorrectly in the case where the data size is
smaller than the architecture register size.

For example, on a 64-bit architecture, a 32-bit value is sign extended
differently if it is typecast from an int to an unsigned long as compared
to being loaded from memory via an unsigned pointer (u32 *).  Given that
the primary, or possibly only, use of cmpxchg is with 4 and 8 byte values,
the incorrect comparison could only occur on 64-bit architectures that make
use of the generic cmpxchg.

Signed-off-by: Darius Rad <darius@bluespec.com>

---
It does not appear that this is relevant to architectures that are in the
kernel tree, since the generic cmpxchg is only ever used by some 32-bit
architectures.  This does impact the RISC-V architecture that is currently
in development.

Patch generated against 3.17-rc1.

 include/asm-generic/cmpxchg-local.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- linux-3.17-rc1.orig/include/asm-generic/cmpxchg-local.h	2014-08-16 12:40:26.000000000 -0400
+++ linux-3.17-rc1/include/asm-generic/cmpxchg-local.h	2014-08-22 14:26:59.280746090 -0400
@@ -25,19 +25,19 @@ static inline unsigned long __cmpxchg_lo
 	raw_local_irq_save(flags);
 	switch (size) {
 	case 1: prev = *(u8 *)ptr;
-		if (prev == old)
+		if ((u8)prev == (u8)old)
 			*(u8 *)ptr = (u8)new;
 		break;
 	case 2: prev = *(u16 *)ptr;
-		if (prev == old)
+		if ((u16)prev == (u16)old)
 			*(u16 *)ptr = (u16)new;
 		break;
 	case 4: prev = *(u32 *)ptr;
-		if (prev == old)
+		if ((u32)prev == (u32)old)
 			*(u32 *)ptr = (u32)new;
 		break;
 	case 8: prev = *(u64 *)ptr;
-		if (prev == old)
+		if ((u64)prev == (u64)old)
 			*(u64 *)ptr = (u64)new;
 		break;
 	default:
