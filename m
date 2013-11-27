Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932393Ab3K0A6Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 19:58:24 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39194 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755260Ab3K0A6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:58:08 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Gavin Shan <shangw@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 3.10 67/80] powerpc/powernv: Add PE to its own PELTV
Date: Tue, 26 Nov 2013 16:57:36 -0800
Message-Id: <20131127005645.584090756@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131127005640.934155527@linuxfoundation.org>
References: <20131127005640.934155527@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/platforms/powernv/pci-ioda.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/arch/powerpc/platforms/powernv/pci-ioda.c
+++ b/arch/powerpc/platforms/powernv/pci-ioda.c
@@ -151,13 +151,23 @@ static int pnv_ioda_configure_pe(struct
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
 


