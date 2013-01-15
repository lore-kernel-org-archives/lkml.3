Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757933Ab3AOS5Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 13:57:16 -0500
Received: from mail.kernel.org ([198.145.19.201]:34768 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757786Ab3AOS5N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 13:57:13 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Giridhar Malavali <giridhar.malavali@qlogic.com>,
        Saurav Kashyap <saurav.kashyap@qlogic.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [ 035/221] SCSI: qla2xxx: Change in setting UNLOADING flag and FC vports logout sequence while unloading qla2xxx driver.
Date: Tue, 15 Jan 2013 10:49:22 -0800
Message-Id: <20130115185000.560894375@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Giridhar Malavali <giridhar.malavali@qlogic.com>

commit 220d36b4c2d96446e88d561714829ec5801b4fc7 upstream.

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/qla2xxx/qla_attr.c |    3 +--
 drivers/scsi/qla2xxx/qla_os.c   |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1615,8 +1615,7 @@ qla2x00_terminate_rport_io(struct fc_rpo
 	 * At this point all fcport's software-states are cleared.  Perform any
 	 * final cleanup of firmware resources (PCBs and XCBs).
 	 */
-	if (fcport->loop_id != FC_NO_LOOP_ID &&
-	    !test_bit(UNLOADING, &fcport->vha->dpc_flags)) {
+	if (fcport->loop_id != FC_NO_LOOP_ID) {
 		if (IS_FWI2_CAPABLE(fcport->vha->hw))
 			fcport->vha->hw->isp_ops->fabric_logout(fcport->vha,
 			    fcport->loop_id, fcport->d_id.b.domain,
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2755,6 +2755,7 @@ qla2x00_remove_one(struct pci_dev *pdev)
 
 	ha->flags.host_shutting_down = 1;
 
+	set_bit(UNLOADING, &base_vha->dpc_flags);
 	mutex_lock(&ha->vport_lock);
 	while (ha->cur_vport_count) {
 		struct Scsi_Host *scsi_host;
@@ -2784,8 +2785,6 @@ qla2x00_remove_one(struct pci_dev *pdev)
 			    "Error while clearing DRV-Presence.\n");
 	}
 
-	set_bit(UNLOADING, &base_vha->dpc_flags);
-
 	qla2x00_abort_all_cmds(base_vha, DID_NO_CONNECT << 16);
 
 	qla2x00_dfs_remove(base_vha);


