Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850AbaFMRqX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 13:46:23 -0400
Received: from mail-by2lp0240.outbound.protection.outlook.com ([207.46.163.240]:13997
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753300AbaFMRqW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 13:46:22 -0400
From: Graham Moore <grmoore@altera.com>
To: <ggrahammoore@gmail.com>
CC: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Graham Moore <grmoore@altera.com>, <linux-mtd@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Alan Tull <atull@altera.com>,
        Dinh Nguyen <dinguyen@altera.com>,
        Yves Vandervennet <rocket.yvanderv@gmail.com>
Subject: [PATCH] In the Denali NAND controller driver, use 8 bytes for READID command.
Date: Fri, 13 Jun 2014 12:46:05 -0500
Message-ID: <1402681565-7826-1-git-send-email-grmoore@altera.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.227;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199002)(68736004)(50466002)(19580405001)(50226001)(19580395003)(84676001)(83322001)(74502001)(50986999)(99396002)(102836001)(97736001)(46102001)(87286001)(44976005)(83072002)(85852003)(92726001)(87936001)(86362001)(92566001)(80022001)(74662001)(53416003)(104166001)(77156001)(77982001)(31966008)(79102001)(93916002)(76482001)(21056001)(4396001)(64706001)(62966002)(33646001)(81542001)(81342001)(6806004)(88136002)(20776003)(47776003)(36756003)(48376002)(89996001);DIR:OUT;SFP:;SCL:1;SRVR:BN1BFFO11HUB011;H:sj-itexedge03.altera.priv.altera.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-OriginatorOrg: altera.onmicrosoft.com
X-Microsoft-Antispam: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
X-Forefront-PRVS: 0241D5F98C
Authentication-Results: spf=softfail (sender IP is 66.35.236.227)
 smtp.mailfrom=grmoore@altera.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Denali NAND driver reads only 5 bytes of ID, but some Hynix and Samsung
have size parameters in the 6th byte.  As a result, the page and oob size
for a Hynix H27UAG8T2B were calculated incorrectly and the driver failed to
load.

The solution is to read 8 bytes of ID, as expected by the nand framework.

Signed-off-by: Graham Moore <grmoore@altera.com>
---
 drivers/mtd/nand/denali.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/nand/denali.c b/drivers/mtd/nand/denali.c
index 9f2012a..7276125 100644
--- a/drivers/mtd/nand/denali.c
+++ b/drivers/mtd/nand/denali.c
@@ -488,7 +488,7 @@ static uint16_t denali_nand_timing_set(struct denali_nand_info *denali)
 	addr = (uint32_t)MODE_11 | BANK(denali->flash_bank);
 	index_addr(denali, (uint32_t)addr | 0, 0x90);
 	index_addr(denali, (uint32_t)addr | 1, 0);
-	for (i = 0; i < 5; i++)
+	for (i = 0; i < 8; i++)
 		index_addr_read_data(denali, addr | 2, &id_bytes[i]);
 	maf_id = id_bytes[0];
 	device_id = id_bytes[1];
@@ -1276,7 +1276,7 @@ static void denali_cmdfunc(struct mtd_info *mtd, unsigned int cmd, int col,
 		addr = (uint32_t)MODE_11 | BANK(denali->flash_bank);
 		index_addr(denali, (uint32_t)addr | 0, 0x90);
 		index_addr(denali, (uint32_t)addr | 1, 0);
-		for (i = 0; i < 5; i++) {
+		for (i = 0; i < 8; i++) {
 			index_addr_read_data(denali,
 						(uint32_t)addr | 2,
 						&id);
-- 
1.7.10.4

