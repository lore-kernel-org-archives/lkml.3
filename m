Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757435Ab3IKFkb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 01:40:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32814 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256Ab3IKE5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:57:15 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=_dbEY2WWEjsA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=nbZzcNTUDpwA:10 a=XJ73DR3wAAAA:8 a=VwQbUJbxAAAA:8 a=tmtSDGaQAAAA:8 a=wAwfuhEyL-vLSwEzO4gA:9 a=g3Y4LtA3PwEA:10 a=jkObVMfX7fAA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042920.184496740@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:29:54 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Sumit Saxena <sumit.saxena@lsi.com>, Kashyap Desai <kashyap.desai@lsi.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [167/251] megaraid_sas: megaraid_sas driver init fails in kdump kernel
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0167-megaraid_sas-megaraid_sas-driver-init-fails-in-kdump.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: "Sumit.Saxena@lsi.com" <Sumit.Saxena@lsi.com>

[ Upstream commit 6431f5d7c6025f8b007af06ea090de308f7e6881 ]

Problem: When Hardware IOMMU is on, megaraid_sas driver initialization fails
in kdump kernel with LSI MegaRAID controller(device id-0x73).

Actually this issue needs fix in firmware, but for firmware running in field,
this driver fix is proposed to resolve the issue.  At firmware initialization
time, if firmware does not come to ready state, driver will reset the adapter
and retry for firmware transition to ready state unconditionally(not only
executed for kdump kernel).

Signed-off-by: Sumit Saxena <sumit.saxena@lsi.com>
Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
Cc: stable@vger.kernel.org
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/scsi/megaraid/megaraid_sas_base.c |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index d525297..7593e28 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -3493,11 +3493,21 @@ static int megasas_init_fw(struct megasas_instance *instance)
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
-- 
1.7.10.4


