Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755179Ab3E0QVG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 12:21:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63552 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753432Ab3E0QTQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 12:19:16 -0400
Date: Mon, 27 May 2013 18:20:27 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH] powerpc/pseries: Force 32 bit MSIs when tearing down
Message-ID: <20130527162027.GA18182@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fix just adds a missed call to a new PAPR function
which should have been done with commit e61133d ("powerpc/
pseries: Force 32 bit MSIs for devices that require it")

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 arch/powerpc/platforms/pseries/msi.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/msi.c b/arch/powerpc/platforms/pseries/msi.c
index 40c7db3..2b80a68 100644
--- a/arch/powerpc/platforms/pseries/msi.c
+++ b/arch/powerpc/platforms/pseries/msi.c
@@ -90,6 +90,7 @@ static int rtas_change_msi(struct pci_dn *pdn, u32 func, u32 num_irqs)
 static void rtas_disable_msi(struct pci_dev *pdev)
 {
 	struct pci_dn *pdn;
+	int rc;
 
 	pdn = get_pdn(pdev);
 	if (!pdn)
@@ -98,7 +99,12 @@ static void rtas_disable_msi(struct pci_dev *pdev)
 	/*
 	 * disabling MSI with the explicit interface also disables MSI-X
 	 */
-	if (rtas_change_msi(pdn, RTAS_CHANGE_MSI_FN, 0) != 0) {
+	if (pdn->force_32bit_msi)
+		rc = rtas_change_msi(pdn, RTAS_CHANGE_32MSI_FN, 0);
+	else
+		rc = rtas_change_msi(pdn, RTAS_CHANGE_MSI_FN, 0);
+
+	if ((rc != 0) && !pdn->force_32bit_msi) {
 		/* 
 		 * may have failed because explicit interface is not
 		 * present
-- 
1.7.7.6


-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
