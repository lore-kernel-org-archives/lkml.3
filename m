Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892AbaLHUYh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 15:24:37 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:54400 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753655AbaLHUYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 15:24:35 -0500
From: Pranith Kumar <bobby.prani@gmail.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux390@de.ibm.com (supporter:S390),
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Jens Freimann <jfrei@linux.vnet.ibm.com>,
        linux-s390@vger.kernel.org (open list:S390),
        linux-kernel@vger.kernel.org (open list)
Cc: paulmck@linux.vnet.ibm.com
Subject: [PATCH] s390: Include kvm_host.h header only if KVM is enabled
Date: Mon,  8 Dec 2014 15:24:35 -0500
Message-Id: <1418070276-24378-1-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KVM uses srcu structures because of which CONFIG_KVM selects CONFIG_SRCU. In
asm-offsets.c, we are including kvm_host.h unconditionally even though
CONFIG_KVM is not enabled because of which we get errors like follows:

    In file included from arch/s390/kernel/asm-offsets.c:10:0:
>> include/linux/kvm_host.h:363:21: error: field 'srcu' has incomplete type
      struct srcu_struct srcu;
                         ^
>> include/linux/kvm_host.h:364:21: error: field 'irq_srcu' has incomplete type
      struct srcu_struct irq_srcu;
                         ^
    make[2]: *** [arch/s390/kernel/asm-offsets.s] Error 1
    make[2]: Target '__build' not remade because of errors.
    make[1]: *** [prepare0] Error 2
    make[1]: Target 'prepare' not remade because of errors.
    make: *** [sub-make] Error 2 

This patch fixes these by including kvm_host.h conditionally on CONFIG_KVM.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 arch/s390/kernel/asm-offsets.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/s390/kernel/asm-offsets.c b/arch/s390/kernel/asm-offsets.c
index ef279a1..055334d 100644
--- a/arch/s390/kernel/asm-offsets.c
+++ b/arch/s390/kernel/asm-offsets.c
@@ -7,12 +7,15 @@
 #define ASM_OFFSETS_C
 
 #include <linux/kbuild.h>
-#include <linux/kvm_host.h>
 #include <linux/sched.h>
 #include <asm/idle.h>
 #include <asm/vdso.h>
 #include <asm/pgtable.h>
 
+#ifdef CONFIG_KVM
+#include <linux/kvm_host.h>
+#endif
+
 /*
  * Make sure that the compiler is new enough. We want a compiler that
  * is known to work with the "Q" assembler constraint.
@@ -182,8 +185,10 @@ int main(void)
 	DEFINE(__LC_PGM_TDB, offsetof(struct _lowcore, pgm_tdb));
 	DEFINE(__THREAD_trap_tdb, offsetof(struct task_struct, thread.trap_tdb));
 	DEFINE(__GMAP_ASCE, offsetof(struct gmap, asce));
+#ifdef CONFIG_KVM
 	DEFINE(__SIE_PROG0C, offsetof(struct kvm_s390_sie_block, prog0c));
 	DEFINE(__SIE_PROG20, offsetof(struct kvm_s390_sie_block, prog20));
+#endif /* CONFIG_KVM */
 #endif /* CONFIG_32BIT */
 	return 0;
 }
-- 
1.9.1

