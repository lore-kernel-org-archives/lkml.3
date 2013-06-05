Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932887Ab3FEV5v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 17:57:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37815 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932809Ab3FEVff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 17:35:35 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Wen Xiong <wenxiong@linux.vnet.ibm.com>,
        Brian King <brking@linux.vnet.ibm.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [ 056/127] SCSI: ipr: Need to reset adapter after the 6th EEH error
Date: Wed,  5 Jun 2013 14:33:43 -0700
Message-Id: <20130605213224.389767185@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130605213217.966891866@linuxfoundation.org>
References: <20130605213217.966891866@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "wenxiong@linux.vnet.ibm.com" <wenxiong@linux.vnet.ibm.com>

commit 96b04db9f2c16e77c31ef0e17e143da1e0cbfd78 upstream.

Add reset adapter after the 6th EEH errors in ipr driver. This triggers
the adapter reset via the PCI config space even when the slot is frozen.

Signed-off-by: Wen Xiong <wenxiong@linux.vnet.ibm.com>
Acked-by: Brian King <brking@linux.vnet.ibm.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/ipr.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -4777,7 +4777,7 @@ static int ipr_eh_host_reset(struct scsi
 	ioa_cfg = (struct ipr_ioa_cfg *) cmd->device->host->hostdata;
 	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
 
-	if (!ioa_cfg->in_reset_reload) {
+	if (!ioa_cfg->in_reset_reload && !ioa_cfg->hrrq[IPR_INIT_HRRQ].ioa_is_dead) {
 		ipr_initiate_ioa_reset(ioa_cfg, IPR_SHUTDOWN_ABBREV);
 		dev_err(&ioa_cfg->pdev->dev,
 			"Adapter being reset as a result of error recovery.\n");
@@ -6739,6 +6739,7 @@ static int ipr_invalid_adapter(struct ip
 static int ipr_ioa_bringdown_done(struct ipr_cmnd *ipr_cmd)
 {
 	struct ipr_ioa_cfg *ioa_cfg = ipr_cmd->ioa_cfg;
+	int i;
 
 	ENTER;
 	if (!ioa_cfg->hrrq[IPR_INIT_HRRQ].removing_ioa) {
@@ -6750,6 +6751,13 @@ static int ipr_ioa_bringdown_done(struct
 
 	ioa_cfg->in_reset_reload = 0;
 	ioa_cfg->reset_retries = 0;
+	for (i = 0; i < ioa_cfg->hrrq_num; i++) {
+		spin_lock(&ioa_cfg->hrrq[i]._lock);
+		ioa_cfg->hrrq[i].ioa_is_dead = 1;
+		spin_unlock(&ioa_cfg->hrrq[i]._lock);
+	}
+	wmb();
+
 	list_add_tail(&ipr_cmd->queue, &ipr_cmd->hrrq->hrrq_free_q);
 	wake_up_all(&ioa_cfg->reset_wait_q);
 	LEAVE;
@@ -8651,7 +8659,7 @@ static void ipr_pci_perm_failure(struct
 	spin_lock_irqsave(ioa_cfg->host->host_lock, flags);
 	if (ioa_cfg->sdt_state == WAIT_FOR_DUMP)
 		ioa_cfg->sdt_state = ABORT_DUMP;
-	ioa_cfg->reset_retries = IPR_NUM_RESET_RELOAD_RETRIES;
+	ioa_cfg->reset_retries = IPR_NUM_RESET_RELOAD_RETRIES - 1;
 	ioa_cfg->in_ioa_bringdown = 1;
 	for (i = 0; i < ioa_cfg->hrrq_num; i++) {
 		spin_lock(&ioa_cfg->hrrq[i]._lock);


