Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751621AbaAOHOt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 02:14:49 -0500
Received: from ozlabs.org ([203.10.76.45]:36931 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750749AbaAOHOe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 02:14:34 -0500
From: Michael Ellerman <mpe@ellerman.id.au>
To: <linuxppc-dev@ozlabs.org>
Cc: Michael Neuling <mikey@neuling.org>, Linus Torvalds <torvalds@osdl.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] powerpc: Implement arch_spin_is_locked() using arch_spin_value_unlocked()
Date: Wed, 15 Jan 2014 18:14:29 +1100
Message-Id: <1389770069-28733-2-git-send-email-mpe@ellerman.id.au>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389770069-28733-1-git-send-email-mpe@ellerman.id.au>
References: <1389770069-28733-1-git-send-email-mpe@ellerman.id.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At a glance these are just the inverse of each other. The one subtlety
is that arch_spin_value_unlocked() takes the lock by value, rather than
as a pointer, which is important for the lockref code.

On the other hand arch_spin_is_locked() doesn't really care, so
implement it in terms of arch_spin_value_unlocked().

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
---
 arch/powerpc/include/asm/spinlock.h | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/include/asm/spinlock.h b/arch/powerpc/include/asm/spinlock.h
index 5162f8c..a30ef69 100644
--- a/arch/powerpc/include/asm/spinlock.h
+++ b/arch/powerpc/include/asm/spinlock.h
@@ -28,8 +28,6 @@
 #include <asm/synch.h>
 #include <asm/ppc-opcode.h>
 
-#define arch_spin_is_locked(x)		((x)->slock != 0)
-
 #ifdef CONFIG_PPC64
 /* use 0x800000yy when locked, where yy == CPU number */
 #ifdef __BIG_ENDIAN__
@@ -59,6 +57,11 @@ static __always_inline int arch_spin_value_unlocked(arch_spinlock_t lock)
 	return lock.slock == 0;
 }
 
+static inline int arch_spin_is_locked(arch_spinlock_t *lock)
+{
+	return !arch_spin_value_unlocked(*lock);
+}
+
 /*
  * This returns the old value in the lock, so we succeeded
  * in getting the lock if the return value is 0.
-- 
1.8.3.2

