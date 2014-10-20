Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688AbaJTGOJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 02:14:09 -0400
Received: from mail-bn1on0133.outbound.protection.outlook.com ([157.56.110.133]:19089
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752455AbaJTGOE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 02:14:04 -0400
From: Jaiprakash Singh <b44839@freescale.com>
To: <linux-kernel@vger.kernel.org>
CC: Jaiprakash Singh <b44839@freescale.com>
Subject: [PATCH 1/1][v2] IFC: Change IO accessor based on endianness
Date: Mon, 20 Oct 2014 11:43:50 +0530
Message-ID: <1413785630-484-1-git-send-email-b44839@freescale.com>
X-Mailer: git-send-email 1.7.9.5
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(43544003)(199003)(189002)(69596002)(19580395003)(36756003)(6806004)(19580405001)(44976005)(68736004)(77156001)(88136002)(85306004)(87286001)(87936001)(78352002)(46102003)(85852003)(80022003)(84676001)(89996001)(104166001)(31966008)(42382002)(76482002)(95666004)(99396003)(120916001)(33646002)(92726001)(92566001)(104016003)(93916002)(62966002)(50986999)(97736003)(50466002)(48376002)(20776003)(47776003)(102836001)(64706001)(21056001)(551934003)(4396001)(229853001)(50226001)(107046002)(2351001)(105586002)(110136001)(81156004)(26826002)(106466001)(101416001)(88662002)(42262002);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR03MB471;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:0;MX:0;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR03MB471;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 03706074BC
Authentication-Results: spf=none (sender IP is 192.88.158.2) smtp.mailfrom=<>; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jaiprakash Singh <b44839@freescale.com>

IFC registers can be of type Little Endian
or big Endian depending upon Freescale SoC.
Here SoC defines the register type of
IFC IP.So update accessors functions with
common IFC accessors functions to take
care both type of endianness.

IFC IO accressor are set at run time based
on IFC IP registers endianness.IFC node in
DTS file contains information about
endianness.

Signed-off-by: Jaiprakash Singh <b44839@freescale.com>
---
Changes for v2
	- Moved IFC accessor function to fsl_ifc.h
	from fsl_ifc.c and make them inline static

.../bindings/memory-controllers/fsl/ifc.txt        |    2 +
 drivers/memory/fsl_ifc.c                           |   72 ++++++----
 drivers/mtd/nand/fsl_ifc_nand.c                    |  151 +++++++++++---------
 include/linux/fsl_ifc.h                            |   42 ++++++
 4 files changed, 167 insertions(+), 100 deletions(-)

diff --git a/Documentation/devicetree/bindings/memory-controllers/fsl/ifc.txt b/Documentation/devicetree/bindings/memory-controllers/fsl/ifc.txt
index d5e3704..ee6226b 100644
--- a/Documentation/devicetree/bindings/memory-controllers/fsl/ifc.txt
+++ b/Documentation/devicetree/bindings/memory-controllers/fsl/ifc.txt
@@ -18,6 +18,8 @@ Properties:
               interrupt (NAND_EVTER_STAT).  If there is only one,
               that interrupt reports both types of event.
 
+- little-endian : If this property is absent, the big-endian mode will
+                  be in use as default for registers.
 
 - ranges : Each range corresponds to a single chipselect, and covers
            the entire access window as configured.
diff --git a/drivers/memory/fsl_ifc.c b/drivers/memory/fsl_ifc.c
index 3d5d792..5689e9b 100644
--- a/drivers/memory/fsl_ifc.c
+++ b/drivers/memory/fsl_ifc.c
@@ -62,7 +62,8 @@ int fsl_ifc_find(phys_addr_t addr_base)
 		return -ENODEV;
 
 	for (i = 0; i < ARRAY_SIZE(fsl_ifc_ctrl_dev->regs->cspr_cs); i++) {
-		u32 cspr = in_be32(&fsl_ifc_ctrl_dev->regs->cspr_cs[i].cspr);
+		u32 cspr = ifc_in32(
+				&fsl_ifc_ctrl_dev->regs->cspr_cs[i].cspr);
 		if (cspr & CSPR_V && (cspr & CSPR_BA) ==
 				convert_ifc_address(addr_base))
 			return i;
@@ -79,16 +80,16 @@ static int fsl_ifc_ctrl_init(struct fsl_ifc_ctrl *ctrl)
 	/*
 	 * Clear all the common status and event registers
 	 */
-	if (in_be32(&ifc->cm_evter_stat) & IFC_CM_EVTER_STAT_CSER)
-		out_be32(&ifc->cm_evter_stat, IFC_CM_EVTER_STAT_CSER);
+	if (ifc_in32(&ifc->cm_evter_stat) & IFC_CM_EVTER_STAT_CSER)
+		ifc_out32(IFC_CM_EVTER_STAT_CSER, &ifc->cm_evter_stat);
 
 	/* enable all error and events */
-	out_be32(&ifc->cm_evter_en, IFC_CM_EVTER_EN_CSEREN);
+	ifc_out32(IFC_CM_EVTER_EN_CSEREN, &ifc->cm_evter_en);
 
 	/* enable all error and event interrupts */
-	out_be32(&ifc->cm_evter_intr_en, IFC_CM_EVTER_INTR_EN_CSERIREN);
-	out_be32(&ifc->cm_erattr0, 0x0);
-	out_be32(&ifc->cm_erattr1, 0x0);
+	ifc_out32(IFC_CM_EVTER_INTR_EN_CSERIREN, &ifc->cm_evter_intr_en);
+	ifc_out32(0x0, &ifc->cm_erattr0);
+	ifc_out32(0x0, &ifc->cm_erattr1);
 
 	return 0;
 }
@@ -127,9 +128,9 @@ static u32 check_nand_stat(struct fsl_ifc_ctrl *ctrl)
 
 	spin_lock_irqsave(&nand_irq_lock, flags);
 
-	stat = in_be32(&ifc->ifc_nand.nand_evter_stat);
+	stat = ifc_in32(&ifc->ifc_nand.nand_evter_stat);
 	if (stat) {
-		out_be32(&ifc->ifc_nand.nand_evter_stat, stat);
+		ifc_out32(stat, &ifc->ifc_nand.nand_evter_stat);
 		ctrl->nand_stat = stat;
 		wake_up(&ctrl->nand_wait);
 	}
@@ -161,36 +162,37 @@ static irqreturn_t fsl_ifc_ctrl_irq(int irqno, void *data)
 	irqreturn_t ret = IRQ_NONE;
 
 	/* read for chip select error */
-	cs_err = in_be32(&ifc->cm_evter_stat);
+	cs_err = ifc_in32(&ifc->cm_evter_stat);
 	if (cs_err) {
-		dev_err(ctrl->dev, "transaction sent to IFC is not mapped to"
-				"any memory bank 0x%08X\n", cs_err);
+		dev_err(ctrl->dev, "transaction sent to IFC is not mapped to");
+		dev_err(ctrl->dev, " any memory bank 0x%08X\n", cs_err);
+
 		/* clear the chip select error */
-		out_be32(&ifc->cm_evter_stat, IFC_CM_EVTER_STAT_CSER);
+		ifc_out32(IFC_CM_EVTER_STAT_CSER, &ifc->cm_evter_stat);
 
 		/* read error attribute registers print the error information */
-		status = in_be32(&ifc->cm_erattr0);
-		err_addr = in_be32(&ifc->cm_erattr1);
-
-		if (status & IFC_CM_ERATTR0_ERTYP_READ)
-			dev_err(ctrl->dev, "Read transaction error"
-				"CM_ERATTR0 0x%08X\n", status);
-		else
-			dev_err(ctrl->dev, "Write transaction error"
-				"CM_ERATTR0 0x%08X\n", status);
-
+		status = ifc_in32(&ifc->cm_erattr0);
+		err_addr = ifc_in32(&ifc->cm_erattr1);
+
+		if (status & IFC_CM_ERATTR0_ERTYP_READ) {
+			dev_err(ctrl->dev, "Read transaction error");
+			dev_err(ctrl->dev, " CM_ERATTR0 0x%08X\n", status);
+		} else {
+			dev_err(ctrl->dev, "Write transaction error");
+			dev_err(ctrl->dev, " CM_ERATTR0 0x%08X\n", status);
+		}
 		err_axiid = (status & IFC_CM_ERATTR0_ERAID) >>
 					IFC_CM_ERATTR0_ERAID_SHIFT;
-		dev_err(ctrl->dev, "AXI ID of the error"
-					"transaction 0x%08X\n", err_axiid);
+		dev_err(ctrl->dev, "AXI ID of the erro");
+		dev_err(ctrl->dev, " transaction 0x%08X\n", err_axiid);
 
 		err_srcid = (status & IFC_CM_ERATTR0_ESRCID) >>
 					IFC_CM_ERATTR0_ESRCID_SHIFT;
-		dev_err(ctrl->dev, "SRC ID of the error"
-					"transaction 0x%08X\n", err_srcid);
+		dev_err(ctrl->dev, "SRC ID of the error");
+		dev_err(ctrl->dev, " transaction 0x%08X\n", err_srcid);
 
-		dev_err(ctrl->dev, "Transaction Address corresponding to error"
-					"ERADDR 0x%08X\n", err_addr);
+		dev_err(ctrl->dev, "Transaction Address corresponding to error");
+		dev_err(ctrl->dev, " ERADDR 0x%08X\n", err_addr);
 
 		ret = IRQ_HANDLED;
 	}
@@ -231,11 +233,19 @@ static int fsl_ifc_ctrl_probe(struct platform_device *dev)
 		goto err;
 	}
 
+	if (of_property_read_bool(dev->dev.of_node, "little-endian"))
+		fsl_ifc_ctrl_dev->little_endian = true;
+	else
+		fsl_ifc_ctrl_dev->little_endian = false;
+
+	dev_dbg(&dev->dev, "IFC REGISTERS are %s endian\n",
+			fsl_ifc_ctrl_dev->little_endian ? "LITTLE" : "BIG");
 	/* get the Controller level irq */
 	fsl_ifc_ctrl_dev->irq = irq_of_parse_and_map(dev->dev.of_node, 0);
 	if (fsl_ifc_ctrl_dev->irq == NO_IRQ) {
-		dev_err(&dev->dev, "failed to get irq resource "
-							"for IFC\n");
+		dev_err(&dev->dev, "failed to get irq resource ");
+		dev_err(&dev->dev, "for IFC\n");
+
 		ret = -ENODEV;
 		goto err;
 	}
diff --git a/drivers/mtd/nand/fsl_ifc_nand.c b/drivers/mtd/nand/fsl_ifc_nand.c
index 2338124..e902d24 100644
--- a/drivers/mtd/nand/fsl_ifc_nand.c
+++ b/drivers/mtd/nand/fsl_ifc_nand.c
@@ -239,8 +239,9 @@ static void set_addr(struct mtd_info *mtd, int column, int page_addr, int oob)
 
 	ifc_nand_ctrl->page = page_addr;
 	/* Program ROW0/COL0 */
-	iowrite32be(page_addr, &ifc->ifc_nand.row0);
-	iowrite32be((oob ? IFC_NAND_COL_MS : 0) | column, &ifc->ifc_nand.col0);
+	ifc_out32(page_addr, &ifc->ifc_nand.row0);
+	ifc_out32((oob ? IFC_NAND_COL_MS : 0) | column,
+			&ifc->ifc_nand.col0);
 
 	buf_num = page_addr & priv->bufnum_mask;
 
@@ -302,19 +303,20 @@ static void fsl_ifc_run_command(struct mtd_info *mtd)
 	int i;
 
 	/* set the chip select for NAND Transaction */
-	iowrite32be(priv->bank << IFC_NAND_CSEL_SHIFT,
+	ifc_out32(priv->bank << IFC_NAND_CSEL_SHIFT,
 		    &ifc->ifc_nand.nand_csel);
 
 	dev_vdbg(priv->dev,
 			"%s: fir0=%08x fcr0=%08x\n",
 			__func__,
-			ioread32be(&ifc->ifc_nand.nand_fir0),
-			ioread32be(&ifc->ifc_nand.nand_fcr0));
+			ifc_in32(&ifc->ifc_nand.nand_fir0),
+			ifc_in32(&ifc->ifc_nand.nand_fcr0));
 
 	ctrl->nand_stat = 0;
 
 	/* start read/write seq */
-	iowrite32be(IFC_NAND_SEQ_STRT_FIR_STRT, &ifc->ifc_nand.nandseq_strt);
+	ifc_out32(IFC_NAND_SEQ_STRT_FIR_STRT,
+			&ifc->ifc_nand.nandseq_strt);
 
 	/* wait for command complete flag or timeout */
 	wait_event_timeout(ctrl->nand_wait, ctrl->nand_stat,
@@ -337,7 +339,8 @@ static void fsl_ifc_run_command(struct mtd_info *mtd)
 		int sector_end = sector + chip->ecc.steps - 1;
 
 		for (i = sector / 4; i <= sector_end / 4; i++)
-			eccstat[i] = ioread32be(&ifc->ifc_nand.nand_eccstat[i]);
+			eccstat[i] = ifc_in32(
+					&ifc->ifc_nand.nand_eccstat[i]);
 
 		for (i = sector; i <= sector_end; i++) {
 			errors = check_read_ecc(mtd, ctrl, eccstat, i);
@@ -377,31 +380,31 @@ static void fsl_ifc_do_read(struct nand_chip *chip,
 
 	/* Program FIR/IFC_NAND_FCR0 for Small/Large page */
 	if (mtd->writesize > 512) {
-		iowrite32be((IFC_FIR_OP_CW0 << IFC_NAND_FIR0_OP0_SHIFT) |
+		ifc_out32((IFC_FIR_OP_CW0 << IFC_NAND_FIR0_OP0_SHIFT) |
 			    (IFC_FIR_OP_CA0 << IFC_NAND_FIR0_OP1_SHIFT) |
 			    (IFC_FIR_OP_RA0 << IFC_NAND_FIR0_OP2_SHIFT) |
 			    (IFC_FIR_OP_CMD1 << IFC_NAND_FIR0_OP3_SHIFT) |
 			    (IFC_FIR_OP_RBCD << IFC_NAND_FIR0_OP4_SHIFT),
 			    &ifc->ifc_nand.nand_fir0);
-		iowrite32be(0x0, &ifc->ifc_nand.nand_fir1);
+		ifc_out32(0x0, &ifc->ifc_nand.nand_fir1);
 
-		iowrite32be((NAND_CMD_READ0 << IFC_NAND_FCR0_CMD0_SHIFT) |
+		ifc_out32((NAND_CMD_READ0 << IFC_NAND_FCR0_CMD0_SHIFT) |
 			    (NAND_CMD_READSTART << IFC_NAND_FCR0_CMD1_SHIFT),
 			    &ifc->ifc_nand.nand_fcr0);
 	} else {
-		iowrite32be((IFC_FIR_OP_CW0 << IFC_NAND_FIR0_OP0_SHIFT) |
+		ifc_out32((IFC_FIR_OP_CW0 << IFC_NAND_FIR0_OP0_SHIFT) |
 			    (IFC_FIR_OP_CA0 << IFC_NAND_FIR0_OP1_SHIFT) |
 			    (IFC_FIR_OP_RA0  << IFC_NAND_FIR0_OP2_SHIFT) |
 			    (IFC_FIR_OP_RBCD << IFC_NAND_FIR0_OP3_SHIFT),
 			    &ifc->ifc_nand.nand_fir0);
-		iowrite32be(0x0, &ifc->ifc_nand.nand_fir1);
+		ifc_out32(0x0, &ifc->ifc_nand.nand_fir1);
 
 		if (oob)
-			iowrite32be(NAND_CMD_READOOB <<
+			ifc_out32(NAND_CMD_READOOB <<
 				    IFC_NAND_FCR0_CMD0_SHIFT,
 				    &ifc->ifc_nand.nand_fcr0);
 		else
-			iowrite32be(NAND_CMD_READ0 <<
+			ifc_out32(NAND_CMD_READ0 <<
 				    IFC_NAND_FCR0_CMD0_SHIFT,
 				    &ifc->ifc_nand.nand_fcr0);
 	}
@@ -423,7 +426,7 @@ static void fsl_ifc_cmdfunc(struct mtd_info *mtd, unsigned int command,
 	switch (command) {
 	/* READ0 read the entire buffer to use hardware ECC. */
 	case NAND_CMD_READ0:
-		iowrite32be(0, &ifc->ifc_nand.nand_fbcr);
+		ifc_out32(0, &ifc->ifc_nand.nand_fbcr);
 		set_addr(mtd, 0, page_addr, 0);
 
 		ifc_nand_ctrl->read_bytes = mtd->writesize + mtd->oobsize;
@@ -438,7 +441,8 @@ static void fsl_ifc_cmdfunc(struct mtd_info *mtd, unsigned int command,
 
 	/* READOOB reads only the OOB because no ECC is performed. */
 	case NAND_CMD_READOOB:
-		iowrite32be(mtd->oobsize - column, &ifc->ifc_nand.nand_fbcr);
+		ifc_out32(mtd->oobsize - column,
+				&ifc->ifc_nand.nand_fbcr);
 		set_addr(mtd, column, page_addr, 1);
 
 		ifc_nand_ctrl->read_bytes = mtd->writesize + mtd->oobsize;
@@ -454,19 +458,19 @@ static void fsl_ifc_cmdfunc(struct mtd_info *mtd, unsigned int command,
 		if (command == NAND_CMD_PARAM)
 			timing = IFC_FIR_OP_RBCD;
 
-		iowrite32be((IFC_FIR_OP_CW0 << IFC_NAND_FIR0_OP0_SHIFT) |
+		ifc_out32((IFC_FIR_OP_CW0 << IFC_NAND_FIR0_OP0_SHIFT) |
 			    (IFC_FIR_OP_UA  << IFC_NAND_FIR0_OP1_SHIFT) |
 			    (timing << IFC_NAND_FIR0_OP2_SHIFT),
 			    &ifc->ifc_nand.nand_fir0);
-		iowrite32be(command << IFC_NAND_FCR0_CMD0_SHIFT,
+		ifc_out32(command << IFC_NAND_FCR0_CMD0_SHIFT,
 			    &ifc->ifc_nand.nand_fcr0);
-		iowrite32be(column, &ifc->ifc_nand.row3);
+		ifc_out32(column, &ifc->ifc_nand.row3);
 
 		/*
 		 * although currently it's 8 bytes for READID, we always read
 		 * the maximum 256 bytes(for PARAM)
 		 */
-		iowrite32be(256, &ifc->ifc_nand.nand_fbcr);
+		ifc_out32(256, &ifc->ifc_nand.nand_fbcr);
 		ifc_nand_ctrl->read_bytes = 256;
 
 		set_addr(mtd, 0, 0, 0);
@@ -481,16 +485,16 @@ static void fsl_ifc_cmdfunc(struct mtd_info *mtd, unsigned int command,
 
 	/* ERASE2 uses the block and page address from ERASE1 */
 	case NAND_CMD_ERASE2:
-		iowrite32be((IFC_FIR_OP_CW0 << IFC_NAND_FIR0_OP0_SHIFT) |
+		ifc_out32((IFC_FIR_OP_CW0 << IFC_NAND_FIR0_OP0_SHIFT) |
 			    (IFC_FIR_OP_RA0 << IFC_NAND_FIR0_OP1_SHIFT) |
 			    (IFC_FIR_OP_CMD1 << IFC_NAND_FIR0_OP2_SHIFT),
 			    &ifc->ifc_nand.nand_fir0);
 
-		iowrite32be((NAND_CMD_ERASE1 << IFC_NAND_FCR0_CMD0_SHIFT) |
+		ifc_out32((NAND_CMD_ERASE1 << IFC_NAND_FCR0_CMD0_SHIFT) |
 			    (NAND_CMD_ERASE2 << IFC_NAND_FCR0_CMD1_SHIFT),
 			    &ifc->ifc_nand.nand_fcr0);
 
-		iowrite32be(0, &ifc->ifc_nand.nand_fbcr);
+		ifc_out32(0, &ifc->ifc_nand.nand_fbcr);
 		ifc_nand_ctrl->read_bytes = 0;
 		fsl_ifc_run_command(mtd);
 		return;
@@ -507,14 +511,14 @@ static void fsl_ifc_cmdfunc(struct mtd_info *mtd, unsigned int command,
 				(NAND_CMD_STATUS << IFC_NAND_FCR0_CMD1_SHIFT) |
 				(NAND_CMD_PAGEPROG << IFC_NAND_FCR0_CMD2_SHIFT);
 
-			iowrite32be(
+			ifc_out32(
 				 (IFC_FIR_OP_CW0 << IFC_NAND_FIR0_OP0_SHIFT) |
 				 (IFC_FIR_OP_CA0 << IFC_NAND_FIR0_OP1_SHIFT) |
 				 (IFC_FIR_OP_RA0 << IFC_NAND_FIR0_OP2_SHIFT) |
 				 (IFC_FIR_OP_WBCD  << IFC_NAND_FIR0_OP3_SHIFT) |
 				 (IFC_FIR_OP_CMD2 << IFC_NAND_FIR0_OP4_SHIFT),
 				 &ifc->ifc_nand.nand_fir0);
-			iowrite32be(
+			ifc_out32(
 				 (IFC_FIR_OP_CW1 << IFC_NAND_FIR1_OP5_SHIFT) |
 				 (IFC_FIR_OP_RDSTAT <<
 					IFC_NAND_FIR1_OP6_SHIFT) |
@@ -528,14 +532,14 @@ static void fsl_ifc_cmdfunc(struct mtd_info *mtd, unsigned int command,
 				    (NAND_CMD_STATUS <<
 					IFC_NAND_FCR0_CMD3_SHIFT));
 
-			iowrite32be(
+			ifc_out32(
 				(IFC_FIR_OP_CW0 << IFC_NAND_FIR0_OP0_SHIFT) |
 				(IFC_FIR_OP_CMD2 << IFC_NAND_FIR0_OP1_SHIFT) |
 				(IFC_FIR_OP_CA0 << IFC_NAND_FIR0_OP2_SHIFT) |
 				(IFC_FIR_OP_RA0 << IFC_NAND_FIR0_OP3_SHIFT) |
 				(IFC_FIR_OP_WBCD << IFC_NAND_FIR0_OP4_SHIFT),
 				&ifc->ifc_nand.nand_fir0);
-			iowrite32be(
+			ifc_out32(
 				 (IFC_FIR_OP_CMD1 << IFC_NAND_FIR1_OP5_SHIFT) |
 				 (IFC_FIR_OP_CW3 << IFC_NAND_FIR1_OP6_SHIFT) |
 				 (IFC_FIR_OP_RDSTAT <<
@@ -556,7 +560,7 @@ static void fsl_ifc_cmdfunc(struct mtd_info *mtd, unsigned int command,
 			column -= mtd->writesize;
 			ifc_nand_ctrl->oob = 1;
 		}
-		iowrite32be(nand_fcr0, &ifc->ifc_nand.nand_fcr0);
+		ifc_out32(nand_fcr0, &ifc->ifc_nand.nand_fcr0);
 		set_addr(mtd, column, page_addr, ifc_nand_ctrl->oob);
 		return;
 	}
@@ -564,11 +568,11 @@ static void fsl_ifc_cmdfunc(struct mtd_info *mtd, unsigned int command,
 	/* PAGEPROG reuses all of the setup from SEQIN and adds the length */
 	case NAND_CMD_PAGEPROG: {
 		if (ifc_nand_ctrl->oob) {
-			iowrite32be(ifc_nand_ctrl->index -
+			ifc_out32(ifc_nand_ctrl->index -
 				    ifc_nand_ctrl->column,
 				    &ifc->ifc_nand.nand_fbcr);
 		} else {
-			iowrite32be(0, &ifc->ifc_nand.nand_fbcr);
+			ifc_out32(0, &ifc->ifc_nand.nand_fbcr);
 		}
 
 		fsl_ifc_run_command(mtd);
@@ -576,12 +580,12 @@ static void fsl_ifc_cmdfunc(struct mtd_info *mtd, unsigned int command,
 	}
 
 	case NAND_CMD_STATUS:
-		iowrite32be((IFC_FIR_OP_CW0 << IFC_NAND_FIR0_OP0_SHIFT) |
+		ifc_out32((IFC_FIR_OP_CW0 << IFC_NAND_FIR0_OP0_SHIFT) |
 			    (IFC_FIR_OP_RB << IFC_NAND_FIR0_OP1_SHIFT),
 			    &ifc->ifc_nand.nand_fir0);
-		iowrite32be(NAND_CMD_STATUS << IFC_NAND_FCR0_CMD0_SHIFT,
+		ifc_out32(NAND_CMD_STATUS << IFC_NAND_FCR0_CMD0_SHIFT,
 			    &ifc->ifc_nand.nand_fcr0);
-		iowrite32be(1, &ifc->ifc_nand.nand_fbcr);
+		ifc_out32(1, &ifc->ifc_nand.nand_fbcr);
 		set_addr(mtd, 0, 0, 0);
 		ifc_nand_ctrl->read_bytes = 1;
 
@@ -592,15 +596,21 @@ static void fsl_ifc_cmdfunc(struct mtd_info *mtd, unsigned int command,
 		 * write-protected, even when it is not.
 		 */
 		if (chip->options & NAND_BUSWIDTH_16)
-			setbits16(ifc_nand_ctrl->addr, NAND_STATUS_WP);
+			ifc_out16(
+			(ifc_in16(ifc_nand_ctrl->addr)
+			| (NAND_STATUS_WP)),
+			ifc_nand_ctrl->addr);
 		else
-			setbits8(ifc_nand_ctrl->addr, NAND_STATUS_WP);
+			ifc_out8(
+			(ifc_in8(ifc_nand_ctrl->addr)
+			| (NAND_STATUS_WP)),
+			ifc_nand_ctrl->addr);
 		return;
 
 	case NAND_CMD_RESET:
-		iowrite32be(IFC_FIR_OP_CW0 << IFC_NAND_FIR0_OP0_SHIFT,
+		ifc_out32(IFC_FIR_OP_CW0 << IFC_NAND_FIR0_OP0_SHIFT,
 			    &ifc->ifc_nand.nand_fir0);
-		iowrite32be(NAND_CMD_RESET << IFC_NAND_FCR0_CMD0_SHIFT,
+		ifc_out32(NAND_CMD_RESET << IFC_NAND_FCR0_CMD0_SHIFT,
 			    &ifc->ifc_nand.nand_fcr0);
 		fsl_ifc_run_command(mtd);
 		return;
@@ -651,16 +661,14 @@ static uint8_t fsl_ifc_read_byte(struct mtd_info *mtd)
 {
 	struct nand_chip *chip = mtd->priv;
 	struct fsl_ifc_mtd *priv = chip->priv;
-	unsigned int offset;
 
 	/*
 	 * If there are still bytes in the IFC buffer, then use the
 	 * next byte.
 	 */
-	if (ifc_nand_ctrl->index < ifc_nand_ctrl->read_bytes) {
-		offset = ifc_nand_ctrl->index++;
-		return in_8(ifc_nand_ctrl->addr + offset);
-	}
+	if (ifc_nand_ctrl->index < ifc_nand_ctrl->read_bytes)
+		return ifc_in8(
+				&ifc_nand_ctrl->addr[ifc_nand_ctrl->index++]);
 
 	dev_err(priv->dev, "%s: beyond end of buffer\n", __func__);
 	return ERR_BYTE;
@@ -681,7 +689,8 @@ static uint8_t fsl_ifc_read_byte16(struct mtd_info *mtd)
 	 * next byte.
 	 */
 	if (ifc_nand_ctrl->index < ifc_nand_ctrl->read_bytes) {
-		data = in_be16(ifc_nand_ctrl->addr + ifc_nand_ctrl->index);
+		data = ifc_in16((uint16_t __iomem *)&ifc_nand_ctrl->
+			       addr[ifc_nand_ctrl->index]);
 		ifc_nand_ctrl->index += 2;
 		return (uint8_t) data;
 	}
@@ -727,18 +736,18 @@ static int fsl_ifc_wait(struct mtd_info *mtd, struct nand_chip *chip)
 	u32 nand_fsr;
 
 	/* Use READ_STATUS command, but wait for the device to be ready */
-	iowrite32be((IFC_FIR_OP_CW0 << IFC_NAND_FIR0_OP0_SHIFT) |
+	ifc_out32((IFC_FIR_OP_CW0 << IFC_NAND_FIR0_OP0_SHIFT) |
 		    (IFC_FIR_OP_RDSTAT << IFC_NAND_FIR0_OP1_SHIFT),
 		    &ifc->ifc_nand.nand_fir0);
-	iowrite32be(NAND_CMD_STATUS << IFC_NAND_FCR0_CMD0_SHIFT,
+	ifc_out32(NAND_CMD_STATUS << IFC_NAND_FCR0_CMD0_SHIFT,
 		    &ifc->ifc_nand.nand_fcr0);
-	iowrite32be(1, &ifc->ifc_nand.nand_fbcr);
+	ifc_out32(1, &ifc->ifc_nand.nand_fbcr);
 	set_addr(mtd, 0, 0, 0);
 	ifc_nand_ctrl->read_bytes = 1;
 
 	fsl_ifc_run_command(mtd);
 
-	nand_fsr = ioread32be(&ifc->ifc_nand.nand_fsr);
+	nand_fsr = ifc_in32(&ifc->ifc_nand.nand_fsr);
 
 	/*
 	 * The chip always seems to report that it is
@@ -830,34 +839,36 @@ static void fsl_ifc_sram_init(struct fsl_ifc_mtd *priv)
 	uint32_t cs = priv->bank;
 
 	/* Save CSOR and CSOR_ext */
-	csor = ioread32be(&ifc->csor_cs[cs].csor);
-	csor_ext = ioread32be(&ifc->csor_cs[cs].csor_ext);
+	csor = ifc_in32(&ifc->csor_cs[cs].csor);
+	csor_ext = ifc_in32(&ifc->csor_cs[cs].csor_ext);
 
 	/* chage PageSize 8K and SpareSize 1K*/
 	csor_8k = (csor & ~(CSOR_NAND_PGS_MASK)) | 0x0018C000;
-	iowrite32be(csor_8k, &ifc->csor_cs[cs].csor);
-	iowrite32be(0x0000400, &ifc->csor_cs[cs].csor_ext);
+	ifc_out32(csor_8k, &ifc->csor_cs[cs].csor);
+	ifc_out32(0x0000400, &ifc->csor_cs[cs].csor_ext);
 
 	/* READID */
-	iowrite32be((IFC_FIR_OP_CW0 << IFC_NAND_FIR0_OP0_SHIFT) |
+	ifc_out32((IFC_FIR_OP_CW0 << IFC_NAND_FIR0_OP0_SHIFT) |
 		    (IFC_FIR_OP_UA  << IFC_NAND_FIR0_OP1_SHIFT) |
 		    (IFC_FIR_OP_RB << IFC_NAND_FIR0_OP2_SHIFT),
 		    &ifc->ifc_nand.nand_fir0);
-	iowrite32be(NAND_CMD_READID << IFC_NAND_FCR0_CMD0_SHIFT,
+	ifc_out32(NAND_CMD_READID << IFC_NAND_FCR0_CMD0_SHIFT,
 		    &ifc->ifc_nand.nand_fcr0);
-	iowrite32be(0x0, &ifc->ifc_nand.row3);
+	ifc_out32(0x0, &ifc->ifc_nand.row3);
 
-	iowrite32be(0x0, &ifc->ifc_nand.nand_fbcr);
+	ifc_out32(0x0, &ifc->ifc_nand.nand_fbcr);
 
 	/* Program ROW0/COL0 */
-	iowrite32be(0x0, &ifc->ifc_nand.row0);
-	iowrite32be(0x0, &ifc->ifc_nand.col0);
+	ifc_out32(0x0, &ifc->ifc_nand.row0);
+	ifc_out32(0x0, &ifc->ifc_nand.col0);
 
 	/* set the chip select for NAND Transaction */
-	iowrite32be(cs << IFC_NAND_CSEL_SHIFT, &ifc->ifc_nand.nand_csel);
+	ifc_out32(cs << IFC_NAND_CSEL_SHIFT,
+			&ifc->ifc_nand.nand_csel);
 
 	/* start read seq */
-	iowrite32be(IFC_NAND_SEQ_STRT_FIR_STRT, &ifc->ifc_nand.nandseq_strt);
+	ifc_out32(IFC_NAND_SEQ_STRT_FIR_STRT,
+			&ifc->ifc_nand.nandseq_strt);
 
 	/* wait for command complete flag or timeout */
 	wait_event_timeout(ctrl->nand_wait, ctrl->nand_stat,
@@ -867,8 +878,8 @@ static void fsl_ifc_sram_init(struct fsl_ifc_mtd *priv)
 		printk(KERN_ERR "fsl-ifc: Failed to Initialise SRAM\n");
 
 	/* Restore CSOR and CSOR_ext */
-	iowrite32be(csor, &ifc->csor_cs[cs].csor);
-	iowrite32be(csor_ext, &ifc->csor_cs[cs].csor_ext);
+	ifc_out32(csor, &ifc->csor_cs[cs].csor);
+	ifc_out32(csor_ext, &ifc->csor_cs[cs].csor_ext);
 }
 
 static int fsl_ifc_chip_init(struct fsl_ifc_mtd *priv)
@@ -885,7 +896,8 @@ static int fsl_ifc_chip_init(struct fsl_ifc_mtd *priv)
 
 	/* fill in nand_chip structure */
 	/* set up function call table */
-	if ((ioread32be(&ifc->cspr_cs[priv->bank].cspr)) & CSPR_PORT_SIZE_16)
+	if ((ifc_in32(&ifc->cspr_cs[priv->bank].cspr)) &
+			CSPR_PORT_SIZE_16)
 		chip->read_byte = fsl_ifc_read_byte16;
 	else
 		chip->read_byte = fsl_ifc_read_byte;
@@ -899,13 +911,14 @@ static int fsl_ifc_chip_init(struct fsl_ifc_mtd *priv)
 	chip->bbt_td = &bbt_main_descr;
 	chip->bbt_md = &bbt_mirror_descr;
 
-	iowrite32be(0x0, &ifc->ifc_nand.ncfgr);
+	ifc_out32(0x0, &ifc->ifc_nand.ncfgr);
 
 	/* set up nand options */
 	chip->bbt_options = NAND_BBT_USE_FLASH;
 	chip->options = NAND_NO_SUBPAGE_WRITE;
 
-	if (ioread32be(&ifc->cspr_cs[priv->bank].cspr) & CSPR_PORT_SIZE_16) {
+	if (ifc_in32(&ifc->cspr_cs[priv->bank].cspr)
+		& CSPR_PORT_SIZE_16) {
 		chip->read_byte = fsl_ifc_read_byte16;
 		chip->options |= NAND_BUSWIDTH_16;
 	} else {
@@ -918,7 +931,7 @@ static int fsl_ifc_chip_init(struct fsl_ifc_mtd *priv)
 	chip->ecc.read_page = fsl_ifc_read_page;
 	chip->ecc.write_page = fsl_ifc_write_page;
 
-	csor = ioread32be(&ifc->csor_cs[priv->bank].csor);
+	csor = ifc_in32(&ifc->csor_cs[priv->bank].csor);
 
 	/* Hardware generates ECC per 512 Bytes */
 	chip->ecc.size = 512;
@@ -984,7 +997,7 @@ static int fsl_ifc_chip_init(struct fsl_ifc_mtd *priv)
 		chip->ecc.mode = NAND_ECC_SOFT;
 	}
 
-	ver = ioread32be(&ifc->ifc_rev);
+	ver = ifc_in32(&ifc->ifc_rev);
 	if (ver == FSL_IFC_V1_1_0)
 		fsl_ifc_sram_init(priv);
 
@@ -1008,7 +1021,7 @@ static int fsl_ifc_chip_remove(struct fsl_ifc_mtd *priv)
 static int match_bank(struct fsl_ifc_regs __iomem *ifc, int bank,
 		      phys_addr_t addr)
 {
-	u32 cspr = ioread32be(&ifc->cspr_cs[bank].cspr);
+	u32 cspr = ifc_in32(&ifc->cspr_cs[bank].cspr);
 
 	if (!(cspr & CSPR_V))
 		return 0;
@@ -1094,13 +1107,13 @@ static int fsl_ifc_nand_probe(struct platform_device *dev)
 
 	dev_set_drvdata(priv->dev, priv);
 
-	iowrite32be(IFC_NAND_EVTER_EN_OPC_EN |
+	ifc_out32(IFC_NAND_EVTER_EN_OPC_EN |
 		    IFC_NAND_EVTER_EN_FTOER_EN |
 		    IFC_NAND_EVTER_EN_WPER_EN,
 		    &ifc->ifc_nand.nand_evter_en);
 
 	/* enable NAND Machine Interrupts */
-	iowrite32be(IFC_NAND_EVTER_INTR_OPCIR_EN |
+	ifc_out32(IFC_NAND_EVTER_INTR_OPCIR_EN |
 		    IFC_NAND_EVTER_INTR_FTOERIR_EN |
 		    IFC_NAND_EVTER_INTR_WPERIR_EN,
 		    &ifc->ifc_nand.nand_evter_intr_en);
diff --git a/include/linux/fsl_ifc.h b/include/linux/fsl_ifc.h
index f49ddb1..0530b47 100644
--- a/include/linux/fsl_ifc.h
+++ b/include/linux/fsl_ifc.h
@@ -830,9 +830,51 @@ struct fsl_ifc_ctrl {
 
 	u32 nand_stat;
 	wait_queue_head_t nand_wait;
+	bool little_endian;
 };
 
 extern struct fsl_ifc_ctrl *fsl_ifc_ctrl_dev;
 
+static inline u32 ifc_in32(void __iomem *addr)
+{
+	if (fsl_ifc_ctrl_dev->little_endian)
+		return ioread32(addr);
+	else
+		return ioread32be(addr);
+}
+
+static inline u16 ifc_in16(void __iomem *addr)
+{
+	if (fsl_ifc_ctrl_dev->little_endian)
+		return ioread16(addr);
+	else
+		return ioread16be(addr);
+}
+
+static inline u8 ifc_in8(void __iomem *addr)
+{
+	return ioread8(addr);
+}
+
+static inline void ifc_out32(u32 val, void __iomem *addr)
+{
+	if (fsl_ifc_ctrl_dev->little_endian)
+		return iowrite32(val, addr);
+	else
+		return iowrite32be(val, addr);
+}
+
+static inline void ifc_out16(u16 val, void __iomem *addr)
+{
+	if (fsl_ifc_ctrl_dev->little_endian)
+		return iowrite16(val, addr);
+	else
+		return iowrite16be(val, addr);
+}
+
+static inline void ifc_out8(u8 val, void __iomem *addr)
+{
+	return iowrite8(val, addr);
+}
 
 #endif /* __ASM_FSL_IFC_H */
-- 
1.7.9.5


