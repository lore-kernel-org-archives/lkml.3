Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753084AbaEOJax (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 05:30:53 -0400
Received: from mail-by2lp0244.outbound.protection.outlook.com ([207.46.163.244]:59713
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752738AbaEOJav (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 05:30:51 -0400
X-Greylist: delayed 873 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 May 2014 05:30:51 EDT
From: Richard Lee <superlibj8301@gmail.com>
To: <linux@arm.linux.org.uk>, <nico@linaro.org>, <iamjoonsoo.kim@lge.com>,
        <santosh.shilimkar@ti.com>, <linux-arm-kernel@lists.infradead.org>,
        <arnd@arndb.de>, <Li.Xiubo@freescale.com>, <robherring2@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <lauraa@codeaurora.org>,
        Richard Lee <superlibj8301@gmail.com>
Subject: [PATCHv2] ARM: ioremap: Fix static vm area boundary checking.
Date: Thu, 15 May 2014 16:29:22 +0800
Message-ID: <1400142562-9111-1-git-send-email-superlibj8301@gmail.com>
X-Mailer: git-send-email 1.8.0
X-EOPAttributedMessage: 0
X-Matching-Connectors: 130446189757640046;(91ab9b29-cfa4-454e-5278-08d120cd25b8);()
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199002)(189002)(21056001)(89996001)(83072002)(88136002)(33646001)(102836001)(31966008)(74662001)(93916002)(81156002)(87936001)(86362001)(97736001)(87286001)(74502001)(19580405001)(81442001)(19580395003)(81342001)(6806004)(44976005)(62966002)(79102001)(81542001)(68736004)(69596002)(50466002)(55446002)(48376002)(73972005)(82202001)(84676001)(36756003)(92566001)(92726001)(2201001)(50226001)(4396001)(77156001)(47776003)(20776003)(61266001)(64706001)(80022001)(73392001)(77982001)(50986999)(77096999)(87792001)(46102001)(99396002)(85852003)(87572001)(57042002)(46252002);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR03MB408;H:az84smr01.freescale.net;FPR:;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
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


Change in V2:
 - PAGE_SIZE --> PAGE_MASK
 - remove the 'size' page size align operation.






 arch/arm/mm/ioremap.c | 40 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 38 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mm/ioremap.c b/arch/arm/mm/ioremap.c
index be69333..f235ab7 100644
--- a/arch/arm/mm/ioremap.c
+++ b/arch/arm/mm/ioremap.c
@@ -47,16 +47,52 @@ static struct static_vm *find_static_vm_paddr(phys_addr_t paddr,
 {
 	struct static_vm *svm;
 	struct vm_struct *vm;
+	size_t offset;
+
+	offset = paddr & ~PAGE_MASK;
 
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
+		vmoff = vm->phys_addr & ~PAGE_MASK;
+		phys_addr_end = vm->phys_addr + vm->size - PAGE_SIZE - vmoff;
+		paddr_end = paddr + size - offset;
+		if (__phys_to_pfn(vm->phys_addr) > __phys_to_pfn(paddr) ||
+			paddr_end - 1 > phys_addr_end - 1)
 			continue;
 
 		return svm;
-- 
1.8.4

