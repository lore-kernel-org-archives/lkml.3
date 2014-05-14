Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265AbaENJin (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 05:38:43 -0400
Received: from mail-bl2on0103.outbound.protection.outlook.com ([65.55.169.103]:41240
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751308AbaENJij (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 05:38:39 -0400
From: Richard Lee <superlibj8301@gmail.com>
To: <linux-mm@kvack.org>, <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <arnd@arndb.de>,
        <robherring2@gmail.com>
CC: <lauraa@codeaurora.org>, <akpm@linux-foundation.org>,
        <d.hatayama@jp.fujitsu.com>, <zhangyanfei@cn.fujitsu.com>,
        <liwanp@linux.vnet.ibm.com>, <iamjoonsoo.kim@lge.com>,
        <hannes@cmpxchg.org>, <linux-kernel@vger.kernel.org>,
        Richard Lee <superlibj8301@gmail.com>
Subject: [PATCHv2 2/2] ARM: ioremap: Add IO mapping space reused support.
Date: Wed, 14 May 2014 16:18:52 +0800
Message-ID: <1400055532-13134-3-git-send-email-superlibj8301@gmail.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1400055532-13134-1-git-send-email-superlibj8301@gmail.com>
References: <1400055532-13134-1-git-send-email-superlibj8301@gmail.com>
X-EOPAttributedMessage: 0
X-Matching-Connectors: 130445319381128282;(91ab9b29-cfa4-454e-5278-08d120cd25b8);()
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019001)(6009001)(189002)(199002)(61266001)(62966002)(46102001)(77096999)(81542001)(87792001)(20776003)(2009001)(87286001)(74662001)(64706001)(81156002)(47776003)(86362001)(48376002)(89996001)(76176999)(97736001)(102836001)(50986999)(33646001)(6806004)(88136002)(77156001)(93916002)(79102001)(73392001)(21056001)(87936001)(82202001)(85852003)(36756003)(4396001)(80022001)(55446002)(50226001)(77982001)(19580395003)(81342001)(2201001)(19580405001)(87572001)(73972005)(83072002)(31966008)(92566001)(44976005)(92726001)(68736004)(74502001)(84676001)(69596002)(99396002)(81442001)(50466002)(57042002)(46252002)(2101003);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR03MB405;H:az84smr01.freescale.net;FPR:;MLV:nov;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Forefront-PRVS: 0211965D06
Authentication-Results: spf=softfail (sender IP is 192.88.158.2)
 smtp.mailfrom=superlibj8301@gmail.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the IO mapping, the same physical address space maybe
mapped more than one time, for example, in some SoCs:
  - 0x20001000 ~ 0x20001400 --> 1KB for Dev1
  - 0x20001400 ~ 0x20001800 --> 1KB for Dev2
  and the page size is 4KB.

Then both Dev1 and Dev2 will do ioremap operations, and the IO
vmalloc area's virtual address will be aligned down to 4KB, and
the size will be aligned up to 4KB. That's to say, only one
4KB size's vmalloc area could contain Dev1 and Dev2 IO mapping area
at the same time.

For this case, we can ioremap only one time, and the later ioremap
operation will just return the exist vmalloc area.

This patch add IO mapping space reused support.

Signed-off-by: Richard Lee <superlibj8301@gmail.com>
---
 arch/arm/mm/ioremap.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm/mm/ioremap.c b/arch/arm/mm/ioremap.c
index f9c32ba..be69333 100644
--- a/arch/arm/mm/ioremap.c
+++ b/arch/arm/mm/ioremap.c
@@ -301,6 +301,12 @@ void __iomem * __arm_ioremap_pfn_caller(unsigned long pfn,
 	if (WARN_ON(pfn_valid(pfn)))
 		return NULL;
 
+	area = find_vm_area_paddr(paddr, size, &offset, VM_IOREMAP);
+	if (area) {
+		addr = (unsigned long)area->addr;
+		return (void __iomem *)(offset + addr);
+	}
+
 	area = get_vm_area_caller(size, VM_IOREMAP, caller);
  	if (!area)
  		return NULL;
-- 
1.8.4

