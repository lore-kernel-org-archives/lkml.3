Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752971Ab3IXISo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 04:18:44 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:32206 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750774Ab3IXISm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 04:18:42 -0400
Date: Tue, 24 Sep 2013 10:18:39 +0200
Message-Id: <201309240818.r8O8IdF9016374@localhost.localdomain>
From: Christophe Leroy <christophe.leroy@c-s.fr>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
CC: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Joakim Tjernlund <joakim.tjernlund@transmode.se>
Subject: [PATCH v4] powerpc 8xx: Fixing issue with CONFIG_PIN_TLB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Activating CONFIG_PIN_TLB is supposed to pin the IMMR and the first three
8Mbytes pages. But the setting of MD_CTR to a pinnable entry was missing before
the pinning of the third 8Mb page. As the index is decremented module 28
(MD_RSV4D is set) after every DTLB update, the third 8Mbytes page was
not pinned.

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
