Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757670Ab3HMGhT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 02:37:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60824 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757554Ab3HMGex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 02:34:53 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sumit Saxena <sumit.saxena@lsi.com>,
        Kashyap Desai <kashyap.desai@lsi.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [ 02/17] SCSI: megaraid_sas: megaraid_sas driver init fails in kdump kernel
Date: Mon, 12 Aug 2013 23:35:48 -0700
Message-Id: <20130813063501.934380668@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.3.825.g36032ce.dirty
In-Reply-To: <20130813063501.728847844@linuxfoundation.org>
References: <20130813063501.728847844@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Sumit.Saxena@lsi.com" <Sumit.Saxena@lsi.com>

commit 6431f5d7c6025f8b007af06ea090de308f7e6881 upstream.

Problem: When Hardware IOMMU is on, megaraid_sas driver initialization fails
in kdump kernel with LSI MegaRAID controller(device id-0x73).

Actually this issue needs fix in firmware, but for firmware running in field,
this driver fix is proposed to resolve the issue.  At firmware initialization
time, if firmware does not come to ready state, driver will reset the adapter
and retry for firmware transition to ready state unconditionally(not only
executed for kdump kernel).

Signed-off-by: Sumit Saxena <sumit.saxena@lsi.com>
Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/megaraid/megaraid_sas_base.c |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -3493,11 +3493,21 @@ static int megasas_init_fw(struct megasa
 		break;
 	}
 
-	/*
-	 * We expect the FW state to be READY
-	 */
-	if (megasas_transition_to_ready(instance, 0))
-		goto fail_ready_state;
+	if (megasas_transition_to_ready(instance, 0)) {
+		atomic_set(&instance->fw_reset_no_pci_access, 1);
+		instance->instancet->adp_reset
+			(instance, instance->reg_set);
+		atomic_set(&instance->fw_reset_no_pci_access, 0);
+		dev_info(&instance->pdev->dev,
+			"megasas: FW restarted successfully from %s!\n",
+			__func__);
+
+		/*waitting for about 30 second before retry*/
+		ssleep(30);
+
+		if (megasas_transition_to_ready(instance, 0))
+			goto fail_ready_state;
+	}
 
 	/* Check if MSI-X is supported while in ready state */
 	msix_enable = (instance->instancet->read_fw_status_reg(reg_set) &


