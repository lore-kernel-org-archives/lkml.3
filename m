Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752105Ab3EBGuY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 02:50:24 -0400
Received: from tama50.ecl.ntt.co.jp ([129.60.39.147]:34623 "EHLO
	tama50.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887Ab3EBGuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 02:50:22 -0400
Message-ID: <1367476850.5660.2.camel@nexus>
Subject: [PATCH] x86, 64bit: do not assume CPU is NX capable when setting
 early page tables
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando_b1@lab.ntt.co.jp>
To: "H. Peter Anvin" <hpa@linux.intel.com>, Yinghai Lu <yinghai@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 02 May 2013 15:40:50 +0900
Organization: NTT Open Source Software Center
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel sets the NX bit in the early page tables without checking whether
the CPU actually supports this feature. If it doesn't the first attempt to use
them will cause a kernel hang. Since these are temporary page tables marked as
initdata this fix takes the approach of not bothering with the NX bit at all.

Noticed when my AMD machine that happened to have the NX feature disabled by
the BIOS failed to boot after the update to 3.9.

Cc: stable@vger.kernel.org
Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
---

diff -urNp linux-3.9/arch/x86/kernel/head64.c linux-3.9-fix/arch/x86/kernel/head64.c
--- linux-3.9/arch/x86/kernel/head64.c	2013-04-29 09:36:01.000000000 +0900
+++ linux-3.9-fix/arch/x86/kernel/head64.c	2013-05-02 14:38:52.589276092 +0900
@@ -99,7 +99,7 @@ again:
 			pmd_p[i] = 0;
 		*pud_p = (pudval_t)pmd_p - __START_KERNEL_map + phys_base + _KERNPG_TABLE;
 	}
-	pmd = (physaddr & PMD_MASK) + (__PAGE_KERNEL_LARGE & ~_PAGE_GLOBAL);
+	pmd = (physaddr & PMD_MASK) + (__PAGE_KERNEL_LARGE_EXEC & ~_PAGE_GLOBAL);
 	pmd_p[pmd_index(address)] = pmd;
 
 	return 0;


