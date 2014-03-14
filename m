Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156AbaCNPsH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 11:48:07 -0400
Received: from mail-by2lp0240.outbound.protection.outlook.com ([207.46.163.240]:7269
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755800AbaCNPsC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 11:48:02 -0400
Date: Fri, 14 Mar 2014 21:13:51 +0530
From: "Reddy, Sreekanth" <Sreekanth.Reddy@lsi.com>
To: <jejb@kernel.org>, <JBottomley@Parallels.com>
CC: <linux-scsi@vger.kernel.org>, <Sathya.Prakash@lsi.com>,
        <Nagalakshmi.Nandigama@lsi.com>, <sreekanth.reddy@lsi.com>,
        <linux-kernel@vger.kernel.org>, <sreekanthreddy0547@gmail.com>
Subject: [PATCH 09/11][SCSI]mpt2sas: Get IOC_FACTS information using
 handshake protocol only after HBA card gets into READY or Operational state
Message-ID: <20140314154351.GA8054@lsi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.19.220.100;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019001)(6009001)(458001)(189002)(199002)(74876001)(33656001)(50466002)(74706001)(23726002)(74366001)(46406003)(85306002)(87266001)(53806001)(76482001)(87936001)(54356001)(6806004)(51856001)(46102001)(56776001)(54316002)(97756001)(81816001)(47976001)(50986001)(49866001)(4396001)(19580405001)(81686001)(80976001)(83322001)(19580395003)(47736001)(83506001)(44976005)(95666003)(90146001)(63696002)(79102001)(77982001)(97336001)(59766001)(97186001)(20776003)(80022001)(65816001)(47776003)(85852003)(93516002)(93136001)(36756003)(83072002)(76176001)(57986002)(86362001)(92566001)(92726001)(47446002)(74502001)(81342001)(56816005)(95416001)(77096001)(74662001)(81542001)(69226001)(76796001)(16796002)(31966008)(94316002)(76786001)(94946001)(2101003);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR07MB071;H:COSEXCH10.lsi.com;FPR:BCD1F0DE.26FAFACE.72FD137F.96F55EC0.20517;PTR:cosexch10.lsi.com;MX:1;A:1;LANG:en;
X-Forefront-PRVS: 0150F3F97D
X-OriginatorOrg: lsi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver would send IOC facts only if HBA is in operational or ready
state. If it is in fault state, a diagnostic reset would be issued. It
would wait for 10 seconds to exit out of reset state. If the HBA continues
to be in reset state, then the HBA wouldn't be claimed by the driver.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
---
 drivers/scsi/mpt2sas/mpt2sas_base.c |  416 ++++++++++++++++++++---------------
 1 files changed, 239 insertions(+), 177 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index 81f1d58..697c841 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -1737,6 +1737,238 @@ _base_handshake_req_reply_wait(struct MPT2SAS_ADAPTER *ioc, int request_bytes,
 }
 
 /**
+ * mpt2sas_base_get_iocstate - Get the current state of a MPT adapter.
+ * @ioc: Pointer to MPT_ADAPTER structure
+ * @cooked: Request raw or cooked IOC state
+ *
+ * Returns all IOC Doorbell register bits if cooked==0, else just the
+ * Doorbell bits in MPI_IOC_STATE_MASK.
+ */
+u32
+mpt2sas_base_get_iocstate(struct MPT2SAS_ADAPTER *ioc, int cooked)
+{
+	u32 s, sc;
+
+	s = readl(&ioc->chip->Doorbell);
+	sc = s & MPI2_IOC_STATE_MASK;
+	return cooked ? sc : s;
+}
+
+/**
+ * _base_wait_on_iocstate - waiting on a particular ioc state
+ * @ioc_state: controller state { READY, OPERATIONAL, or RESET }
+ * @timeout: timeout in second
+ * @sleep_flag: CAN_SLEEP or NO_SLEEP
+ *
+ * Returns 0 for success, non-zero for failure.
+ */
+static int
+_base_wait_on_iocstate(struct MPT2SAS_ADAPTER *ioc, u32 ioc_state, int timeout,
+	int sleep_flag)
+{
+	u32 count, cntdn;
+	u32 current_state;
+
+	count = 0;
+	cntdn = (sleep_flag == CAN_SLEEP) ? 1000*timeout : 2000*timeout;
+	do {
+		current_state = mpt2sas_base_get_iocstate(ioc, 1);
+		if (current_state == ioc_state)
+			return 0;
+		if (count && current_state == MPI2_IOC_STATE_FAULT)
+			break;
+		if (sleep_flag == CAN_SLEEP)
+			msleep(1);
+		else
+			udelay(500);
+		count++;
+	} while (--cntdn);
+
+	return current_state;
+}
+
+/**
+ * _base_diag_reset - the "big hammer" start of day reset
+ * @ioc: per adapter object
+ * @sleep_flag: CAN_SLEEP or NO_SLEEP
+ *
+ * Returns 0 for success, non-zero for failure.
+ */
+static int
+_base_diag_reset(struct MPT2SAS_ADAPTER *ioc, int sleep_flag)
+{
+	u32 host_diagnostic;
+	u32 ioc_state;
+	u32 count;
+	u32 hcb_size;
+
+	printk(MPT2SAS_INFO_FMT "sending diag reset !!\n", ioc->name);
+
+	drsprintk(ioc, printk(MPT2SAS_INFO_FMT "clear interrupts\n",
+	    ioc->name));
+
+	count = 0;
+	do {
+		/* Write magic sequence to WriteSequence register
+		 * Loop until in diagnostic mode
+		 */
+		drsprintk(ioc, printk(MPT2SAS_INFO_FMT "write magic sequence\n"
+		    , ioc->name));
+		writel(MPI2_WRSEQ_FLUSH_KEY_VALUE, &ioc->chip->WriteSequence);
+		writel(MPI2_WRSEQ_1ST_KEY_VALUE, &ioc->chip->WriteSequence);
+		writel(MPI2_WRSEQ_2ND_KEY_VALUE, &ioc->chip->WriteSequence);
+		writel(MPI2_WRSEQ_3RD_KEY_VALUE, &ioc->chip->WriteSequence);
+		writel(MPI2_WRSEQ_4TH_KEY_VALUE, &ioc->chip->WriteSequence);
+		writel(MPI2_WRSEQ_5TH_KEY_VALUE, &ioc->chip->WriteSequence);
+		writel(MPI2_WRSEQ_6TH_KEY_VALUE, &ioc->chip->WriteSequence);
+
+		/* wait 100 msec */
+		if (sleep_flag == CAN_SLEEP)
+			msleep(100);
+		else
+			mdelay(100);
+
+		if (count++ > 20)
+			goto out;
+
+		host_diagnostic = readl(&ioc->chip->HostDiagnostic);
+		drsprintk(ioc, printk(MPT2SAS_INFO_FMT
+		  "wrote magic sequence: count(%d), host_diagnostic(0x%08x)\n",
+		  ioc->name, count, host_diagnostic));
+
+	} while ((host_diagnostic & MPI2_DIAG_DIAG_WRITE_ENABLE) == 0);
+
+	hcb_size = readl(&ioc->chip->HCBSize);
+
+	drsprintk(ioc, printk(MPT2SAS_INFO_FMT "diag reset: issued\n",
+	    ioc->name));
+	writel(host_diagnostic | MPI2_DIAG_RESET_ADAPTER,
+	     &ioc->chip->HostDiagnostic);
+
+	/*This delay allows the chip PCIe hardware time to finish reset tasks*/
+	if (sleep_flag == CAN_SLEEP)
+		msleep(MPI2_HARD_RESET_PCIE_FIRST_READ_DELAY_MICRO_SEC/1000);
+	else
+		mdelay(MPI2_HARD_RESET_PCIE_FIRST_READ_DELAY_MICRO_SEC/1000);
+
+	/* Approximately 300 second max wait */
+	for (count = 0; count < (300000000 /
+	    MPI2_HARD_RESET_PCIE_SECOND_READ_DELAY_MICRO_SEC); count++) {
+
+		host_diagnostic = readl(&ioc->chip->HostDiagnostic);
+
+		if (host_diagnostic == 0xFFFFFFFF)
+			goto out;
+		if (!(host_diagnostic & MPI2_DIAG_RESET_ADAPTER))
+			break;
+
+		/* Wait to pass the second read delay window */
+		if (sleep_flag == CAN_SLEEP)
+			msleep(MPI2_HARD_RESET_PCIE_SECOND_READ_DELAY_MICRO_SEC
+			      /1000);
+		else
+			mdelay(MPI2_HARD_RESET_PCIE_SECOND_READ_DELAY_MICRO_SEC
+			      /1000);
+	}
+
+	if (host_diagnostic & MPI2_DIAG_HCB_MODE) {
+
+		drsprintk(ioc, printk(MPT2SAS_INFO_FMT
+		 "restart adapter assuming HCB Address points to good FW\n",
+		 ioc->name));
+		host_diagnostic &= ~MPI2_DIAG_BOOT_DEVICE_SELECT_MASK;
+		host_diagnostic |= MPI2_DIAG_BOOT_DEVICE_SELECT_HCDW;
+		writel(host_diagnostic, &ioc->chip->HostDiagnostic);
+
+		drsprintk(ioc, printk(MPT2SAS_INFO_FMT
+		    "re-enable the HCDW\n", ioc->name));
+		writel(hcb_size | MPI2_HCB_SIZE_HCB_ENABLE,
+		    &ioc->chip->HCBSize);
+	}
+
+	drsprintk(ioc, printk(MPT2SAS_INFO_FMT "restart the adapter\n",
+	    ioc->name));
+	writel(host_diagnostic & ~MPI2_DIAG_HOLD_IOC_RESET,
+	    &ioc->chip->HostDiagnostic);
+
+	drsprintk(ioc, printk(MPT2SAS_INFO_FMT
+	    "disable writes to the diagnostic register\n", ioc->name));
+	writel(MPI2_WRSEQ_FLUSH_KEY_VALUE, &ioc->chip->WriteSequence);
+
+	drsprintk(ioc, printk(MPT2SAS_INFO_FMT
+	    "Wait for FW to go to the READY state\n", ioc->name));
+	ioc_state = _base_wait_on_iocstate(ioc, MPI2_IOC_STATE_READY, 20,
+	    sleep_flag);
+	if (ioc_state) {
+		printk(MPT2SAS_ERR_FMT
+		    "%s: failed going to ready state(ioc_state=0x%x)\n",
+		    ioc->name, __func__, ioc_state);
+		goto out;
+	}
+
+	printk(MPT2SAS_INFO_FMT "diag reset: SUCCESS\n", ioc->name);
+	return 0;
+
+ out:
+	printk(MPT2SAS_ERR_FMT "diag reset: FAILED\n", ioc->name);
+	return -EFAULT;
+}
+
+/**
+ * _base_wait_for_iocstate - Wait until the card is in READY or OPERATIONAL
+ * @ioc: per adapter object
+ * @timeout:
+ * @sleep_flag: CAN_SLEEP or NO_SLEEP
+ *
+ * Returns 0 for success, non-zero for failure.
+ */
+static int
+_base_wait_for_iocstate(struct MPT2SAS_ADAPTER *ioc, int timeout,
+	int sleep_flag)
+{
+	u32 ioc_state;
+	int rc;
+
+	dinitprintk(ioc, printk(MPT2SAS_INFO_FMT "%s\n", ioc->name,
+	    __func__));
+
+	if (ioc->pci_error_recovery)
+		return 0;
+
+	ioc_state = mpt2sas_base_get_iocstate(ioc, 0);
+	dhsprintk(ioc, printk(MPT2SAS_INFO_FMT "%s: ioc_state(0x%08x)\n",
+	    ioc->name, __func__, ioc_state));
+
+	if (((ioc_state & MPI2_IOC_STATE_MASK) == MPI2_IOC_STATE_READY) ||
+	    (ioc_state & MPI2_IOC_STATE_MASK) == MPI2_IOC_STATE_OPERATIONAL)
+		return 0;
+
+	if (ioc_state & MPI2_DOORBELL_USED) {
+		dhsprintk(ioc, printk(MPT2SAS_INFO_FMT
+		    "unexpected doorbell activ!e\n", ioc->name));
+		goto issue_diag_reset;
+	}
+
+	if ((ioc_state & MPI2_IOC_STATE_MASK) == MPI2_IOC_STATE_FAULT) {
+		mpt2sas_base_fault_info(ioc, ioc_state &
+		    MPI2_DOORBELL_DATA_MASK);
+		goto issue_diag_reset;
+	}
+
+	ioc_state = _base_wait_on_iocstate(ioc, MPI2_IOC_STATE_READY,
+	    timeout, sleep_flag);
+	if (ioc_state) {
+		printk(MPT2SAS_ERR_FMT
+		    "%s: failed going to ready state (ioc_state=0x%x)\n",
+		    ioc->name, __func__, ioc_state);
+		return -EFAULT;
+	}
+
+ issue_diag_reset:
+	rc = _base_diag_reset(ioc, sleep_flag);
+	return rc;
+}
+/**
  * _base_get_ioc_facts - obtain ioc facts reply and save in ioc
  * @ioc: per adapter object
  * @sleep_flag: CAN_SLEEP or NO_SLEEP
@@ -1752,8 +1984,14 @@ _base_get_ioc_facts(struct MPT2SAS_ADAPTER *ioc, int sleep_flag)
 	int mpi_reply_sz, mpi_request_sz, r;
 
 	dinitprintk(ioc, printk(MPT2SAS_INFO_FMT "%s\n", ioc->name,
-	    __func__));
+		    __func__));
 
+	r = _base_wait_for_iocstate(ioc, 10, sleep_flag);
+	if (r) {
+		printk(MPT2SAS_ERR_FMT "%s: failed getting to correct state\n",
+			ioc->name, __func__);
+		return r;
+	}
 	mpi_reply_sz = sizeof(Mpi2IOCFactsReply_t);
 	mpi_request_sz = sizeof(Mpi2IOCFactsRequest_t);
 	memset(&mpi_request, 0, mpi_request_sz);
@@ -3228,57 +3466,6 @@ chain_done:
 }
 
 /**
- * mpt2sas_base_get_iocstate - Get the current state of a MPT adapter.
- * @ioc: Pointer to MPT_ADAPTER structure
- * @cooked: Request raw or cooked IOC state
- *
- * Returns all IOC Doorbell register bits if cooked==0, else just the
- * Doorbell bits in MPI_IOC_STATE_MASK.
- */
-u32
-mpt2sas_base_get_iocstate(struct MPT2SAS_ADAPTER *ioc, int cooked)
-{
-	u32 s, sc;
-
-	s = readl(&ioc->chip->Doorbell);
-	sc = s & MPI2_IOC_STATE_MASK;
-	return cooked ? sc : s;
-}
-
-/**
- * _base_wait_on_iocstate - waiting on a particular ioc state
- * @ioc_state: controller state { READY, OPERATIONAL, or RESET }
- * @timeout: timeout in second
- * @sleep_flag: CAN_SLEEP or NO_SLEEP
- *
- * Returns 0 for success, non-zero for failure.
- */
-static int
-_base_wait_on_iocstate(struct MPT2SAS_ADAPTER *ioc, u32 ioc_state, int timeout,
-    int sleep_flag)
-{
-	u32 count, cntdn;
-	u32 current_state;
-
-	count = 0;
-	cntdn = (sleep_flag == CAN_SLEEP) ? 1000*timeout : 2000*timeout;
-	do {
-		current_state = mpt2sas_base_get_iocstate(ioc, 1);
-		if (current_state == ioc_state)
-			return 0;
-		if (count && current_state == MPI2_IOC_STATE_FAULT)
-			break;
-		if (sleep_flag == CAN_SLEEP)
-			msleep(1);
-		else
-			udelay(500);
-		count++;
-	} while (--cntdn);
-
-	return current_state;
-}
-
-/**
  * _base_send_ioc_reset - send doorbell reset
  * @ioc: per adapter object
  * @reset_type: currently only supports: MPI2_FUNCTION_IOC_MESSAGE_UNIT_RESET
@@ -4039,131 +4226,6 @@ mpt2sas_base_validate_event_type(struct MPT2SAS_ADAPTER *ioc, u32 *event_type)
 }
 
 /**
- * _base_diag_reset - the "big hammer" start of day reset
- * @ioc: per adapter object
- * @sleep_flag: CAN_SLEEP or NO_SLEEP
- *
- * Returns 0 for success, non-zero for failure.
- */
-static int
-_base_diag_reset(struct MPT2SAS_ADAPTER *ioc, int sleep_flag)
-{
-	u32 host_diagnostic;
-	u32 ioc_state;
-	u32 count;
-	u32 hcb_size;
-
-	printk(MPT2SAS_INFO_FMT "sending diag reset !!\n", ioc->name);
-	drsprintk(ioc, printk(MPT2SAS_INFO_FMT "clear interrupts\n",
-	    ioc->name));
-
-	count = 0;
-	do {
-		/* Write magic sequence to WriteSequence register
-		 * Loop until in diagnostic mode
-		 */
-		drsprintk(ioc, printk(MPT2SAS_INFO_FMT "write magic "
-		    "sequence\n", ioc->name));
-		writel(MPI2_WRSEQ_FLUSH_KEY_VALUE, &ioc->chip->WriteSequence);
-		writel(MPI2_WRSEQ_1ST_KEY_VALUE, &ioc->chip->WriteSequence);
-		writel(MPI2_WRSEQ_2ND_KEY_VALUE, &ioc->chip->WriteSequence);
-		writel(MPI2_WRSEQ_3RD_KEY_VALUE, &ioc->chip->WriteSequence);
-		writel(MPI2_WRSEQ_4TH_KEY_VALUE, &ioc->chip->WriteSequence);
-		writel(MPI2_WRSEQ_5TH_KEY_VALUE, &ioc->chip->WriteSequence);
-		writel(MPI2_WRSEQ_6TH_KEY_VALUE, &ioc->chip->WriteSequence);
-
-		/* wait 100 msec */
-		if (sleep_flag == CAN_SLEEP)
-			msleep(100);
-		else
-			mdelay(100);
-
-		if (count++ > 20)
-			goto out;
-
-		host_diagnostic = readl(&ioc->chip->HostDiagnostic);
-		drsprintk(ioc, printk(MPT2SAS_INFO_FMT "wrote magic "
-		    "sequence: count(%d), host_diagnostic(0x%08x)\n",
-		    ioc->name, count, host_diagnostic));
-
-	} while ((host_diagnostic & MPI2_DIAG_DIAG_WRITE_ENABLE) == 0);
-
-	hcb_size = readl(&ioc->chip->HCBSize);
-
-	drsprintk(ioc, printk(MPT2SAS_INFO_FMT "diag reset: issued\n",
-	    ioc->name));
-	writel(host_diagnostic | MPI2_DIAG_RESET_ADAPTER,
-	     &ioc->chip->HostDiagnostic);
-
-	/* This delay allows the chip PCIe hardware time to finish reset tasks*/
-	if (sleep_flag == CAN_SLEEP)
-		msleep(MPI2_HARD_RESET_PCIE_FIRST_READ_DELAY_MICRO_SEC/1000);
-	else
-		mdelay(MPI2_HARD_RESET_PCIE_FIRST_READ_DELAY_MICRO_SEC/1000);
-
-	/* Approximately 300 second max wait */
-	for (count = 0; count < (300000000 /
-	    MPI2_HARD_RESET_PCIE_SECOND_READ_DELAY_MICRO_SEC); count++) {
-
-		host_diagnostic = readl(&ioc->chip->HostDiagnostic);
-
-		if (host_diagnostic == 0xFFFFFFFF)
-			goto out;
-		if (!(host_diagnostic & MPI2_DIAG_RESET_ADAPTER))
-			break;
-
-		/* Wait to pass the second read delay window */
-		if (sleep_flag == CAN_SLEEP)
-			msleep(MPI2_HARD_RESET_PCIE_SECOND_READ_DELAY_MICRO_SEC
-			       /1000);
-		else
-			mdelay(MPI2_HARD_RESET_PCIE_SECOND_READ_DELAY_MICRO_SEC
-			       /1000);
-	}
-
-	if (host_diagnostic & MPI2_DIAG_HCB_MODE) {
-
-		drsprintk(ioc, printk(MPT2SAS_INFO_FMT "restart the adapter "
-		    "assuming the HCB Address points to good F/W\n",
-		    ioc->name));
-		host_diagnostic &= ~MPI2_DIAG_BOOT_DEVICE_SELECT_MASK;
-		host_diagnostic |= MPI2_DIAG_BOOT_DEVICE_SELECT_HCDW;
-		writel(host_diagnostic, &ioc->chip->HostDiagnostic);
-
-		drsprintk(ioc, printk(MPT2SAS_INFO_FMT
-		    "re-enable the HCDW\n", ioc->name));
-		writel(hcb_size | MPI2_HCB_SIZE_HCB_ENABLE,
-		    &ioc->chip->HCBSize);
-	}
-
-	drsprintk(ioc, printk(MPT2SAS_INFO_FMT "restart the adapter\n",
-	    ioc->name));
-	writel(host_diagnostic & ~MPI2_DIAG_HOLD_IOC_RESET,
-	    &ioc->chip->HostDiagnostic);
-
-	drsprintk(ioc, printk(MPT2SAS_INFO_FMT "disable writes to the "
-	    "diagnostic register\n", ioc->name));
-	writel(MPI2_WRSEQ_FLUSH_KEY_VALUE, &ioc->chip->WriteSequence);
-
-	drsprintk(ioc, printk(MPT2SAS_INFO_FMT "Wait for FW to go to the "
-	    "READY state\n", ioc->name));
-	ioc_state = _base_wait_on_iocstate(ioc, MPI2_IOC_STATE_READY, 20,
-	    sleep_flag);
-	if (ioc_state) {
-		printk(MPT2SAS_ERR_FMT "%s: failed going to ready state "
-		    " (ioc_state=0x%x)\n", ioc->name, __func__, ioc_state);
-		goto out;
-	}
-
-	printk(MPT2SAS_INFO_FMT "diag reset: SUCCESS\n", ioc->name);
-	return 0;
-
- out:
-	printk(MPT2SAS_ERR_FMT "diag reset: FAILED\n", ioc->name);
-	return -EFAULT;
-}
-
-/**
  * _base_make_ioc_ready - put controller in READY state
  * @ioc: per adapter object
  * @sleep_flag: CAN_SLEEP or NO_SLEEP
-- 
1.7.1

