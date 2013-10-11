Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757407Ab3JKM4q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 08:56:46 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:35036 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751751Ab3JKM4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 08:56:44 -0400
Date: Fri, 11 Oct 2013 14:56:40 +0200
Message-Id: <201310111256.r9BCuepM006243@localhost.localdomain>
From: Christophe Leroy <christophe.leroy@c-s.fr>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
CC: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH] powerpc 8xx: Fixing memory init issue with CONFIG_PIN_TLB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Activating CONFIG_PIN_TLB allows access to the 24 first Mbytes of memory at
bootup instead of 8. It is needed for "big" kernels for instance when activating
CONFIG_LOCKDEP_SUPPORT. This needs to be taken into account in init_32 too,
otherwise memory allocation soon fails after startup.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>

diff -ur linux-3.11.org/arch/powerpc/kernel/head_8xx.S linux-3.11/arch/powerpc/kernel/head_8xx.S
--- linux-3.11.org/arch/powerpc/mm/init_32.c	2013-09-02 22:46:10.000000000 +0200
+++ linux-3.11/arch/powerpc/mm/init_32.c	2013-09-09 11:28:54.000000000 +0200
@@ -213,7 +213,12 @@
 	 */
 	BUG_ON(first_memblock_base != 0);
 
+#ifdef CONFIG_PIN_TLB
+	/* 8xx can only access 24MB at the moment */
+	memblock_set_current_limit(min_t(u64, first_memblock_size, 0x01800000));
+#else
 	/* 8xx can only access 8MB at the moment */
 	memblock_set_current_limit(min_t(u64, first_memblock_size, 0x00800000));
+#endif
 }
 #endif /* CONFIG_8xx */
