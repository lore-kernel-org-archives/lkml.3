Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759761Ab3IHDVX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 23:21:23 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56182 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756532Ab3IHDSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 23:18:46 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Sumit.Saxena@lsi.com" <Sumit.Saxena@lsi.com>,
        "Sumit Saxena" <sumit.saxena@lsi.com>,
        "Kashyap Desai" <kashyap.desai@lsi.com>,
        "James Bottomley" <JBottomley@Parallels.com>
Date: Sun, 08 Sep 2013 03:52:01 +0100
Message-ID: <lsq.1378608721.917550873@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [056/121] [SCSI] megaraid_sas: megaraid_sas driver init fails in
 kdump kernel
In-Reply-To: <lsq.1378608720.401499712@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.51-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -3547,11 +3547,21 @@ static int megasas_init_fw(struct megasa
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

