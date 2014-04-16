Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755879AbaDPMMp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 08:12:45 -0400
Received: from avcashub3.qlogic.com ([198.70.193.117]:60915 "EHLO
	avcashub1.qlogic.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751428AbaDPMMm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 08:12:42 -0400
From: Anil Gurumurthy <Anil.Gurumurthy@qlogic.com>
To: Alexander Gordeev <agordeev@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
CC: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>
Subject: RE: [PATCH v2 RESEND 02/23] bfa: Do not call pci_enable_msix()
 after it failed once
Thread-Topic: [PATCH v2 RESEND 02/23] bfa: Do not call pci_enable_msix()
 after it failed once
Thread-Index: AQHPV7tud5PZsL5QGke66O0QaufRWJsT9adA
Date: Wed, 16 Apr 2014 09:03:47 +0000
Message-ID: <20B1A3CBD98F3845B3F5F56D8597EF59F827E4@avmb2.qlogic.org>
References: <cover.1397461652.git.agordeev@redhat.com>
 <f9c36a94438cfb19e45f95111877f6e140b98089.1397461652.git.agordeev@redhat.com>
In-Reply-To: <f9c36a94438cfb19e45f95111877f6e140b98089.1397461652.git.agordeev@redhat.com>
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
Subject: [PATCH v2 RESEND 02/23] bfa: Do not call pci_enable_msix() after it failed once

Function pci_enable_msix() should not be called in case it threw a negative errno from a previous call.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Anil Gurumurthy <agurumur@brocade.com>
Cc: Vijaya Mohan Guvva <vmohan@brocade.com>
Cc: linux-scsi@vger.kernel.org
Cc: linux-pci@vger.kernel.org
Acked-by: Anil Gurumurthy <anil.gurumurthy@qlogic.com>
---
 drivers/scsi/bfa/bfad.c |   48 ++++++++++++++++++++++------------------------
 1 files changed, 23 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c index cc0fbcd..972ff8d 100644
--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -1235,33 +1235,31 @@ bfad_setup_intr(struct bfad_s *bfad)
           (bfa_asic_id_cb(pdev->device) && !msix_disable_cb)) {

                error = pci_enable_msix(bfad->pcidev, msix_entries, bfad->nvec);
-               if (error) {
-                       /* In CT1 & CT2, try to allocate just one vector */
-                       if (bfa_asic_id_ctc(pdev->device)) {
-                               printk(KERN_WARNING "bfa %s: trying one msix "
-                                      "vector failed to allocate %d[%d]\n",
-                                      bfad->pci_name, bfad->nvec, error);
-                               bfad->nvec = 1;
-                               error = pci_enable_msix(bfad->pcidev,
+               /* In CT1 & CT2, try to allocate just one vector */
+               if (error > 0 && bfa_asic_id_ctc(pdev->device)) {
+                       printk(KERN_WARNING "bfa %s: trying one msix "
+                              "vector failed to allocate %d[%d]\n",
+                              bfad->pci_name, bfad->nvec, error);
+                       bfad->nvec = 1;
+                       error = pci_enable_msix(bfad->pcidev,
                                                msix_entries, bfad->nvec);
-                       }
+               }

-                       /*
-                        * Only error number of vector is available.
-                        * We don't have a mechanism to map multiple
-                        * interrupts into one vector, so even if we
-                        * can try to request less vectors, we don't
-                        * know how to associate interrupt events to
-                        *  vectors. Linux doesn't duplicate vectors
-                        * in the MSIX table for this case.
-                        */
-                       if (error) {
-                               printk(KERN_WARNING "bfad%d: "
-                                      "pci_enable_msix failed (%d), "
-                                      "use line based.\n",
-                                       bfad->inst_no, error);
-                               goto line_based;
-                       }
+               /*
+                * Only error number of vector is available.
+                * We don't have a mechanism to map multiple
+                * interrupts into one vector, so even if we
+                * can try to request less vectors, we don't
+                * know how to associate interrupt events to
+                *  vectors. Linux doesn't duplicate vectors
+                * in the MSIX table for this case.
+                */
+               if (error) {
+                       printk(KERN_WARNING "bfad%d: "
+                              "pci_enable_msix failed (%d), "
+                              "use line based.\n",
+                               bfad->inst_no, error);
+                       goto line_based;
                }

                /* Disable INTX in MSI-X mode */
--
1.7.7.6

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in the body of a message to majordomo@vger.kernel.org More majordomo info at  http://vger.kernel.org/majordomo-info.html

________________________________

This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.
