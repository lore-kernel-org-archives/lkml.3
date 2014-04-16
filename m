Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756095AbaDPMND (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 08:13:03 -0400
Received: from avcashub1.qlogic.com ([198.70.193.115]:22804 "EHLO
	avcashub1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755278AbaDPMNA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 08:13:00 -0400
X-Greylist: delayed 356 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Apr 2014 08:12:29 EDT
From: Anil Gurumurthy <Anil.Gurumurthy@qlogic.com>
To: Alexander Gordeev <agordeev@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
CC: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>
Subject: RE: [PATCH v2 RESEND 04/23] bfa: Use pci_enable_msix_exact()
 instead of pci_enable_msix()
Thread-Topic: [PATCH v2 RESEND 04/23] bfa: Use pci_enable_msix_exact()
 instead of pci_enable_msix()
Thread-Index: AQHPV7t8fDZIz6CLPUWJwtCLHdmFLpsT9kdw
Date: Wed, 16 Apr 2014 09:05:10 +0000
Message-ID: <20B1A3CBD98F3845B3F5F56D8597EF59F827FE@avmb2.qlogic.org>
References: <cover.1397461652.git.agordeev@redhat.com>
 <7db0ca73195c7a4b41ec8263e23ffaeb7ff4dce2.1397461652.git.agordeev@redhat.com>
In-Reply-To: <7db0ca73195c7a4b41ec8263e23ffaeb7ff4dce2.1397461652.git.agordeev@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.1.4.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch look good.
Acked-by: Anil Gurumurthy <anil.gurumurthy@qlogic.com>

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Alexander Gordeev
Sent: 14 April 2014 13:35
To: linux-kernel
Cc: Alexander Gordeev; Anil Gurumurthy; Vijaya Mohan Guvva; linux-scsi; linux-pci
Subject: [PATCH v2 RESEND 04/23] bfa: Use pci_enable_msix_exact() instead of pci_enable_msix()

As result of deprecation of MSI-X/MSI enablement functions
pci_enable_msix() and pci_enable_msi_block() all drivers using these two interfaces need to be updated to use the new pci_enable_msi_range()  or pci_enable_msi_exact() and pci_enable_msix_range() or pci_enable_msix_exact() interfaces.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Anil Gurumurthy <agurumur@brocade.com>
Cc: Vijaya Mohan Guvva <vmohan@brocade.com>
Cc: linux-scsi@vger.kernel.org
Cc: linux-pci@vger.kernel.org
---
 drivers/scsi/bfa/bfad.c |   20 ++++++--------------
 1 files changed, 6 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c index e7e4774..839c81c 100644
--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -1234,29 +1234,21 @@ bfad_setup_intr(struct bfad_s *bfad)
        if ((bfa_asic_id_ctc(pdev->device) && !msix_disable_ct) ||
           (bfa_asic_id_cb(pdev->device) && !msix_disable_cb)) {

-               error = pci_enable_msix(bfad->pcidev, msix_entries, bfad->nvec);
+               error = pci_enable_msix_exact(bfad->pcidev,
+                                             msix_entries, bfad->nvec);
                /* In CT1 & CT2, try to allocate just one vector */
-               if (error > 0 && bfa_asic_id_ctc(pdev->device)) {
+               if (error == -ENOSPC && bfa_asic_id_ctc(pdev->device)) {
                        printk(KERN_WARNING "bfa %s: trying one msix "
                               "vector failed to allocate %d[%d]\n",
                               bfad->pci_name, bfad->nvec, error);
                        bfad->nvec = 1;
-                       error = pci_enable_msix(bfad->pcidev,
-                                               msix_entries, bfad->nvec);
+                       error = pci_enable_msix_exact(bfad->pcidev,
+                                                     msix_entries, 1);
                }

-               /*
-                * Only error number of vector is available.
-                * We don't have a mechanism to map multiple
-                * interrupts into one vector, so even if we
-                * can try to request less vectors, we don't
-                * know how to associate interrupt events to
-                *  vectors. Linux doesn't duplicate vectors
-                * in the MSIX table for this case.
-                */
                if (error) {
                        printk(KERN_WARNING "bfad%d: "
-                              "pci_enable_msix failed (%d), "
+                              "pci_enable_msix_exact failed (%d), "
                               "use line based.\n",
                                bfad->inst_no, error);
                        goto line_based;
--
1.7.7.6

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in the body of a message to majordomo@vger.kernel.org More majordomo info at  http://vger.kernel.org/majordomo-info.html

________________________________

This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.
