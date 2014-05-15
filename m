Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753926AbaEOGnv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 02:43:51 -0400
Received: from mail-bn1blp0185.outbound.protection.outlook.com ([207.46.163.185]:48816
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753870AbaEOGnt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 02:43:49 -0400
From: Richard Lee <superlibj8301@gmail.com>
To: <linux@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <arnd@arndb.de>, <robherring2@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <lauraa@codeaurora.org>,
        Richard Lee <superlibj8301@gmail.com>
Subject: [PATCH] ARM: ioremap: Fix static vm area boundary checking.
Date: Thu, 15 May 2014 13:57:07 +0800
Message-ID: <1400133427-5653-1-git-send-email-superlibj8301@gmail.com>
X-Mailer: git-send-email 1.8.0
X-EOPAttributedMessage: 0
X-Matching-Connectors: 130446098265574846;(91ab9b29-cfa4-454e-5278-08d120cd25b8);()
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199002)(189002)(77096999)(99396002)(86362001)(97736001)(68736004)(69596002)(21056001)(92566001)(80022001)(46102001)(2201001)(44976005)(47776003)(61266001)(62966002)(81156002)(93916002)(87936001)(102836001)(48376002)(87286001)(19580405001)(19580395003)(73392001)(4396001)(84676001)(89996001)(77156001)(81342001)(81442001)(87572001)(81542001)(87792001)(36756003)(50986999)(6806004)(50466002)(77982001)(88136002)(73972005)(83072002)(85852003)(74502001)(79102001)(20776003)(31966008)(74662001)(50226001)(64706001)(55446002)(33646001)(82202001)(92726001)(57042002)(46252002)(2101003);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR03MB406;H:az84smr01.freescale.net;FPR:;MLV:nov;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Forefront-PRVS: 0212BDE3BE
Authentication-Results: spf=softfail (sender IP is 192.88.158.2)
 smtp.mailfrom=superlibj8301@gmail.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Static vm area boundary check:

      paddr1 --->|       |
                 |       |
                 |-------| <-\--- svm->vm->addr(is page aligned)
      paddr2 --->|       |    |
                 |     --| <--|-- svm->vm->phys_addr
                 |       |    |
      paddr3 --->|       |    |
                 |       |    |
                 |-------| <--|-- next page boundary
                 |       |    |
      paddr4 --->|       |    | <----- svm->vm->size(including guard page)
                 |       |    |
                 |       |    |
max paddr_end -->|-------| <--|-- svm->vm's phys_addr_end
                 | ///// |    |
      paddr5 --->| guard |    |
                 | page  |    |
                 | ///// |    |
                  -------  <-/--- svm->vm->addr + svm->vm_size

<1> If the paddr == paddr1, then continue;
<2> If the paddr == paddr2~paddr4 and paddr_end > phys_addr_end,
    then continue;
<3> if the paddr >= paddr5 then continue;

Signed-off-by: Richard Lee <superlibj8301@gmail.com>
---
 arch/arm/mm/ioremap.c | 44 ++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 42 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mm/ioremap.c b/arch/arm/mm/ioremap.c
index be69333..2fa41f4 100644
--- a/arch/arm/mm/ioremap.c
+++ b/arch/arm/mm/ioremap.c
@@ -47,16 +47,56 @@ static struct static_vm *find_static_vm_paddr(phys_addr_t paddr,
 {
 	struct static_vm *svm;
 	struct vm_struct *vm;
+	size_t offset;
+
+	/*
+	 * Make sure the size the mapping size is page aligned.
+	 */
+	size = PAGE_ALIGN((paddr & ~PAGE_SIZE) + size);
+	offset = paddr & ~PAGE_SIZE;
 
 	list_for_each_entry(svm, &static_vmlist, list) {
+		phys_addr_t paddr_end, phys_addr_end;
+		size_t vmoff;
+
 		vm = &svm->vm;
 		if (!(vm->flags & VM_ARM_STATIC_MAPPING))
 			continue;
 		if ((vm->flags & VM_ARM_MTYPE_MASK) != VM_ARM_MTYPE(mtype))
 			continue;
 
-		if (vm->phys_addr > paddr ||
-			paddr + size - 1 > vm->phys_addr + vm->size - 1)
+		/* Static vm area boundary check:
+		 *
+		 *       paddr1 --->|       |
+		 *                  |       |
+		 *                  |-------| <-\--- svm->vm->addr(page aligned)
+		 *       paddr2 --->|       |    |
+		 *                  |     --| <--|-- svm->vm->phys_addr
+		 *                  |       |    |
+		 *       paddr3 --->|       |    |
+		 *                  |       |    |
+		 *                  |-------| <--|-- next page boundary
+		 *                  |       |    |
+		 *       paddr4 --->|       |    | <----- svm->vm->size,
+		 *                  |       |    |         including guard page
+		 *                  |       |    |
+		 * max paddr_end -->|-------| <--|-- svm->vm's phys_addr_end
+		 *                  | ///// |    |
+		 *       paddr5 --->| guard |    |
+		 *                  | page  |    |
+		 *                  | ///// |    |
+		 *                   -------  <-/-- svm->vm->addr + svm->vm_size
+		 *
+		 * <1> If paddr == paddr1, then continue;
+		 * <2> If paddr == paddr2~paddr4 and paddr_end > phys_addr_end,
+		 *     then continue;
+		 * <3> if paddr >= paddr5 then continue;
+		 */
+		vmoff = vm->phys_addr & ~PAGE_SIZE;
+		phys_addr_end = vm->phys_addr + vm->size - PAGE_SIZE - vmoff;
+		paddr_end = paddr + size - offset;
+		if (__phys_to_pfn(vm->phys_addr) > __phys_to_pfn(paddr) ||
+			paddr_end - 1 > phys_addr_end - 1)
 			continue;
 
 		return svm;
-- 
1.8.4

