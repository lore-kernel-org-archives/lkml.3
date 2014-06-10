Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936267AbaFJAda (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 20:33:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58620 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934528AbaFJAWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 20:22:44 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jeff Skirvin <jeffrey.d.skirvin@intel.com>,
        Lukasz Dorau <lukasz.dorau@intel.com>,
        James Bottomley <JBottomley@Parallels.com>,
        Ben Hutchings <ben@decadent.org.uk>, Rui Xiang <rui.xiang@huawei.com>
Subject: [PATCH 3.4 63/88] isci: Fix a race condition in the SSP task management path
Date: Mon,  9 Jun 2014 17:25:13 -0700
Message-Id: <20140610002426.579752659@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140610002424.500996570@linuxfoundation.org>
References: <20140610002424.500996570@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Skirvin <jeffrey.d.skirvin@intel.com>

commit 96f15f29038e58e1b0a96483e2b369ff446becf1 upstream.

This commit fixes a race condition in the isci driver abort task and SSP
device task management path.  The race is caused when an I/O termination
in the SCU hardware is necessary because of an SSP target timeout condition,
and the check of the I/O end state races against the HW-termination-driven
end state.  The failure of the race meant that no TMF was sent to the device
to clean-up the pending I/O.

Signed-off-by: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
Reviewed-by: Lukasz Dorau <lukasz.dorau@intel.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Rui Xiang <rui.xiang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/isci/task.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/scsi/isci/task.c
+++ b/drivers/scsi/isci/task.c
@@ -956,6 +956,7 @@ int isci_task_abort_task(struct sas_task
 	int                       ret = TMF_RESP_FUNC_FAILED;
 	unsigned long             flags;
 	int                       perform_termination = 0;
+	int                       target_done_already = 0;
 
 	/* Get the isci_request reference from the task.  Note that
 	 * this check does not depend on the pending request list
@@ -970,9 +971,11 @@ int isci_task_abort_task(struct sas_task
 	/* If task is already done, the request isn't valid */
 	if (!(task->task_state_flags & SAS_TASK_STATE_DONE) &&
 	    (task->task_state_flags & SAS_TASK_AT_INITIATOR) &&
-	    old_request)
+	    old_request) {
 		isci_device = isci_lookup_device(task->dev);
-
+		target_done_already = test_bit(IREQ_COMPLETE_IN_TARGET,
+					       &old_request->flags);
+	}
 	spin_unlock(&task->task_state_lock);
 	spin_unlock_irqrestore(&isci_host->scic_lock, flags);
 
@@ -1031,7 +1034,7 @@ int isci_task_abort_task(struct sas_task
 	}
 	if (task->task_proto == SAS_PROTOCOL_SMP ||
 	    sas_protocol_ata(task->task_proto) ||
-	    test_bit(IREQ_COMPLETE_IN_TARGET, &old_request->flags)) {
+	    target_done_already) {
 
 		spin_unlock_irqrestore(&isci_host->scic_lock, flags);
 


