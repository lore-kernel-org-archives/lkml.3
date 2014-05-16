Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756914AbaEPKZU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 06:25:20 -0400
Received: from mail-bn1lp0144.outbound.protection.outlook.com ([207.46.163.144]:10749
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756807AbaEPKZT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 06:25:19 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <linux@arm.linux.org.uk>, <lauraa@codeaurora.org>,
        <linux-arm-kernel@lists.infradead.org>, <nico@linaro.org>,
        <santosh.shilimkar@ti.com>, <iamjoonsoo.kim@lge.com>,
        <superlibj8301@gmail.com>
CC: <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH v3] arm: ioremap: Fix static vm area boundary check.
Date: Fri, 16 May 2014 17:35:20 +0800
Message-ID: <1400232920-25079-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199002)(189002)(83322001)(19580405001)(99396002)(77096999)(6806004)(44976005)(50226001)(83072002)(4396001)(31966008)(19580395003)(74662001)(69596002)(68736004)(84676001)(74502001)(102836001)(97736001)(50986999)(81542001)(92566001)(87936001)(21056001)(92726001)(79102001)(87286001)(77156001)(81156002)(86362001)(50466002)(89996001)(20776003)(81342001)(80022001)(36756003)(85852003)(76482001)(77982001)(46102001)(48376002)(47776003)(62966002)(64706001)(2101003);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR03MB509;H:az84smr01.freescale.net;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Forefront-PRVS: 02135EB356
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Li.Xiubo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For each vmalloc area, there is one guard page at the end of it.
so the vm->size = PAGE_ALIGN(offset + request size) + guard page size.

Signed-off-by: Richard Lee <superlibj8301@gmail.com>
Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
Cc: Nicolas Pitre <nico@linaro.org>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
---
 arch/arm/mm/ioremap.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mm/ioremap.c b/arch/arm/mm/ioremap.c
index be69333..758e8f7 100644
--- a/arch/arm/mm/ioremap.c
+++ b/arch/arm/mm/ioremap.c
@@ -49,14 +49,18 @@ static struct static_vm *find_static_vm_paddr(phys_addr_t paddr,
 	struct vm_struct *vm;
 
 	list_for_each_entry(svm, &static_vmlist, list) {
+		phys_addr_t paddr_end, phys_addr_end;
+
 		vm = &svm->vm;
 		if (!(vm->flags & VM_ARM_STATIC_MAPPING))
 			continue;
 		if ((vm->flags & VM_ARM_MTYPE_MASK) != VM_ARM_MTYPE(mtype))
 			continue;
 
-		if (vm->phys_addr > paddr ||
-			paddr + size - 1 > vm->phys_addr + vm->size - 1)
+		/* The PAGE_SIZE here is vmalloc area's guard page */
+		phys_addr_end = vm->phys_addr + vm->size - PAGE_SIZE - 1;
+		paddr_end = paddr + size - 1;
+		if (vm->phys_addr > paddr || paddr_end > phys_addr_end)
 			continue;
 
 		return svm;
-- 
1.8.4

