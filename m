Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756090Ab3IKQpA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 12:45:00 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:16410 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754249Ab3IKQo7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 12:44:59 -0400
Date: Wed, 11 Sep 2013 18:44:56 +0200
Message-Id: <201309111644.r8BGiuDZ016325@localhost.localdomain>
From: Christophe Leroy <christophe.leroy@c-s.fr>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
CC: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Joakim Tjernlund <joakim.tjernlund@transmode.se>
Subject: [PATCH] powerpc 8xx: Fixing issue with CONFIG_PIN_TLB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Activating CONFIG_PIN_TLB is supposed to pin the IMMR and the first three
8Mbytes pages. But the setting of the MD_CTR was missing so as the index is
decremented every DTLB update, the pinning of the third 8Mbytes page was
overwriting the DTLB entry for IMMR.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>

diff -ur linux-3.11.org/arch/powerpc/kernel/head_8xx.S linux-3.11/arch/powerpc/kernel/head_8xx.S
--- linux-3.11.org/arch/powerpc/kernel/head_8xx.S	2013-09-02 22:46:10.000000000 +0200
+++ linux-3.11/arch/powerpc/kernel/head_8xx.S	2013-09-09 11:28:54.000000000 +0200
@@ -862,6 +862,9 @@
 	addis	r11, r11, 0x0080	/* Add 8M */
 	mtspr	SPRN_MD_RPN, r11
 
+	addi	r10, r10, 0x0100
+	mtspr	SPRN_MD_CTR, r10
+
 	addis	r8, r8, 0x0080		/* Add 8M */
 	mtspr	SPRN_MD_EPN, r8
 	mtspr	SPRN_MD_TWC, r9
