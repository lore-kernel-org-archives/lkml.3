Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161120Ab3CVReb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 13:34:31 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:27694 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161069Ab3CVRea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 13:34:30 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH] xen/mmu: Move the setting of pvops.write_cr3 to later phase in bootup.
Date: Fri, 22 Mar 2013 13:34:24 -0400
Message-Id: <1363973664-16380-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.0.2
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We move the setting of write_cr3 from the early bootup variant
(see git commit 0cc9129d75ef8993702d97ab0e49542c15ac6ab9
"x86-64, xen, mmu: Provide an early version of write_cr3.")
to a more appropiate location.

This new location sets all of the other non-early variants
of pvops calls - and most importantly is before the
alternative_asm mechanism kicks in.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/mmu.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 31cc1ef..750f185 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1470,8 +1470,6 @@ static void __init xen_write_cr3_init(unsigned long cr3)
 	__xen_write_cr3(true, cr3);
 
 	xen_mc_issue(PARAVIRT_LAZY_CPU);  /* interrupts restored */
-
-	pv_mmu_ops.write_cr3 = &xen_write_cr3;
 }
 #endif
 
@@ -2142,6 +2140,7 @@ static void __init xen_post_allocator_init(void)
 #endif
 
 #ifdef CONFIG_X86_64
+	pv_mmu_ops.write_cr3 = &xen_write_cr3;
 	SetPagePinned(virt_to_page(level3_user_vsyscall));
 #endif
 	xen_mark_init_mm_pinned();
-- 
1.8.0.2

