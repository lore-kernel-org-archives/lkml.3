Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756413AbaFWTVv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 15:21:51 -0400
Received: from mail-by2lp0235.outbound.protection.outlook.com ([207.46.163.235]:7854
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755192AbaFWTVt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 15:21:49 -0400
From: Graham Moore <grmoore@altera.com>
To: <ggrahammoore@gmail.com>
CC: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Graham Moore <grmoore@altera.com>, <linux-mtd@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Alan Tull <atull@altera.com>,
        Dinh Nguyen <dinguyen@altera.com>,
        Yves Vandervennet <rocket.yvanderv@gmail.com>
Subject: [PATCH V2] In the Denali NAND controller driver, use 8 bytes for READID command.
Date: Mon, 23 Jun 2014 14:21:10 -0500
Message-ID: <1403551270-31873-1-git-send-email-grmoore@altera.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.227;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199002)(189002)(20776003)(74502001)(97736001)(79102001)(88136002)(31966008)(81542001)(87936001)(48376002)(76482001)(92566001)(92726001)(50226001)(83322001)(19580395003)(19580405001)(105596002)(102836001)(62966002)(99396002)(84676001)(80022001)(50466002)(77982001)(83072002)(89996001)(85852003)(46102001)(6806004)(64706001)(44976005)(95666004)(33646001)(74662001)(77156001)(85306003)(81342001)(68736004)(21056001)(87286001)(50986999)(106466001)(53416004)(104166001)(77096002)(4396001)(36756003)(86362001)(93916002);DIR:OUT;SFP:;SCL:1;SRVR:BL2FFO11HUB021;H:sj-itexedge03.altera.priv.altera.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-OriginatorOrg: altera.onmicrosoft.com
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 025100C802
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
--
V2: Increase size of id_bytes array to 8.
---
 drivers/mtd/nand/denali.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/mtd/nand/denali.c b/drivers/mtd/nand/denali.c
index 9f2012a..0b071a3 100644
--- a/drivers/mtd/nand/denali.c
+++ b/drivers/mtd/nand/denali.c
@@ -473,7 +473,7 @@ static void detect_partition_feature(struct denali_nand_info *denali)
 static uint16_t denali_nand_timing_set(struct denali_nand_info *denali)
 {
 	uint16_t status = PASS;
-	uint32_t id_bytes[5], addr;
+	uint32_t id_bytes[8], addr;
 	uint8_t i, maf_id, device_id;
 
 	dev_dbg(denali->dev,
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

