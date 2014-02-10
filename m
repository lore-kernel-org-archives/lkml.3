Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540AbaBJURo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 15:17:44 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34607 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155AbaBJTlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 14:41:40 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Vijaya Mohan Guvva <vmohan@brocade.com>,
        James Bottomley <JBottomley@Parallels.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 012/124] [SCSI] bfa: Chinook quad port 16G FC HBA claim issue
Date: Mon, 10 Feb 2014 11:39:12 -0800
Message-Id: <1392061264-28124-13-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392061264-28124-1-git-send-email-kamal@canonical.com>
References: <1392061264-28124-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.18 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/scsi/bfa/bfad.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c
index e6bf126..630e09d 100644
--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -1824,7 +1824,7 @@ out:
 static u32 *
 bfad_load_fwimg(struct pci_dev *pdev)
 {
-	if (pdev->device == BFA_PCI_DEVICE_ID_CT2) {
+	if (bfa_asic_id_ct2(pdev->device)) {
 		if (bfi_image_ct2_size == 0)
 			bfad_read_firmware(pdev, &bfi_image_ct2,
 				&bfi_image_ct2_size, BFAD_FW_FILE_CT2);
@@ -1834,12 +1834,14 @@ bfad_load_fwimg(struct pci_dev *pdev)
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
-- 
1.8.3.2

