Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648AbaFWICl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 04:02:41 -0400
Received: from mail-bl2lp0207.outbound.protection.outlook.com ([207.46.163.207]:9788
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751282AbaFWICh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:02:37 -0400
From: Ruchika Gupta <ruchika.gupta@freescale.com>
To: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <herbert@gondor.apana.org.au>
CC: <davem@davemloft.net>, <alexandru.porosanu@freescale.com>,
        <kim.phillips@freescale.com>, <dan.carpenter@oracle.com>,
        Ruchika Gupta <ruchika.gupta@freescale.com>
Subject: [PATCH] crypto: caam - Add definition of rd/wr_reg64 for little endian platform
Date: Mon, 23 Jun 2014 18:49:30 +0530
Message-ID: <1403529570-23393-1-git-send-email-ruchika.gupta@freescale.com>
X-Mailer: git-send-email 1.8.1.4
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199002)(74662001)(31966008)(87936001)(74502001)(26826002)(33646001)(83072002)(50226001)(21056001)(102836001)(104166001)(4396001)(47776003)(95666004)(50466002)(68736004)(104016002)(92726001)(105606002)(76482001)(84676001)(88136002)(77982001)(81342001)(20776003)(19580395003)(83322001)(80022001)(86362001)(85306003)(46102001)(87286001)(85852003)(99396002)(64706001)(92566001)(77156001)(93916002)(48376002)(62966002)(106466001)(44976005)(6806004)(50986999)(19580405001)(97736001)(89996001)(81542001)(79102001)(36756003)(2201001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB556;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
X-Forefront-PRVS: 025100C802
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=ruchika.gupta@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CAAM IP has certain 64 bit registers . 32 bit architectures cannot force
atomic-64 operations.  This patch adds definition of these atomic-64
operations for little endian platforms. The definitions which existed
previously were for big endian platforms.

Signed-off-by: Ruchika Gupta <ruchika.gupta@freescale.com>
---
Tested on LS1021 platform

 drivers/crypto/caam/regs.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/crypto/caam/regs.h b/drivers/crypto/caam/regs.h
index cbde8b9..2825067 100644
--- a/drivers/crypto/caam/regs.h
+++ b/drivers/crypto/caam/regs.h
@@ -84,6 +84,7 @@
 #endif
 
 #ifndef CONFIG_64BIT
+#ifdef __BIG_ENDIAN
 static inline void wr_reg64(u64 __iomem *reg, u64 data)
 {
 	wr_reg32((u32 __iomem *)reg, (data & 0xffffffff00000000ull) >> 32);
@@ -95,6 +96,21 @@ static inline u64 rd_reg64(u64 __iomem *reg)
 	return (((u64)rd_reg32((u32 __iomem *)reg)) << 32) |
 		((u64)rd_reg32((u32 __iomem *)reg + 1));
 }
+#else
+#ifdef __LITTLE_ENDIAN
+static inline void wr_reg64(u64 __iomem *reg, u64 data)
+{
+	wr_reg32((u32 __iomem *)reg + 1, (data & 0xffffffff00000000ull) >> 32);
+	wr_reg32((u32 __iomem *)reg, data & 0x00000000ffffffffull);
+}
+
+static inline u64 rd_reg64(u64 __iomem *reg)
+{
+	return (((u64)rd_reg32((u32 __iomem *)reg + 1)) << 32) |
+		((u64)rd_reg32((u32 __iomem *)reg));
+}
+#endif
+#endif
 #endif
 
 /*
-- 
1.8.1.4

