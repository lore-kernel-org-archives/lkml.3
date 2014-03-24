Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751258AbaCXVSi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 17:18:38 -0400
Received: from mail-bn1lp0141.outbound.protection.outlook.com ([207.46.163.141]:36143
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751070AbaCXVSg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 17:18:36 -0400
X-Greylist: delayed 883 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 Mar 2014 17:18:36 EDT
From: Anders Berg <anders.berg@lsi.com>
To: Russell King <linux@arm.linux.org.uk>,
        Nicolas Pitre <nicolas.pitre@linaro.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Anders Berg <anders.berg@lsi.com>,
        =?UTF-8?q?Fredrik=20Markstr=C3=B6m?= <fredrik.markstrom@gmail.com>
Subject: [PATCH RFC] ARM: mm: Fix for highmem on machines with more than 14 cores
Date: Mon, 24 Mar 2014 22:02:12 +0100
Message-ID: <52661057074abf5bfe6174cb561bec5eea8892fb.1395692531.git.anders.berg@lsi.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <cover.1395692531.git.anders.berg@lsi.com>
References: <cover.1395692531.git.anders.berg@lsi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [85.229.45.38]
X-ClientProxiedBy: DB4PR07CA040.eurprd07.prod.outlook.com (10.242.229.50) To
 CO1PR07MB377.namprd07.prod.outlook.com (10.141.74.156)
X-Forefront-PRVS: 01604FB62B
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019001)(6009001)(6069001)(428001)(189002)(199002)(89996001)(95666003)(69226001)(81342001)(94946001)(46102001)(4396001)(90146001)(47976001)(51856001)(93916002)(85306002)(33646001)(62966002)(95416001)(56816005)(87976001)(50226001)(19580405001)(50466002)(88136002)(80976001)(97186001)(74366001)(53806001)(81816001)(97336001)(81686001)(98676001)(93136001)(92726001)(50986001)(86362001)(94316002)(47736001)(49866001)(85852003)(92566001)(81542001)(74876001)(76482001)(87286001)(83322001)(56776001)(54316002)(19580395003)(87266001)(93516002)(42186004)(63696002)(47776003)(76786001)(20776003)(76796001)(77096001)(65816001)(77156001)(80022001)(36756003)(79102001)(31966008)(77982001)(59766001)(66066001)(74662001)(47446002)(74502001)(23676002);DIR:OUT;SFP:1102;SCL:1;SRVR:CO1PR07MB377;H:localhost.localdomain;FPR:DCDD70F2.8CDEBCE9.4C51B4E.88EAEA69.20211;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-OriginatorOrg: lsi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The fixmap area was hard coded to 224 pages which was only enough for 14 CPU:s.
Now the area adapts to the configured number of CPU:s (NR_CPUS). We still have
a hard limit of 30 CPU:s since we only have a single pte-chunk (512 pte:s).

Signed-off-by: Anders Berg <anders.berg@lsi.com>
Signed-off-by: Fredrik Markström <fredrik.markstrom@gmail.com>
---
 arch/arm/include/asm/fixmap.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/include/asm/fixmap.h b/arch/arm/include/asm/fixmap.h
index bbae919..40f1f05 100644
--- a/arch/arm/include/asm/fixmap.h
+++ b/arch/arm/include/asm/fixmap.h
@@ -7,15 +7,15 @@
  * On ARM we already have well known fixed virtual addresses imposed by
  * the architecture such as the vector page which is located at 0xffff0000,
  * therefore a second level page table is already allocated covering
- * 0xfff00000 upwards.
+ * 0xffe00000 upwards.
  *
  * The cache flushing code in proc-xscale.S uses the virtual area between
  * 0xfffe0000 and 0xfffeffff.
  */
 
-#define FIXADDR_START		0xfff00000UL
+#define FIXADDR_SIZE		((KM_TYPE_NR * NR_CPUS) << PAGE_SHIFT)
 #define FIXADDR_TOP		0xfffe0000UL
-#define FIXADDR_SIZE		(FIXADDR_TOP - FIXADDR_START)
+#define FIXADDR_START		(FIXADDR_TOP - FIXADDR_SIZE)
 
 #define FIX_KMAP_BEGIN		0
 #define FIX_KMAP_END		(FIXADDR_SIZE >> PAGE_SHIFT)
-- 
1.8.3.2

