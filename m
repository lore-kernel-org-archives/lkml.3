Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991Ab3HBKyb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 06:54:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37109 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759175Ab3HBKIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 06:08:52 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jeff Skirvin <jeffrey.d.skirvin@intel.com>,
        Lukasz Dorau <lukasz.dorau@intel.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [ 15/99] SCSI: isci: Fix a race condition in the SSP task management path
Date: Fri,  2 Aug 2013 18:07:28 +0800
Message-Id: <20130802100228.160227742@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.4.841.g1a3f60e
In-Reply-To: <20130802100225.478715166@linuxfoundation.org>
References: <20130802100225.478715166@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/isci/task.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/scsi/isci/task.c
+++ b/drivers/scsi/isci/task.c
@@ -491,6 +491,7 @@ int isci_task_abort_task(struct sas_task
 	struct isci_tmf           tmf;
 	int                       ret = TMF_RESP_FUNC_FAILED;
 	unsigned long             flags;
+	int                       target_done_already = 0;
 
 	/* Get the isci_request reference from the task.  Note that
 	 * this check does not depend on the pending request list
@@ -505,9 +506,11 @@ int isci_task_abort_task(struct sas_task
 	/* If task is already done, the request isn't valid */
 	if (!(task->task_state_flags & SAS_TASK_STATE_DONE) &&
 	    (task->task_state_flags & SAS_TASK_AT_INITIATOR) &&
-	    old_request)
+	    old_request) {
 		idev = isci_get_device(task->dev->lldd_dev);
-
+		target_done_already = test_bit(IREQ_COMPLETE_IN_TARGET,
+					       &old_request->flags);
+	}
 	spin_unlock(&task->task_state_lock);
 	spin_unlock_irqrestore(&ihost->scic_lock, flags);
 
@@ -561,7 +564,7 @@ int isci_task_abort_task(struct sas_task
 
 	if (task->task_proto == SAS_PROTOCOL_SMP ||
 	    sas_protocol_ata(task->task_proto) ||
-	    test_bit(IREQ_COMPLETE_IN_TARGET, &old_request->flags) ||
+	    target_done_already ||
 	    test_bit(IDEV_GONE, &idev->flags)) {
 
 		spin_unlock_irqrestore(&ihost->scic_lock, flags);


