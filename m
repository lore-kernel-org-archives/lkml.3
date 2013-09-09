Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845Ab3IINRN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 09:17:13 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:19157 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752610Ab3IINRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 09:17:10 -0400
From: Yijing Wang <wangyijing@huawei.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Chris Metcalf <cmetcalf@tilera.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Airlie <airlied@linux.ie>,
        Mike Marciniszyn <infinipath@intel.com>,
        Roland Dreier <roland@kernel.org>,
        Roland Dreier <roland@purestorage.com>
CC: <linux-kernel@vger.kernel.org>, Mark Einon <mark.einon@gmail.com>,
        Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        <linux-rdma@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        Yijing Wang <wangyijing@huawei.com>, Hanjun Guo <guohanjun@huawei.com>
Subject: [PATCH 4/6] IB/qib: Use pcie_set_mps() and pcie_get_mps() to simplify code
Date: Mon, 9 Sep 2013 21:13:06 +0800
Message-ID: <1378732388-4508-5-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.11.msysgit.1
In-Reply-To: <1378732388-4508-1-git-send-email-wangyijing@huawei.com>
References: <1378732388-4508-1-git-send-email-wangyijing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Refactor qib_tune_pcie_caps() function, use pcie_set_mps()
and pcie_get_mps() to simply code. Because pci core caches
the "PCI-E Max Payload Size Supported" in pci_dev->pcie_mpss,
so use that instead of pcie_capability_read_word(). Remove
the unused val2fld() and fld2val().

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 drivers/infiniband/hw/qib/qib_pcie.c |   96 +++++++++++-----------------------
 1 files changed, 30 insertions(+), 66 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_pcie.c b/drivers/infiniband/hw/qib/qib_pcie.c
index 3a5b99b..f52a2fe 100644
--- a/drivers/infiniband/hw/qib/qib_pcie.c
+++ b/drivers/infiniband/hw/qib/qib_pcie.c
@@ -476,30 +476,6 @@ void qib_pcie_reenable(struct qib_devdata *dd, u16 cmd, u8 iline, u8 cline)
 			"pci_enable_device failed after reset: %d\n", r);
 }
 
-/* code to adjust PCIe capabilities. */
-
-static int fld2val(int wd, int mask)
-{
-	int lsbmask;
-
-	if (!mask)
-		return 0;
-	wd &= mask;
-	lsbmask = mask ^ (mask & (mask - 1));
-	wd /= lsbmask;
-	return wd;
-}
-
-static int val2fld(int wd, int mask)
-{
-	int lsbmask;
-
-	if (!mask)
-		return 0;
-	lsbmask = mask ^ (mask & (mask - 1));
-	wd *= lsbmask;
-	return wd;
-}
 
 static int qib_pcie_coalesce;
 module_param_named(pcie_coalesce, qib_pcie_coalesce, int, S_IRUGO);
@@ -584,9 +560,8 @@ static int qib_tune_pcie_caps(struct qib_devdata *dd)
 {
 	int ret = 1; /* Assume the worst */
 	struct pci_dev *parent;
-	u16 pcaps, pctl, ecaps, ectl;
-	int rc_sup, ep_sup;
-	int rc_cur, ep_cur;
+	u16 rc_mpss, rc_mps, ep_mpss, ep_mps;
+	u16 rc_mrrs, ep_mrrs, max_mrrs;
 
 	/* Find out supported and configured values for parent (root) */
 	parent = dd->pcidev->bus->self;
@@ -597,38 +572,29 @@ static int qib_tune_pcie_caps(struct qib_devdata *dd)
 
 	if (!pci_is_pcie(parent) || !pci_is_pcie(dd->pcidev))
 		goto bail;
-	pcie_capability_read_word(parent, PCI_EXP_DEVCAP, &pcaps);
-	pcie_capability_read_word(parent, PCI_EXP_DEVCTL, &pctl);
+	rc_mpss = parent->pcie_mpss;
+	rc_mps = ffs(pcie_get_mps(parent)) - 8;
 	/* Find out supported and configured values for endpoint (us) */
-	pcie_capability_read_word(dd->pcidev, PCI_EXP_DEVCAP, &ecaps);
-	pcie_capability_read_word(dd->pcidev, PCI_EXP_DEVCTL, &ectl);
+	ep_mpss = dd->pcidev->pcie_mpss;
+	ep_mps = ffs(pcie_get_mps(dd->pcidev)) - 8;
 
 	ret = 0;
 	/* Find max payload supported by root, endpoint */
-	rc_sup = fld2val(pcaps, PCI_EXP_DEVCAP_PAYLOAD);
-	ep_sup = fld2val(ecaps, PCI_EXP_DEVCAP_PAYLOAD);
-	if (rc_sup > ep_sup)
-		rc_sup = ep_sup;
-
-	rc_cur = fld2val(pctl, PCI_EXP_DEVCTL_PAYLOAD);
-	ep_cur = fld2val(ectl, PCI_EXP_DEVCTL_PAYLOAD);
+	if (rc_mpss > ep_mpss)
+		rc_mpss = ep_mpss;
 
 	/* If Supported greater than limit in module param, limit it */
-	if (rc_sup > (qib_pcie_caps & 7))
-		rc_sup = qib_pcie_caps & 7;
+	if (rc_mpss > (qib_pcie_caps & 7))
+		rc_mpss = qib_pcie_caps & 7;
 	/* If less than (allowed, supported), bump root payload */
-	if (rc_sup > rc_cur) {
-		rc_cur = rc_sup;
-		pctl = (pctl & ~PCI_EXP_DEVCTL_PAYLOAD) |
-			val2fld(rc_cur, PCI_EXP_DEVCTL_PAYLOAD);
-		pcie_capability_write_word(parent, PCI_EXP_DEVCTL, pctl);
+	if (rc_mpss > rc_mps) {
+		rc_mps = rc_mpss;
+		pcie_set_mps(parent, 128 << rc_mps);
 	}
 	/* If less than (allowed, supported), bump endpoint payload */
-	if (rc_sup > ep_cur) {
-		ep_cur = rc_sup;
-		ectl = (ectl & ~PCI_EXP_DEVCTL_PAYLOAD) |
-			val2fld(ep_cur, PCI_EXP_DEVCTL_PAYLOAD);
-		pcie_capability_write_word(dd->pcidev, PCI_EXP_DEVCTL, ectl);
+	if (rc_mpss > ep_mps) {
+		ep_mps = rc_mpss;
+		pcie_set_mps(dd->pcidev, 128 << ep_mps);
 	}
 
 	/*
@@ -636,23 +602,21 @@ static int qib_tune_pcie_caps(struct qib_devdata *dd)
 	 * No field for max supported, but PCIe spec limits it to 4096,
 	 * which is code '5' (log2(4096) - 7)
 	 */
-	rc_sup = 5;
-	if (rc_sup > ((qib_pcie_caps >> 4) & 7))
-		rc_sup = (qib_pcie_caps >> 4) & 7;
-	rc_cur = fld2val(pctl, PCI_EXP_DEVCTL_READRQ);
-	ep_cur = fld2val(ectl, PCI_EXP_DEVCTL_READRQ);
-
-	if (rc_sup > rc_cur) {
-		rc_cur = rc_sup;
-		pctl = (pctl & ~PCI_EXP_DEVCTL_READRQ) |
-			val2fld(rc_cur, PCI_EXP_DEVCTL_READRQ);
-		pcie_capability_write_word(parent, PCI_EXP_DEVCTL, pctl);
+	max_mrrs = 5;
+	if (max_mrrs > ((qib_pcie_caps >> 4) & 7))
+		max_mrrs = (qib_pcie_caps >> 4) & 7;
+
+	max_mrrs = 128 << max_mrrs;
+	rc_mrrs = pcie_get_readrq(parent);
+	ep_mrrs = pcie_get_readrq(dd->pcidev);
+
+	if (max_mrrs > rc_mrrs) {
+		rc_mrrs = max_mrrs;
+		pcie_set_readrq(parent, rc_mrrs);
 	}
-	if (rc_sup > ep_cur) {
-		ep_cur = rc_sup;
-		ectl = (ectl & ~PCI_EXP_DEVCTL_READRQ) |
-			val2fld(ep_cur, PCI_EXP_DEVCTL_READRQ);
-		pcie_capability_write_word(dd->pcidev, PCI_EXP_DEVCTL, ectl);
+	if (max_mrrs > ep_mrrs) {
+		ep_mrrs = max_mrrs;
+		pcie_set_readrq(dd->pcidev, ep_mrrs);
 	}
 bail:
 	return ret;
-- 
1.7.1


