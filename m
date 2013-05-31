Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858Ab3EaM7E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 08:59:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41692 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753652Ab3EaM6i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 08:58:38 -0400
Date: Fri, 31 May 2013 15:00:01 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <michael@ellerman.id.au>
Subject: [PATCH] powerpc/pseries: Request FW for power of two MSI-Xs only
Message-ID: <20130531130001.GA1468@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current logic in requesting firmware for MSI-X interrupts
is confusing. On the one hand it is known the firmware
refuses any non power of two allocations. On the other
hand such attempts still could be taken, but surprisingly
- after the attempt to request power of two interrupts
failed, not before.

This update sticks to the idea the firmware can only
allocate power of two MSI-X interrupts and makes the logic
bit more straight.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 arch/powerpc/platforms/pseries/msi.c |   43 ++++++++++++++++-----------------
 1 files changed, 21 insertions(+), 22 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/msi.c b/arch/powerpc/platforms/pseries/msi.c
index 420524e..40c7db3 100644
--- a/arch/powerpc/platforms/pseries/msi.c
+++ b/arch/powerpc/platforms/pseries/msi.c
@@ -357,18 +357,35 @@ static int rtas_msi_check_device(struct pci_dev *pdev, int nvec, int type)
 {
 	int quota, rc;
 
+	/*
+	 * Firmware currently refuses any non power of two allocation
+	 * so we round up if the quota will allow it.
+	 */
+
+	nvec = roundup_pow_of_two(nvec);
+
 	if (type == PCI_CAP_ID_MSIX)
 		rc = check_req_msix(pdev, nvec);
 	else
 		rc = check_req_msi(pdev, nvec);
 
-	if (rc)
+	/*
+	 * Prevent endless recursion with the same value of 'nvec' by rounding
+	 * 'nvec' down to the previous power of two on fallback paths.
+	 */
+
+	if (rc) {
+		if (rc > (nvec / 2))
+			rc = (nvec / 2);
 		return rc;
+	}
 
 	quota = msi_quota_for_device(pdev, nvec);
-
-	if (quota && quota < nvec)
+	if (quota && quota < nvec) {
+		if (quota > (nvec / 2))
+			quota = (nvec / 2);
 		return quota;
+	}
 
 	return 0;
 }
@@ -394,13 +411,12 @@ static int check_msix_entries(struct pci_dev *pdev)
 	return 0;
 }
 
-static int rtas_setup_msi_irqs(struct pci_dev *pdev, int nvec_in, int type)
+static int rtas_setup_msi_irqs(struct pci_dev *pdev, int nvec, int type)
 {
 	struct pci_dn *pdn;
 	int hwirq, virq, i, rc;
 	struct msi_desc *entry;
 	struct msi_msg msg;
-	int nvec = nvec_in;
 
 	pdn = get_pdn(pdev);
 	if (!pdn)
@@ -410,23 +426,10 @@ static int rtas_setup_msi_irqs(struct pci_dev *pdev, int nvec_in, int type)
 		return -EINVAL;
 
 	/*
-	 * Firmware currently refuse any non power of two allocation
-	 * so we round up if the quota will allow it.
-	 */
-	if (type == PCI_CAP_ID_MSIX) {
-		int m = roundup_pow_of_two(nvec);
-		int quota = msi_quota_for_device(pdev, m);
-
-		if (quota >= m)
-			nvec = m;
-	}
-
-	/*
 	 * Try the new more explicit firmware interface, if that fails fall
 	 * back to the old interface. The old interface is known to never
 	 * return MSI-Xs.
 	 */
-again:
 	if (type == PCI_CAP_ID_MSI) {
 		if (pdn->force_32bit_msi)
 			rc = rtas_change_msi(pdn, RTAS_CHANGE_32MSI_FN, nvec);
@@ -441,10 +444,6 @@ again:
 		rc = rtas_change_msi(pdn, RTAS_CHANGE_MSIX_FN, nvec);
 
 	if (rc != nvec) {
-		if (nvec != nvec_in) {
-			nvec = nvec_in;
-			goto again;
-		}
 		pr_debug("rtas_msi: rtas_change_msi() failed\n");
 		return rc;
 	}
-- 
1.7.7.6


-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
