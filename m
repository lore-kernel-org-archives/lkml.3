Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759844Ab3GaNke (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 09:40:34 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46952 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759723Ab3GaNZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 09:25:53 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Lukasz Dorau" <lukasz.dorau@intel.com>,
        "Jeff Skirvin" <jeffrey.d.skirvin@intel.com>,
        "James Bottomley" <JBottomley@Parallels.com>
Date: Wed, 31 Jul 2013 15:23:09 +0200
Message-ID: <lsq.1375276989.175584473@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [66/84] [SCSI] isci: Fix a race condition in the SSP task
 management path
In-Reply-To: <lsq.1375276989.251749228@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.181
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.50-rc1 review patch.  If anyone has any objections, please let me know.

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
---
 drivers/scsi/isci/task.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/scsi/isci/task.c
+++ b/drivers/scsi/isci/task.c
@@ -1038,6 +1038,7 @@ int isci_task_abort_task(struct sas_task
 	int                       ret = TMF_RESP_FUNC_FAILED;
 	unsigned long             flags;
 	int                       perform_termination = 0;
+	int                       target_done_already = 0;
 
 	/* Get the isci_request reference from the task.  Note that
 	 * this check does not depend on the pending request list
@@ -1052,9 +1053,11 @@ int isci_task_abort_task(struct sas_task
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
 
@@ -1116,7 +1119,7 @@ int isci_task_abort_task(struct sas_task
 	}
 	if (task->task_proto == SAS_PROTOCOL_SMP ||
 	    sas_protocol_ata(task->task_proto) ||
-	    test_bit(IREQ_COMPLETE_IN_TARGET, &old_request->flags)) {
+	    target_done_already) {
 
 		spin_unlock_irqrestore(&isci_host->scic_lock, flags);
 

