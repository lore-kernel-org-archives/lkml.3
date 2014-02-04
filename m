Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934271AbaBDVJn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 16:09:43 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56930 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933677AbaBDVJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:09:23 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Vijaya Mohan Guvva <vmohan@brocade.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [PATCH 3.12 126/133] SCSI: bfa: Chinook quad port 16G FC HBA claim issue
Date: Tue,  4 Feb 2014 13:08:47 -0800
Message-Id: <20140204210740.587614235@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204210737.008598235@linuxfoundation.org>
References: <20140204210737.008598235@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vijaya Mohan Guvva <vmohan@brocade.com>

commit dcaf9aed995c2b2a49fb86bbbcfa2f92c797ab5d upstream.

Bfa driver crash is observed while pushing the firmware on to chinook
quad port card due to uninitialized bfi_image_ct2 access which gets
initialized only for CT2 ASIC based cards after request_firmware().
For quard port chinook (CT2 ASIC based), bfi_image_ct2 is not getting
initialized as there is no check for chinook PCI device ID before
request_firmware and instead bfi_image_cb is initialized as it is the
default case for card type check.

This patch includes changes to read the right firmware for quad port chinook.

Signed-off-by: Vijaya Mohan Guvva <vmohan@brocade.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/bfa/bfad.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -1832,7 +1832,7 @@ out:
 static u32 *
 bfad_load_fwimg(struct pci_dev *pdev)
 {
-	if (pdev->device == BFA_PCI_DEVICE_ID_CT2) {
+	if (bfa_asic_id_ct2(pdev->device)) {
 		if (bfi_image_ct2_size == 0)
 			bfad_read_firmware(pdev, &bfi_image_ct2,
 				&bfi_image_ct2_size, BFAD_FW_FILE_CT2);
@@ -1842,12 +1842,14 @@ bfad_load_fwimg(struct pci_dev *pdev)
 			bfad_read_firmware(pdev, &bfi_image_ct,
 				&bfi_image_ct_size, BFAD_FW_FILE_CT);
 		return bfi_image_ct;
-	} else {
+	} else if (bfa_asic_id_cb(pdev->device)) {
 		if (bfi_image_cb_size == 0)
 			bfad_read_firmware(pdev, &bfi_image_cb,
 				&bfi_image_cb_size, BFAD_FW_FILE_CB);
 		return bfi_image_cb;
 	}
+
+	return NULL;
 }
 
 static void


