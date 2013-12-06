Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423060Ab3LFXU5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 18:20:57 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:49008 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161101Ab3LFXUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 18:20:48 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Gavin Shan <shangw@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 057/152] powerpc/powernv: Add PE to its own PELTV
Date: Fri,  6 Dec 2013 15:09:41 -0800
Message-Id: <1386371476-2477-58-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386371476-2477-1-git-send-email-kamal@canonical.com>
References: <1386371476-2477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.14 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/powerpc/platforms/powernv/pci-ioda.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/platforms/powernv/pci-ioda.c b/arch/powerpc/platforms/powernv/pci-ioda.c
index 8e90e89..7e18662 100644
--- a/arch/powerpc/platforms/powernv/pci-ioda.c
+++ b/arch/powerpc/platforms/powernv/pci-ioda.c
@@ -158,13 +158,23 @@ static int pnv_ioda_configure_pe(struct pnv_phb *phb, struct pnv_ioda_pe *pe)
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

