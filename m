Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751633AbaELDWJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 23:22:09 -0400
Received: from mail-bl2on0132.outbound.protection.outlook.com ([65.55.169.132]:46569
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751393AbaELDWH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 23:22:07 -0400
X-Greylist: delayed 938 seconds by postgrey-1.27 at vger.kernel.org; Sun, 11 May 2014 23:22:07 EDT
From: Richard Lee <superlibj8301@gmail.com>
To: <linux@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
CC: Richard Lee <superlibj8301@gmail.com>, Richard Lee <superlibj@gmail.com>
Subject: [RFC][PATCH 2/2] ARM: ioremap: Add IO mapping space reused support.
Date: Mon, 12 May 2014 10:19:55 +0800
Message-ID: <1399861195-21087-3-git-send-email-superlibj8301@gmail.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1399861195-21087-1-git-send-email-superlibj8301@gmail.com>
References: <1399861195-21087-1-git-send-email-superlibj8301@gmail.com>
X-EOPAttributedMessage: 0
X-Matching-Connectors: 130443375756231189;(91ab9b29-cfa4-454e-5278-08d120cd25b8);()
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019001)(6009001)(189002)(199002)(4396001)(76176999)(50986999)(77096999)(81442001)(48376002)(2009001)(50466002)(68736004)(44976005)(19580405001)(19580395003)(79102001)(86362001)(21056001)(92566001)(47776003)(80022001)(93916002)(50226001)(92726001)(61266001)(2201001)(69596002)(64706001)(81342001)(99396002)(20776003)(81542001)(87572001)(97736001)(33646001)(88136002)(83072002)(85852003)(62966002)(74502001)(87936001)(74662001)(81156002)(77156001)(31966008)(6806004)(82202001)(77982001)(84676001)(73972005)(87286001)(55446002)(36756003)(46102001)(57042002)(46252002)(2101003);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR03MB411;H:az84smr01.freescale.net;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Forefront-PRVS: 0209425D0A
Authentication-Results: spf=softfail (sender IP is 192.88.158.2)
 smtp.mailfrom=superlibj8301@gmail.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the IO mapping, for the same physical address space maybe
mapped more than one time, for example, in some SoCs:
0x20000000 ~ 0x20001000: are global control IO physical map,
and this range space will be used by many drivers.
And then if each driver will do the same ioremap operation, we
will waste to much malloc virtual spaces.

This patch add IO mapping space reused support.

Signed-off-by: Richard Lee <superlibj@gmail.com>
---
 arch/arm/mm/ioremap.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mm/ioremap.c b/arch/arm/mm/ioremap.c
index f9c32ba..26a3744 100644
--- a/arch/arm/mm/ioremap.c
+++ b/arch/arm/mm/ioremap.c
@@ -260,7 +260,7 @@ void __iomem * __arm_ioremap_pfn_caller(unsigned long pfn,
 {
 	const struct mem_type *type;
 	int err;
-	unsigned long addr;
+	unsigned long addr, off;
 	struct vm_struct *area;
 	phys_addr_t paddr = __pfn_to_phys(pfn);
 
@@ -301,6 +301,12 @@ void __iomem * __arm_ioremap_pfn_caller(unsigned long pfn,
 	if (WARN_ON(pfn_valid(pfn)))
 		return NULL;
 
+	area = find_vm_area_paddr(paddr, size, &off, VM_IOREMAP);
+	if (area) {
+		addr = (unsigned long)area->addr;
+		return (void __iomem *)(offset + off + addr);
+	}
+
 	area = get_vm_area_caller(size, VM_IOREMAP, caller);
  	if (!area)
  		return NULL;
@@ -410,6 +416,9 @@ void __iounmap(volatile void __iomem *io_addr)
 	if (svm)
 		return;
 
+	if (!vm_area_is_aready_to_free((unsigned long)addr))
+		return;
+
 #if !defined(CONFIG_SMP) && !defined(CONFIG_ARM_LPAE)
 	{
 		struct vm_struct *vm;
-- 
1.8.4

