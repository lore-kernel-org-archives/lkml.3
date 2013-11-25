Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756669Ab3KYNPP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 08:15:15 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57266 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366Ab3KYNIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:08:55 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Gavin Shan <shangw@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 59/78] powerpc/powernv: Add PE to its own PELTV
Date: Mon, 25 Nov 2013 13:06:46 +0000
Message-Id: <1385384825-21681-60-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1385384825-21681-1-git-send-email-luis.henriques@canonical.com>
References: <1385384825-21681-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.26 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gavin Shan <shangw@linux.vnet.ibm.com>

commit 631ad691b5818291d89af9be607d2fe40be0886e upstream.

We need add PE to its own PELTV. Otherwise, the errors originated
from the PE might contribute to other PEs. In the result, we can't
clear up the error successfully even we're checking and clearing
errors during access to PCI config space.

Reported-by: kalshett@in.ibm.com
Signed-off-by: Gavin Shan <shangw@linux.vnet.ibm.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/powerpc/platforms/powernv/pci-ioda.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/platforms/powernv/pci-ioda.c b/arch/powerpc/platforms/powernv/pci-ioda.c
index fbdd74d..5da8e8d 100644
--- a/arch/powerpc/platforms/powernv/pci-ioda.c
+++ b/arch/powerpc/platforms/powernv/pci-ioda.c
@@ -613,13 +613,23 @@ static int __devinit pnv_ioda_configure_pe(struct pnv_phb *phb,
 		rid_end = pe->rid + 1;
 	}
 
-	/* Associate PE in PELT */
+	/*
+	 * Associate PE in PELT. We need add the PE into the
+	 * corresponding PELT-V as well. Otherwise, the error
+	 * originated from the PE might contribute to other
+	 * PEs.
+	 */
 	rc = opal_pci_set_pe(phb->opal_id, pe->pe_number, pe->rid,
 			     bcomp, dcomp, fcomp, OPAL_MAP_PE);
 	if (rc) {
 		pe_err(pe, "OPAL error %ld trying to setup PELT table\n", rc);
 		return -ENXIO;
 	}
+
+	rc = opal_pci_set_peltv(phb->opal_id, pe->pe_number,
+				pe->pe_number, OPAL_ADD_PE_TO_DOMAIN);
+	if (rc)
+		pe_warn(pe, "OPAL error %d adding self to PELTV\n", rc);
 	opal_pci_eeh_freeze_clear(phb->opal_id, pe->pe_number,
 				  OPAL_EEH_ACTION_CLEAR_FREEZE_ALL);
 
-- 
1.8.3.2

