Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756269AbaHES2l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 14:28:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52442 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755192AbaHESOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 14:14:41 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH 3.14 04/39] ARM: fix alignment of keystone page table fixup
Date: Tue,  5 Aug 2014 11:13:41 -0700
Message-Id: <20140805181336.160728396@linuxfoundation.org>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <20140805181336.030349158@linuxfoundation.org>
References: <20140805181336.030349158@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russell King <rmk+kernel@arm.linux.org.uk>

commit 823a19cd3b91b0729d7417f1848413846be61712 upstream.

If init_mm.brk is not section aligned, the LPAE fixup code will miss
updating the final PMD.  Fix this by aligning map_end.

Fixes: a77e0c7b2774 ("ARM: mm: Recreate kernel mappings in early_paging_init()")
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mm/mmu.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -1436,8 +1436,8 @@ void __init early_paging_init(const stru
 		return;
 
 	/* remap kernel code and data */
-	map_start = init_mm.start_code;
-	map_end   = init_mm.brk;
+	map_start = init_mm.start_code & PMD_MASK;
+	map_end   = ALIGN(init_mm.brk, PMD_SIZE);
 
 	/* get a handle on things... */
 	pgd0 = pgd_offset_k(0);
@@ -1472,7 +1472,7 @@ void __init early_paging_init(const stru
 	}
 
 	/* remap pmds for kernel mapping */
-	phys = __pa(map_start) & PMD_MASK;
+	phys = __pa(map_start);
 	do {
 		*pmdk++ = __pmd(phys | pmdprot);
 		phys += PMD_SIZE;


